function f = gen_battery( NUMBER_OF_BATTERIES, battery_struct )
%Filename:     gen_battery.m
%Description:  generates battery status
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-04  1.0   Creation; ignored array_warning
%======================================================================
%gen_battery_struct();
array_battery(NUMBER_OF_BATTERIES) = battery_struct;
for i = 1:NUMBER_OF_BATTERIES
    battery_struct.id = i;
    array_battery(i) = battery_struct; 
end

f = array_battery;
end

