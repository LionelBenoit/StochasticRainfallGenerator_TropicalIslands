function[]=Display_IslandScale_Statistics(V_Time,M_Data_TargetIsland2,str_simulated_rain)

M_Data_TargetIsland2_toplot=M_Data_TargetIsland2;
nb_simul=length(str_simulated_rain);
V_datavect_forseason=datevec(V_Time);
V_month=V_datavect_forseason(:,2);

figure(300)
clf
V_PropZeros_obs=sum(M_Data_TargetIsland2_toplot==0,1)/length(M_Data_TargetIsland2_toplot(:,1));
V_MeanAccu_obs=mean(M_Data_TargetIsland2_toplot,1);
V_CVAccu_obs=std(M_Data_TargetIsland2_toplot,0,1)./mean(M_Data_TargetIsland2_toplot,1);
V_CVAccu_obs(isinf(V_CVAccu_obs))=0;
V_MaxAccu_obs=max(M_Data_TargetIsland2_toplot,[],1);

for my_sim=1:nb_simul
    
    M_sim=str_simulated_rain(my_sim).data;
    V_PropZeros_sim=sum(M_sim==0,1)/length(M_sim(:,1));
    V_MeanAccu_sim=mean(M_sim,1);
    V_CVAccu_sim=std(M_sim,0,1)./mean(M_sim,1);
    V_CVAccu_sim(isinf(V_CVAccu_sim))=0;
    V_MaxAccu_sim=max(M_sim,[],1);
    
    V_q_obs=zeros(101,1);
    V_q_sim=zeros(101,1);
    V_q_obs_MeanAccu=zeros(101,1);
    V_q_sim_MeanAccu=zeros(101,1);
    V_q_obs_CVAccu=zeros(101,1);
    V_q_sim_CVAccu=zeros(101,1);
    V_q_obs_MaxAccu=zeros(101,1);
    V_q_sim_MaxAccu=zeros(101,1);
    
    my_ind=1;
    for my_q=0:0.01:1
        V_q_obs(my_ind)=quantile(V_PropZeros_obs,my_q);
        V_q_sim(my_ind)=quantile(V_PropZeros_sim,my_q);
        V_q_obs_MeanAccu(my_ind)=quantile(V_MeanAccu_obs,my_q);
        V_q_sim_MeanAccu(my_ind)=quantile(V_MeanAccu_sim,my_q);
        V_q_obs_CVAccu(my_ind)=quantile(V_CVAccu_obs,my_q);
        V_q_sim_CVAccu(my_ind)=quantile(V_CVAccu_sim,my_q);
        V_q_obs_MaxAccu(my_ind)=quantile(V_MaxAccu_obs,my_q);
        V_q_sim_MaxAccu(my_ind)=quantile(V_MaxAccu_sim,my_q);
        my_ind=my_ind+1;
    end
    subplot(4,3,3)
    hold on
    plot(V_q_obs,V_q_sim,'k-')
    plot(V_q_obs,V_q_sim,'k.')
    plot([0 1],[0 1],'r-')
    axis([0 1 0 1])
    axis equal tight
    title('PropZeros-annual')
    
    subplot(4,3,6)
    hold on
    plot(V_q_obs_MeanAccu,V_q_sim_MeanAccu,'k-')
    plot(V_q_obs_MeanAccu,V_q_sim_MeanAccu,'k.')
    plot([0 max([V_q_obs_MeanAccu(end) V_q_sim_MeanAccu(end)])],[0 max([V_q_obs_MeanAccu(end) V_q_sim_MeanAccu(end)])],'r-')
    axis equal tight
    title('MeanAccu-annual')
    
    subplot(4,3,9)
    hold on
    plot(V_q_obs_CVAccu,V_q_sim_CVAccu,'k-')
    plot(V_q_obs_CVAccu,V_q_sim_CVAccu,'k.')
    plot([0 max([V_q_obs_CVAccu(end) V_q_sim_CVAccu(end)])],[0 max([V_q_obs_CVAccu(end) V_q_sim_CVAccu(end)])],'r-')
    axis equal tight
    title('CVAccu-annual')
    
    subplot(4,3,12)
    hold on
    plot(V_q_obs_MaxAccu,V_q_sim_MaxAccu,'k-')
    plot(V_q_obs_MaxAccu,V_q_sim_MaxAccu,'k.')
    plot([0 max([V_q_obs_MaxAccu(end) V_q_sim_MaxAccu(end)])],[0 max([V_q_obs_MaxAccu(end) V_q_sim_MaxAccu(end)])],'r-')
    axis equal tight
    title('MaxAccu-annual')
end

