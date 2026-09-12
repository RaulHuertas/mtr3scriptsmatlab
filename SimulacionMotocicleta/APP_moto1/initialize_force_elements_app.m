function [] = initialize_force_elements_app
  
    figure_handle = findobj('Tag','figure_handle');
    %fh.f = figure_handle;
    
    data = figure_handle.UserData;
    fh.f = data.fh.f;
        %h_ax1=axes;
        %polar(h_ax1,[0 1],[0 1]);
        %l1=compass(h_ax1,[1000 0],[0 1]);
        %set(l1(1),'visible','off');
        %set(l1,'linewidth',4);
        %set(h_ax1,'position',[0.5 0.75 0.5 0.2])
        %set(get(h_ax1,'Title'),'String','rear wheel slip');
        %set(h_ax1,'XTickLabel','one');
%% Developers Tools

dev_console = axes(fh.f);
dev_console.NextPlot = 'add';
  dev_console.Position = [0.297 0.911 0.296 0.087];  
  dev_console.Color = 'none';   dev_console.XTick = []; dev_console.YTick = []; dev_console.XColor='none';  dev_console.YColor='none';
   
   devTex_1 =    text(0.34,0.687,'hi');  
    devTex_2 =    text(0.34,0.5,'hi');       
        
 %% rear wheel slip    polaraxes       
        h_ax1=polaraxes(fh.f);
        h_ax1.NextPlot='add';
        h_ax1.ThetaLimMode='manual';
        h_ax1.ThetaLim=[0 360];
        h_ax1.ThetaZeroLocation='right';
        h_ax1.ThetaDir='counterclockwise';
        h_ax1.RLim=[0 2000];
        h_ax1.RTickLabel='';
       % h_ax2.ThetaMinorTick='on';
       % h_ax2.TickLength =[0.2 0];
        h_ax1.ThetaTick=[0:30:360];
        h_ax1.ThetaAxis.TickLabelRotation= 0;
        h_ax1.ThetaAxis.FontSize=8;
        h_ax1.Color='none';
        set(h_ax1,'position',[0.5 0.75 0.5 0.2])  ;
        set(get(h_ax1,'Title'),'String','rear wheel slip');
        
        l1 = polarplot(h_ax1,[pi/2 pi/2 ],[0 1],'Color','b');
 %%    front wheel slip     polaraxes
        %h_ax2=axes;        
        %l2=compass(h_ax2,[1000 0],[0 1]);
        %set(l2(1),'visible','off');        
        %set(l2,'linewidth',4);
        %set(h_ax2,'position',[0.67 0.75 0.5 0.2])  ;
        %set(get(h_ax2,'Title'),'String','front wheel slip');
        
        h_ax2 =  polaraxes(fh.f);
        h_ax2.NextPlot='add';
        h_ax2.ThetaLimMode='manual';
        h_ax2.ThetaLim=[0 360];
        h_ax2.ThetaZeroLocation='right';
        h_ax2.ThetaDir='counterclockwise';
        h_ax2.RLim=[0 2000];
        h_ax2.RTickLabel='';
       % h_ax2.ThetaMinorTick='on';
       % h_ax2.TickLength =[0.2 0];
        h_ax2.ThetaTick=[0:30:360];
        h_ax2.ThetaAxis.TickLabelRotation= 0;
        h_ax2.ThetaAxis.FontSize=8;
        h_ax2.Color='none';
        set(h_ax2,'position',[0.67 0.75 0.5 0.2])  ;
        set(get(h_ax2,'Title'),'String','front wheel slip');
        
        l2 = polarplot(h_ax2,[pi/2 pi/2 ],[0 1],'Color','b');
%%    roll angle  polaraxes
        h_ax5 = polaraxes(fh.f);
        h_ax5.NextPlot='add';
        l5 = polarplot( h_ax5 , [pi/2 pi/2 ],  [0 1],'Color','b');
        l6 = polarplot( h_ax5 , [pi/2 pi/2 ],  [0 1],'Color','r');
        
        h_ax5.ThetaLimMode='manual';
        h_ax5.ThetaLim=[-90 90];
        h_ax5.ThetaZeroLocation='top';
        h_ax5.ThetaDir='clockwise';
        h_ax5.RLim=[0 1];
        h_ax5.RTickLabel='';
        h_ax5.ThetaMinorTick='on';
        h_ax5.TickLength =[0.2 0];
        h_ax5.ThetaTick=[-90:10:90];
%         l5=compass(h_ax5,[1000 0],[0 1]);
        h_ax5.ThetaAxis.TickLabelRotation= 0;
         h_ax5.ThetaAxis.FontSize=8;
        h_ax5.Color='none';
        
        %set(l5,'visible','off');
        %set(l5,'linewidth',4);       
        set(h_ax5,'position',[0.05 0.75 0.2 0.2])  ;
        set(get(h_ax5,'Title'),'String','roll angle');
 %% front wheel normal force  bar
        h_ax3=axes(fh.f);
        h_ax3.NextPlot='add';
        
        l3 = bar(h_ax3,100);  l3.XData = 0.5; l3.BarWidth = 1; 
        h_ax3.XLim=[0 1];
        h_ax3.Position=[0.67 0.75 0.01 0.2];
        h_ax3.YLabel.String='front wheel normal force';
        h_ax3.Title.String='1e3';
        h_ax3.Box='on';
        h_ax3.YTick=[0:2000:10000];
        h_ax3.YTickLabel={'0','2','4','6','8','10'};
        h_ax3.BoxStyle='full';
        h_ax3.YLim=[0 10000];
        h_ax3.Color='none';
        
        
        
