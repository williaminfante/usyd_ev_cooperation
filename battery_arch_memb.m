%Filename:     1EMB.m
%Description:  1 Electric Vehicle, Multiple Batteries; add waiting time  
%              until full charge of batteries 
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-06-03  1.5   Added function for multiple
%                                  batteries and vehicles
%                                  Priority swapping with ready 
%                                   batteries (100% SoC)
%======================================================================

% %Clear Values 
% clc
% clear

%b_id - battery id 
%c_id - customer id 
if (strcmp(customer_type, 'cooperative')) 
    is_cooperative_value = true; 
elseif (strcmp(customer_type, 'indifferent'))
    is_cooperative_value = false; 
end

is_double_peak_value    = true;

mx_no = 0;
s_mx(my.OBSERVATION_YEARS*my.DAYS_IN_A_YEAR*my.HOURS_IN_A_DAY).id = 0;
% 
% %Create Battery b
% b = Battery; 
% %======================================================================
% batt(cust(v_id).ba).is_cooperative    = true;
% myseed              = 47;
% %======================================================================
%Seed for replication 
rng(myseed);

disappointments = 0;
%generating Battery properties for all
batt(batt_number) = Battery;
for b_id = 1:batt_number
    batt(b_id) = Battery; 
    batt(b_id).id = b_id; 

    if (strcmp(load, 'duck')) 
        batt(b_id).heavy_interval = [19 20 21 22];
        batt(b_id).light_interval = [12 13 14 15];
    elseif (strcmp(load, 'nswd')) 
        batt(b_id).heavy_interval = [17 18 19 20];
        batt(b_id).light_interval = [2 3 4 5];    
    elseif (strcmp(load, 'mojo'))
        batt(b_id).heavy_interval = [15 16 17 18];
        batt(b_id).light_interval = [0 1 2 3];
    else
        error('no type of load existing'); 
    end
    
    batt(b_id).is_double_peak = is_double_peak_value;
    batt(b_id).is_cooperative = is_cooperative_value;
end 


%initially associate Customer with current battery 
list_of_battery_in_ev = randperm(batt_number, cust_number);
list_of_ev_customers = 1:cust_number; 

list_of_battery_in_all = 1:batt_number; 
list_of_battery_in_station = setdiff(list_of_battery_in_all,            ...
    list_of_battery_in_ev);
%list_of_ready_full_charge; 
%list_of_ready_partial_charge; 

if (cust_number > batt_number) 
    error('EV customers exceeding number of all batteries');
end


cust(cust_number) = Customer; 
for c_id = 1:cust_number
    cust(c_id)                   = Customer;
    cust(c_id).id                = c_id;

    cust(c_id).ba  = list_of_battery_in_ev(c_id); 
    batt(cust(c_id).ba).mode = mode_type.HIGH_EV_MODE;
end


