function[M_EigVect,M_PCs]=KL_Transform(M_Data_latent)

X=M_Data_latent';
[W,~] = eig(X'*X); %eigenvector decomposition of variance-covariance matrix
M_EigVect=fliplr(W);
M_PCs=X*M_EigVect;

M_EigVect=M_EigVect(:,1:3);
M_PCs=M_PCs(:,1:3);
end