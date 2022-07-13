function x = compute_x(z,Iext)

x = [z(1);0.04*z(1)^2+5*z(1)+140-z(2)+Iext];

end