%Assumption: 50 days arbitrarily chosen 
for day=1:my.OBSERVATION_YEARS*my.DAYS_IN_A_YEAR
    %next time change to global variable 
    for c_id = 1:cust_number
        cust(c_id).abs_day_current = day; 
    end
    for b_id = 1:batt_number
        batt(b_id).abs_day_current = day; 
    end    
    
    for hour=0:(my.HOURS_IN_A_DAY-1)
        %next time change to global variable 
        for c_id = 1:cust_number
            cust(c_id).hour_day_current = hour; 
        end
        for b_id = 1:batt_number
            batt(b_id).hour_day_current = hour; 
        end        
        

        
        %customer visit the station 
        %Assumption: 50% chance to discharge when possible
        %if a customer can remove the battery
        %random 
        
        %check if there are customers ready to visit the station 
        %list_of_evs_to_visit_station = [];
        list_of_evs_to_visit_station = list_of_ev_customers;
        for c_id = 1:cust_number
            if(cust(c_id).will_visit_station == false)
                list_of_evs_to_visit_station(c_id) = []; 
            end; 
        end        
        
        for visitor = 1:numel(list_of_evs_to_visit_station) 
            v_id = list_of_evs_to_visit_station(visitor); 
            %use battery id of existing customer 
            if ( randperm(2,1) == 2 &&                                  ...
                 batt(cust(v_id).ba).can_discharge == true) 
                %Safeguard condition so SoC will not go below 25;
                if (batt(cust(v_id).ba).soc_current_charge == 60)
                    batt(cust(v_id).ba).discharge(25); 
                else
                    batt(cust(v_id).ba).discharge(randi([4,6],1,1)*10); 
                end           
            end            
            %----------------------------------------------------------
            if (   (batt(cust(v_id).ba).can_recharge == true)           ...
                && (batt(cust(v_id).ba).hours_to_charge == hour)        ...
                && (batt(cust(v_id).ba).abs_day_to_charge == day) )
                %Assumption: Charging full has about 3 times chance than 
                %   charging partially.                               
                if (randperm(4,1) == 1) 
                    batt(cust(v_id).ba).charge(                         ...
                        charge_type.SOC_FULL_CHARGE);
                else
                    %Conditional in case battery is 60% or more SoC.
                    %   This means it is charged fully not partially.
                    if (batt(cust(v_id).ba).soc_current_charge          ...
                        >= charge_type.SOC_PARTIAL_CHARGE)                  
                        batt(cust(v_id).ba).charge(                     ...
                            charge_type.SOC_FULL_CHARGE);
                    else
                        batt(cust(v_id).ba).charge(                     ...
                            charge_type.SOC_PARTIAL_CHARGE);
                    end
                end   
                
                %swap the batteries 
                % add computation when battery is ready for swapping 
                
                list_of_ready_battery_in_station                        ...
                    = list_of_battery_in_station;                                               
                for stock_battery = 1:numel(list_of_battery_in_station)
                    temp_batt_id                                        ...
                        = list_of_battery_in_station(stock_battery); 
                    if ( batt(temp_batt_id).day_for_grid_ready > day)
                        list_of_ready_battery_in_station(stock_battery) ...
                            = 0;
                    elseif ( batt(temp_batt_id).day_for_grid_ready == day )
                        if ( batt(temp_batt_id).hour_for_grid_ready > hour)
                            list_of_ready_battery_in_station(           ...
                                stock_battery) = 0; 
                        end
                    end
                end     
                list_of_ready_battery_in_station (list_of_ready_battery_in_station == 0) = [];
                %disp(['cust(v_id).ba ' num2str(cust(v_id).ba)]);
                
                if (isempty(list_of_ready_battery_in_station))
                    list_of_ready_battery_in_station = list_of_battery_in_station; 
                    cust(v_id).disappoint(); 
                        disappointments = disappointments + 1; 
                        %disp(disappointments);
                        %disp(['v_id ' num2str(v_id)]);
                        %disp(['cust(v_id).ba ' num2str(cust(v_id).ba)]); 
                end
                
                temp_swap = cust(v_id).ba;                                                               
                cust(v_id).ba = list_of_ready_battery_in_station(1); 
                list_of_battery_in_ev(list_of_battery_in_ev == temp_swap) = list_of_ready_battery_in_station(1);

                %------------- temporary swapping of batteries
                
                temp_batt_list = [list_of_battery_in_station 0];
                temp_batt_list(temp_batt_list == list_of_ready_battery_in_station(1)) = []; 
                temp_batt_list(end) = temp_swap;
                list_of_battery_in_station = temp_batt_list;
                
                
     
                
                cust(v_id).pay(                                         ...
                    batt(cust(v_id).ba).profit_customer,                ...
                    batt(cust(v_id).ba).discount_counter_flag,          ...
                    batt(cust(v_id).ba).high_int_counter_flag,          ...
                    batt(cust(v_id).ba).low_int_counter_flag); 
                
            end            
            %check if battery is ready to be added in ready_batteries
        end
        
        %Track property values at every time interval
        mx_no = mx_no + 1;            
        s_mx(mx_no).mx_no                   = mx_no;
        s_mx(mx_no).day                     = day;
        s_mx(mx_no).hour                    = hour;
        s_mx(mx_no).list_batt_stn          = num2str(list_of_battery_in_station); 
        s_mx(mx_no).list_batt_ev           = num2str(list_of_battery_in_ev);
        s_mx(mx_no).abs_day_to_charge       = batt(cust(v_id).ba).abs_day_to_charge;    
        s_mx(mx_no).hours_to_charge         = batt(cust(v_id).ba).hours_to_charge;             
        s_mx(mx_no).soc_current_charge      = batt(cust(v_id).ba).soc_current_charge;        
        %s_mx(mx_no).profit_lease_fee        = batt(cust(v_id).ba).profit_lease_fee;
        %s_mx(mx_no).profit_swap_fee         = batt(cust(v_id).ba).profit_swap_fee;
        %s_mx(mx_no).profit_customer         = batt(cust(v_id).ba).profit_customer;
        %s_mx(mx_no).total_profit_customer   = batt(cust(v_id).ba).total_profit_customer;
        %s_mx(mx_no).total_electricity_cost  = batt(cust(v_id).ba).total_electricity_cost;  
        

        for i_batt = 1:batt_number        
            s_mx(mx_no).(['discount_counter_', num2str(i_batt)]) = batt(i_batt).discount_counter;
            s_mx(mx_no).(['low_int_counter_', num2str(i_batt)]) = batt(i_batt).low_int_counter;
            s_mx(mx_no).(['low_int_counter_', num2str(i_batt)]) = batt(i_batt).high_int_counter;
            s_mx(mx_no).(['low_int_counter_', num2str(i_batt)]) = batt(i_batt).times_battery_charged;
        end 
