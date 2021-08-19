function[]=Display_Quantiles_Maps(V_Time,M_Data_TargetIsland2,str_simulated_rain,V_Lat_TargetIsland2,V_Lon_TargetIsland2)
nb_simul=length(str_simulated_rain);

%Maps probability exceedance
V_datavect_forseason=datevec(V_Time);
V_month=V_datavect_forseason(:,2);
M_Data_TargetIsland2_toplot=M_Data_TargetIsland2;

my_colormap=colormap('jet');

for my_quantile=10:20:90
    
    figure(400+my_quantile)
    clf
    V_q_obs=quantile(M_Data_TargetIsland2_toplot,my_quantile/100,2);
    my_max=max(V_q_obs);
    
    subplot(3,3,3)
    
    hold on
    
    Plot_coastline(1)
    
    for my_gauge=1:length(V_q_obs)
        my_ind_color=min(floor(V_q_obs(my_gauge)/my_max*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(my_gauge),V_Lon_TargetIsland2(my_gauge),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
    end
    colormap('jet')
    caxis([0 my_max])
    colorbar
    title(strcat('obs rain - annual - quantile:',num2str(my_quantile),'%'))
    axis equal tight
    
    M_q_sim=[];
    for my_sim=1:nb_simul
        
        M_sim=str_simulated_rain(my_sim).data;
        V_q_sim=quantile(M_sim,my_quantile/100,2);
        M_q_sim=[M_q_sim V_q_sim];
        
    end
    
    V_q_sim=median(M_q_sim,2);
    
    subplot(3,3,6)
    hold on
    
    Plot_coastline(1)
    
    for my_gauge=1:length(V_q_sim)
        my_ind_color=min(floor(V_q_sim(my_gauge)/my_max*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(my_gauge),V_Lon_TargetIsland2(my_gauge),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
    end
    colormap('jet')
    caxis([0 my_max])
    colorbar
    title(strcat('sim rain - annual - quantile:',num2str(my_quantile),'%'))
    axis equal tight
    
    subplot(3,3,9)
    hold on
    
    Plot_coastline(1)
    my_max_diff=max(abs(V_q_obs-V_q_sim));
    for my_gauge=1:length(V_q_sim)
        my_ind_color=min(floor(abs(V_q_obs(my_gauge)-V_q_sim(my_gauge))/my_max_diff*255)+1,255);
        my_color=my_colormap(my_ind_color,:);
        plotm(V_Lat_TargetIsland2(my_gauge),V_Lon_TargetIsland2(my_gauge),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
    end
    colormap('jet')
    caxis([0 my_max_diff])
    colorbar
    title('absolute error')
    axis equal tight
    
    
    for my_season=1:2
        
        if my_season==1
            inds_season=(V_month==1 | V_month==2 | V_month==3 | V_month==10 | V_month==11 | V_month==12);
        else
            inds_season=(V_month==4 | V_month==5 | V_month==6 | V_month==7 | V_month==8 | V_month==9);
        end
        
        V_q_obs=quantile(M_Data_TargetIsland2_toplot(:,inds_season),my_quantile/100,2);
        
        subplot(3,3,my_season)
        
        hold on
        
        Plot_coastline(1)
        
        for my_gauge=1:length(V_q_obs)
            my_ind_color=min(floor(V_q_obs(my_gauge)/my_max*255)+1,255);
            my_color=my_colormap(my_ind_color,:);
            plotm(V_Lat_TargetIsland2(my_gauge),V_Lon_TargetIsland2(my_gauge),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
        end
        colormap('jet')
        caxis([0 my_max])
        colorbar
        
        if my_season==1
            str_season='JFM+OND';
        else
            str_season='AMJJAS';
        end
        
        title(strcat('obs rain-',str_season,'- quantile:',num2str(my_quantile),'%'))
        axis equal tight
        
        M_q_sim=[];
        for my_sim=1:nb_simul
            
            M_sim=str_simulated_rain(my_sim).data;
            V_q_sim=quantile(M_sim(:,inds_season),my_quantile/100,2);
            
            M_q_sim=[M_q_sim V_q_sim];
            
        end
        
        V_q_sim=median(M_q_sim,2);
        
        subplot(3,3,3+my_season)
        hold on
        
        Plot_coastline(1)
        
        for my_gauge=1:length(V_q_sim)
            my_ind_color=min(floor(V_q_sim(my_gauge)/my_max*255)+1,255);
            my_color=my_colormap(my_ind_color,:);
            plotm(V_Lat_TargetIsland2(my_gauge),V_Lon_TargetIsland2(my_gauge),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
        end
        colormap('jet')
        caxis([0 my_max])
        colorbar
        title(strcat('sim rain-',str_season,'- quantile:',num2str(my_quantile),'%'))
        axis equal tight
        
        subplot(3,3,6+my_season)
        hold on
        
        Plot_coastline(1)
        for my_gauge=1:length(V_q_sim)
            my_ind_color=min(floor(abs(V_q_obs(my_gauge)-V_q_sim(my_gauge))/my_max_diff*255)+1,255);
            my_color=my_colormap(my_ind_color,:);
            plotm(V_Lat_TargetIsland2(my_gauge),V_Lon_TargetIsland2(my_gauge),'o','MarkerSize',5,'color','k','MarkerFaceColor',my_color)
        end
        colormap('jet')
        caxis([0 my_max_diff])
        colorbar
        title('absolute error')
        axis equal tight
        
    end
end

end