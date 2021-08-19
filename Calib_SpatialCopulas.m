function[str_SpatialCopulas]=Calib_SpatialCopulas(M_Data_latent,M_Data,V_RainTypes_calib)
nb_clusters=max(V_RainTypes_calib);
str_SpatialCopulas=struct();
for i=1:nb_clusters+1
    str_SpatialCopulas(i).Copulas=[];
end

%process zeros separately
my_inds=(V_RainTypes_calib==0);
str_SpatialCopulas(1).Copulas=M_Data(:,my_inds);

%other types
for my_clust=1:nb_clusters
    my_inds=(V_RainTypes_calib==my_clust);
    str_SpatialCopulas(my_clust+1).Copulas=M_Data_latent(:,my_inds);
end

end