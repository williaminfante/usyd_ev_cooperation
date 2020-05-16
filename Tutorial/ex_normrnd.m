x(100000) = 0;

deviation = (my.MAX_HR_RETURN_BATT - my.MIN_HR_RETURN_BATT) / 8;
for i=1:100000
    
    x(i) = round(normrnd(my.AVE_HR_RETURN_BATT, deviation));
end

x(x<my.MIN_HR_RETURN_BATT)=my.AVE_HR_RETURN_BATT;
x(x>my.MAX_HR_RETURN_BATT)=my.AVE_HR_RETURN_BATT;

y = sort(x); 
histogram(y)