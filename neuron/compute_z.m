function z = compute_z(x,Iext)

z = [x(1);0.04*x(1)^2+5*x(1)+140-x(2)+Iext];

end