%          s_mx(mx_no).discount_counter_2        = batt(2).discount_counter;
%          s_mx(mx_no).low_int_counter_2         = batt(2).low_int_counter; 
%          s_mx(mx_no).high_int_counter_2        = batt(2).high_int_counter;    
%          s_mx(mx_no).times_battery_charged_2   = batt(2).times_battery_charged;
%         
%          s_mx(mx_no).discount_counter_3        = batt(3).discount_counter;
%          s_mx(mx_no).low_int_counter_3         = batt(3).low_int_counter; 
%          s_mx(mx_no).high_int_counter_3        = batt(3).high_int_counter;          
%          s_mx(mx_no).times_battery_charged_3   = batt(3).times_battery_charged;         

%          s_mx(mx_no).discount_counter_4         = batt(4).discount_counter;
%          s_mx(mx_no).low_int_counter_4          = batt(4).low_int_counter; 
%          s_mx(mx_no).high_int_counter_4         = batt(4).high_int_counter;          
%          s_mx(mx_no).times_battery_charged_4    = batt(4).times_battery_charged;        
       
         s_mx(mx_no).cut_disc                   = cust(v_id).discount_counter; 
         s_mx(mx_no).cut_hi                     = cust(v_id).high_int_counter; 
         s_mx(mx_no).cut_lo                     = cust(v_id).low_int_counter; 
         s_mx(mx_no).cust_x_charged             = cust(v_id).times_battery_charged;
         

%         s_mx(mx_no).times_battery_charged   = batt(cust(v_id).ba).times_battery_charged;
%         s_mx(mx_no).tracking_dist_no_add    = batt(cust(v_id).ba).tracking_dist_no_add;
%         s_mx(mx_no).times_battery_charged_1   = batt(1).times_battery_charged;
%         s_mx(mx_no).tracking_dist_no_add_1    = batt(1).tracking_dist_no_add;
%         s_mx(mx_no).times_battery_charged_2   = batt(2).times_battery_charged;
%         s_mx(mx_no).tracking_dist_no_add_2    = batt(2).tracking_dist_no_add;
%         
        
        
        
    end
end


table_mx            = struct2table(s_mx); 
cell_mx             = table2cell(table_mx); 
cell_mx_with_header = [table_mx.Properties.VariableNames;  cell_mx];



if(batt(cust(v_id).ba).is_double_peak == false) 
    peak_name = 'norm';
else
    peak_name = 'dobl';   
end
if(batt(cust(v_id).ba).is_cooperative == false) 
    customer_name = 'indf';
else 
    customer_name = 'coop';
end


FileName=sprintf('%s_memb_%s_%s_batt_%02d_ev_%02d_seed_%d.xlsx',            ...
        datestr(now, 'yymmdd_HHMM'), load, ...
        customer_name, batt_number, cust_number, myseed);

f_mx.filename                       = FileName;
f_mx.is_double_peak                 = batt(1).is_double_peak;
f_mx.is_cooperative                 = batt(1).is_cooperative;
f_mx.batt_number                    = batt_number; 
f_mx.cust_number                    = cust_number;
f_mx.myseed                         = myseed;
f_mx.disappointments                = disappointments; 
% f_mx.times_battery_charged          = batt(cust(v_id).ba).times_battery_charged;
% f_mx.discount_counter               = batt(cust(v_id).ba).discount_counter;
% f_mx.low_int_counter                = batt(cust(v_id).ba).low_int_counter; 
% f_mx.high_int_counter               = batt(cust(v_id).ba).high_int_counter;  
% f_mx.total_profit_customer          = batt(cust(v_id).ba).total_profit_customer;
% f_mx.total_electricity_cost         = batt(cust(v_id).ba).total_electricity_cost; 
% f_mx.soh                            = batt(cust(v_id).ba).soh;


table_f_mx            = struct2table(f_mx); 
cell_f_mx             = table2cell(table_f_mx); 
cell_f_mx_with_header = [table_f_mx.Properties.VariableNames;  cell_f_mx];    
    
    
    
sheetnames = {'data_per_time', 'final_state'}; 
xlsheets(sheetnames, FileName);
xlswrite(FileName, cell_mx_with_header, 'data_per_time');
xlswrite(FileName, transpose(cell_f_mx_with_header), 'final_state');

% overview_struct = struct(b);
% overview_table = struct2table(overview_struct);
% overview_header = [overview_table.Properties.VariableNames; ...
%  table2cell(overview_table)]; 
% xlswrite(FileName, transpose(overview_header), 'final_state');
