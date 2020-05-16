classdef Customer < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id                      = 0; 
        ba                      = 0; %battery_attached ID 
        profit_customer         = 0;      
        total_profit_customer   = 0; 
        discount_counter        = 0; 
        high_int_counter        = 0; 
        low_int_counter         = 0; 
        times_battery_charged   = 0; 
        abs_day_current         = 2; 
        hour_day_current        = 1;   
        %flag visit station 
        will_visit_station      = true; 
        unsatisfied_counter        = 0; 
    end
    
    methods
        function pay(obj, charge_of_station, discount_flag, high_flag, low_flag)
            obj.profit_customer = charge_of_station; 
            obj.total_profit_customer = obj.total_profit_customer + obj.profit_customer;     
            obj.times_battery_charged = obj.times_battery_charged + 1; 
            obj.discount_counter = obj.discount_counter + discount_flag; 
            obj.high_int_counter = obj.high_int_counter + high_flag; 
            obj.low_int_counter  = obj.low_int_counter + low_flag;
        end
        function disappoint(obj)
            obj.unsatisfied_counter = obj.unsatisfied_counter + 1; 
        end
        
        
    end
    
end

