

% if (YEAR < 2010) 
%     error('Year cannot be lower than 2011.'); 
% end 
% 
% if (PROJECT_EXPECTED_LIFE_IN_YEARS < 1)
%     error('Year cannot be lower than 2011.'); 
% end
% 
% REF_BATT_PRICE = gen_price_batt_per_year(YEAR, PROJECT_EXPECTED_LIFE_IN_YEARS); 


%Validation
        %            function set.soc_current_charge(obj, val)
        %             if (val < 0) || (val > 100)
        %                 error('Value should be from 0 to 100'); 
        %             end
        %             obj.soc_current_charge = val; 
        %         end
        %         function set.soc_prev_charge(obj, val)
        %             if (val < 0) || (val > 100)
        %                 error('Value should be from 0 to 100'); 
        %             end
        %             obj.soc_prev_charge = val; 
        %         end
        %         function set.abs_day_bought(obj, val)
        %             if (val < 0)
        %                 error('Value should be a natural number'); 
        %             end
        %             obj.abs_day_bought = round(val); 
        %         end
        %         function set.mode(obj, val)
        %             if (ismember(val,enumeration('mode_type')) == 0)
        %                 error('Value should be of type mode_type'); 
        %             end
        %             obj.mode = val; 
        %         end
        %         function set.abs_day_current(obj, val)
        %             if (obj.abs_day_current < obj.abs_day_current)
        %                 error('Current day is before bought day'); 
        %             end
        %             obj.abs_day_current = round(val); 
        %         end     
        %         function set.times_battery_charged(obj, val)
        %             if (obj.times_battery_charged < 0)
        %                 error('Number should be a positive number'); 
        %             end
        %             obj.times_battery_charged = round(val); 
        %         end   