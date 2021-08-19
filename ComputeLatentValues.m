function[M_Data_latent,V_p0,V_k,V_teta]=ComputeLatentValues(M_Data_DailyRain,V_Lon,V_Lat)

M_Data_latent=NaN(size(M_Data_DailyRain,1),size(M_Data_DailyRain,2));
V_p0=NaN(1,size(M_Data_DailyRain,2));
V_k=NaN(1,size(M_Data_DailyRain,2));
V_teta=NaN(1,size(M_Data_DailyRain,2));

for my_day=1:size(M_Data_DailyRain,2)
    my_day
    
    %compute max distance to wet rain gauge (to define the latent field under the truncation threshold)
    V_Lon_wet=[];
    V_Lat_wet=[];
    for my_gauge=1:size(M_Data_DailyRain,1)
        if M_Data_DailyRain(my_gauge,my_day)>0
            V_Lon_wet=[V_Lon_wet;V_Lon(my_gauge)];
            V_Lat_wet=[V_Lat_wet;V_Lat(my_gauge)];
        end
    end
    my_max_dist=0;
    V_nonzero_rainAccumulation=[];
    nb_zeros=0;
    nb_wet=0;
    V_raw_accumulation=[];
    for my_gauge=1:size(M_Data_DailyRain,1)
        if ~isnan(M_Data_DailyRain(my_gauge,my_day))
            if M_Data_DailyRain(my_gauge,my_day)==0
                V_dist_closestWetGauge=sqrt((V_Lon(my_gauge)-V_Lon_wet).^2+(V_Lat(my_gauge)-V_Lat_wet).^2);
                dist_closest_wet_gauge=min(V_dist_closestWetGauge);
                my_max_dist=max(my_max_dist,dist_closest_wet_gauge);
                nb_zeros=nb_zeros+1;
            else
                V_raw_accumulation=[V_raw_accumulation;M_Data_DailyRain(my_gauge,my_day)];
                nb_wet=nb_wet+1;
            end
        end
    end
    my_max_dist=my_max_dist+0.01;
    if isempty(my_max_dist)
        my_max_dist=50000;
    end
    prop_zeros=nb_zeros/(nb_zeros+nb_wet);
    
    %infer transform function parameters for wet gauges and compute corresponding latent values
    if size(M_Data_DailyRain,1)-nb_zeros>4
        
        [V_accumulation_gaussian,k,teta]=infer_gammaanamorphosis_parameters(prop_zeros,V_raw_accumulation);
        
        V_p0(my_day)=prop_zeros;
        
        V_k(my_day)=k;
        V_teta(my_day)=teta;
        
        %transform the data to obtain the latent field
        ind_wet_obs=1;
        for my_gauge=1:size(M_Data_DailyRain,1)
            my_latent_value=NaN;
            if ~isnan(M_Data_DailyRain(my_gauge,my_day))
                if M_Data_DailyRain(my_gauge,my_day)==0
                    V_dist_closestWetGauge=sqrt((V_Lon(my_gauge)-V_Lon_wet).^2+(V_Lat(my_gauge)-V_Lat_wet).^2);
                    dist_closest_wet_gauge=min(V_dist_closestWetGauge);
                    if isempty(dist_closest_wet_gauge)
                        dist_closest_wet_gauge=50000;
                    end
                    my_latent_value=norminv((1-dist_closest_wet_gauge/my_max_dist)*prop_zeros);
                else
                    my_latent_value=V_accumulation_gaussian(ind_wet_obs);
                    ind_wet_obs=ind_wet_obs+1;
                end
            end
            M_Data_latent(my_gauge,my_day)=my_latent_value;
        end
        
    else
        
        V_p0(my_day)=prop_zeros;
        V_k(my_day)=-1;
        V_teta(my_day)=-1;
        M_Data_latent(:,my_day)=randn(size(M_Data_DailyRain,1),1);
    end
end


end