function[M_SimulatedRain]=Simul_DailyRainFields(V_RainTypes_simulated,str_MarginalDistributions,str_SpatialCopulas)

M_SimulatedRain=NaN(size(str_SpatialCopulas(1).Copulas,1),length(V_RainTypes_simulated));

for my_simul_day=1:length(V_RainTypes_simulated)
    
    my_clust=V_RainTypes_simulated(my_simul_day);
    
    if my_clust==0
        %Special case: Vector sampling on 'raw data'
        
        M_TI=str_SpatialCopulas(my_clust+1).Copulas;
        V_sim=M_TI(:,ceil(rand*size(M_TI,2)));
        
        V_sim_final=V_sim;
    else
        
        %D.2.a) Spatial structure / rain location (i.e. simulate latent field)
        
        M_TI=str_SpatialCopulas(my_clust+1).Copulas;
        V_sim=M_TI(:,ceil(rand*size(M_TI,2)));
        
        my_rand_num=rand;
        my_ind=ceil(my_rand_num*size(str_MarginalDistributions(my_clust+1).TI_a0_k_teta,1));
        V_param=str_MarginalDistributions(my_clust+1).TI_a0_k_teta(my_ind,:);
        
        std_noise_a0=std(str_MarginalDistributions(my_clust+1).TI_a0_k_teta(:,1))*size(str_MarginalDistributions(my_clust+1).TI_a0_k_teta,1)^(-1/(3+4));
        my_a0=V_param(1)+randn*std_noise_a0;
        my_a0=max(-6,min(my_a0,6));
        my_p0=normcdf(my_a0);
        
        
        std_noise_k=std(str_MarginalDistributions(my_clust+1).TI_a0_k_teta(:,2))*size(str_MarginalDistributions(my_clust+1).TI_a0_k_teta,1)^(-1/(3+4));
        my_k=V_param(2)+randn*std_noise_k;
        my_k=max(my_k,0.0001);
        
        std_noise_teta=std(str_MarginalDistributions(my_clust+1).TI_a0_k_teta(:,3))*size(str_MarginalDistributions(my_clust+1).TI_a0_k_teta,1)^(-1/(3+4));
        my_teta=V_param(3)+randn*std_noise_teta;
        my_teta=max(my_teta,0.0001);
        %---
        
        %D.2.c) Combine the two above components (i.e. back transform)
        V_sim_final=V_sim;
        for my_gauge=1:length(V_sim)
            if V_sim(my_gauge)<my_a0
                V_sim_final(my_gauge)=0;
            else
                my_uniform0=normcdf(V_sim(my_gauge),0,1);
                my_uniform=(my_uniform0-my_p0)/(1-my_p0);
                my_rain=gaminv(my_uniform,my_k,my_teta);
                V_sim_final(my_gauge)=my_rain;
            end
        end
        
    end
    
    
    M_SimulatedRain(:,my_simul_day)=V_sim_final;
    
end


end %end_function