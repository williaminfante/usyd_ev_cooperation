%Filename:     variables.m
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-04  1.0   Creation
%======================================================================

%Variables
status_kWH_for_grid                 = 0;    
status_kWH_possible_capacity_grid   = 0; 
time_type_returned                  = time_type_returned.HEAVY_INTERVAL;
profit_swap_customer_per_visit      = 0;
add_purchase_batt;
accumulated_profit_per_day          = 0;

%Counters
batt_taken_from_class_a_counter     = 0; 
batt_taken_from_class_b_counter     = 0; 
num_demand_ev_batt                  = 0;