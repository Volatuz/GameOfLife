function editplot (src,evt)
%Llamada cuando se clickea el plot en la interfaz
global mundo tamano pointSizeC flagSimulacion 
flagSimulacion = -1;
[x,y] = ginput(1);
   x = round(x);
   y = round(y);
   x(x==0) = 1;
   y(y==0) = 1;
   x(x==tamano+1) = tamano;
   y(y==tamano+1) = tamano;
   if mundo(y,x)
       mundo(y,x) = 0;
   else
       mundo(y,x) = 1;
   end
   spy(mundo,'.w',pointSizeC/tamano)
   set(gca,'color', [0 0 0]);
    set(gca,'ButtonDownFcn',@editplot)
    grid on
    set(gca,'XTick',0.5:1:tamano+1)
    set(gca,'YTick',0.5:1:tamano+1)
    set(gca,'fontSize',1)
    set(gca,'gridLineStyle','-')
    set(gca,'gridColor','w') 
    set(gca,'gridAlpha',0.05)