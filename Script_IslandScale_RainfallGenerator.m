%*******************************************************************
%**** Stochastic daily rainfall generation on tropical islands *****
%*******************************************************************

%The following script allows to calibrate and run the rainfall model presented in the paper 'Stochastic daily rainfall generation on tropical islands with complex topography' by Benoit L, Sichoix L, Nugent A.D, Lucas M.P and Giambelluca T.W.  

close all
clear all

%NB1: Throughout this demo script, we use the dataset of O'ahu island, Hawai'i, USA, 1991-2011.
%This demo dataset is made of daily rain gauge records on the island of O'ahu. 
%Data collection, compilation and gap filling are described in: Longman, R. J., et al. (2018), Compilation of climate data from heterogeneous networks across the Hawaiian Islands, Scientific Data, 5, 180012, DOI: 10.1038/sdata.2018.12
%A most recent and updated version of this dataset can be downloaded (open data) from the Hawaii climate data portal (https://www.hawaii.edu/climate-data-portal/data-portal/).

%NB2: The display functions are made for the O'ahu demo dataset. In case another dataset is used, display functions should be slightly modified by adapting the internal function Plot_coastline to the area of interest



%***** STEP 0: Load raw dataset ****
%***********************************

M=load('M_DailyRainfall_records.mat');
M_DailyRainfall_records=M.M_DailyRainfall_records; %rows: rain gauges, columns: days.
M=load('V_Time.mat');
V_Time=M.V_Time;
M_datevec=datevec(V_Time);
M=load('V_Latitude_gauges.mat');
V_Latitude_gauges=M.V_Latitude_gauges; %vector with rain the latitude of the rain gauges (in decimal degrees)
M=load('V_Longitude_gauges.mat');
V_Longitude_gauges=M.V_Longitude_gauges; %vector with rain the longitude of the rain gauges (in decimal degrees)
M=load('V_Altitude_gauges.mat');
V_Altitude_gauges=M.V_Altitude_gauges; %vector with rain the altitude of the rain gauges (in meters)
clear M;

%---- Meteorological covariates ----
%This demo dataset of meteorological covariates is made of reanalysis data derived from the ERA5 dataset at 12:00PM HST, and correspond the the spatial mean of the 12 grid cells encompassing the island of O'ahu.
%An updated version of this dataset (or other locations) can be downloaded from the Copernicus Data Portal (https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-pressure-levels?tab=form).
M=load('M_Meteorological_Covariates.mat');
M_Meteorological_Covariates_Daily=M.M_Meteorological_Covariates; %rows: days, colums: meteorological covariates. c1=Geopotential height at 950hPa, c2=Temperature at 950hPa - Temperature at 700hPa, c3=Specific humidity at 700hPa, c4: Humidity flux at 950hPa (U component), c5: Humidity flux at 950hPa (V component)
clear M;
%Aggregate meteorological covariates at the monthly scale
M_Meteorological_Covariates_Monthly=M_Meteorological_Covariates_Daily;
for my_year_cov=min(M_datevec(:,1)):max(M_datevec(:,1))
    for my_month_cov=1:12
        my_inds_cov=find(M_datevec(:,1)==my_year_cov & M_datevec(:,2)==my_month_cov);
        M_Meteorological_Covariates_Monthly(my_inds_cov,1)=mean(M_Meteorological_Covariates_Daily(my_inds_cov,1));
        M_Meteorological_Covariates_Monthly(my_inds_cov,2)=mean(M_Meteorological_Covariates_Daily(my_inds_cov,2));
        M_Meteorological_Covariates_Monthly(my_inds_cov,3)=mean(M_Meteorological_Covariates_Daily(my_inds_cov,3));
        M_Meteorological_Covariates_Monthly(my_inds_cov,4)=mean(M_Meteorological_Covariates_Daily(my_inds_cov,4));
        M_Meteorological_Covariates_Monthly(my_inds_cov,5)=mean(M_Meteorological_Covariates_Daily(my_inds_cov,5));
    end
end

%---Split demo dataset into calibration (1991-2001) and simulation (2001-2011) subsets ---
%For illustration purposes the dataset is split in two subsets of equal size. Other choices can be made to define calibration and simulation datasets, e.g. leave-one-year out.
half_dataset_length=3653;
M_DailyRainfall_records_calibperiod=M_DailyRainfall_records(:,1:half_dataset_length);
M_DailyRainfall_records_simulperiod=M_DailyRainfall_records(:,half_dataset_length+1:end);
V_Time_calibperiod=V_Time(1:half_dataset_length);
V_Time_simulperiod=V_Time(half_dataset_length+1:end);
M_Meteorological_Covariates_Daily_calibperiod=M_Meteorological_Covariates_Daily(1:half_dataset_length,:);
M_Meteorological_Covariates_Daily_simulperiod=M_Meteorological_Covariates_Daily(half_dataset_length+1:end,:);
M_Meteorological_Covariates_Monthly_calibperiod=M_Meteorological_Covariates_Monthly(1:half_dataset_length,:);
M_Meteorological_Covariates_Monthly_simulperiod=M_Meteorological_Covariates_Monthly(half_dataset_length+1:end,:);



%%
%**** STEP 1: Rain typing ****
%*****************************

%----Compute parameters of the transform function (Psy) for each day and derive the latent values
[M_Data_latent_calibperiod,V_p0_calibperiod,V_k_calibperiod,V_teta_calibperiod]=ComputeLatentValues(M_DailyRainfall_records_calibperiod,V_Longitude_gauges,V_Latitude_gauges);

%----Karhunen-Loeve expansion of the latent field
[M_EigVect_calibperiod,M_PCs_calibperiod]=KL_Transform(M_Data_latent_calibperiod);

%----Rain typing----
[V_RainTypes_calibperiod,~,nb_clusters]=RainTyping(V_p0_calibperiod,V_k_calibperiod,V_teta_calibperiod,M_PCs_calibperiod,0);

%----Display rain typing results----
Display_RainTypes(V_Time_calibperiod,M_DailyRainfall_records_calibperiod,V_RainTypes_calibperiod,M_Meteorological_Covariates_Daily_calibperiod,V_Longitude_gauges,V_Latitude_gauges)



%%
%**** STEP 2: Stochastic rainfall model calibration ****
%*******************************************************

%------Calibration non-homogeneous Markov Chain---------
[str_RainType_occurence_calib]=Calib_MarkovChain_nonHomogeneous(nb_clusters,M_Meteorological_Covariates_Monthly_calibperiod,V_RainTypes_calibperiod);
%----------Calibration Meta-gaussian model--------------
[str_MarginalDistributions_calibperiod]=Calib_MarginalDistributions(V_p0_calibperiod,V_k_calibperiod,V_teta_calibperiod,V_RainTypes_calibperiod);
[str_SpatialCopulas_calibperiod]=Calib_SpatialCopulas(M_Data_latent_calibperiod,M_DailyRainfall_records_calibperiod,V_RainTypes_calibperiod);




%%
%**** STEP 3: Stochastic Simulation ****
%***************************************

nb_simul=50; %#to set

%-----------initialization---------------
str_simulated_rain=struct();
for my_iter_sim=1:nb_simul
    str_simulated_rain(my_iter_sim).data=[];    
end

%----------run simulations---------------
for my_iter_sim=1:nb_simul
    %Simulation of Rain types
    [V_RainTypes_simulated]=Simul_RainTypeOccurence(nb_clusters,M_Meteorological_Covariates_Monthly_simulperiod,str_RainType_occurence_calib);%non-homogeneous MC
    %Simulation of Rain intensity conditional to rain types
    [M_SimulatedRain]=Simul_DailyRainFields(V_RainTypes_simulated,str_MarginalDistributions_calibperiod,str_SpatialCopulas_calibperiod);
    %Store simulation results
    str_simulated_rain(my_iter_sim).data=[str_simulated_rain(my_iter_sim).data, M_SimulatedRain];
end

%--------- Display results ---------------
%Site-specific statistics
Display_SingleGauge_Results([74 71 70 49 48],V_Time_simulperiod,M_DailyRainfall_records_simulperiod,str_simulated_rain,V_Latitude_gauges,V_Longitude_gauges)
%Island-scale statistics
Display_IslandScale_Statistics(V_Time_simulperiod,M_DailyRainfall_records_simulperiod,str_simulated_rain)
%Spatial patterns
Display_Quantiles_Maps(V_Time_simulperiod,M_DailyRainfall_records_simulperiod,str_simulated_rain,V_Latitude_gauges,V_Longitude_gauges);

