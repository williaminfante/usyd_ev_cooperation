%Filename:     batt_pk_dobl_ld_mojo_coop.m
%Description:  Generates Battery class
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-27  1.0   Creation
%======================================================================



%Create Battery and Load parameters
b                   = Battery; 
b.is_double_peak    = true;
load                = 'mojo';
b.is_cooperative    = true;
myseed              = gen_iteration_random;

battery_arch