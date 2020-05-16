%Filename:     batt_pk_dobl_ld_duck_coop_sd_85.m
%Description:  Generates Battery class
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-21  1.0   Creation
%======================================================================

clear_values

%Create Battery and Load parameters
b                   = Battery; 
b.is_double_peak    = true;
load                = 'duck';
b.is_cooperative    = true;
myseed              = 85;

battery_arch