%Filename:     Battery.m
%Description:  List of types of battery charging
%
%Modification History: 
%======================================================================
%Author          Date        Ver   Remarks  
%======================================================================
%william         2016-04-13  1.0   Creation
%======================================================================

classdef charge_type < uint32
    %charge_type: list of types of battery charging
    %   Each charge category has a numerical %SoC value 
    enumeration 
        SOC_FULL_CHARGE (90)
        SOC_PARTIAL_CHARGE (60)
        SOC_EMPTY_CHARGE (25)
    end
end