global HEAD NUM POIS CALC_DEPTH YOUNG FRIC R_STRESS ID KODE ELEMENT
global FCOMMENT GRID SIZE SECTION
global MIN_LON MAX_LON MIN_LAT MAX_LAT ZERO_LON ZERO_LAT
global IRAKE IND_RAKE
global SEC_XS SEC_YS SEC_XF SEC_YF SEC_INCRE SEC_DEPTH SEC_DEPTHINC
fid = fopen(filename,'wt');
fprintf(fid,[HEAD{1}]); fprintf(fid,' \n');
fprintf(fid,[HEAD{2}]); fprintf(fid,' \n');
fprintf(fid,'#reg1=  0  #reg2=  0  #fixed= %3i  sym=  1\n',NUM);
fprintf(fid,' PR1=%12.3f     PR2=%12.3f   DEPTH=%12.3f\n',POIS,POIS,CALC_DEPTH);
fprintf(fid,'  E1=%15.3e   E2=%15.3e\n',YOUNG,YOUNG);
fprintf(fid,'XSYM=       .000     YSYM=       .000\n');
fprintf(fid,'FRIC=%15.3f\n',FRIC);
fprintf(fid,'S1DR=%15.3f',R_STRESS(1,1));
fprintf(fid,' S1DP=%15.3f',R_STRESS(1,2));
fprintf(fid,' S1IN=%15.3f',R_STRESS(1,3));
fprintf(fid,' S1GD=%15.3f\n',R_STRESS(1,4));
fprintf(fid,'S2DR=%15.3f',R_STRESS(2,1));
fprintf(fid,' S2DP=%15.3f',R_STRESS(2,2));
fprintf(fid,' S2IN=%15.3f',R_STRESS(2,3));
fprintf(fid,' S2GD=%15.3f\n',R_STRESS(2,4));
fprintf(fid,'S3DR=%15.3f',R_STRESS(3,1));
fprintf(fid,' S3DP=%15.3f',R_STRESS(3,2));
fprintf(fid,' S3IN=%15.3f',R_STRESS(3,3));
fprintf(fid,' S3GD=%15.3f\n\n',R_STRESS(3,4));
%
temp_element = ELEMENT; % to avoid accidental overwriting
%
if IRAKE == 0 | isempty(IRAKE) == 1           % right-lat & reverse slip format
    fprintf(fid,'  #   X-start    Y-start     X-fin      Y-fin   Kode  rt.lat    ');
    fprintf(fid,'reverse   dip angle     top      bot\n');
    fprintf(fid,'xxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxx xxxxxxxxxx ');
    fprintf(fid,'xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx\n');
elseif IRAKE == 1       % rake & net-slip format
    fprintf(fid,'  #   X-start    Y-start     X-fin      Y-fin   Kode   rake     ');
    fprintf(fid,'netslip   dip angle     top        bot\n');
    fprintf(fid,'xxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxx xxxxxxxxxx ');
    fprintf(fid,'xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx xxxxxxxxxx\n');

    imessage = 0;
    if isempty(IND_RAKE)
        for k = 1:NUM
            if ELEMENT(k,5)==0.0 && ELEMENT(k,6)==0.0
                temp_element(k,5) = 0.0;
                temp_element(k,5) = 0.0;
                imessage = 1;
            else
                [temp_element(k,5) temp_element(k,6)] = comp2rake(ELEMENT(k,5),ELEMENT(k,6));
            end
        end
        if imessage == 1
        warndlg({'No slip element exists.';'See command window for details.'});
        disp('Since slip is zero, rake and net slip have been set to 0.0; you must assign a rake to this patch if you want to use it as receiver.');
        end
    else
        for k = 1:NUM
            if ELEMENT(k,5)==0.0 && ELEMENT(k,6)==0.0
                temp_element(k,5) = IND_RAKE(k,1);
                 temp_element(k,5) = 0.0;
            else
                [temp_element(k,5) temp_element(k,6)] = comp2rake(ELEMENT(k,5),ELEMENT(k,6));
            end
        end
    end
