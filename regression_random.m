%Filename:     regression_random.m
%Description:  List of simulations to run
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-27  1.0   Creation
%======================================================================

battery_number = 2; 

for iteration=1:battery_number
    gen_iteration_random = randi([1,1000],1,1);
    
    %Normal Load 
    batt_pk_norm_ld_nswd_indf
    batt_pk_norm_ld_nswd_coop

    %Dobl Load, NSWD
    batt_pk_dobl_ld_nswd_indf
    batt_pk_dobl_ld_nswd_coop

    %Dobl Load, MOJO
    batt_pk_dobl_ld_mojo_indf
    batt_pk_dobl_ld_mojo_coop

    %Dobl Load, MOJO
    batt_pk_dobl_ld_duck_indf
    batt_pk_dobl_ld_duck_coop
end