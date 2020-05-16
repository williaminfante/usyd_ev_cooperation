function f = gen_price_batt_per_year( YEAR_START, PROJECT_EXPECTED_LIFE_IN_YEARS)
%Filename:     gen_price_batt_per_year.m
%Description:  generates the price of battery in every 
%              provided the year it starts 
%              (Year can only start from Year 2011)
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-04  1.0   Creation
%======================================================================
for i = 1:PROJECT_EXPECTED_LIFE_IN_YEARS
    y(i) = floor(1044.1*exp(-0.169*(YEAR_START - 2011 + i)));
end
f = y;
end