end
sp = '   ';
for k=1:NUM
    fprintf(fid,'%3i %10.4f %10.4f %10.4f %10.4f ',ID(k),ELEMENT(k,1),ELEMENT(k,2),...
        ELEMENT(k,3),ELEMENT(k,4));
    if KODE(k) == 100
    fprintf(fid,'%3i %10.4f %10.4f %10.4f %10.4f %10.4f %s',KODE(k),...
        temp_element(k,5),temp_element(k,6),ELEMENT(k,7),ELEMENT(k,8),ELEMENT(k,9),sp);
    else
        fprintf(fid,'%3i %10i %10i %10.4f %10.4f %10.4f %s',KODE(k),...
            int64(temp_element(k,5)),int64(temp_element(k,6)),ELEMENT(k,7),ELEMENT(k,8),ELEMENT(k,9),sp);
    end
    try
        if iscell(FCOMMENT(k).ref) == 1
            fprintf(fid,cell2mat(FCOMMENT(k).ref)); fprintf(fid,' \n');
        elseif iscell(FCOMMENT(k).ref) == 0
            fprintf(fid,FCOMMENT(k).ref); fprintf(fid,' \n');
        end
    catch
        fprintf(fid,' \n');
    end
end
fprintf(fid,'  \n');
fprintf(fid,'    Grid Parameters\n');
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',GRID(1,1));
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',GRID(2,1));
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',GRID(3,1));
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',GRID(4,1));
fprintf(fid,'  5  ------------------------  x-increment = %16.7f\n',GRID(5,1));
fprintf(fid,'  6  ------------------------  y-increment = %16.7f\n',GRID(6,1));
fprintf(fid,'     Size Parameters\n');
fprintf(fid,'  1  --------------------------  Plot size = %16.7f\n',SIZE(1,1));
fprintf(fid,'  2  --------------  Shade/Color increment = %16.7f\n',SIZE(2,1));
fprintf(fid,'  3  ------  Exaggeration for disp.& dist. = %16.7f\n',SIZE(3,1));
fprintf(fid,'  \n');
if ~isempty(SEC_XS) && ~isempty(SEC_YS) && ~isempty(SEC_XF) && ~isempty(SEC_YF)...
        && ~isempty(SEC_INCRE) && ~isempty(SEC_DEPTH) && ~isempty(SEC_DEPTHINC)
fprintf(fid,'     Cross section default\n');
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',SEC_XS);
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',SEC_YS);
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',SEC_XF);
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',SEC_YF);
fprintf(fid,'  5  ------------------  Distant-increment = %16.7f\n',SEC_INCRE);
fprintf(fid,'  6  ----------------------------  Z-depth = %16.7f\n',(-1.0)*SEC_DEPTH);
fprintf(fid,'  7  ------------------------  Z-increment = %16.7f\n',SEC_DEPTHINC);
elseif isempty(SECTION) ~= 1
fprintf(fid,'     Cross section default\n');
fprintf(fid,'  1  ----------------------------  Start-x = %16.7f\n',SECTION(1,1));
fprintf(fid,'  2  ----------------------------  Start-y = %16.7f\n',SECTION(2,1));
fprintf(fid,'  3  --------------------------   Finish-x = %16.7f\n',SECTION(3,1));
fprintf(fid,'  4  --------------------------   Finish-y = %16.7f\n',SECTION(4,1));
fprintf(fid,'  5  ------------------  Distant-increment = %16.7f\n',SECTION(5,1));
fprintf(fid,'  6  ----------------------------  Z-depth = %16.7f\n',SECTION(6,1));
fprintf(fid,'  7  ------------------------  Z-increment = %16.7f\n',SECTION(7,1));
end
if isempty(MIN_LON) ~= 1 && isempty(MAX_LON) ~= 1
    if isempty(MIN_LAT) ~= 1 && isempty(MAX_LAT) ~= 1
        if isempty(ZERO_LON) ~= 1 && isempty(ZERO_LAT) ~= 1
fprintf(fid,'     Map info\n');
fprintf(fid,'  1  ---------------------------- min. lon = %16.7f\n',MIN_LON);
fprintf(fid,'  2  ---------------------------- max. lon = %16.7f\n',MAX_LON);
fprintf(fid,'  3  ---------------------------- zero lon = %16.7f\n',ZERO_LON);
fprintf(fid,'  4  ---------------------------- min. lat = %16.7f\n',MIN_LAT);
fprintf(fid,'  5  ---------------------------- max. lat = %16.7f\n',MAX_LAT);
fprintf(fid,'  6  ---------------------------- zero lat = %16.7f\n',ZERO_LAT);
        end
    end
end
fclose(fid);
