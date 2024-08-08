%tests optimally oriented plane algorithm
%2012 stress field, southern California, 1x1 degree resolution

clear all
close all

%load tectonic/seismic stress tensor data
load WrightwoodStressTensors.txt; 

%define regional stress tensor components (calculated from Coulomb 3.3)
% xx, yy, zz, yz, xz, xy
regionalTensor = [-10.5594616; -89.4005432; -30.0000038; -0.0012789;...
    0.0050973; -30.7830715];

%define coefficient of friction
mu = 0.6;

%calculate optimally oriented planes
i = 1; %first plane
while i <= size(WrightwoodStressTensors,1)
    stressTensor = WrightwoodStressTensors(i,:)'; %tectonic/coseismic stress tensor
    optPlanes(i,:) = calcOptPlanes(regionalTensor,stressTensor,mu); %calculate optimally oriented plane
    i = i+1; %go to next stress tensor
end

save optPlanes optPlanes -ascii