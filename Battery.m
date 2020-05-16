%Filename:     Battery.m
%Description:  Generates Battery class
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-14  1.0   Creation
%======================================================================

classdef Battery < handle
    %Battery: generates the Battery class 
    %   building block for the simulations
    properties
        id                      = 0;         
        mode                    = mode_type.IDLE_MODE;
        class_type_prop         = class_type.CLASS_B;
        
        %SoC
        soc_current_charge      = 100;
        soc_prev_charge         = 100;                 
        dod_ave                 = 0; 
        
        %SoH
        soh_previous            = 100;   
        soh                     = 100;         
        
        %Time
        abs_day_current         = 2; 
        hour_day_current        = 1;
        
        abs_day_to_charge       = 0;         
        hours_to_charge         = 0;
        
        abs_day_bought          = 1; 
        hour_bought             = 1;        %hour 1 to 24
        addtl_hr_for_charge     = 0;
        time_type_returned      = 0; 
        customer_used_hours     = 0; 
        
        hour_for_grid_ready     = 0;
        day_for_grid_ready      = 0;
        
        %Flags
        can_discharge           = true;
        can_recharge            = false;
        is_cooperative          = false;
        
        %Counters
        times_battery_charged   = 0; 
        cumulative_cycles       = 0;
        second_cycle_counter    = 0;   
        discount_counter        = 0;
        
        %Money 
        profit_customer         = 0; 
        profit_lease_fee        = 0;
        profit_swap_fee         = 0;
        discount_fee_undrained  = 0; 
        total_profit_customer   = 0; 
        total_electricity_cost  = 0; 
    end
    properties (Dependent)
        %Time
        year_bought             = 0; 
        year_disposed           = 0;
        days_battery_used       = 0;  
        
        %SoC
        dod_current             = 0;
        
        %Money
        purchase_price          = 0; 

    end
    
    methods          
        %% Get Methods
        function get_year_bought = get.year_bought(obj)
            get_year_bought = floor(obj.abs_day_bought / 360)           ...
                + my.YEAR_BASE;
        end
        function get_dod_current = get.dod_current(obj) 
            get_dod_current = obj.soc_prev_charge - obj.soc_current_charge;
        end
        function get_days_battery_used = get.days_battery_used(obj)       
            get_days_battery_used                                       ...
                = obj.abs_day_current - obj.abs_day_bought;
            if (obj.abs_day_current <= obj.abs_day_bought)
                error('Current day before date purchased!'); 
            end
        end
        function get_purchase_price = get.purchase_price(obj)
            %basis for formula 
            %   2014	4	550
            %   2017	7	300
            %   2020	10	200            
            get_purchase_price = my.BATTERY_CAPACITY                    ...
            * round(1044.1*exp(-0.169*(obj.year_bought - 2010)),2);
        end    
        
        
        
        %% Commands with Return Values
        function f = compute_soh(obj)
            % SoH is dependent on (a) calendar and (b) cycling fade
            %   [Santhanagopalan,   2010 #155] min (calendar, cycling)
            %   [Viswanathan,       2011 #133] from lower of 2 SoH, half  
            %   the higher degradation was subtracted
            %   Ours: similar to Viswanathan + additional degradation for 
            %   Second Life Batteries 
            function cycles = dod_to_cycles( dod_decimal )
            % DOD_TO_CYCLES convert Depth of Discharge to Number of Cycles
            %   [Santhanagopalan,   2010 #155] computation: 
            %   DOD = 145.71*(CYCLES)^(-0.6844) 
            %   Our rearranged formula:   
            %   CYCLES = (DOD/145.71)^(-1.46199)
            %   Note: DoD is in [0,1]
                cycles = round((dod_decimal/145.71)^(-1.46199));                
            end
            
            function cycles_equivalent = dod_to_dodce( dod )
            %DOD_TO_DODCE Convert DoD to Cycle Equivalent (full cycle)
            %   [Strickland,        2014#134] DoDCE = No. of cycles x DoD
                dod_decimal = dod / 100; 
                cycles = @dod_to_cycles;
                cycles_equivalent = round(min(cycles(dod_decimal)       ...
                    *dod_decimal), my.TYPICAL_CYCLE_MAX);
            end       
            
            function cal_fade = calendar_fade(time_in_days) %time in days 
                % [Strickland,        2014#134] day 1 = 100% SoH
                %   18 years = 80 % (linear approximation) 
                %   y = -0.003x + 100;
                cal_fade = -0.003*(time_in_days) + 100; 
            end 
            
            % [Strickland,        2014#134] 70-80%, 80% conservative 
            % [Viswanathan,       2011 #133] 80% 
            % Based on this, after using all first life cycles, value 
            % should be 80%; Typical cycle used is 2500 [#133]
            % make sure computed cycle does not exceed 2500
            
            f = @dod_to_dodce; 
            
            max_cycle = round(f(obj.dod_ave));
            %disp(max_cycle);
            % display(max_cycle); 
            % tempo_cumulative_cycles = obj.cumulative_cycles;
            % display(tempo_cumulative_cycles);
            % tempo_soh_previous = obj.soh_previous;
            % display(tempo_soh_previous);
            cycle_soh = (100                                            ...
              - 20*(min(obj.cumulative_cycles, max_cycle)/ max_cycle));
                        
            %disp(cycle_soh);      
            g = @calendar_fade; 
            calendar_soh = g(obj.days_battery_used);
            %disp(calendar_soh);
            real_soh = min(calendar_soh, cycle_soh) ...
                - 0.5*(100 - max(calendar_soh, cycle_soh));            
            %once it reaches below 80, second life becomes higher, 
            %meaning until the value itself     
            
            if (real_soh < 80) %%need reference
                obj.second_cycle_counter = obj.second_cycle_counter + 1; 
                f = real_soh - obj.second_cycle_counter/500; %%%%%%%%%%%%
            else
                f = real_soh;
            end                    
        end 
        %% Commands with no Return Values        
        function charge(obj, how_much_charge)   
            if (how_much_charge == charge_type.SOC_FULL_CHARGE) 
                obj.profit_swap_fee = my.FULL_FEE_SWAP;
            elseif (how_much_charge == charge_type.SOC_PARTIAL_CHARGE) 
                obj.profit_swap_fee = (1 - my.SWAP_REQUEST_DISCOUNT)    ...
                                    * my.FULL_FEE_SWAP;
            else 
                error('charge does not fall in correct category');
            end
            
            obj.total_electricity_cost = obj.total_electricity_cost     ...
            + (( how_much_charge - obj.soc_current_charge)              ...
               * my.COST_TO_BUSINESS_PER_CHARGE/100);
            
            how_much_charge = double(how_much_charge); 
            obj.cumulative_cycles = round(obj.cumulative_cycles         ...
                                  + (how_much_charge                    ...
                                     - obj.soc_current_charge)/100, 1);    
            obj.dod_ave = (obj.dod_ave*obj.times_battery_charged        ...
                           + obj.dod_current)                           ...
                        / (obj.times_battery_charged + 1);                                    
            obj.soc_current_charge = how_much_charge;            
            obj.times_battery_charged = obj.times_battery_charged + 1;
            if (how_much_charge < obj.soc_current_charge) 
                error('current batt charge is higher than expected');
            end
                    
            obj.soc_prev_charge = how_much_charge;
            if (obj.soh > obj.soh_previous)
                obj.soh = obj.soh_previous;
            else 
                obj.soh_previous = obj.soh;
            end

            obj.soh_previous = obj.soh;
            comp = @compute_soh;
            obj.soh = comp(obj);
            
            if (obj.soh >  my.SOH_LOW_USE_LIMIT)
                class_type_prop_temp = class_type.CLASS_A;
                %class_type_prop_temp = 'CLASS_A';
            elseif (obj.soh >  my.SOH_GRID_ONLY_LIMIT)
                class_type_prop_temp = class_type.CLASS_B;
                %class_type_prop_temp = 'CLASS_B';
            elseif (obj.soh > my.SOH_DISPOSE_LIMIT) 
                class_type_prop_temp = class_type.CLASS_C;
                %class_type_prop_temp = 'CLASS_C';
            else 
                class_type_prop_temp = class_type.CLASS_D;
                %class_type_prop_temp = 'CLASS_D';
            end
            obj.class_type_prop = class_type_prop_temp;                        
        end
        function discharge(obj, val)
            if (val < 0)
                error('value should be greater than 0');
            end
            if (val > (charge_type.SOC_FULL_CHARGE                      ...
                    - charge_type.SOC_EMPTY_CHARGE + 1))
                error('value should be within charging range');
            end
            obj.soc_current_charge = obj.soc_current_charge - val;
        end        
    end    
end