for my_season=1:2
    
    if my_season==1
        inds_season=(V_month==1 | V_month==2 | V_month==3 | V_month==10 | V_month==11 | V_month==12);
        str_season='Wet season (JFM+OND)';
    else
        inds_season=(V_month==4 | V_month==5 | V_month==6 | V_month==7 | V_month==8 | V_month==9);
        str_season='Dry season (AMJJAS)';
    end
    
    V_PropZeros_obs=sum(M_Data_TargetIsland2_toplot(:,inds_season)==0,1)/length(M_Data_TargetIsland2_toplot(:,1));
    V_MeanAccu_obs=mean(M_Data_TargetIsland2_toplot(:,inds_season),1);
    V_CVAccu_obs=std(M_Data_TargetIsland2_toplot(:,inds_season),0,1)./mean(M_Data_TargetIsland2_toplot(:,inds_season),1);
    V_CVAccu_obs(isinf(V_CVAccu_obs))=0;
    V_MaxAccu_obs=max(M_Data_TargetIsland2_toplot(:,inds_season),[],1);
    
    for my_sim=1:nb_simul
        
        M_sim=str_simulated_rain(my_sim).data;
        V_PropZeros_sim=sum(M_sim(:,inds_season)==0,1)/length(M_sim(:,1));
        V_MeanAccu_sim=mean(M_sim(:,inds_season),1);
        V_CVAccu_sim=std(M_sim(:,inds_season),0,1)./mean(M_sim(:,inds_season),1);
        V_CVAccu_sim(isinf(V_CVAccu_sim))=0;
        V_MaxAccu_sim=max(M_sim(:,inds_season),[],1);
        
        V_q_obs_PropZeros=zeros(101,1);
        V_q_sim_PropZeros=zeros(101,1);
        V_q_obs_MeanAccu=zeros(101,1);
        V_q_sim_MeanAccu=zeros(101,1);
        V_q_obs_CVAccu=zeros(101,1);
        V_q_sim_CVAccu=zeros(101,1);
        V_q_obs_MaxAccu=zeros(101,1);
        V_q_sim_MaxAccu=zeros(101,1);
        
        my_ind=1;
        for my_q=0:0.01:1
            V_q_obs_PropZeros(my_ind)=quantile(V_PropZeros_obs,my_q);
            V_q_sim_PropZeros(my_ind)=quantile(V_PropZeros_sim,my_q);
            V_q_obs_MeanAccu(my_ind)=quantile(V_MeanAccu_obs,my_q);
            V_q_sim_MeanAccu(my_ind)=quantile(V_MeanAccu_sim,my_q);
            V_q_obs_CVAccu(my_ind)=quantile(V_CVAccu_obs,my_q);
            V_q_sim_CVAccu(my_ind)=quantile(V_CVAccu_sim,my_q);
            V_q_obs_MaxAccu(my_ind)=quantile(V_MaxAccu_obs,my_q);
            V_q_sim_MaxAccu(my_ind)=quantile(V_MaxAccu_sim,my_q);
            my_ind=my_ind+1;
        end
        subplot(4,3,my_season)
        hold on
        plot(V_q_obs_PropZeros,V_q_sim_PropZeros,'k-')
        plot(V_q_obs_PropZeros,V_q_sim_PropZeros,'k.')
        plot([0 1],[0 1],'r-')
        axis([0 1 0 1])
        axis equal tight
        title(strcat('PropZeros-',str_season))
        
        subplot(4,3,my_season+3)
        hold on
        plot(V_q_obs_MeanAccu,V_q_sim_MeanAccu,'k-')
        plot(V_q_obs_MeanAccu,V_q_sim_MeanAccu,'k.')
        plot([0 max([V_q_obs_MeanAccu(end) V_q_sim_MeanAccu(end)])],[0 max([V_q_obs_MeanAccu(end) V_q_sim_MeanAccu(end)])],'r-')
        axis equal tight
        title(strcat('MeanAccu-',str_season))
        
        subplot(4,3,my_season+6)
        hold on
        plot(V_q_obs_CVAccu,V_q_sim_CVAccu,'k-')
        plot(V_q_obs_CVAccu,V_q_sim_CVAccu,'k.')
        plot([0 max([V_q_obs_CVAccu(end) V_q_sim_CVAccu(end)])],[0 max([V_q_obs_CVAccu(end) V_q_sim_CVAccu(end)])],'r-')
        axis equal tight
        title(strcat('CVAccu-',str_season))
        
        subplot(4,3,my_season+9)
        hold on
        plot(V_q_obs_MaxAccu,V_q_sim_MaxAccu,'k-')
        plot(V_q_obs_MaxAccu,V_q_sim_MaxAccu,'k.')
        plot([0 max([V_q_obs_MaxAccu(end) V_q_sim_MaxAccu(end)])],[0 max([V_q_obs_MaxAccu(end) V_q_sim_MaxAccu(end)])],'r-')
        axis equal tight
        title(strcat('MaxAccu-',str_season))
        
    end
    
    
end


end