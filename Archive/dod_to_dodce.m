function cycles_equivalent = dod_to_dodce( dod )
%DOD_TO_DODCE Convert DoD to Cycle Equivalent (remaining full charge)
%[Strickland, 2014#134] DoDCE = No. of cycles x DoD
cycles = @dod_to_cycles;
cycles_equivalent = round(cycles(dod) *dod);
end