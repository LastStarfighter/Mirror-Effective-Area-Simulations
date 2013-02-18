%Compare Mirror Coatings at an angle of 1.2697 degrees

[energy,reflect_ni,trans] = textread('/Users/Oakley/Documents/Work/microx/3rd_flight_design/effective_area/efficiency_shell6_ni.txt','%f%f%f','headerlines',2);
[energy,reflect_rh,trans] = textread('/Users/Oakley/Documents/Work/microx/3rd_flight_design/effective_area/efficiency_shell6.txt','%f%f%f','headerlines',2);
[energy,reflect_ir,trans] = textread('/Users/Oakley/Documents/Work/microx/3rd_flight_design/effective_area/efficiency_shell6_ir.txt','%f%f%f','headerlines',2);

energy = energy/1000.;
reflect_ni = reflect_ni.^2;
reflect_ir = reflect_ir.^2;
reflect_rh = reflect_rh.^2;


plot(energy,reflect_rh,'m');
hold on;
plot(energy,reflect_ir,'b');
plot(energy,reflect_ni,'r');

legend('Rhodium','Irridium','Nickel');
xlim([0,4]);
xlabel('Energy [keV]');
ylabel('Efficiency');
title('Coating Effectiveness [2 reflections at 1.2697 degrees off a 30nm layer]');


