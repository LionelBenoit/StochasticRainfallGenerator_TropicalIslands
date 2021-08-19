function[]=Display_SingleGauge_Results(V_TargetGauges_toplot,V_Time,M_Data_TargetIsland2,str_simulated_rain,V_Lat_TargetIsland2,V_Lon_TargetIsland2,id_Island)

M_datevec=datevec(V_Time);
nb_years=max(M_datevec(:,1))-min(M_datevec(:,1))+1;
nb_simul=length(str_simulated_rain);

M_MeanMonthlyFrequency_TargetGauges_obs=NaN(12,length(V_TargetGauges_toplot),nb_years);
M_MeanMonthlyFrequency_TargetGauges_sim=NaN(12,length(V_TargetGauges_toplot),nb_years,nb_simul);

for my_sim=1:nb_simul
    
    V_time_MeanMonthlyFrequency=NaN(12,1);
    
    M_sim=str_simulated_rain(my_sim).data;
    
    for my_month=1:12
        for my_year=min(M_datevec(:,1)):max(M_datevec(:,1))
            V_inds_month=find((M_datevec(:,1)==my_year) & (M_datevec(:,2)==my_month));
            length(V_inds_month)
            V_time_MeanMonthlyFrequency(my_month)=datenum([2000 my_month 15 0 0 0]);
            for my_targetgauge=1:length(V_TargetGauges_toplot)
                if my_sim==1
                    M_MeanMonthlyFrequency_TargetGauges_obs(my_month,my_targetgauge,my_year-min(M_datevec(:,1))+1)=sum(M_Data_TargetIsland2(V_TargetGauges_toplot(my_targetgauge),V_inds_month));
                end
                M_MeanMonthlyFrequency_TargetGauges_sim(my_month,my_targetgauge,my_year-min(M_datevec(:,1))+1,my_sim)=sum(M_sim(V_TargetGauges_toplot(my_targetgauge),V_inds_month));
            end
        end
    end
end

%---
M_datevec=datevec(V_Time);
year_min=min(M_datevec(:,1));
year_max=max(M_datevec(:,1));
M_MeanAnnualFrequency_TargetGauges_obs=NaN(year_max-year_min+1,length(V_TargetGauges_toplot));
M_MeanAnnualFrequency_TargetGauges_sim=NaN(year_max-year_min+1,length(V_TargetGauges_toplot),nb_simul);

for my_sim=1:nb_simul
    
    V_time_MeanAnnualFrequency=NaN(year_max-year_min+1,1);
    
    M_sim=str_simulated_rain(my_sim).data;
    for my_year=year_min:year_max
        V_inds_year=find((M_datevec(:,1)==my_year));
        V_time_MeanAnnualFrequency(my_year-year_min+1)=datenum([my_year 6 30 0 0 0]);
        
        for my_targetgauge=1:length(V_TargetGauges_toplot)
            M_MeanAnnualFrequency_TargetGauges_obs(my_year-year_min+1,my_targetgauge)=mean(M_Data_TargetIsland2(V_TargetGauges_toplot(my_targetgauge),V_inds_year));
            M_MeanAnnualFrequency_TargetGauges_sim(my_year-year_min+1,my_targetgauge,my_sim)=mean(M_sim(V_TargetGauges_toplot(my_targetgauge),V_inds_year));
        end
        
    end
    
end
%---

