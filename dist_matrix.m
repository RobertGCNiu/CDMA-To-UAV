function matrix = dist_matrix(k)

interations=1;dmin=20;
N = [0,0;100*sqrt(3),0];

alpha=3;


    
 
    for i=1:k
        dist(i,1)=abs(100*rand(1));
        dist(i,2)=abs(100*rand(1));
        theta(i) = 2*pi*rand(1);
    end
    for i=1:k
         x_loc(i)=dist(i,1)*cos(theta(i));
         y_loc(i)=dist(i,1)*sin(theta(i));
        
        dist12(i)=sqrt((x_loc(i)-100*sqrt(3))^2+(y_loc(i))^2);
  

%     
%         if dist12(i)<= dmin;
%             
%            dist12(i)=dmin;
%         
%         end
%         
%         if dist(i,1)<= dmin;
%             
%            dist(i,1)=dmin;
%         
%        end

      end
 for i=1:k
         x_loc(i)=dist(i,2)*cos(theta(i));
         y_loc(i)=dist(i,2)*sin(theta(i));
        
        dist21(i)=sqrt((x_loc(i)+100*sqrt(3))^2+(y_loc(i))^2);
  

    
%         if dist21(i)<= dmin;
%             
%            dist21(i)=dmin;
%         
%         end
%         
%         if dist(i,2)<= dmin;
%             
%            dist(i,2)=dmin;
        
%         end

    
 end


gamma= 0.01;
    for i=1:1:k
    
    d_ratio1(i)=(dist(i,1)/dist(i,1)).^alpha;
    d_ratio2(i)=(dist(i,2)/dist21(i)).^alpha;
    d_ratio3(i)=(dist(i,1)/dist12(i)).^alpha;
    

      
    end
%         if sir_up < gamma_threshold(i)
%            counterinc('outage_counter');
%         end
%     disp(counterval('outage_counter'));

A= [k,sum(d_ratio3);sum(d_ratio2),k];
[a,b] = eig(A);

matrix=b(1,1);
end

