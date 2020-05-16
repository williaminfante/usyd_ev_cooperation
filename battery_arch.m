%Filename:     BatteryInTime.m
%Description:  Observe 1 battery charging and discharging in a swapping
%              station at random intervals including pricing.
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-13  1.0   Creation
%william         2016-04-21  1.1   Placed Battery-related commands 
%                                  to Battery.m
%                                  Rename to battery_arch.m
%======================================================================

% %Clear Values 
% clc
% clear
 
%Initialize Values

mx_no = 0;
s_mx(my.OBSERVATION_YEARS*my.DAYS_IN_A_YEAR*my.HOURS_IN_A_DAY).id = 0;
% 
% %Create Battery b
% b = Battery; 
% %======================================================================
% b.is_cooperative    = true;
% myseed              = 47;
% %======================================================================

%Seed for replication 
rng(myseed);

if (strcmp(load, 'duck')) 
    b.heavy_interval = [19 20 21 22];
    b.light_interval = [12 13 14 15];
elseif (strcmp(load, 'nswd')) 
    b.heavy_interval = [17 18 19 20];
    b.light_interval = [2 3 4 5];    
elseif (strcmp(load, 'mojo'))
    b.heavy_interval = [15 16 17 18];
    b.light_interval = [0 1 2 3];
else
    error('no type of load existing'); 
end


%Assumption: 50 days arbitrarily chosen 
for day=1:my.OBSERVATION_YEARS*my.DAYS_IN_A_YEAR
    b.abs_day_current = day;
    for hour=0:(my.HOURS_IN_A_DAY-1)
        b.hour_day_current = hour; 
        
        %Assumption: 50% chance to discharge when possible
        if ( randperm(2,1) == 2 && b.can_discharge == true) 
            
            %Safeguard condition so SoC will not go below 25;
            if (b.soc_current_charge == 60)
                b.discharge(25); 
            else
                b.discharge(randi([4,6],1,1)*10); 
            end           
        end

        if (   (b.can_recharge == true)                                 ...
            && (b.hours_to_charge == hour)                              ...
            && (b.abs_day_to_charge == day) )
            
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
        end
        
        %Track property values at every time interval
        mx_no = mx_no + 1;            
        s_mx(mx_no).mx_no                   = mx_no;
        %s_mx(mx_no).day                     = day;
        %s_mx(mx_no).hour                    = hour;
        s_mx(mx_no).abs_day_current         = b.abs_day_current;        
        s_mx(mx_no).hour_day_current        = b.hour_day_current; 
        s_mx(mx_no).abs_day_to_charge       = b.abs_day_to_charge;    
        s_mx(mx_no).hours_to_charge         = b.hours_to_charge;
        s_mx(mx_no).preferred_low_f         = b.preferred_low_f;   
        s_mx(mx_no).preferred_high_f        = b.preferred_high_f;              
        s_mx(mx_no).soc_current_charge      = b.soc_current_charge;        
        s_mx(mx_no).can_discharge           = b.can_discharge;        
        %s_mx(mx_no).can_recharge            = b.can_recharge;
        %s_mx(mx_no).addtl_hr_for_charge     = b.addtl_hr_for_charge;
        %s_mx(mx_no).hour_for_grid_ready     = b.hour_for_grid_ready;
        s_mx(mx_no).discount_fee_undrained  = b.discount_fee_undrained;
        s_mx(mx_no).customer_used_hours     = b.customer_used_hours;
        %s_mx(mx_no).profit_lease_fee        = b.profit_lease_fee;
        %s_mx(mx_no).profit_swap_fee         = b.profit_swap_fee;
        %s_mx(mx_no).profit_customer         = b.profit_customer;
        s_mx(mx_no).total_profit_customer   = b.total_profit_customer;
        s_mx(mx_no).total_electricity_cost  = b.total_electricity_cost;  
        s_mx(mx_no).discount_counter        = b.discount_counter;
        s_mx(mx_no).low_int_counter         = b.low_int_counter; 
        s_mx(mx_no).high_int_counter        = b.high_int_counter;         
        s_mx(mx_no).times_battery_charged   = b.times_battery_charged;
    end
end


table_mx            = struct2table(s_mx); 
cell_mx             = table2cell(table_mx); 
cell_mx_with_header = [table_mx.Properties.VariableNames;  cell_mx];

f_mx.is_double_peak                 = b.is_double_peak;
f_mx.is_cooperative                 = b.is_cooperative;
f_mx.myseed                         = myseed;
f_mx.times_battery_charged          = b.times_battery_charged;
f_mx.discount_counter               = b.discount_counter;
f_mx.low_int_counter                = b.low_int_counter; 
f_mx.high_int_counter               = b.high_int_counter;  
f_mx.total_profit_customer          = b.total_profit_customer;
f_mx.total_electricity_cost         = b.total_electricity_cost; 
f_mx.soh                            = b.soh;
table_f_mx            = struct2table(f_mx); 
cell_f_mx             = table2cell(table_f_mx); 
cell_f_mx_with_header = [table_f_mx.Properties.VariableNames;  cell_f_mx];

if(b.is_double_peak == false) 
    peak_name = 'norm';
else
    peak_name = 'dobl';   
end
if(b.is_cooperative == false) 
    customer_name = 'indf';
else 
    customer_name = 'coop';
end


FileName=sprintf('%s_batt_pk_%s_ld_%s_%s_sd_%d.xlsx',            ...
        datestr(now, 'yymmdd_HHMM'), peak_name, load, ...
        customer_name, myseed);


sheetnames = {'data_per_time', 'final_state'}; 
xlsheets(sheetnames, FileName);
xlswrite(FileName, cell_mx_with_header, 'data_per_time');
xlswrite(FileName, transpose(cell_f_mx_with_header), 'final_state');

% overview_struct = struct(b);
% overview_table = struct2table(overview_struct);
% overview_header = [overview_table.Properties.VariableNames; ...
%  table2cell(overview_table)]; 
% xlswrite(FileName, transpose(overview_header), 'final_state');
