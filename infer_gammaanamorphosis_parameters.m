function[V_accumulation_gaussian,k,teta]=infer_gammaanamorphosis_parameters(prop_zeros,V_raw_accumulation)

data=V_raw_accumulation;

fun = @(param)-1*((param(1)-1)*sum(log(data)) - length(data)*log(gamma(param(1))) - length(data)*param(1)*log(param(2)) - 1/param(2)*sum(data));
param0(1) = min(4/(skewness(data)^2),100);
param0(2) = mean(data)/2;
A=[[-1 0];[1 0];[0 -1];[0 1]];
b=[0.2;15;0.05;150];

param = fmincon(fun,param0,A,b);
k=param(1);
teta=param(2);


for i=1:length(V_raw_accumulation)
    my_uniform=gamcdf(V_raw_accumulation(i),k,teta);
    my_gaussian=norminv(prop_zeros+(1-prop_zeros)*my_uniform);
    V_accumulation_gaussian(i)=my_gaussian;
end

end