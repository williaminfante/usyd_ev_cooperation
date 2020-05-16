%Filename:     my.m
%Description:  Constants used throughout the simulation.
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-13  1.0   Creation
%william         2016-04-21  1.1   Moved INTERVALS to Battery class
%                                  Added Constants for Low Grid Use 
%william                           
%======================================================================

classdef my
    %my: grouped constants to be used for research    
    properties (Constant)
        %%Time
        YEAR_BASE                       = 2016;       
        PROJECT_EXPECTED_LIFE_IN_YEARS  = 20;
        CHARGING_TIME                   = 4;        %hour; need ref  
        HOURS_IN_A_DAY                  = 24;
        DAYS_IN_A_YEAR                  = 365;
        %HEAVY_INTERVAL                  = [6 7 8 17 18 19]; %need ref
        %LIGHT_INTERVAL                  = [0 1 2 23];    
        
        HOUR_DISCOUNTED_COOPERATIVE     = 1;        %hour 
        COOPERATIVE_TIME                = 3;        
        OBSERVATION_YEARS               = 1;
            %assumption: customer willing delay charging for discount
        
        MAX_HR_RETURN_BATT              = 72;    
        AVE_HR_RETURN_BATT              = 48; 
        MIN_HR_RETURN_BATT              = 24; 
        HR_BEFORE_LOW_GRID_USE          = 1;               
        %Capacity 
        MIN_CAPACITY_FOR_GRID           = 1000;     %kWH;                     
            %assumption - 1MW minimum to participate in grid services 
        MIN_BATT_CHARGE_GRID            = 500;      %kWH
            %assumption - is it 50% of MIN_CAPACITY_FOR_GRID
        BATTERY_CAPACITY                = 70;       %kWH;Tesla(70, 85, 90); 
       
        %SoH
        SOH_LOW_USE_LIMIT               = 80;       %unit: %
        SOH_GRID_ONLY_LIMIT             = 70;       %unit: %
        SOH_DISPOSE_LIMIT               = 65;       %unit: %
                
        %Percentage 
        DISCOUNT_RATE_PER_YEAR          = 0.05;    
        SWAP_REQUEST_DISCOUNT           = 0.3;        
        EV_GROWTH_RATE                  = 0.1;   
        EV_USERS_HIGH_PERCENTAGE        = 0.40;   
        EV_USERS_TYP_PERCENTAGE         = 0.30;   
        DISCOUNT_VALUE                  = 0.3;      %
        
        %Counters
        EV_STARTING_CUSTOMERS           = 10;       %need references
        TYPICAL_CYCLE_MAX               = 2500;         
        BATT_MARGIN_EV_SWAP             = 5;
            %assumption: extra 5 batteries per hour for going customers
            
        %Money

        FULL_FEE_SWAP                   = 30;       %$
           %60-80$ about the same as filling a 15-gallon gas tank  (TESLA)
           %Our rate also has leasing value, so full fee is smaller
        HOUR_RATE_FOR_EV_BATT_USE       = 0.5;      %$
        GRID_PRICE_REGULATION           = 15;       %$
        ADAPTATION_COST                 = 1000;     %$ 
        COST_TO_BUSINESS_PER_CHARGE     = 25;       %$
            %assumption: theoretical max from empty to full (Tesla)
            %conservative: instead of 20, use 25
    end    
    
    methods
    end    
end

