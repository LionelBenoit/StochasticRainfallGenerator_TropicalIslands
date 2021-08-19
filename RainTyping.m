function[V_RainTypes,my_GMModel,nb_clusters]=RainTyping(V_p0,V_k,V_teta,M_PCs,nb_clusters)

V_RainTypes=zeros(size(V_p0));

inds_dry=(V_k==-1);
inds_wet=(V_k>0);

V_p0(inds_dry)=[];
V_k(inds_dry)=[];
V_teta(inds_dry)=[];
M_PCs(inds_dry,:)=[];

V_p0(V_p0<0.01)=0.01;
V_p0(V_p0>0.99)=0.99;

V_k(V_k<0.01)=0.01;

V_teta(V_teta<0.01)=0.01;

M_PCs=M_PCs(:,1:3);%only 3 first PCs

nb_PCs=size(M_PCs,2);

M_rainpatterns=[norminv(V_p0);log(V_k);log(V_teta);M_PCs'];

if nb_clusters==0
    
    max_clusters=25;%#ToSet
    min_clusters=10;
    nb_iter=3;
    
    figure(10)
    clf
    
    %EM classification based on M_rainpatterns
    M_BIC=[];
    
    options = statset('MaxIter',10000,'TolFun',1e-15);
    
    V_nb_clusters=min_clusters:max_clusters;
    M_BIC=NaN(length(V_nb_clusters),nb_iter);
    for iter=1:nb_iter
        for j=min_clusters:max_clusters
            j
            GMModel = fitgmdist(M_rainpatterns',j,'Options',options,'CovarianceType','diagonal','RegularizationValue',0.1);
            M_BIC(j-min_clusters+1,iter)=GMModel.BIC;
        end
    end
    hold on
    plot(V_nb_clusters,M_BIC,'c-')
    hold on
    plot(V_nb_clusters,mean(M_BIC,2),'b-')
    [~,nb_clusters]=min(mean(M_BIC,2));
    nb_clusters=nb_clusters+min_clusters-1;
    %---
    options = statset('MaxIter',1e6,'TolFun',1e-20);
    my_GMModel = fitgmdist(M_rainpatterns',nb_clusters,'Options',options,'CovarianceType','diagonal','RegularizationValue',0.1);
    [V_RainTypes_tmp,~,~] = cluster(my_GMModel,M_rainpatterns');
    V_RainTypes(inds_wet)=V_RainTypes_tmp;
    
else
    display('before cluster')
    options = statset('MaxIter',1e4,'TolFun',1e-20);
    my_GMModel = fitgmdist(M_rainpatterns',nb_clusters,'Options',options,'CovarianceType','diagonal','RegularizationValue',0.1);
    display('after cluster')
    [V_RainTypes_tmp,~,~] = cluster(my_GMModel,M_rainpatterns');
    V_RainTypes(inds_wet)=V_RainTypes_tmp;
end


end
