classdef Customer
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id                      = 0; 
        ba                      = 0; %battery_attached ID 
        profit_customer         = 0; 
        profit_lease_fee        = 0;
        profit_swap_fee         = 0;      
        total_profit_customer   = 0; 
        
        abs_day_current         = 2; 
        hour_day_current        = 1;   
        %flag visit station 
        will_visit_station      = true; 
    end
    
    methods
        
    end
    
end

