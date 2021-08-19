This code corresponds to the rainfall model presented in the paper 'Stochastic daily rainfall generation on tropical islands with complex topography' by Benoit L, Sichoix L, Nugent A.D, Lucas M.P and Giambelluca T.W.

Brief model description:
To allow for stochastic rainfall modeling on tropical islands, despite non-stationarity, we propose a new stochastic daily rainfall generator specifically for areas with significant orographic effects.
Our model relies on a preliminary classification of daily rain patterns into rain types based on rainfall space and intensity statistics, and sheds new light on rainfall variability at the island scale. Within each rain type, the spatial distribution of rainfall through the island is modeled following a meta-Gaussian approach combining empirical spatial copulas and a Gamma transform function, which allows us to generate realistic daily rain fields.

An exemple dataset and a demo script focusing of the island of O'ahu, Hawai'i, USA are provided along with the model.

This model is implemented in MATLAB, and therefore requires a MATLAB license and toolboxes.

How to use it? Open and run the following script: Script_IslandScale_RainfallGenerator.m

Enjoy the rain! :-)
