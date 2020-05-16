%Filename:     batt_01_coop_seed_39_test.m
%Description:  Generates Battery class
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-21  1.0   Creation
%======================================================================

clear_values

%Create Battery b
b                   = Battery; 
b.is_cooperative    = true;
myseed              = 39;

battery_arch