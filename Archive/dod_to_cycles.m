function cycles = dod_to_cycles( dod )
%DOD_TO_CYCLES convert Depth of Discharge to Number of Cycles at that rate
% [Santhanagopalan, 2010 #155] computation: DOD = 145.71*(CYCLES)^(-0.6844) 
% Our rearranged Formula:   CYCLES = (DOD/145.71)^(-1.46199)
% Note: DoD is in [0,1]
cycles = round((dod/145.71)^(-1.46199));
end

