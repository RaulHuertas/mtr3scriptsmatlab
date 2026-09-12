function [] = createForceElementsMenu
    figure_handle = findobj('Tag','figure_handle');
    
    %%
    m = uimenu(figure_handle,'Text','force_elements');

    uimenu(m,'Text','roll angle','MenuSelectedFcn',@menuRulerSelectedFcn1,'Checked','on');
    uimenu(m,'Text','front wheel forces ','MenuSelectedFcn',@menuRulerSelectedFcn2,'Checked','on');

    uimenu(m,'Text','rear wheel forces','MenuSelectedFcn',@menuRulerSelectedFcn3,'Checked','on');
    uimenu(m,'Text','front suspension','MenuSelectedFcn',@menuRulerSelectedFcn4,'Checked','on');
    uimenu(m,'Text','rear suspension','MenuSelectedFcn',@menuRulerSelectedFcn5,'Checked','on');
    uimenu(m,'Text','speedometer','MenuSelectedFcn',@menuRulerSelectedFcn6,'Checked','on');
    
    %mitem3 = uimenu(m,'Text','options','Tag','rulerOptions');
    %    mitem31 = uimenu(mitem3,'Text','Pol ','Tag','PolOptions');
    %        uimenu(mitem31,'Text','TickLabel ','MenuSelectedFcn',@PolTickLabel,'Tag','PolTickLabel','Checked','on');
    %        uimenu(mitem31,'Text','InnerLine ','MenuSelectedFcn',@PolInnerLine,'Tag','PolInnerLine','Checked','on');
    %        uimenu(mitem31,'Text','OuterLine ','MenuSelectedFcn',@PolOuterLine,'Tag','PolOuterLine','Checked','on');
    %        
    %   mitem32 = uimenu(mitem3,'Text','Az ','Tag','AzOptions');
    %        uimenu(mitem32,'Text','TickLabel ','MenuSelectedFcn',@AzTickLabel,'Tag','AzTickLabel','Checked','on');
    %        uimenu(mitem32,'Text','InnerLine ','MenuSelectedFcn',@AzInnerLine,'Tag','AzInnerLine','Checked','on');
    %        uimenu(mitem32,'Text','OuterLine ','MenuSelectedFcn',@AzOuterLine,'Tag','AzOuterLine','Checked','on');
    
    m1 = uimenu(figure_handle,'Text','qi slider');
        uimenu(m1,'Text','show','MenuSelectedFcn',@menuSelectedFcn1,'Checked','on');
    
 %% local Fcn
 
 function menuRulerSelectedFcn1(source,~)
% set roll angle polaraxes   visible on/off
    if strcmp(source.Checked,'off')
        figure_handle.UserData.fhf.h_ax5.Visible = 'on';
        figure_handle.UserData.fhf.l5.Visible = 'on';
           figure_handle.UserData.fhf.l6.Visible = 'on';
        source.Checked='on';
    else
        figure_handle.UserData.fhf.h_ax5.Visible = 'off';
         figure_handle.UserData.fhf.l5.Visible = 'off';
           figure_handle.UserData.fhf.l6.Visible = 'off';
        source.Checked='off';
    end
 end

function menuRulerSelectedFcn2(source,~)
% set front wheel slip polaraxes  and normal force bar visible on/off
    if strcmp(source.Checked,'off')
            figure_handle.UserData.fhf.h_ax2.Visible = 'on';
            figure_handle.UserData.fhf.l2.Visible = 'on';
          
            figure_handle.UserData.fhf.h_ax3.Visible = 'on'; 
            figure_handle.UserData.fhf.l3.Visible = 'on';   
            
        source.Checked='on';
    else
        figure_handle.UserData.fhf.h_ax2.Visible = 'off';
        figure_handle.UserData.fhf.l2.Visible = 'off';
       
        % front wheel normal force bar 
            figure_handle.UserData.fhf.h_ax3.Visible = 'off';  
            figure_handle.UserData.fhf.l3.Visible = 'off';   
             
        source.Checked='off';
    end
end

function menuRulerSelectedFcn3(source,~)
% set rear wheel slip polaraxes  and normal force bar visible on/off
    if strcmp(source.Checked,'off')
            figure_handle.UserData.fhf.h_ax1.Visible = 'on';
            figure_handle.UserData.fhf.l1.Visible = 'on';
          
            figure_handle.UserData.fhf.h_ax4.Visible = 'on'; 
            figure_handle.UserData.fhf.l4.Visible = 'on';   
            
        source.Checked='on';
    else
        figure_handle.UserData.fhf.h_ax1.Visible = 'off';
        figure_handle.UserData.fhf.l1.Visible = 'off';
       
        % front wheel normal force bar 
            figure_handle.UserData.fhf.h_ax4.Visible = 'off';  
            figure_handle.UserData.fhf.l4.Visible = 'off';   
             
        source.Checked='off';
    end
end

function menuRulerSelectedFcn4(source,~)
% set front suspension visible on/off
    if strcmp(source.Checked,'off')
            figure_handle.UserData.fhf.h_ax9.Visible = 'on';
            figure_handle.UserData.fhf.l9.Visible = 'on';
          
        source.Checked='on';
    else
        figure_handle.UserData.fhf.h_ax9.Visible = 'off';
        figure_handle.UserData.fhf.l9.Visible = 'off';
       
        source.Checked='off';
    end
end

function menuRulerSelectedFcn5(source,~)
% set rear suspension visible on/off
    if strcmp(source.Checked,'off')
            figure_handle.UserData.fhf.h_ax10.Visible = 'on';
            figure_handle.UserData.fhf.l10.Visible = 'on';
          
        source.Checked='on';
    else
        figure_handle.UserData.fhf.h_ax10.Visible = 'off';
        figure_handle.UserData.fhf.l10.Visible = 'off';
       
        source.Checked='off';
    end
end

function menuRulerSelectedFcn6(source,~)
% set speedometer visible on/off
    if strcmp(source.Checked,'off')
            figure_handle.UserData.fhf.h_ax7.Visible = 'on';
            figure_handle.UserData.fhf.l7.Visible = 'on';
          figure_handle.UserData.fhf.t8.Visible = 'on';
          figure_handle.UserData.fhf.t7.Visible = 'on';
          
          % acceleration bar
           figure_handle.UserData.fhf.l8.Visible = 'on';
            figure_handle.UserData.fhf.h_ax8.Visible = 'on';
        source.Checked='on';
    else
        figure_handle.UserData.fhf.h_ax7.Visible = 'off';
        figure_handle.UserData.fhf.l7.Visible = 'off';
       figure_handle.UserData.fhf.t8.Visible = 'off';
       figure_handle.UserData.fhf.t7.Visible = 'off';
       
       % acceleration bar
       figure_handle.UserData.fhf.l8.Visible = 'off';
       figure_handle.UserData.fhf.h_ax8.Visible = 'off';
        source.Checked='off';
    end
end

function menuSelectedFcn1(source,~)
% set roll angle polaraxes   visible on/off
    if strcmp(source.Checked,'off')
        set(  figure_handle.UserData.fh.sld,'visible','on');
       
        source.Checked='on';
    else
      set(  figure_handle.UserData.fh.sld,'visible','off');
   
        source.Checked='off';
    end
 end

end