load('/Users/Oakley/Documents/Work/microx/simulations/filter_transmission_data.mat','-mat');

%Actual energy array at good resolution (0.5 eV)
microx_energy = 0.100:.0005:10.000;

%Interpolate the filters to match the desired resolution. Set them to 1
%(0.97 for the meshed ones)
%from 4-10keV. This matches Henke data. Could import from 0.1 to 10, but then
%we'd lose resolution on the filters (maximum of 500 steps)
filter_transmission = interp1(filter_energy,filter_transmission,microx_energy,'linear',1);
filter_transmission_mesh = interp1(filter_energy,filter_transmission_mesh,microx_energy,'linear',0.97);

%Load the optics effective area curve
%optics_file_newmirrors = '/Users/Oakley/Documents/Work/microx/simulations/optics_effective_area_2.5m_rh_coated.txt';
optics_file_newmirrors = '/Users/Oakley/Documents/Work/microx/simulations/optics_effective_area_2.5m_1-5shell_rhcoated.txt';
optics_file_newmirrors_ni = '/Users/Oakley/Documents/Work/microx/simulations/optics_effective_area_2.5m_ni_coated.txt';
optics_file_newmirrors_ir = '/Users/Oakley/Documents/Work/microx/simulations/optics_effective_area_2.5m_ir_coated.txt';

optics_file = '/Users/Oakley/Documents/Work/microx/simulations/optics_effective_area_2.1m.txt';
[optics_energy_newmirrors, optics_area_raw_newmirrors] = textread(optics_file_newmirrors,'%f%f');
[optics_energy_newmirrors_ni, optics_area_raw_newmirrors_ni] = textread(optics_file_newmirrors_ni,'%f%f');
[optics_energy_newmirrors_ir, optics_area_raw_newmirrors_ir] = textread(optics_file_newmirrors_ir,'%f%f');
[optics_energy, optics_area_raw] = textread(optics_file,'%f%f');

%Interpolate the optics effective area curves to the desired resolution
optics_area_newmirrors = interp1(optics_energy_newmirrors,optics_area_raw_newmirrors,microx_energy,'linear','extrap');
optics_area_newmirrors_ni = interp1(optics_energy_newmirrors_ni,optics_area_raw_newmirrors_ni,microx_energy,'linear','extrap');
optics_area_newmirrors_ir = interp1(optics_energy_newmirrors_ir,optics_area_raw_newmirrors_ir,microx_energy,'linear','extrap');
optics_area = interp1(optics_energy,optics_area_raw,microx_energy,'linear','extrap');

%Calculate the new effective are curves
microx_area_newmirrors_rh = optics_area_newmirrors .* filter_transmission_mesh.^3 .* filter_transmission.^2;
microx_area_newmirrors_ni = optics_area_newmirrors_ni .* filter_transmission_mesh.^3 .* filter_transmission.^2;
microx_area_newmirrors_ir = optics_area_newmirrors_ir .* filter_transmission_mesh.^3 .* filter_transmission.^2;
microx_area = optics_area .* filter_transmission_mesh.^3 .* filter_transmission.^2;

%Take care of any negative interpolation
microx_area_newmirrors_rh(microx_area_newmirrors_rh < 0) = 0;
microx_area_newmirrors_ni(microx_area_newmirrors_ni < 0) = 0;
microx_area_newmirrors_ir(microx_area_newmirrors_ir < 0) = 0;
microx_area(microx_area < 0) = 0;

% plot(microx_energy,optics_area,'k');
% title('2.1 Meter Optics');
% xlabel('Energy [keV]');
% ylabel('Effective Area [cm^2]');

%Plot
plot(microx_energy,microx_area,'k');
title('Effective Area Curves for Micro-X Optics');
xlabel('Energy [keV]');
ylabel('Effective Area [cm^2]');
hold on

plot(microx_energy,microx_area_newmirrors_rh,'b');
%plot(microx_energy,microx_area_newmirrors_ni,'g');
%plot(microx_energy,microx_area_newmirrors_ir,'r');
%legend('2.1 Meter Optics with 5 Filters (3 with Meshes)','2.5 Meter Optics (4 Rh coated Shells) with 5 Filters (3 with Meshes)','2.5 Meter Optics (4 Ni coated Shells) with 5 Filters (3 with Meshes)','2.5 Meter Optics (4 Ir coated Shells) with 5 Filters (3 with Meshes)');
legend('Current Optics','High Resolution Optics (5 shells)');

%Save the data

%put this back in! taking it out to make 2-6 shell version
%save('/Users/Oakley/Documents/Work/microx/simulations/microx_effective_area_data.mat','filter_energy', 'al_transmission','poly_transmission','filter_transmission','filter_transmission_mesh','microx_energy','microx_area','microx_area_newmirrors_rh','microx_area_newmirrors_ni','microx_area_newmirrors_ir','optics_area','optics_area');

file_values = [microx_energy;microx_area;microx_area_newmirrors_rh;microx_area_newmirrors_ni;microx_area_newmirrors_ir];
fileID = fopen('microx_effective_area_values_rh_1-5shells.txt','w');
fprintf(fileID,'%s %s %s %s %s\n','Energy','Area (Current)','Area (2.5m Rh coated)','Area (2.5m Ni coated)','Area (2.5m Ir coated)');
fprintf(fileID,'%f %f %f %f %f\n',file_values);
%fprintf(fileID,'%f \n',microx_energy);
fclose(fileID);



%dlmwrite('/Users/Oakley/Documents/Work/microx/simulations/microx_effective_area_rh_2-6shells.txt', microx_area_newmirrorsrh)
%dlmwrite('/Users/Oakley/Documents/Work/microx/simulations/microx_energy.txt', microx_energy)
%dlmwrite('/Users/Oakley/Documents/Work/microx/simulations/microx_energy_newmirrors_rh.txt', microx_energy_newmirrors_rh)
%dlmwrite('/Users/Oakley/Documents/Work/microx/simulations/microx_energy_newmirrors_ni.txt', microx_energy_newmirrors_ni)
%dlmwrite('/Users/Oakley/Documents/Work/microx/simulations/microx_energy_newmirrors_ir.txt', microx_energy_newmirrors_ir)
