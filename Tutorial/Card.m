classdef Card < handle
   properties
      type    % number: 1-4
      value   % number: 1-13
   end
   methods
      function obj = Card(type, value)
         % some code to check [type, value] should be inserted here
         obj.type = type;
         obj.value = value;
      end
      function c = get_card(obj, t, v)
          c = obj([obj.type] == t & [obj.value] == v);
      end
      function c_arr = get_cards_array(obj, t, v)
          c_arr = obj(ismember([obj.type], t) & ismember([obj.value], v));
      end      
      function print(obj)
          for k = 1 : numel(obj)
              fprintf('Card type = %g; value = %g\n', obj(k).type, obj(k).value);
          end
      end
   end
end