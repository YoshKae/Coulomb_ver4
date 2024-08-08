function stressChanges = stressCalc(strike,dip,rake,SXX,SYY,SZZ,SYZ,SXZ,SXY)
%calculates shear, normal, and Coulomb stress changes
%requires plane orientation (degrees) and stress tensor components
%agrees with Coulomb 3.3 when not taking into account regional stress

%form stress tensor
stressTensor = [SXX SXY SXZ; SXY SYY SYZ; SXZ SYZ SZZ];

%define parameters, convert angles to radians
mu = 0.6;
strike = strike*pi/180; %strike (radians)
dip = dip*pi/180; %dip (radians)
rake = rake*pi/180; %rake (radians)

%calculate normal stress change
normalStress = dot(stressTensor*[cos(strike)*sin(dip); -sin(strike)*sin(dip);...
     cos(dip)],[cos(strike)*sin(dip); -sin(strike)*sin(dip); cos(dip)]); 
 
%calculate shear stress change
shearStress = -cos(rake)*dot(stressTensor*[cos(strike)*sin(dip); -sin(strike)*sin(dip); cos(dip)],...
     [-sin(strike); -cos(strike);0])-sin(rake)*dot(stressTensor*[cos(strike)*sin(dip); -sin(strike)*sin(dip); cos(dip)],...
    [cos(strike)*cos(dip); -sin(strike)*cos(dip); -sin(dip)]);

%calculate Coulomb stress change
coulombStress = mu*normalStress+shearStress;

%final output
stressChanges = [normalStress shearStress coulombStress];