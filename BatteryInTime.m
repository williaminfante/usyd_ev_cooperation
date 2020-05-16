%Filename:     BatteryInTime.m
%Description:  Observe 1 battery charging and discharging in a swapping
%              station at random intervals including pricing.
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-14  1.0   Creation
%======================================================================

%Clear Values 
clc
clear

%Initialize Values
mx_no = 0;
mx(1200, :) = {  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,                 ...
                11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
b = Battery; 

%======================================================================
b.is_cooperative    = false;
myseed              = 47;
%======================================================================


rng(myseed);  %Optional 


%Assumption: 50 days arbitrarily chosen 
for day=1:my.OBSERVATION_YEARS*my.DAYS_IN_A_YEAR
    b.abs_day_current = day;
    for hour=1:my.HOURS_IN_A_DAY
        b.hour_day_current = hour; 
        
        %Assumption: 50% chance to discharge when possible
        if ( randperm(2,1) == 2 && b.can_discharge == true) 
            
            %Safeguard condition so SoC will not go below 25;
            if (b.soc_current_charge == 60)
                b.discharge(25); 
            else
                b.discharge(randi([4,6],1,1)*10); 
            end
            
            %Assumption: user will use up battery after 1 day and 
            %   about 6 to 8 more hours
            b.customer_used_hours = 24 + randi([6 8], 1); 
            
            b.hours_to_charge                                           ...
            = mod(b.hour_day_current + b.customer_used_hours            ...
               , my.HOURS_IN_A_DAY) + 1;
            
            if (b.is_cooperative == true)
                fut_addtl_hr_for_charge                                 ...
                = round( my.CHARGING_TIME                               ...
                 * (charge_type.SOC_FULL_CHARGE - b.soc_current_charge) ...
                 / (charge_type.SOC_FULL_CHARGE                         ...
                    - charge_type.SOC_EMPTY_CHARGE) );

                fut_hour_for_grid_ready                                 ...
                = mod(b.hours_to_charge + b.addtl_hr_for_charge, 24) + 1;
                
                
                
                
                diff_interval =[my.HEAVY_INTERVAL my.HEAVY_INTERVAL+24] ...
                    - double(fut_hour_for_grid_ready);
                diff_interval(diff_interval < 0) = []; 
                preferred_diff = min(diff_interval);
                if (preferred_diff <= my.COOPERATIVE_TIME)
                    b.customer_used_hours = b.customer_used_hours       ...
                        + preferred_diff;
                    b.hours_to_charge                                   ...
                    = mod(b.hour_day_current + b.customer_used_hours    ...
                       , my.HOURS_IN_A_DAY) + 1;
                end
            end
           
            b.abs_day_to_charge                                         ...
            = b.abs_day_current                                         ...
            + floor( (b.hour_day_current + b.customer_used_hours)       ...
               / my.HOURS_IN_A_DAY );                                              
                 
            b.can_discharge = false; 
            b.can_recharge = true; 
        end

        if (   (b.can_recharge == true)                                 ...
            && (b.hours_to_charge == hour)                              ...
            && (b.abs_day_to_charge == day) )
            %Cooperative customers assuming discount can be taken within 
            %3 hours 
            
            
            b.addtl_hr_for_charge                                       ...
            = round( my.CHARGING_TIME                                   ...
             * (charge_type.SOC_FULL_CHARGE - b.soc_current_charge)     ...
             / (charge_type.SOC_FULL_CHARGE                             ...
                - charge_type.SOC_EMPTY_CHARGE) );
            
            b.hour_for_grid_ready                                       ...
            = mod(b.hour_day_current + b.addtl_hr_for_charge, 24) + 1;
            
            b.day_for_grid_ready  = b.abs_day_current                   ...
                            + floor((b.hour_day_current                 ...
                                 + b.addtl_hr_for_charge)               ...
                                /my.HOURS_IN_A_DAY);
                            
            if (ismember(b.hour_for_grid_ready, my.HEAVY_INTERVAL) == true)
                b.discount_fee_undrained = my.DISCOUNT_VALUE; 
                b.discount_counter = b.discount_counter + 1; 
            else
                b.discount_fee_undrained = 0; 
            end

            
            %Assumption: Charging full has about 3 times chance than 
            %   charging partially.
            if (randperm(4,1) == 1) 
                b.charge(charge_type.SOC_FULL_CHARGE);
            else
                %Conditional safeguard in case battery is 60% or more SoC.
                %   This means it should be charged fully not partially.
                if (b.soc_current_charge >= charge_type.SOC_PARTIAL_CHARGE)
                    b.charge(charge_type.SOC_FULL_CHARGE);
                else
                    b.charge(charge_type.SOC_PARTIAL_CHARGE);
                end
            end
            
            
            b.profit_lease_fee                                          ...
            = b.customer_used_hours*my.HOUR_RATE_FOR_EV_BATT_USE        ...
            * (1 - b.discount_fee_undrained);
        
            b.profit_customer = b.profit_lease_fee + b.profit_swap_fee;
            b.total_profit_customer = b.total_profit_customer +         ...
                b.profit_customer;
            b.can_discharge = true; 
            b.can_recharge = false;
        end
        
        %Track property values at every time interval
        mx_no = mx_no + 1;       
        mx(mx_no, :) = {mx_no,                                          ...
                        day,                                            ...
                        hour,                                           ...
                        b.abs_day_current,                              ...
                        b.hour_day_current,                             ... 
                        b.abs_day_to_charge                             ... 
                        b.hours_to_charge,                              ...                       
                        b.soc_current_charge,                           ...
                        b.times_battery_charged,                        ...
                        b.can_discharge,                                ...
                        b.can_recharge                                  ...
                        b.addtl_hr_for_charge                           ...
                        b.hour_for_grid_ready                           ...
                        b.discount_fee_undrained                        ...
                        b.customer_used_hours                           ...
                        b.profit_lease_fee                              ...
                        b.profit_swap_fee                               ...
                        b.profit_customer                               ...
                        b.total_profit_customer                         ...
                        b.total_electricity_cost                        ...
                        };         
    end
end

if(b.is_cooperative == false) 
    FileName=sprintf('batt_%s_seed_%d.xlsx', datestr(now, 'yymmdd_HHMM'), myseed);
else 
    FileName=sprintf('batt_%s_seed_%d_coop.xlsx', datestr(now, 'yymmdd_HHMM'), myseed);    
end
xlswrite(FileName, mx);