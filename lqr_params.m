clear; clc; close all;

%params
m  = 0.029;
g  = 9.81;
Jx = 1.4e-5;
Jy = 1.4e-5;
Jz = 2.17e-5;
l  = 0.046;

nx = 12;
nu = 4;
Ts = 0.004; %250 Hz

%lqr weights
Q_base = diag([20, 20, 40, 5, 5, 10, 40, 40, 10, 5, 5, 1]);
R_base = diag([10, 1, 1, 1]);

%range for lookup table
roll_range  = deg2rad(-30:5:30);
pitch_range = deg2rad(-30:5:30);

K_lookup = cell(length(pitch_range), length(roll_range));

for i = 1:length(pitch_range)
    for j = 1:length(roll_range)
        
        theta_eq = pitch_range(i);
        phi_eq   = roll_range(j);
        
        A = zeros(nx,nx);
        B = zeros(nx,nu);
        
        A(1,4) = 1; A(2,5) = 1; A(3,6) = 1;
        A(7,10) = 1; A(8,11) = 1; A(9,12) = 1;
        
        
        A(4,8) =  g * cos(theta_eq);  % x_accel ==> pitch
        A(5,7) = -g * cos(phi_eq);    % y_accel ==>roll
        
        B(6,1)  = 1/m;    
        B(10,2) = l/Jx;   
        B(11,3) = l/Jy;   
        B(12,4) = 1/Jz;   

        sysc = ss(A,B,[],[]);
        sysd = c2d(sysc, Ts, 'zoh');
        
        [K_temp, ~] = dlqr(sysd.A, sysd.B, Q_base, R_base);
        
        K_lookup{i,j} = K_temp;
    end
end

%write c readable array for lookup table
fileID = fopen('lookup_table.txt','w');

for i = 1:length(pitch_range)
    fprintf(fileID, '  {\n');
    for j = 1:length(roll_range)
        fprintf(fileID, '    {\n'); 
        K_curr = K_lookup{i,j};
        
        for row = 1:4
            fprintf(fileID, '      {');
            for col = 1:12
                if col < 12
                    fprintf(fileID, '%f, ', K_curr(row, col));
                else
                    fprintf(fileID, '%f', K_curr(row, col));
                end
            end
            if row < 4
                fprintf(fileID, '},\n');
            else
                fprintf(fileID, '}\n');
            end
        end
        
        if j < length(roll_range)
            fprintf(fileID, '    },\n');
        else
            fprintf(fileID, '    }\n');
        end
    end
    if i < length(pitch_range)
        fprintf(fileID, '  },\n');
    else
        fprintf(fileID, '  }\n');
    end
end
fprintf(fileID, '};\n');
fclose(fileID);

disp("Done");