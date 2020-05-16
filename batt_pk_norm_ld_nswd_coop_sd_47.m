%Filename:     batt_pk_norm_ld_nswd_coop_sd_47.m
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
b.is_double_peak    = false;
load                = 'nswd';
b.is_cooperative    = true;
myseed              = 47;

battery_arch