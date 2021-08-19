function []=Display_RainTypes(V_Time,M_Data_obs,V_Raintypes,M_Covariates_calib,V_Lon_TargetIsland2,V_Lat_TargetIsland2)

nb_clusters=max(V_Raintypes(:));
M_datevec=datevec(V_Time);

M_MeanMonthlyFrequency_Raintypes=zeros(12,nb_clusters+1);
for my_month=1:12
    my_inds_month=(M_datevec(:,2)==my_month);
    V_raintypes_month=V_Raintypes(my_inds_month);
    for my_clust=0:nb_clusters
        my_nb=sum(V_raintypes_month==my_clust);
        M_MeanMonthlyFrequency_Raintypes(my_month,my_clust+1)=my_nb/length(V_raintypes_month);
    end
end

year_min=min(M_datevec(:,1));
year_max=max(M_datevec(:,1));

M_MeanAnnualFrequency_Raintypes=zeros(year_max-year_min+1,nb_clusters+1);
for my_year=year_min:year_max
    my_inds_year=(M_datevec(:,1)==my_year);
    V_raintypes_year=V_Raintypes(my_inds_year);
    for my_clust=0:nb_clusters
        my_nb=sum(V_raintypes_year==my_clust);
        M_MeanAnnualFrequency_Raintypes(my_year-year_min+1,my_clust+1)=my_nb/length(V_raintypes_year);
    end
end

