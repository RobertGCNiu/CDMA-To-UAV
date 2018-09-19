
interations=1;


    for i=1:100
    
        a=SIR_up822(i);b=SIR_down822(i);
        c(i,interations)=a(end);d(i,interations)=b(end);
        
    
    end
 interations=interations+1;

for i=1:100
    for j=1:(interations-1)
        gamma1(i)=sum(c(i,j));
        gamma2(i)=sum(d(i,j));
    end
end
 plot(gamma1(),'r');
 hold on;grid on
 plot(gamma2(),'b')
 hold on;grid on;
 title('Distance Based Power Control Algorithm')
 xlabel('Number of users in cell')
 ylabel('SIR(dB)')
 legend('uplink','downlink');