my_colormap=colormap(jet);
for my_targetgauge=1:length(V_TargetGauges_toplot)
    
    figure(200+my_targetgauge)
    clf
    
    subplot(2,3,1)
    Plot_coastline(1)
    
    V_toPlot=mean(M_Data_TargetIsland2,2)*365;
    my_max=max(V_toPlot);
    for i=1:length(V_toPlot)
        my_ind_color=min(floor((V_toPlot(i))/my_max*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(i),V_Lon_TargetIsland2(i),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
    end
    plotm(V_Lat_TargetIsland2(V_TargetGauges_toplot(my_targetgauge)),V_Lon_TargetIsland2(V_TargetGauges_toplot(my_targetgauge)),'x','MarkerSize',15,'color','r')
    colormap(my_colormap)
    caxis([0 my_max])
    colorbar
    title('Gauge of interest')
    
    
    subplot(2,3,2)
    hold on
    
    
    
    V_sim_q10=quantile(quantile(M_MeanMonthlyFrequency_TargetGauges_sim(:,my_targetgauge,:,:),0.1,3),0.5,4);
    V_sim_q50=quantile(quantile(M_MeanMonthlyFrequency_TargetGauges_sim(:,my_targetgauge,:,:),0.5,3),0.5,4);
    V_sim_q90=quantile(quantile(M_MeanMonthlyFrequency_TargetGauges_sim(:,my_targetgauge,:,:),0.9,3),0.5,4);
    
    area(1:12,V_sim_q90,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[1.0 1.0 1.0])
    area(1:12,V_sim_q10,'FaceColor',[1.0 1.0 1.0],'EdgeColor',[1.0 1.0 1.0])
    plot(1:12,quantile(M_MeanMonthlyFrequency_TargetGauges_obs(:,my_targetgauge,:),0.5,3),'r-')
    plot(1:12,quantile(M_MeanMonthlyFrequency_TargetGauges_obs(:,my_targetgauge,:),0.1,3),'r--')
    plot(1:12,quantile(M_MeanMonthlyFrequency_TargetGauges_obs(:,my_targetgauge,:),0.9,3),'r--')
    plot(1:12,V_sim_q50,'k-')
    plot(1:12,V_sim_q10,'k:')
    plot(1:12,V_sim_q90,'k:')
    
    
    xlim([0.5 12.5])
    ax=gca;
    ax.XTick=1:12;
    ax.XTickLabel={'J','F','M','A','M','J','J','A','S','O','N','D'};
    ylim([0 800])
    title('Monthly rain accumulation')
    
    %--
    subplot(2,3,3)
    hold on
    
    
    area(year_min:year_max,quantile(M_MeanAnnualFrequency_TargetGauges_sim(:,my_targetgauge,:),1.0,3)*365,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[1.0 1.0 1.0])
    area(year_min:year_max,quantile(M_MeanAnnualFrequency_TargetGauges_sim(:,my_targetgauge,:),0.0,3)*365,'FaceColor',[1.0 1.0 1.0],'EdgeColor',[1.0 1.0 1.0])
    plot(year_min:year_max,M_MeanAnnualFrequency_TargetGauges_obs(:,my_targetgauge)*365,'r-')
    plot(year_min:year_max,quantile(M_MeanAnnualFrequency_TargetGauges_sim(:,my_targetgauge,:),0.5,3)*365,'k-')
    plot(year_min:year_max,quantile(M_MeanAnnualFrequency_TargetGauges_sim(:,my_targetgauge,:),1.0,3)*365,'k:')
    plot(year_min:year_max,quantile(M_MeanAnnualFrequency_TargetGauges_sim(:,my_targetgauge,:),0.0,3)*365,'k:')
    
    
    ylim([0 10000])
    title('Monthly rain accumulation')
    
    %--
    
    subplot(2,3,4)
    hold on
    for my_sim=1:nb_simul
        M_sim=str_simulated_rain(my_sim).data;
        V_sim=M_sim(V_TargetGauges_toplot(my_targetgauge),:);
        V_obs=M_Data_TargetIsland2(V_TargetGauges_toplot(my_targetgauge),:);
        for my_q=0:0.01:1
            my_ind_color=min(floor(my_q*255)+1,255);
            my_color=my_colormap(my_ind_color,:);
            plot(quantile(V_obs,my_q),quantile(V_sim,my_q),'.k')
            plot(quantile(V_obs,my_q),quantile(V_sim,my_q),'-k')
        end
    end
    
    plot([0 500],[0 500],'r-')
    axis([0 500 0 500])
    

    axis square
    title('q-q Rain Accumulation')
    
    %---
    subplot(2,3,5)
    hold on
    for my_sim=1:nb_simul
        M_sim=str_simulated_rain(my_sim).data;
        
        V_sim=M_sim(V_TargetGauges_toplot(my_targetgauge),:);
        
        CC_sim=double(V_sim>0);
        V_length_ExcursionSet_sim=[];
        if CC_sim(1)==1
            day_begin_rain=1;
        end
        for d=2:length(CC_sim)
            if CC_sim(d)-CC_sim(d-1)>0
                day_begin_rain=d;
            end
            if CC_sim(d)-CC_sim(d-1)<0
                V_length_ExcursionSet_sim=[V_length_ExcursionSet_sim;d-day_begin_rain];
            end
        end
        
        
        V_obs=M_Data_TargetIsland2(V_TargetGauges_toplot(my_targetgauge),:);
        
        CC_obs=double(V_obs>0);
        V_length_ExcursionSet_obs=[];
        if CC_obs(1)==1
            day_begin_rain=1;
        end
        for d=2:length(CC_obs)
            if CC_obs(d)-CC_obs(d-1)>0
                day_begin_rain=d;
            end
            if CC_obs(d)-CC_obs(d-1)<0
                V_length_ExcursionSet_obs=[V_length_ExcursionSet_obs;d-day_begin_rain];
            end
        end
        
        for my_q=0:0.01:1
            my_ind_color=min(floor(my_q*255)+1,255);
            my_color=my_colormap(my_ind_color,:);
            plot(quantile(V_length_ExcursionSet_obs,my_q),quantile(V_length_ExcursionSet_sim,my_q),'k.')
            plot(quantile(V_length_ExcursionSet_obs,my_q),quantile(V_length_ExcursionSet_sim,my_q),'k-')
        end
    end
    plot([0 100],[0 100],'r-')
    axis([0 100 0 100])
    axis square
    title('q-q plot wet spell duration')
    
end


end