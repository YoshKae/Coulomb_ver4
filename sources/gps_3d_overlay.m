global GPS_DATA PREF SIZE H_MAIN
            
    figure(H_MAIN);
    if ~isempty(GPS_DATA)
        zero = zeros(size(GPS_DATA,1),1);
        hold on;

        h = scatter3(GPS_DATA(:,6),GPS_DATA(:,7),zero,5*PREF(5,4));
        hold on;
        h1 = quiver3(GPS_DATA(:,6),GPS_DATA(:,7),zero,...
                GPS_DATA(:,3)*SIZE(3),...
                GPS_DATA(:,4)*SIZE(3),...
                GPS_DATA(:,5)*SIZE(3));
        % calc in half space
        m = size(GPS_DATA(:,6),1);
        ux = zeros(m,1,'double');
        uy = zeros(m,1,'double');
        uz = zeros(m,1,'double');
        [dc3de] = dc3de_calc(GPS_DATA(:,6),GPS_DATA(:,7));
        ux = dc3de(:,6);
        uy = dc3de(:,7);
        uz = dc3de(:,8);
        hold on;
        h2 = quiver3(GPS_DATA(:,6),GPS_DATA(:,7),zero,...
                ux*SIZE(3),...
                uy*SIZE(3),...
                uz*SIZE(3));
        set(h1,'Color','b','LineWidth',PREF(2,4),'Tag','GPS3D_OBS_Obj');
        set(h2,'Color','r','LineWidth',PREF(2,4),'Tag','GPS3D_CALC_Obj');

        set(h,'MarkerEdgeColor',[0.1,0.2,0.9]); % white edge color for GPS station 
        set(h,'Tag','GPSObj');                  % put a tag to remove them later
        hold on;
    end
