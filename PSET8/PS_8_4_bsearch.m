% Problem Set 8, Question 4
% Nicholas Rypkema (rypkema@mit.edu)

targ = 20;
tol = 1e-3;
avals = [];
wcvals = [];
mindiff = 1e-5;

% loop through range of a's
for a = 0.1:0.3:10
    disp(num2str(a));
    prev_wcval = 0;
    wcval = 10;
    % perform binary search for optimal cutoff frequency
    while(1)
        maxval = PS_8_4(wcval,a);
        if ((abs(wcval-prev_wcval)) < tol)
            wcvals = [wcvals, wcval];
            avals = [avals, a];
            break
        end
        temp = prev_wcval;
        diff = abs(wcval - temp)/2;
        prev_wcval = wcval;
        if (maxval < targ)
            if (diff < mindiff)
                wcval = wcval + mindiff;
            else
                wcval = wcval + diff;
            end
        else
            if (diff < mindiff)
                wcval = wcval - mindiff;
            else
                wcval = wcval - diff;
            end
        end
        %disp(num2str(diff));
        %disp(num2str(wcval));
        disp(num2str(maxval));
    end
end

plot(avals,wcvals)