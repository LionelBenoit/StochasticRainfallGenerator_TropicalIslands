function[V_RainTypes_simulated]=Simul_RainTypeOccurence(nb_clusters,M_Cov_TM,str_RainType_occurence)

TM_Baseline=str_RainType_occurence.TM_Baseline;
str_cov=str_RainType_occurence.str_cov;

V_RainTypes_simulated=zeros(size(M_Cov_TM,1),1);

current_type=ceil(rand*nb_clusters);

V_RainTypes_simulated(1)=current_type;
for current_ind=1:length(V_RainTypes_simulated)-1
    
    V_P=zeros(1,nb_clusters+1);
    Xt=M_Cov_TM(current_ind,:);
    
    for i=1:nb_clusters+1
        my_gamma=TM_Baseline(current_type,i);
        my_mu=mean(str_cov(current_type,i).data);
        my_sigma=cov(str_cov(current_type,i).data);
        
        V_P(i)=my_gamma*exp(-0.5*(Xt-my_mu)*inv(my_sigma)*(Xt-my_mu)');
        
    end
    V_P(isnan(V_P))=0;
    V_P(isinf(V_P))=0;
    V_P_norm=V_P/sum(V_P);
    r = mnrnd(1,V_P_norm);
    current_type=find(r==1);
    
    if isempty(current_type)
        current_type=1;
    end
    V_RainTypes_simulated(current_ind+1)=current_type-1;
end

end %end_function