function optData = calcOptPlanes(regionalStress,stressChange,mu)
%calculates optimally oriented planes given regional stress tensor,
%stress tensor from tectonic, seismic sources, and coefficient of friction
%stress tensor component input must be 6x1 column vector: xx, yy, zz, yz,
%xz, xy
%mu = coefficient of friction
%output: optimally oriented strike, dip, rake, and normal, shear and
%Coulomb stress changes

%combine regional stres, seismic/tectonic stress tensor components
totalTensor = regionalStress+stressChange;

%define stress tensor components (seismic/tectonic stress), format into 3x3 matrix
%total stress tensor
TXX = totalTensor(1,1); 
TYY = totalTensor(2,1);
TZZ = totalTensor(3,1);
TYZ = totalTensor(4,1);
TXZ = totalTensor(5,1);
TXY = totalTensor(6,1);
tTensor = [TXX,TXY,TXZ;TXY,TYY,TYZ;TXZ,TYZ,TZZ];
%only seismic/tectonic stress changes
SXX = stressChange(1,1);
SYY = stressChange(2,1);
SZZ = stressChange(3,1);
SYZ = stressChange(4,1);
SXZ = stressChange(5,1);
SXY = stressChange(6,1);

%calculate principle stresses (eigValues), eigenvectors (eigVectors)
[eigVectors,eigValues] = eig(tTensor);

%sort eigenvectors by principal stress
eigVal1 = eigValues(1,1); %find eigenvalues
eigVal2 = eigValues(2,2);
eigVal3 = eigValues(3,3);
eigColumn = [eigVal1;eigVal2;eigVal3];
eigData = [eigColumn eigVectors'];
eigData = sortrows(eigData,-1);

%define rotation matrix
rotationMatrix = eigData(:,2:4)';

%define principal stresses
sigma1 = eigData(1,1); %greatest principal stress
sigma2 = eigData(2,1); %intermediate principal stress
sigma3 = eigData(3,1); %least principal stress

%define Mohr's circle properties
centerCircleN = (sigma1+sigma3)/2; %normal stress at center of main circle
circleRadius = sigma1-centerCircleN; %radius of main circle
theta = atan(mu); %angle between x-axis, line tangent to main circle (its slope is defined by coefficient of friction)

%calculate normal, shear stress changes
sigmaN = centerCircleN+(circleRadius*cos(theta)); %normal stress change
sigmaS = abs(circleRadius*sin(theta)); %shear stress change

%solve for components of vector normal to fault plane (in principal axes)
%******SOMETIMES THESE VALUES ARE SLIGHTLY NEGATIVE, POSSIBLY FROM ROUNDING
%ERRORS********
n1squared = ((sigmaN-sigma2)*(sigmaN-sigma3)+sigmaS^2)/((sigma1-sigma2)*(sigma1-sigma3));
n2squared = ((sigmaN-sigma3)*(sigmaN-sigma1)+sigmaS^2)/((sigma2-sigma3)*(sigma2-sigma1));
n3squared = ((sigmaN-sigma1)*(sigmaN-sigma2)+sigmaS^2)/((sigma3-sigma1)*(sigma3-sigma2));

%positive and negative solutions for each component of n (only real values)
n1pos = real(sqrt(n1squared));
n1neg = real(-sqrt(n1squared));
n2pos = real(sqrt(n2squared));
n2neg = real(-sqrt(n2squared));
n3pos = real(sqrt(n3squared));
n3neg = real(-sqrt(n3squared));

%possible n values (all combinations of negative, positive normal vector
%components)
normal1 = [n1pos; n2pos; n3pos];
normal2 = [n1pos; n2pos; n3neg];
normal3 = [n1pos; n2neg; n3pos];
normal4 = [n1pos; n2neg; n3neg];
normal5 = [n1neg; n2pos; n3pos];
normal6 = [n1neg; n2pos; n3neg];
normal7 = [n1neg; n2neg; n3pos];
normal8 = [n1neg; n2neg; n3neg];

%create matrix of possible normal vectors
normalVectorMatrix = [normal1 normal2 normal3 normal4 normal5 ...
    normal6 normal7 normal8];

%calculate Coulomb stress for each possible normal vector
i = 1; %begin with first normal vector
k = [0;0;1]; %vertical unit vector

while i <= 8
    %define normal vector
    normalVector = normalVectorMatrix(:,i); 
    
    %rotate normal vector into original coordinate system
    normalVector = rotationMatrix*normalVector;
    
    %calculate vectors parallel to fault plane
    fs = cross(k, normalVector); %parallel vector along strike
    fStrikeSlip = fs/(sqrt(fs(1,1)^2+fs(2,1)^2+fs(3,1)^2)); %normalize fs
    fDipSlip = cross(normalVector,fStrikeSlip); %parallel vector along dip, should already be normalized
    
    %calculate strike and dip of fault plane
    strike = asin(-fStrikeSlip(1,1)); %strike angle (radians)
    dip = acos(fDipSlip(1,1)/cos(strike)); %dip angle (radians)
    
    %calculate rake angle
    t = tTensor*normalVector; %traction vector
    a = dot(t,fStrikeSlip); %a and b are used to calculate rake angle
    b = dot(t,fDipSlip); 
    rake = acos(a/sqrt(a^2+b^2)); %rake angle (radians)
    
    %convert fault plane angles to degrees
    strike = strike*180/pi;
    dip = dip*180/pi;
    rake = rake*180/pi;
    
    %calculate Coulomb stress for selected normal vector, form matrix of
    %stress change values
    %stressCalc function gives 1x3 row vector with normal, shear and
    %Coulomb stress change
    stressChange = stressCalc(strike,dip,rake,TXX,TYY,TZZ,TYZ,TXZ,TXY);
    stressChanges(i,:) = stressChange; %add to matrix of stress change values
    strikeAngles(i,1) = strike; %add to columns of fault plane angles
    dipAngles(i,1) = dip;
    rakeAngles(i,1) = rake;
    i = i+1; %go to next normal vector
end

%find maximum Coulomb stress change, define optimally oriented plane
%combine fault plane, stress data into matrix
stressData = [strikeAngles dipAngles rakeAngles stressChanges];
%sort matrix rows according to Coulomb stress change
stressData = sortrows(stressData,6);

%define optimally oriented planes
optStrike = stressData(8,1); %optimal strike angle
optDip = stressData(8,2); %optimal dip angle
optRake = stressData(8,3); %optimal rake angle

%calculate stress change from optimally oriented planes, seismic/tectonic
%stress tensor
optimalStressChanges = stressCalc(optStrike,optDip,optRake,SXX,SYY,SZZ,...
    SYZ,SXZ,SXY); %left to right: normal, shear, Coulomb stress change
optimalCoulomb = optimalStressChanges(:,3); %Coulomb stress change from optimally oriented plane

%final output
optData = [optStrike optDip optRake optimalCoulomb];

