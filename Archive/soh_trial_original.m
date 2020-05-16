
b = Battery; 
b.abs_day_current = 5500;
n = 3000;
a(1:n) = 0;
c(1:n) = class_type.CLASS_D;
h(1:n) = 0;
for i = 1:n
    %b.discharge(40); 
    %b.charge(charge_type.SOC_FULL_CHARGE); 
    b.discharge(60); 
    b.charge(charge_type.SOC_FULL_CHARGE); 
    a(i) = b.soh;
    c(i) = b.class_type_prop;
    h(i) = b.soh_previous;
end  
r = plot(a);
s = plot(h);
%bar(c);
% [u,~,n] = unique(c(:));
% B = accumarray(n, 1, [], @sum);
% bar(B)
% set(gca,'XTickLabel',u)
