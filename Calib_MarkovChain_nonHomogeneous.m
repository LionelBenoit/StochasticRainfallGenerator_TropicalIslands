function[str_RainType_occurence]=Calib_MarkovChain_nonHomogeneous(nb_clusters,M_Covariates_obs,V_RainTypes)
str_RainType_occurence=struct();
TM_Baseline=zeros(nb_clusters+1,nb_clusters+1);

str_cov=struct();
for i=1:nb_clusters+1
    for j=1:nb_clusters+1
        str_cov(i,j).data=[];
    end
end


for i=1:length(V_RainTypes)-1
    TM_Baseline(V_RainTypes(i)+1,V_RainTypes(i+1)+1)=TM_Baseline(V_RainTypes(i)+1,V_RainTypes(i+1)+1)+1;
    str_cov(V_RainTypes(i)+1,V_RainTypes(i+1)+1).data=[str_cov(V_RainTypes(i)+1,V_RainTypes(i+1)+1).data; M_Covariates_obs(i,:)];
end

TM_Baseline=TM_Baseline/(length(V_RainTypes)-1);
str_RainType_occurence.TM_Baseline=TM_Baseline;
str_RainType_occurence.str_cov=str_cov;

end