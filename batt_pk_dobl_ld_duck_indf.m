%Filename:     batt_pk_dobl_ld_duck_indf.m
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
load                = 'duck';
b.is_cooperative    = false;
myseed              = gen_iteration_random;

battery_arch