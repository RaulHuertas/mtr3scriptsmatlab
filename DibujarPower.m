close all;


plot(abs(out.corriente.Data'), abs(out.voltaje.Data'), 'LineWidth',8 );
axis([0 50 0 80])
hold on
I = imread('Ratings80V_50AMax_80VMaxHD.jpg'); 
I = flip(I, 1);
h = image(xlim, ylim,I); 
uistack(h,'bottom')


