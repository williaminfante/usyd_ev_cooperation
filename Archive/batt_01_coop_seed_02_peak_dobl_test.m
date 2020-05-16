%Filename:     batt_01_coop_seed_02_test.m
%Description:  Generates Battery class
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-21  1.0   Creation
%======================================================================

clear_values

load                = 'duck';
%Create Battery b
b                   = Battery; 
b.is_cooperative    = true;
b.is_double_peak    = true;
%b.heavy_interval    = my.HEAVY_INTERVAL;
%b.light_interval    = my.LIGHT_INTERVAL;
myseed              = 02;

battery_arch