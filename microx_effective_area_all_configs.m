
shell_diameter = [23.97359055, 23.22477953,22.49675591,21.78899606,21.10099213,20.43224409,19.78225984,18.68583099,18.01888496,17.37122074,16.74229064,16.13156164,15.53851509,14.96264636];
geometrical_area = [164.460554,154.4994725,145.1001368,136.2335635,127.872031,119.9890483,112.5593218,101.30,94.22,87.58,81.37,75.55,70.11,65.01];
geometrical_area = flipdim(geometrical_area,2);
graze_angles = [1.66388484,1.61363535,1.564629235,1.516847905,1.470272015,1.42488156,1.380655995,1.31647,1.26972,1.22430,1.18018,1.13730,1.09565,1.05519];

shell_options = size(shell_diameter,2);  %should be 14

%Load Filter Curves
load('/Users/Oakley/Documents/Work/microx/simulations/microx_effective_area_data.mat');

curve_points=500;
microx_points = size(microx_energy,2);

effective_area = zeros(shell_options,microx_points);
efficiency_curves_rh = effective_area;
efficiency_curves_ir = effective_area;
efficiency_curves_ni = effective_area;


%Load the mirror efficiency curves
for k=1:5
    %load efficiency curves
    [energy,reflectivity,transmission] = textread(['/Users/Oakley/Documents/Work/microx/3rd_flight_design/effective_area/efficiency_shell' num2str(k) '.txt'],'%f%f%f','headerlines',2);
    
    %Put energy into keV
    energy = energy / 1e3;
    
    %square curves to account for 2 bounces
    reflectivity = reflectivity.^2;
    
    %Interpolate to the energy resolution of micro-x
    interp_reflectivity = interp1(energy,reflectivity,microx_energy);
    
    %Convovle with filters
    %full_reflectivity = interp_reflectivity .* filter_transmission.^2 .* filter_transmission.^3;
    full_reflectivity = interp_reflectivity;
    
    %insert curve into master matrix
    efficiency_curves_rh(k,:) = full_reflectivity;
        
end


mirror_area = zeros(5,microx_points);
for k=1:5
    mirror_area(k,:) = efficiency_curves_rh(k,:)*geometrical_area(k);
end

effective_area = sum(mirror_area,1)*.8;

plot(microx_energy,effective_area,'k');






[energy,config1,config2,config3,config4,config5,config6] = textread('/Users/Oakley/Documents/Work/microx/3rd_flight_design/effective_area/config_comaprison_data.txt','%f%f%f%f%f%f%f','headerlines',1);
plot(energy,config1);
hold on;
plot(energy,config2);
plot(energy,config3);
plot(energy,config4,'r');
plot(energy,config5,'r');
plot(energy,config6,'r');
xlabel('Energy [keV]');
ylabel('Effective Area [cm^2]');
ylim([0,500]);