my_max_frequency=max(M_MeanMonthlyFrequency_Raintypes(:));
my_max_frequency_annual=max(M_MeanAnnualFrequency_Raintypes(:));
nb_steps_histo=15;
for my_clust=0:nb_clusters
    figure(100+my_clust)
    clf
    
    M_Covariates_clust=M_Covariates_calib(V_Raintypes==my_clust,:);
    
    %---
    figure(999)
    h1=histogram(M_Covariates_calib(:,1),min(M_Covariates_calib(:,1)):(max(M_Covariates_calib(:,1))-min(M_Covariates_calib(:,1)))/nb_steps_histo:max(M_Covariates_calib(:,1)));
    figure(100+my_clust)
    subplot(2,5,1)
    hold on
    plot((h1.BinEdges(2:end)+h1.BinEdges(1:end-1))/2,h1.Values/sum(h1.Values),'k:','LineWidth',3)
    
    figure(999)
    h2=histogram(M_Covariates_clust(:,1),min(M_Covariates_calib(:,1)):(max(M_Covariates_calib(:,1))-min(M_Covariates_calib(:,1)))/nb_steps_histo:max(M_Covariates_calib(:,1)));
    figure(100+my_clust)
    subplot(2,5,1)
    hold on
    plot((h2.BinEdges(2:end)+h2.BinEdges(1:end-1))/2,h2.Values/sum(h2.Values),'r-','LineWidth',3)
    ylim([0 0.5])
    title('Z700')
    %---
    figure(999)
    clf
    h1=histogram(M_Covariates_calib(:,2),min(M_Covariates_calib(:,2)):(max(M_Covariates_calib(:,2))-min(M_Covariates_calib(:,2)))/nb_steps_histo:max(M_Covariates_calib(:,2)));
    figure(100+my_clust)
    subplot(2,5,2)
    hold on
    plot((h1.BinEdges(2:end)+h1.BinEdges(1:end-1))/2,h1.Values/sum(h1.Values),'k:','LineWidth',3)
    
    figure(999)
    clf
    h2=histogram(M_Covariates_clust(:,2),min(M_Covariates_calib(:,2)):(max(M_Covariates_calib(:,2))-min(M_Covariates_calib(:,2)))/nb_steps_histo:max(M_Covariates_calib(:,2)));
    figure(100+my_clust)
    subplot(2,5,2)
    hold on
    plot((h2.BinEdges(2:end)+h2.BinEdges(1:end-1))/2,h2.Values/sum(h2.Values),'r-','LineWidth',3)
    ylim([0 0.5])
    title('T950-T700')
    %----
    figure(999)
    clf
    h1=histogram(M_Covariates_calib(:,3),min(M_Covariates_calib(:,3)):(max(M_Covariates_calib(:,3))-min(M_Covariates_calib(:,3)))/nb_steps_histo:max(M_Covariates_calib(:,3)));
    figure(100+my_clust)
    subplot(2,5,3)
    hold on
    plot((h1.BinEdges(2:end)+h1.BinEdges(1:end-1))/2,h1.Values/sum(h1.Values),'k:','LineWidth',3)
    
    figure(999)
    clf
    h2=histogram(M_Covariates_clust(:,3),min(M_Covariates_calib(:,3)):(max(M_Covariates_calib(:,3))-min(M_Covariates_calib(:,3)))/nb_steps_histo:max(M_Covariates_calib(:,3)));
    figure(100+my_clust)
    subplot(2,5,3)
    hold on
    plot((h2.BinEdges(2:end)+h2.BinEdges(1:end-1))/2,h2.Values/sum(h2.Values),'r-','LineWidth',3)
    ylim([0 0.5])
    title('H700')
    %----
    V_WindSpeed_calib=sqrt(M_Covariates_calib(:,4).^2+M_Covariates_calib(:,5).^2);
    V_WindDirection_calib=-atan2(-M_Covariates_calib(:,4),M_Covariates_calib(:,5))*180/pi;
    
    V_WindSpeed_clust=sqrt(M_Covariates_clust(:,4).^2+M_Covariates_clust(:,5).^2);
    V_WindDirection_clust=-atan2(-M_Covariates_clust(:,4),M_Covariates_clust(:,5))*180/pi;
    
    figure(999)
    clf
    h1=histogram(V_WindSpeed_calib,min(V_WindSpeed_calib):(max(V_WindSpeed_calib)-min(V_WindSpeed_calib))/nb_steps_histo:max(V_WindSpeed_calib));
    figure(100+my_clust)
    subplot(2,5,4)
    hold on
    plot((h1.BinEdges(2:end)+h1.BinEdges(1:end-1))/2,h1.Values/sum(h1.Values),'k:','LineWidth',3)
    
    figure(999)
    clf
    h2=histogram(V_WindSpeed_clust,min(V_WindSpeed_calib):(max(V_WindSpeed_calib)-min(V_WindSpeed_calib))/nb_steps_histo:max(V_WindSpeed_calib));
    figure(100+my_clust)
    subplot(2,5,4)
    hold on
    plot((h2.BinEdges(2:end)+h2.BinEdges(1:end-1))/2,h2.Values/sum(h2.Values),'r-','LineWidth',3)
    ylim([0 0.5])
    title('Moisture Transport intensity')
    %---
    figure(999)
    clf
    h1=histogram(V_WindDirection_calib,min(V_WindDirection_calib):(max(V_WindDirection_calib)-min(V_WindDirection_calib))/nb_steps_histo:max(V_WindDirection_calib));
    figure(100+my_clust)
    subplot(2,5,5)
    hold on
    plot((h1.BinEdges(2:end)+h1.BinEdges(1:end-1))/2,h1.Values/sum(h1.Values),'k:','LineWidth',3)
    
    figure(999)
    clf
    h2=histogram(V_WindDirection_clust,min(V_WindDirection_calib):(max(V_WindDirection_calib)-min(V_WindDirection_calib))/nb_steps_histo:max(V_WindDirection_calib));
    figure(100+my_clust)
    subplot(2,5,5)
    hold on
    plot((h2.BinEdges(2:end)+h2.BinEdges(1:end-1))/2,h2.Values/sum(h2.Values),'r-','LineWidth',3)
    ylim([0 0.5])
    title('Moisture Transport Direction')
    
    close 999
    %---
    subplot(2,5,6)
    Mamat_seasonality_boxplot=M_MeanMonthlyFrequency_Raintypes(:,my_clust+1);
    plot(1:12,Mamat_seasonality_boxplot,'k.','MarkerSize',15)
    hold on
    plot(1:12,Mamat_seasonality_boxplot,'k-')
    axis([0.5 12.5 0 my_max_frequency])
    title('Seasonality RainType Occurence')
    
    %--
    subplot(2,5,7)
    Mamat_InterAnnualVariability_boxplot=M_MeanAnnualFrequency_Raintypes(:,my_clust+1);
    plot(min(M_datevec(:,1)):max(M_datevec(:,1)), Mamat_InterAnnualVariability_boxplot,'k.','MarkerSize',15)
    hold on
    plot(min(M_datevec(:,1)):max(M_datevec(:,1)), Mamat_InterAnnualVariability_boxplot,'k-')
    axis([min(M_datevec(:,1))-0.5 max(M_datevec(:,1))+0.5 0 my_max_frequency_annual])
    title('InterAnnual Variability RainType Occurence')
    %--
    subplot(2,5,8)
    M_Data_clust=M_Data_obs(:,V_Raintypes==my_clust);
    Plot_coastline(1)
    V_toPlot=mean(M_Data_clust,2);
    %my_max=max(max(V_toPlot),3);
    my_max=20;
    my_colormap=colormap('jet');
    for i=1:length(V_toPlot)
        my_ind_color=min(floor((V_toPlot(i))/my_max*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(i),V_Lon_TargetIsland2(i),'o','MarkerSize',10,'color','k','MarkerFaceColor',my_color)
    end
    title('mean observed pattern')
    colormap(my_colormap)
    caxis([0 my_max])
    colorbar
    %--
    subplot(2,5,9)
    M_Data_clust=M_Data_obs(:,V_Raintypes==my_clust);
    Plot_coastline(1)
    V_toPlot=median(M_Data_clust,2);
    my_colormap=colormap('jet');
    for i=1:length(V_toPlot)
        my_ind_color=min(floor((V_toPlot(i))/my_max*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(i),V_Lon_TargetIsland2(i),'o','MarkerSize',10,'color','k','MarkerFaceColor',my_color)
    end
    title('median observed pattern')
    colormap(my_colormap)
    caxis([0 my_max])
    colorbar
    %--
    subplot(2,5,10)
    M_Data_clust=M_Data_obs(:,V_Raintypes==my_clust);
    Plot_coastline(1)
    V_toPlot=std(M_Data_clust,0,2);
    my_colormap=colormap('jet');
    for i=1:length(V_toPlot)
        my_ind_color=min(floor((V_toPlot(i))/my_max*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(i),V_Lon_TargetIsland2(i),'o','MarkerSize',10,'color','k','MarkerFaceColor',my_color)
    end
    title('std observed pattern')
    colormap(my_colormap)
    caxis([0 my_max])
    colorbar
end


