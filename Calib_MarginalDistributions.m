function[str_MarginalDistributions]=Calib_MarginalDistributions(V_p0,V_k,V_teta,V_RainTypes_calib)

nb_clusters=max(V_RainTypes_calib);
str_MarginalDistributions=struct();

V_p0(V_p0<0.01)=0.01;
V_p0(V_p0>0.99)=0.99;
V_a0=norminv(V_p0);


for i=1:nb_clusters+1
    str_MarginalDistributions(i).TI_a0_k_teta=[];
end

for my_clust=1:nb_clusters
    my_inds=find(V_RainTypes_calib==my_clust);
    
    V_a0_clust=V_a0(my_inds);
    V_k_clust=V_k(my_inds);
    V_teta_clust=V_teta(my_inds);
    
    str_MarginalDistributions(my_clust+1).TI_a0_k_teta=[V_a0_clust' V_k_clust' V_teta_clust'];
end

end