%% rear wheel normal force  bar
        
        
        
        h_ax4=axes(fh.f);
        h_ax4.NextPlot='add';
        l4 = bar(h_ax4,100);  l4.XData = 0.5; l4.BarWidth = 1;
        h_ax4.XLim=[0 1];
        h_ax4.Position=[0.84 0.75 0.01 0.2];
        h_ax4.YTick=[0:2000:10000];
        h_ax4.YTickLabel={'0','2','4','6','8','10'};
        h_ax4.YLabel.String='rear wheel normal force';
        h_ax4.Title.String='1e3';
        h_ax4.YLim=[0 10000];
         h_ax4.Color='none';
         h_ax4.Box='on';
        h_ax4.BoxStyle='full';
%%  velocity   polaraxes
        h_ax7 = polaraxes(fh.f);
        h_ax7.NextPlot='add';
        
        l7 = polarplot( h_ax7 , [pi/2 pi/2 ],  [0 1],'Color','r');
        t7 = text(1,0.4,['000 km/h']);      t7.FontSize = 15;
        t8 = text(-1.387,-0.174,['00:00','s']); 
        
        h_ax7.ThetaLimMode='manual';
        h_ax7.ThetaLim=[-45 225];
        h_ax7.ThetaZeroLocation='left';
        h_ax7.ThetaDir='clockwise';
        h_ax7.RLim=[0 1];
        h_ax7.RTickLabel='';
         h_ax7.ThetaMinorTick='on';
        h_ax7.ThetaAxis.MinorTickValues=[-33.75 -11.25 11.25 33.75 56.25 78.75 101.25 123.75 146.25 168.75 191.25 213.75];
         h_ax7.TickLength =[0.2 0];
         h_ax7.RColor=[0.15 0.15 0.15]; 
         h_ax7.RTick=[0.8 1];
        h_ax7.ThetaTick=[-45:22.5:225];
        h_ax7.ThetaColor='k';
%         l5=compass(h_ax5,[1000 0],[0 1]);
        h_ax7.ThetaAxis.TickLabelRotation= 0;
        h_ax7.ThetaAxis.TickLabel={'0','20','40','60','80','100','120','140','160','180','200','220','240'};
        h_ax7.ThetaAxis.FontSize=8;
        h_ax7.Color='none';
        
        %set(l5,'visible','off');
        %set(l5,'linewidth',4);       
         set(h_ax7,'OuterPosition',[0.722 -0.035 0.8*0.282 0.8*0.482])  ;
        set(get(h_ax7,'Title'),'String','speed');
%%   acceleration bar

        h_ax8 = axes(fh.f);
        h_ax8.NextPlot='add';
        
        l8 = bar(h_ax8,1);  l8.XData=0.5; l8.BarWidth=1; 
        h_ax8.XLim=[0 1];
        h_ax8.OuterPosition=[0.681 0.012 0.06 0.26];
        h_ax8.YLabel.String='accleration [m s^{-2}]';
       % h_ax8.Title.String='1e3';
        h_ax8.Box='on';
        h_ax8.YTick=[-15:5:15];
       % h_ax8.YTickLabel={'0','2','4','6','8','10'};
        h_ax8.BoxStyle='full';
        h_ax8.YLim=[-15 15];
        h_ax8.Color='none';
        
%%  front suspension bar

        h_ax9 = axes(fh.f);
        h_ax9.NextPlot = 'add';
        
        l9=bar(h_ax9,1);  l9.XData=0.5; l9.BarWidth=1;  l9.BaseValue = 0.0;
        h_ax9.XLim=[0 1];
        h_ax9.OuterPosition=[0.681 0.323 0.06 0.26];
        h_ax9.YLabel.String='front suspension';
       % h_ax8.Title.String='1e3';
        h_ax9.Box='on';
        h_ax9.YTick=[0.0:0.2:1.0];
        
       % h_ax8.YTickLabel={'0','2','4','6','8','10'};
        h_ax9.BoxStyle='full';
        h_ax9.YLim=[0 1];
        h_ax9.Color='none';
%%  rear suspension bar

        h_ax10=axes(fh.f);
        h_ax10.NextPlot='add';
        
        l10=bar(h_ax10,1);  l10.XData=0.5; l10.BarWidth=1;  l10.BaseValue = 0.0;
        h_ax10.XLim=[0 1];
        h_ax10.OuterPosition=[0.74 0.323 0.065 0.26];
        h_ax10.YLabel.String='rear suspension';
       % h_ax8.Title.String='1e3';
        h_ax10.Box='on';
        h_ax10.YTick=[-1:0.5:1];
        
       % h_ax8.YTickLabel={'0','2','4','6','8','10'};
        h_ax10.BoxStyle='full';
        h_ax10.YLim=[-1.0 1.0];
        h_ax10.Color='none';


%%
fhf.h_ax1 = h_ax1;
fhf.h_ax2 = h_ax2;
fhf.h_ax5 = h_ax5;
fhf.h_ax7 = h_ax7;
fhf.h_ax3 = h_ax3;
fhf.h_ax4 = h_ax4;
fhf.h_ax9 = h_ax9;
fhf.h_ax8 = h_ax8;
fhf.h_ax10 = h_ax10;

fhf.dev_console = dev_console;
fhf.devTex_1 = devTex_1;
fhf.devTex_2 = devTex_2;

fhf.l1 = l1;
fhf.l2 = l2;
fhf.l5 = l5;
fhf.l3 = l3;
fhf.l4 = l4;
fhf.l6 = l6;
fhf.l7 = l7;
fhf.l8 = l8;
fhf.l9 = l9;
fhf.l10 = l10;
fhf.t7 = t7;
fhf.t8 = t8;

data.fhf = fhf;
figure_handle.UserData = data;
end