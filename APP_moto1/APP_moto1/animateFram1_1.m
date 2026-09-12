function animation(varargin)
% - input of q and qd so that tire forces and alphas and kappas can be
%    calculated
% - parameter fit on fjr1300
% - measurement vector implementation in this file
% - validation of model on roundabout, slalom, and j-turn
% improve plotcom function

figure_handle = findobj('Tag','figure_handle');
    %fh.f = figure_handle;
    
data = figure_handle.UserData;

fh = data.fh;
%zoom(3)
%camproj('perspective')

%%
% test if it should draw a kinematic model, or an animation
% if kinematic, draw gui elements
% else, initialize force elements
p=parameters('dummy');% gsxr1000 k7 FJR1300 dummy

if nargin<1
    q  = coordinates('dummy');
    data.q = q;
    % text, no user interface
    sld(1)=uicontrol(fh.f,'style','text','String','qx: x-position' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,540,110,20]);
    sld(2)=uicontrol(fh.f,'style','text','String','qy: y-position' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,500,110,20]);
    sld(3)=uicontrol(fh.f,'style','text','String','qz: z-position' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,460,110,20]);
    sld(4)=uicontrol(fh.f,'style','text','String','q0: rear yaw'   ,'FontSize',12,'HorizontalAlignment','left','Position',[10,420,110,20]);
    sld(5)=uicontrol(fh.f,'style','text','String','q1: rear roll'  ,'FontSize',12,'HorizontalAlignment','left','Position',[10,380,110,20]);
    sld(6)=uicontrol(fh.f,'style','text','String','q2: rear pitch' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,340,110,20]);
    sld(7)=uicontrol(fh.f,'style','text','String','q3: steering'   ,'FontSize',12,'HorizontalAlignment','left','Position',[10,300,110,20]);
    sld(8)=uicontrol(fh.f,'style','text','String','q4: front yaw'  ,'FontSize',12,'HorizontalAlignment','left','Position',[10,260,110,20]);
    sld(9)=uicontrol(fh.f,'style','text','String','q5: front roll' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,220,110,20]);
    sld(10)=uicontrol(fh.f,'style','text','String','q6: front pitch','FontSize',12,'HorizontalAlignment','left','Position',[10,180,110,20]);
    sld(11)=uicontrol(fh.f,'style','text','String','q7: swingarm'   ,'FontSize',12,'HorizontalAlignment','left','Position',[10,140,110,20]);
    sld(12)=uicontrol(fh.f,'style','text','String','qf: front fork' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,100,110,20]);
    sld(13)=uicontrol(fh.f,'style','text','String','q8: rear wheel' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,60,110,20]);
    sld(14)=uicontrol(fh.f,'style','text','String','q9: front wheel','FontSize',12,'HorizontalAlignment','left','Position',[10,20,110,20]);
    
    
    % sliders
    qx_s = uicontrol(fh.f,'style','slider','Min',-200,'Max',200,'Value',q.qx,'Position',[120,540,100,20],'Callback',{@update_qx_edit});     sld(15)= qx_s;
    qy_s = uicontrol(fh.f,'style','slider','Min',-200,'Max',200,'Value',q.qy,'Position',[120,500,100,20],'Callback',{@update_qy_edit});     sld(16)= qy_s;
    qz_s = uicontrol(fh.f,'style','slider','Min',0,'Max',2,'Value',q.qz,'Position',[120,460,100,20],'Callback',{@update_qz_edit});      sld(17)= qz_s;
    q0_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q0,'Position',[120,420,100,20],'Callback',{@update_q0_edit});   sld(18)= q0_s;
    q1_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q1,'Position',[120,380,100,20],'Callback',{@update_q1_edit});   sld(19)= q1_s;
    q2_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q2,'Position',[120,340,100,20],'Callback',{@update_q2_edit});   sld(20)= q2_s;
    q3_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q3,'Position',[120,300,100,20],'Callback',{@update_q3_edit});   sld(21)= q3_s;
    q4_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q4,'Position',[120,260,100,20],'Callback',{@update_q4_edit});   sld(22)= q4_s;
    q5_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q5,'Position',[120,220,100,20],'Callback',{@update_q5_edit});   sld(23)= q5_s;
    q6_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q6,'Position',[120,180,100,20],'Callback',{@update_q6_edit});   sld(24)= q6_s;
    q7_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q7,'Position',[120,140,100,20],'Callback',{@update_q7_edit});   sld(25)= q7_s;
    qf_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.qf,'Position',[120,100,100,20],'Callback',{@update_qf_edit});   sld(26)= qf_s;
    q8_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q8,'Position',[120,060,100,20],'Callback',{@update_q8_edit});   sld(27)= q8_s;
    q9_s = uicontrol(fh.f,'style','slider','Min',-pi,'Max',pi,'Value',q.q9,'Position',[120,020,100,20],'Callback',{@update_q9_edit});   sld(28)= q9_s;

    % edit boxes
    qx_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.qx,'Position',[220,540,72,20],'Callback',{@update_qx_slider});  sld(29)= qx_e;
    qy_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.qy,'Position',[220,500,72,20],'Callback',{@update_qy_slider});  sld(30)= qy_e;
    qz_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.qz,'Position',[220,460,72,20],'Callback',{@update_qz_slider});  sld(31)= qz_e;
    q0_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q0,'Position',[220,420,72,20],'Callback',{@update_q0_slider});  sld(32)= q0_e;
    q1_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q1,'Position',[220,380,72,20],'Callback',{@update_q1_slider});  sld(33)= q1_e;
    q2_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q2,'Position',[220,340,72,20],'Callback',{@update_q2_slider});  sld(34)= q2_e;
    q3_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q3,'Position',[220,300,72,20],'Callback',{@update_q3_slider});  sld(35)= q3_e;
    q4_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q4,'Position',[220,260,72,20],'Callback',{@update_q4_slider});  sld(36)= q4_e;
    q5_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q5,'Position',[220,220,72,20],'Callback',{@update_q5_slider});  sld(37)= q5_e;
    q6_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q6,'Position',[220,180,72,20],'Callback',{@update_q6_slider});  sld(38)= q6_e;
    q7_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q7,'Position',[220,140,72,20],'Callback',{@update_q7_slider});  sld(39)= q7_e;
    qf_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.qf,'Position',[220,100,72,20],'Callback',{@update_qf_slider});  sld(40)= qf_e;
    q8_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q8,'Position',[220,060,72,20],'Callback',{@update_q8_slider});  sld(41)= q8_e;
    q9_e = uicontrol(fh.f,'Style','edit','backgroundColor','w','FontSize',12,'String',q.q9,'Position',[220,020,72,20],'Callback',{@update_q9_slider});  sld(42)= q9_e;
    
    %buttons
    sld(43)=uicontrol(fh.f,'style','pushbutton','String','write current configuration to command window' ,'FontSize',10,'HorizontalAlignment','left','Position',[10,580,282,20],'Callback',{@write_q});
    
    fh.sld = sld;
    data.fh = fh;
    figure_handle.UserData = data;
    set(sld,'Visible','on');
    
    updateplot(q);
   % set(fh.f,'Visible','on');
  %  assignin('base','fh',fh)
else
    fhf = data.fhf;
    % fh = data.fh;
    % set(fh.sld,'Visible','off');
    qt=varargin{1};
    if nargin > 1
    qdt=varargin{2};
    else
       % qdt=0*qt;
       qdt=zeros(length(qt),13);
    end
    
    if nargin > 2
    SimTimeIndex = varargin{3};
    end
    
    tic
    if isstruct(qt)
        for i=1:length(qt)
            q.qx=qt(i,1);q.qy=qt(i,2);q.qz=qt(i,3);
            q.q0=qt(i,4);q.q1=qt(i,5);q.q2=qt(i,6);
            q.q4=qt(i,7);q.q5=qt(i,8);q.q6=qt(i,9);
            q.q7=qt(i,10);q.qf=qt(i,11);q.q8=qt(i,12);q.q9=qt(i,13);
            qd.qxd=qdt(i,1);qd.qyd=qdt(i,2);qd.qzd=qdt(i,3);
            qd.q0d=qdt(i,4);qd.q1d=qdt(i,5);qd.q2d=qdt(i,6);
            qd.q4d=qdt(i,7);qd.q5d=qdt(i,8);qd.q6d=qdt(i,9);
            qd.q7d=qdt(i,10);qd.qfd=qdt(i,11);qd.q8d=qdt(i,12);qd.q9d=qdt(i,13);
  
            updateplot(q,qd)
       
        % set(fh.f,'Visible','on');
        
        end
    end
    
    if isa(qt,'double')
        j = figure_handle.UserData.Index ;
       % n = figure_handle.UserData.LengthIndex ;
        n = length(qt);
        
        drawTime = zeros(1,n);
        
        datta =  figure_handle.UserData ;
        datta.LengthIndex = n;
        datta.drawTime = drawTime;
         figure_handle.UserData =  datta  ;
        
        for i=j:1:n%  i=1:length(qt)
            
            tic;
            q.qx=qt(i,1);q.qy=qt(i,2);q.qz=qt(i,3);
            q.q0=qt(i,4);q.q1=qt(i,5);q.q2=qt(i,6);
            q.q4=qt(i,7);q.q5=qt(i,8);q.q6=qt(i,9);
            q.q7=qt(i,10);q.qf=qt(i,11);q.q8=qt(i,12);q.q9=qt(i,13);
            
            qd.qxd=qdt(i,1);qd.qyd=qdt(i,2);qd.qzd=qdt(i,3);
            qd.q0d=qdt(i,4);qd.q1d=qdt(i,5);qd.q2d=qdt(i,6);
            qd.q4d=qdt(i,7);qd.q5d=qdt(i,8);qd.q6d=qdt(i,9);
            qd.q7d=qdt(i,10);qd.qfd=qdt(i,11);qd.q8d=qdt(i,12);qd.q9d=qdt(i,13);
  
            updateplot(q,qd);
           % attachToAnimation;
            %  set(fh.f,'Visible','on');
           
            drawTime(i) = toc;
            
           data =  figure_handle.UserData ;
           data.Index = i;
           data.drawTime = drawTime;
           % data.LengthIndex = length(qt);
           figure_handle.UserData = data;
           
                    if  figure_handle.UserData.Play == 0
                        disp(drawTime)
                        return;
                    end
        end
        
%        set(fh.sld,'Visible','on');
        % Fcn attach to animation
       % attachToAnimation; 
    end
end

%____________________________________-
                 %  function attachToAnimation(varargin)
                  % update sliders           -   edit boxes 
                  %         to current motorcycle configuration
                  %      sld(15).Value = q.qx;  sld(29).String = q.qx;         
                  %      sld(16).Value = q.qy;  sld(30).String = q.qy;
                  %      sld(17).Value = q.qz;  sld(31).String = q.qz;
                  %      sld(18).Value = q.q0;  sld(32).String = q.q0;
                  %      sld(19).Value = q.q1;  sld(33).String = q.q1;
                  %      sld(20).Value = q.q2;  sld(34).String = q.q2;
                  %    %  sld(21).Value = q3y;  sld(35).String =q3y;
                   %     sld(22).Value = q.q4;  sld(36).String = q.q4;
                  %      sld(23).Value = q.q5;  sld(37).String = q.q5;
                 %       sld(24).Value = q.q6;  sld(38).String = q.q6;
                 %       sld(25).Value = q.q7;  sld(39).String = q.q7;
                 %       sld(26).Value = q.qf;  sld(40).String = q.qf;
                 %       sld(27).Value = q.q8;  sld(41).String = q.q8;
                 %       sld(28).Value = q.q9;  sld(42).String = q.q9;
                 %   end

% update edit boxes
    function update_qx_edit(varargin); 	q = figure_handle.UserData.q;	q.qx = get(qx_s,'value');	set(qx_e,'string',q.qx,'userdata',q.qx);    updateplot;    end
    function update_qy_edit(varargin);	q = figure_handle.UserData.q;	q.qy = get(qy_s,'value');	set(qy_e,'string',q.qy,'userdata',q.qy);    updateplot;    end
    function update_qz_edit(varargin);	q = figure_handle.UserData.q;	q.qz = get(qz_s,'value');	set(qz_e,'string',q.qz,'userdata',q.qz);    updateplot;    end
    function update_q0_edit(varargin);	q = figure_handle.UserData.q;	q.q0 = get(q0_s,'value');	set(q0_e,'string',q.q0,'userdata',q.q0);    update_qf;     end
    function update_q1_edit(varargin);	q = figure_handle.UserData.q;	q.q1 = get(q1_s,'value');	set(q1_e,'string',q.q1,'userdata',q.q1);    update_qf;     end
    function update_q2_edit(varargin);	q = figure_handle.UserData.q;	q.q2 = get(q2_s,'value');	set(q2_e,'string',q.q2,'userdata',q.q2);    update_qf;     end
    function update_q3_edit(varargin);	q = figure_handle.UserData.q;	q.q3 = get(q3_s,'value');	set(q3_e,'string',q.q3,'userdata',q.q3);    update_qf;     end
    function update_q4_edit(varargin);	q = figure_handle.UserData.q;	q.q4 = get(q4_s,'value');	set(q4_e,'string',q.q4,'userdata',q.q4);    update_qr;     end
    function update_q5_edit(varargin);	q = figure_handle.UserData.q;	q.q5 = get(q5_s,'value');	set(q5_e,'string',q.q5,'userdata',q.q5);    update_qr;     end
    function update_q6_edit(varargin);	q = figure_handle.UserData.q;	q.q6 = get(q6_s,'value');	set(q6_e,'string',q.q6,'userdata',q.q6);    update_qr;     end
    function update_q7_edit(varargin);	q = figure_handle.UserData.q;	q.q7 = get(q7_s,'value');	set(q7_e,'string',q.q7,'userdata',q.q7);    updateplot;    end
    function update_qf_edit(varargin);	q = figure_handle.UserData.q;	q.qf = get(qf_s,'value');	set(qf_e,'string',q.qf,'userdata',q.qf);    updateplot;    end
    function update_q8_edit(varargin);	q = figure_handle.UserData.q;	q.q8 = get(q8_s,'value');	set(q8_e,'string',q.q8,'userdata',q.q8);    updateplot;    end
    function update_q9_edit(varargin);	q = figure_handle.UserData.q;	q.q9 = get(q9_s,'value');	set(q9_e,'string',q.q9,'userdata',q.q9);    updateplot;    end

% update sliders
    function update_qx_slider(varargin); q = figure_handle.UserData.q;	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.qx = str2double(val);    updateplot;    end
    function update_qy_slider(varargin); q = figure_handle.UserData.q;	val = get(qy_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qy_s,'min') || str2double(val) > get(qy_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qy_s,'value',str2double(val));	set(qy_e,'userdata',val);   q.qy = str2double(val);    updateplot;    end
    function update_qz_slider(varargin); q = figure_handle.UserData.q;	val = get(qz_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qz_s,'min') || str2double(val) > get(qz_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qz_s,'value',str2double(val));	set(qz_e,'userdata',val);   q.qz = str2double(val);    updateplot;    end
    function update_q0_slider(varargin); q = figure_handle.UserData.q;	val = get(q0_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q0_s,'min') || str2double(val) > get(q0_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q0_s,'value',str2double(val));	set(q0_e,'userdata',val);   q.q0 = str2double(val);    update_qf;    end
    function update_q1_slider(varargin); q = figure_handle.UserData.q;	val = get(q1_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q1_s,'min') || str2double(val) > get(q1_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q1_s,'value',str2double(val));	set(q1_e,'userdata',val);   q.q1 = str2double(val);    update_qf;    end
    function update_q2_slider(varargin); q = figure_handle.UserData.q;	val = get(q2_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q2_s,'min') || str2double(val) > get(q2_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q2_s,'value',str2double(val));	set(q2_e,'userdata',val);   q.q2 = str2double(val);    update_qf;    end
    function update_q3_slider(varargin); q = figure_handle.UserData.q;	val = get(q3_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q3_s,'min') || str2double(val) > get(q3_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q3_s,'value',str2double(val));	set(q3_e,'userdata',val);   q.q3 = str2double(val);    update_qf;    end
    function update_q4_slider(varargin); q = figure_handle.UserData.q;	val = get(q4_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q4_s,'min') || str2double(val) > get(q4_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q4_s,'value',str2double(val));	set(q4_e,'userdata',val);   q.q4 = str2double(val);    update_qr;    end
    function update_q5_slider(varargin); q = figure_handle.UserData.q;	val = get(q5_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q5_s,'min') || str2double(val) > get(q5_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q5_s,'value',str2double(val));	set(q5_e,'userdata',val);   q.q5 = str2double(val);    update_qr;    end
    function update_q6_slider(varargin); q = figure_handle.UserData.q;	val = get(q6_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q6_s,'min') || str2double(val) > get(q6_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q6_s,'value',str2double(val));	set(q6_e,'userdata',val);   q.q6 = str2double(val);    update_qr;    end
    function update_q7_slider(varargin); q = figure_handle.UserData.q;	val = get(q7_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q7_s,'min') || str2double(val) > get(q7_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q7_s,'value',str2double(val));	set(q7_e,'userdata',val);   q.q7 = str2double(val);    updateplot;    end
    function update_qf_slider(varargin); q = figure_handle.UserData.q;	val = get(qf_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qf_s,'min') || str2double(val) > get(qf_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qf_s,'value',str2double(val));	set(qf_e,'userdata',val);   q.qf = str2double(val);    updateplot;    end
    function update_q8_slider(varargin); q = figure_handle.UserData.q;	val = get(q8_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q8_s,'min') || str2double(val) > get(q8_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q8_s,'value',str2double(val));	set(q8_e,'userdata',val);   q.q8 = str2double(val);    updateplot;    end
    function update_q9_slider(varargin); q = figure_handle.UserData.q;	val = get(q9_e,'string');	if isnan(str2double(val)) || str2double(val) < get(q9_s,'min') || str2double(val) > get(q9_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(q9_s,'value',str2double(val));	set(q9_e,'userdata',val);   q.q9 = str2double(val);    updateplot;    end

    function write_q(varargin)
        assignin('base','ans',q);
    end
% q8 = q0+atan((s3*c2)/(c1*c3-s1*s2*s3))  ; % kinematic steering angle in Cossalter
% q4 = -atan((-s3*tan(q1)+s2*c3)/c2)      ; % front wheel camber angle
% q5 = -asin(c1*s2*s3+s1*c3)              ; % front fork angle (measuered in front wheel plane)


    function update_qf
        q.q4 = q.q0+atan((sin(q.q3)*cos(q.q2))/(cos(q.q1)*cos(q.q3)-sin(q.q1)*sin(q.q2)*sin(q.q3)));
        q.q5 = asin(cos(q.q1)*sin(q.q2)*sin(q.q3)+sin(q.q1)*cos(q.q3))     ;
        q.q6 = atan((-sin(q.q3)*tan(q.q1)+sin(q.q2)*cos(q.q3))/cos(q.q2))  ;
        set(q4_s,'value',q.q4,'userdata',q.q4);
        set(q5_s,'value',q.q5,'userdata',q.q5);
        set(q6_s,'value',q.q6,'userdata',q.q6);
        set(q4_e,'string',q.q4,'userdata',q.q4);
        set(q5_e,'string',q.q5,'userdata',q.q5);
        set(q6_e,'string',q.q6,'userdata',q.q6);
        updateplot
    end

    function update_qr
        q.q3 = -q.q3;
        q.q0 = q.q4+atan((sin(q.q3)*cos(q.q6))/(cos(q.q5)*cos(q.q3)-sin(q.q5)*sin(q.q6)*sin(q.q3)));
        q.q1 = asin(cos(q.q5)*sin(q.q6)*sin(q.q3)+sin(q.q5)*cos(q.q3))     ;
        q.q2 = atan((-sin(q.q3)*tan(q.q5)+sin(q.q6)*cos(q.q3))/cos(q.q6))  ;
        q.q3=-q.q3;
        set(q0_s,'value',q.q0,'userdata',q.q0);
        set(q1_s,'value',q.q1,'userdata',q.q1);
        set(q2_s,'value',q.q2,'userdata',q.q2);
        set(q0_e,'string',q.q0,'userdata',q.q0);
        set(q1_e,'string',q.q1,'userdata',q.q1);
        set(q2_e,'string',q.q2,'userdata',q.q2);
        updateplot
    end
%%
% update plot
   function updateplot(varargin)
        % create frequently used expressions
        a1 = p.a1  ; l2 = p.l2  ; l3 = p.l3 ; m5 = p.m5  ; a6 = p.a6 ;
        b1 = p.b1  ; m2 = p.m2  ; m3 = p.m3 ; x5 = p.x5  ; b6 = p.b6 ;
        m1 = p.m1  ; x2 = p.x2  ; x3 = p.x3 ; z5 = p.z5  ; m6 = p.m6 ;
        i1 = p.i1  ; i2 = p.i2  ; z3 = p.z3 ; i5 = p.i5  ; i6 = p.i6 ;
        j1 = p.j1  ; t2 = p.t2  ; i3 = p.i3 ; t5 = p.t5  ; j6 = p.j6 ;
        f1 = p.f1  ; b2 = p.b2  ; k3 = p.k3 ; b5 = p.b5  ; f6 = p.f6 ;
        e1 = p.e1  ; p2 = p.p2  ; d3 = p.d3 ; p5 = p.p5  ; e6 = p.e6 ;
        k1 = p.k1  ; d2 = p.d2  ; l4 = p.l4 ; d5 = p.d5  ; k6 = p.k6 ;
        d1 = p.d1  ; e2 = p.e2  ; m4 = p.m4 ; e5 = p.e5  ; d6 = p.d6 ;
        t1 = p.t1  ; k2 = p.k2  ; x4 = p.x4 ; k5 = p.k5  ; t6 = p.t6 ;
                     n2 = p.n2  ; z4 = p.z4 ; n5 = p.n5  ; 
                     f2 = p.f2  ; i4 = p.i4 ; f5 = p.f5  ; 

        qx=q.qx;qy=q.qy;qz=q.qz;
        q0=q.q0;q1=q.q1;q2=q.q2;
        q4=q.q4;q5=q.q5;q6=q.q6;
        q7=q.q7;qf=q.qf;q8=q.q8;q9=q.q9;
        
        s0 =sin(q.q0);    c0=cos(q.q0);     s1 =sin(q.q1);    c1=cos(q.q1);
        s2 =sin(q.q2);    c2=cos(q.q2);
        s4 =sin(q.q4);    c4=cos(q.q4);     s5 =sin(q.q5);    c5=cos(q.q5);
        s6 =sin(q.q6);    c6=cos(q.q6);     s7 =sin(q.q7);    c7=cos(q.q7);
        s8 =sin(q.q8);    c8=cos(q.q8);     s9 =sin(q.q9);    c9=cos(q.q9);
        %         sb =sin(qb);    cb=cos(qb);     st =sin(qt);    ct=cos(qt);

        % create basic rotation matrices and their derivative
        R0 = [c0 -s0 0;s0 c0 0;0 0 1]; R0q = [-s0 -c0 0;c0 -s0 0;0 0 0]; % rear yaw (rate)
        R1 = [1 0 0;0 c1 -s1;0 s1 c1]; R1q = [0 0 0;0 -s1 -c1;0 c1 -s1]; % rear roll (rate)
        R2 = [c2 0 s2;0 1 0;-s2 0 c2]; R2q = [-s2 0 c2;0 0 0;-c2 0 -s2]; % rear pitch (rate)
        R4 = [c4 -s4 0;s4 c4 0;0 0 1]; R4q = [-s4 -c4 0;c4 -s4 0;0 0 0]; % front yaw (rate)
        R5 = [1 0 0;0 c5 -s5;0 s5 c5]; R5q = [0 0 0;0 -s5 -c5;0 c5 -s5]; % front roll (rate)
        R6 = [c6 0 s6;0 1 0;-s6 0 c6]; R6q = [-s6 0 c6;0 0 0;-c6 0 -s6]; % front pitch (rate)
        R7 = [c7 0 s7;0 1 0;-s7 0 c7]; R7q = [-s7 0 c7;0 0 0;-c7 0 -s7]; % swingarm angle/angular velocity
        R8 = [c8 0 s8;0 1 0;-s8 0 c8]; R8q = [-s8 0 c8;0 0 0;-c8 0 -s8]; % rear wheel angle/angular velocity
        R9 = [c9 0 s9;0 1 0;-s9 0 c9]; R9q = [-s9 0 c9;0 0 0;-c9 0 -s9]; % front wheel angle/angular velocity

        % body orientations
        Rm1 = R0*R1*R8; % rear wheel
        Rm2 = R0*R1*R7; % swingarm
        Rm3 = R0*R1*R2; % frame
        Rm4 = R4*R5*R6; % steering head
        Rm5 = R4*R5*R6; % front fork
        Rm6 = R4*R5*R9; % front wheel

        R8 = eye(3); % rear wheel angle
        R9 = eye(3); % front wheel angle

        % joint positions
        r4 = [q.qx q.qy q.qz].'                                                     ; % steering joint position
        r3 = r4+R0*(R1*(R2*[-p.l3;0;0]))                                            ; % swingarm joint position
        r2 = r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2;0;0]))                             ; % rear wheel hub position
        r1 = r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2;0;0]+R8*[0;0;-p.b1]))              ; % rear tire torus centerline lowest point
        r0 = r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2;0;0]+R8*[0;0;-p.b1])+[0;0;-p.a1])  ; % rear wheel lowest point
        r5 = r4+R4*(R5*(R6*[p.l4;0;-q.qf]))                                         ; % front wheel hub position
        r6 = r4+R4*(R5*(R6*[p.l4;0;-q.qf]+R9*[0;0;-p.b6]))                          ; % front tyre torus centerline
        r7 = r4+R4*(R5*(R6*[p.l4;0;-q.qf]+R9*[0;0;-p.b6])+[0;0;-p.a6])              ; % front tyre outer surface

        R8 = [c8 0 s8;0 1 0;-s8 0 c8]; % rear wheel angle
        R9 = [c9 0 s9;0 1 0;-s9 0 c9]; % front wheel angle

        % body positions
        rm1=r2;% rear wheel
        rm2=r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2+p.x2;0;0])   );% swingarm
        rm3=r4+R0*(R1*(R2*[-p.l3+p.x3;0;p.z3])   );% frame
        rm4=r4+R4*(R5*(R6*[ p.x4;0;p.z4])   );% steering head
        rm5=r4+R4*(R5*(R6*[ p.l4+p.x5;0;-q.qf+p.z5]));% front fork
        rm6=r5;% front wheel
        
      % forces
      if nargin>1
        qxd=qd.qxd;qyd=qd.qyd;qzd=qd.qzd;
        q0d=qd.q0d;q1d=qd.q1d;q2d=qd.q2d;
        q4d=qd.q4d;q5d=qd.q5d;q6d=qd.q6d;
        q7d=qd.q7d;qfd=qd.qfd;q8d=qd.q8d;q9d=qd.q9d;

        g=9.81;     q70=-.4;      qf0=0.6;

        r0d =[qxd+(-s0*(-c2*l3-c7*l2)-c0*(-c1*s1*a1-s1*(s2*l3+s7*l2-b1-c1*a1)))*q0d+s0*c1*(s2*l3+s7*l2-b1-c1*a1)*q1d+(c0*s2*l3+s0*s1*c2*l3)*q2d+(c0*s7*l2+s0*s1*c7*l2)*q7d+c0*(-b1-c1*a1)*q8d
              qyd+(c0*(-c2*l3-c7*l2)-s0*(-c1*s1*a1-s1*(s2*l3+s7*l2-b1-c1*a1)))*q0d-c0*c1*(s2*l3+s7*l2-b1-c1*a1)*q1d+(s0*s2*l3-c0*s1*c2*l3)*q2d+(s0*s7*l2-c0*s1*c7*l2)*q7d+s0*(-b1-c1*a1)*q8d
              qzd-s1*(s2*l3+s7*l2-b1-c1*a1)*q1d+c1*c2*l3*q2d+c1*c7*l2*q7d];
        r7d =[qxd+(-s4*(c6*l4-s6*qf)-c4*(-c5*s5*a6-s5*(-s6*l4-c6*qf-b6-c5*a6)))*q4d+s4*c5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+(c4*(-s6*l4-c6*qf)+s4*s5*(-c6*l4+s6*qf))*q6d+(-c4*s6-sin(q4)*s5*c6)*qfd+c4*(-b6-c5*a6)*q9d
              qyd+(c4*(c6*l4-s6*qf)-s4*(-c5*s5*a6-s5*(-s6*l4-c6*qf-b6-c5*a6)))*q4d-c4*c5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+(s4*(-s6*l4-c6*qf)-c4*s5*(-c6*l4+s6*qf))*q6d+(-s4*s6+c4*s5*c6)*qfd+s4*(-b6-c5*a6)*q9d
              qzd-s5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+c5*(-c6*l4+s6*qf)*q6d-c5*c6*qfd];

        r0  = [0;0;qz+c1*(s2*l3+s7*l2-b1)-a1];
        r7  = [0;0;qz-c5*(s6*l4+c6*qf+b6)-a6];
        
        % velocities rear
        vtr =-s0*r0d(1)+c0*r0d(2);
        vlr = c0*r0d(1)+s0*r0d(2)+.01;
        % velocities front
        vtf =-s4*r7d(1)+c4*r7d(2);
        vlf = c4*r7d(1)+s4*r7d(2)+.01;
        
        v1  = [c0*s2+s0*s1*c2;s0*s2-c0*s1*c2;c1*c2];
        v2  = [c4*s6+s4*s5*c6;s4*s6-c4*s5*c6;c5*c6];

        Rm3 = R0*R1*R2; % frame
        Rm4 = R4*R5*R6; % steering head

        % 2. rotate one frame to get the z-axes colinear
            % first, find the axis about to rotate and the angle
        %     v1 = Rm3(:,3);
        %     v2 = Rm4(:,3);
            w  = cross(v1,v2)/norm(cross(v1,v2))   ;     % axis
        %     qqq  = acos((dot(v1,v2))) ;   % angle
            % second, use Rodrigues rotation formula to get the new x and y vectors
            x_old = Rm3(:,1);
            y_old = Rm3(:,2);
            z_old = Rm3(:,3);
            x_new = x_old*dot(v1,v2)+cross(w,x_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,x_old)*(1-dot(v1,v2));
            y_new = y_old*dot(v1,v2)+cross(w,y_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,y_old)*(1-dot(v1,v2));
%             z_new = z_old*dot(v1,v2)+cross(w,z_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,z_old)*(1-dot(v1,v2));
        % 3. calculate angle between the vectors
         q3x = real(acos(complex(dot(x_new,Rm4(:,1)))));
        q3y = real(acos(complex(dot(y_new,Rm4(:,2)))));
%         q3=q3y;
%         T3  = u*(v1+v2)/norm(v1+v2);

        % forces/torques
        
        
%         Frs = k2*(q2-q7-q70)+b2*(q2d-q7d);                                % suspension forces
%         Ffs = k1*(qf-qf0)+d1*qfd;

        Fzr = max((-k1*r0(3)-d1*r0d(3))*(r0(3)<0),0) ;                      % normal force rear
%         Ftr = t1*Fzr*atan(-vtr/vlr);
%         Flr = Fzr*min(max(f1*((b1+a1*cos(q1))*q8d/vlr-1),-1),1);

        Fzf = max((-k1*r7(3)-d1*r7d(3))*(r7(3)<0),0) ;                      % normal force front
%         Ftf = t6*Fzf*atan(-vtf/vlf);
%         Flf = Fzf*min(max(f6*((b6+a6*cos(q5))*q9d/vlf-1),-1),1);
% 
%         T1  =  k3*(pi/2-dot(v1,v2))*cross(v1,v2);

        %% experiment
        sr    =  r0d(1:2);
        Fr    =  -1*Fzr*(sr./((sr.'*sr)^4+1)^(1/8)+sr./((sr.'*sr)^2+1));
        Flr =  c0*Fr(1)+s0*Fr(2);
        Ftr = -s0*Fr(1)+c0*Fr(2);

        ss    =  r7d(1:2);
        Ff    =  -1*Fzf*(ss./((ss.'*ss)^4+1)^(1/8)+ss./((ss.'*ss)^2+1));
        Flf =  c4*Ff(1)+s4*Ff(2);
        Ftf = -s4*Ff(1)+c4*Ff(2);
        
        % update force elements
      %  assignin('base','fhf',fhf);
%%  update force elements
            set(fhf.l3,'YData',Fzr) ;% l3 and l4 are bars
            set(fhf.l4,'YData',Fzf);
        
%         l1=compass(fhf.h_ax1,[2000 Ftr],[0 Flr]);% rear wheel
        % l2=compass(fhf.h_ax2,[2000 Ftf],[0 Flf]);% front wheel
        % l5=polarplot(fhf.h_ax5 ,q5 ,1 );% [ sind(-q5+pi/2)]
        % l5=compass(fhf.h_ax5,[ cos(-q5+pi/2) ],[ sin(-q5+pi/2)]);% roll
        % angle
       
%           set(l1,'linewidth',3);
%           set(l2,'linewidth',3);
            [theta1,rho1] = cart2pol(Ftr,Flr);
            fhf.l1.ThetaData=[theta1 theta1];     fhf.l1.RData=[0 rho1];

        
            [theta2,rho2] = cart2pol(Ftf,Flf);
            fhf.l2.ThetaData=[theta2 theta2];     fhf.l2.RData=[0 rho2]; % sign()*sqrt(Ftf^2 + Flf^2)
            % fhf.l2.XData=0;
            % fhf.l2.YData=0;
        
            set(fhf.l5 ,'linewidth',1);
            fhf.l5.ThetaData=[q5 q5];        
            fhf.l6.ThetaData=[q1 q1];        
        
%            set(l1(1),'visible','off');
            % set(l5(1),'visible','off');
%         set(l2(1),'visible','off');
%         set(l1(2),'visible','on');
%         set(l2(2),'visible','on');
        % set(l5,'visible','on');

        speed = (0.25*pi/40)*( sqrt(qxd^2 +qyd^2 )*3.6 ) -(0.25*pi);
        acceleration = Flr/(m1+m2+m3+m4+m5+m6);
        fhf.l7.ThetaData= [0 speed];    
       
        fhf.l8.YData =  acceleration ;
       
        fhf.l9.YData = (qf0-qf)/qf0;
       
        fhf.l10.YData = (q7-q70);
       
        fhf.t7.String =[ num2str(sqrt(qxd^2 +qyd^2 )*3.6,'%.0f'),'kmh'];  % [ num2str(sqrt(qxd^2 +qyd^2 )*3.6),'kmh']
        fhf.t8.String = [num2str(SimTimeIndex(i),'%05.2f'),'s'];
        
        
        
        
        
       %  fhf.devTex_1.String = [num2str(drawTime(i),'%05.2f'),'s'];
        fhf.devTex_1.String = [num2str(figure_handle.UserData.drawTime(figure_handle.UserData.Index)),'s']; % ,'%05.2f'
        fhf.devTex_2.String = [num2str(1/figure_handle.UserData.drawTime(figure_handle.UserData.Index)),' fps']; % ,'%05.2f'
        
        
        %     attachToAnimation;
                
        %____________________________________-
                  % function attachToAnimation(varargin)
                  % update sliders           -   edit boxes 
                  %         to current motorcycle configuration
                        fh.sld(15).Value = qx;  fh.sld(29).String = qx;         
                        fh.sld(16).Value = qy;  fh.sld(30).String = qy;
                        fh.sld(17).Value = qz;  fh.sld(31).String = qz;
                        fh.sld(18).Value = q0;  fh.sld(32).String = q0;
                        fh.sld(19).Value = q1;  fh.sld(33).String = q1;
                        fh.sld(20).Value = q2;  fh.sld(34).String = q2;
                        fh.sld(21).Value = q3y; fh.sld(35).String = q3y;
                        fh.sld(22).Value = q4;  fh.sld(36).String = q4;
                        fh.sld(23).Value = q5;  fh.sld(37).String = q5;
                        fh.sld(24).Value = q6;  fh.sld(38).String = q6;
                        fh.sld(25).Value = q7;  fh.sld(39).String = q7;
                        fh.sld(26).Value = qf;  fh.sld(40).String = qf;
                        fh.sld(27).Value = mod(q8,pi);  fh.sld(41).String = mod(q8,pi);
                        fh.sld(28).Value = mod(q9,pi);  fh.sld(42).String = mod(q9,pi);
                 %   end
                        fh.sld(15).UserData = qx;  fh.sld(29).UserData = qx;         
                        fh.sld(16).UserData = qy;  fh.sld(30).UserData= qy;
                        fh.sld(17).UserData = qz;  fh.sld(31).UserData = qz;
                        fh.sld(18).UserData = q0;  fh.sld(32).UserData = q0;
                        fh.sld(19).UserData = q1;  fh.sld(33).UserData = q1;
                        fh.sld(20).UserData = q2;  fh.sld(34).UserData = q2;
                        fh.sld(21).UserData = q3y; fh.sld(35).UserData = q3y;
                        fh.sld(22).UserData = q4;  fh.sld(36).UserData = q4;
                        fh.sld(23).UserData = q5;  fh.sld(37).UserData = q5;
                        fh.sld(24).UserData = q6;  fh.sld(38).UserData = q6;
                        fh.sld(25).UserData = q7;  fh.sld(39).UserData = q7;
                        fh.sld(26).UserData = qf;  fh.sld(40).UserData = qf;
                        fh.sld(27).UserData = mod(q8,pi);  fh.sld(41).UserData = mod(q8,pi);
                        fh.sld(28).UserData = mod(q9,pi);  fh.sld(42).UserData = mod(q9,pi);
                        
                 % fh.sld(15).Value = q.qx;  fh.sld(29).String = q.qx;         
                 %       fh.sld(16).Value = q.qy;    fh.sld(30).String = q.qy;
                 %       fh.sld(17).Value = q.qz;  fh.sld(31).String = q.qz;
                 %       fh.sld(18).Value = q.q0;  fh.sld(32).String = q.q0;
                 %       fh.sld(19).Value = q.q1;  fh.sld(33).String = q.q1;
                  %      fh.sld(20).Value = q.q2;  fh.sld(34).String = q.q2;
                  %      fh.sld(21).Value = q3y;  fh.sld(35).String = q3y;
                  %      fh.sld(22).Value = q.q4;  fh.sld(36).String = q.q4;
                  %      fh.sld(23).Value = q.q5;  fh.sld(37).String = q.q5;
                  %      fh.sld(24).Value = q.q6;  fh.sld(38).String = q.q6;
                  %      fh.sld(25).Value = q.q7;  fh.sld(39).String = q.q7;
                  %      fh.sld(26).Value = q.qf;  fh.sld(40).String = q.qf;
                  %      fh.sld(27).Value = mod(q.q8,pi);  fh.sld(41).String = mod(q.q8,pi);
                  %      fh.sld(28).Value = q.q9;  fh.sld(42).String = q.q9;
                  
                  dataa=figure_handle.UserData;
                  dataa.q.q3 = q3y;
                  figure_handle.UserData=dataa;
      end
        
        % visualisation

        % joint positions
        updateframe(fh.r01,r0,eye(3))   ; % rear wheel lowest point
        updateframe(fh.r02,r0,R0)       ; % rear wheel lowest point
        updateframe(fh.r03,r1,R0)       ; % rear tire torus centerline lowest point
        updateframe(fh.r04,r1,R0*R1)    ; % rear tire torus centerline lowest point
        updateframe(fh.r05,r2,R0*R1)    ; % rear wheel hub
        updateframe(fh.r06,r2,R0*R1*R7) ; % rear wheel hub
        updateframe(fh.r07,r3,R0*R1*R7) ; % swingarm joint
        updateframe(fh.r08,r3,R0*R1*R2) ; % swingarm joint
        updateframe(fh.r09,r4,R0*R1*R2) ; % steering joint
        updateframe(fh.r10,r4,R4*R5*R6) ; % steering joint
        updateframe(fh.r11,r5,R4*R5*R6) ; % front wheel hub
        updateframe(fh.r12,r5,R4*R5)    ; % front wheel hub
        updateframe(fh.r13,r6,R4*R5)    ; % front tire torus centerline lowest point
        updateframe(fh.r14,r6,R4)       ; % front tire torus centerline lowest point
        updateframe(fh.r15,r7,R4)       ; % front wheel lowest point
        updateframe(fh.r16,r7,eye(3))   ; % front wheel lowest point

        % update center of masses
        updatecom(fh.c1,rm1,Rm1);
        updatecom(fh.c2,rm2,Rm2);
        updatecom(fh.c3,rm3,Rm3);
        updatecom(fh.c4,rm4,Rm4);
        updatecom(fh.c5,rm5,Rm5);
        updatecom(fh.c6,rm6,Rm6);
       
        % update bodies
        updatewheel(fh.rwl,r2,Rm1,p.b1,p.a1);
        updatewheel(fh.fwl,r5,Rm6,p.b6,p.a6);
        updateswingarm(fh.swa,r2,Rm2)
        updatesteeringhead(fh.sth,r4,Rm4,p.l4)
        updatefrontfork(fh.ffo,r5,Rm5)

        %axis(fh.ax1,[0 150 -5 5 0 2])
       % axis(fh.ax1,[q.qx-10 q.qx+10 q.qy-10 q.qy+10 q.qz-10 q.qz+10])
        axis(fh.ax1,[q.qx-2 q.qx+2 q.qy-2 q.qy+2 0 q.qz+2])
        set(fh.ax1,'DataAspectRatio',[1 1 1])
        
        drawnow
%        title(toc)
       
        
         %%%__________________________ Local Fcn inside animate
                 
            %____________________________________-
              %     function attachToAnimation(varargin)
                  % update sliders           -   edit boxes 
                  %         to current motorcycle configuration
                  %      sld(15).Value = qx;  sld(29).String = qx;         
                  %      sld(16).Value = qy;  sld(30).String = qy;
                  %      sld(17).Value = qz;  sld(31).String = qz;
                  %      sld(18).Value = q0;  sld(32).String = q0;
                  %      sld(19).Value = q1;  sld(33).String = q1;
                  %      sld(20).Value = q2;  sld(34).String = q2;
                  %      sld(21).Value = q3y;  sld(35).String =q3y;
                  %      sld(22).Value = q4;  sld(36).String = q4;
                  %      sld(23).Value = q5;  sld(37).String = q5;
                  %      sld(24).Value = q6;  sld(38).String = q6;
                  %     sld(25).Value = q7;  sld(39).String = q7;
                  %      sld(26).Value = qf;  sld(40).String = qf;
                  %      sld(27).Value = q8;  sld(41).String = q8;
                  %      sld(28).Value = q9;  sld(42).String = q9;
                  %  end
                  
                  
                  
               data =    figure_handle.UserData ;
               data.q.qx = qx;  data.q.qy = qy;  data.q.qz = qz;  data.q.q0 = q0;  data.q.q1 = q1;  data.q.q2 = q2;  
              try
               data.q.q3 = q3y;  
              catch
              end
               data.q.q4 = q4;  data.q.q5 = q5;  data.q.q6 = q6;  data.q.q7 = q7; data.q.qf = qf;   data.q.q8 = q8;  data.q.q9 = q9;
               figure_handle.UserData = data;
                  
   end

end
%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%%  End of animation  Local Fcn's inside animateFram from here on
function updateframe(h,O,R)
        p=R*[1 0 0;0 0 0;0 1 0;0 0 0;0 0 1;0 0 0].'/5;
        p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];
        set(h,'Faces',1:6,'Vertices',p.');
end

function updatecom(h,p,R)
a = .44433292853227944784221559874174;
v = [ 0 0 1;sin(pi/8) 0 cos(pi/8);0 sin(pi/8) cos(pi/8);
    sin(pi/4) 0 sin(pi/4);a a sqrt(1-2*a^2);0 sin(pi/4) sin(pi/4);
    cos(pi/8) 0 sin(pi/8);sqrt(1-2*a^2) a a;a sqrt(1-2*a^2) a;0 cos(pi/8) sin(pi/8);
    1 0 0;cos(pi/8) sin(pi/8) 0;sin(pi/4) sin(pi/4) 0;sin(pi/8) cos(pi/8) 0;0 1 0]./20;
v1= [-v(:,1) -v(:,2) v(:,3)];
v2= [v(:,1) -v(:,2) -v(:,3)];
v3= [-v(:,1) v(:,2) -v(:,3)];
v4= R*[v;v1;v2;v3].';
v5= -v4;
v4= [v4(1,:)+p(1);v4(2,:)+p(2);v4(3,:)+p(3)];
v5= [v5(1,:)+p(1);v5(2,:)+p(2);v5(3,:)+p(3)];
set(h.h1,'Vertices',v4');
set(h.h2,'Vertices',v5');
end

function updatewheel(h,O,R,r2,r1)
n=64;
t=linspace(-pi,pi,n);
[u v] = meshgrid(t,linspace(-pi/2,pi/2,16));
x = reshape((r2+r1*cos(v)).*cos(u),1,16*n);
y = reshape(    r1*sin(v),1,16*n);
z = reshape((r2+r1*cos(v)).*sin(u),1,16*n);
p  = R*[x;y;z];

p1 = reshape(p(1,:)+O(1),16,n);
p2 = reshape(p(2,:)+O(2),16,n);
p3 = reshape(p(3,:)+O(3),16,n);

set(h.h1,'XData',p1,'YData',p2,'ZData',p3);


% rim
f  =reshape([1:n;[(n+2):(2*n) n+1]],2*n,1);
f1 =[f circshift(f,-1) circshift(f,-2)];

x1 = [r2*sin(t) (r2-.02)*sin(t-pi/n) (r2-.02)*sin(t-2*pi/n) r2* sin(t-3*pi/n)];
y1 = [r1*ones(1,n) (r1-.01)*ones(1,n) -(r1-.01)*ones(1,n) -r1*ones(1,n)];
z1 = [r2*cos(t) (r2-.02)*cos(t-pi/n) (r2-.02)*cos(t-2*pi/n) r2* cos(t-3*pi/n)];

p  = R*[x1;y1;z1];
p  = [p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h2,'vertices',p.','faces',[f1;f1+n;f1+n*2],'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');

% spokes
d1 = .01;
x2 = (r2-.02)* sin(2*pi*[-d1 d1 1-d1 1+d1 2-d1 2+d1]/3);
z2 = (r2-.02)* cos(2*pi*[-d1 d1 1-d1 1+d1 2-d1 2+d1]/3);
d2 = .5;
x3 = 0.03* sin(2*pi*[-d2 d2 1-d2 1+d2 2-d2 2+d2]/3);
z3 = 0.03* cos(2*pi*[-d2 d2 1-d2 1+d2 2-d2 2+d2]/3);
y2 = [.015*ones(1,6) .04*ones(1,6)];

p1 = R*[[x2 x3 x2 x3];[y2 -y2];[z2 z3 z2 z3]];
p1 = [p1(1,:)+O(1);p1(2,:)+O(2);p1(3,:)+O(3)];
f3 = [1 2 8 7;3 4 10 9;5 6 12 11;13 14 20 19;15 16 22 21;17 18 24 23;1 13 19 7;2 14 20 8;3 15 21 9;4 16 22 10;5 17 23 11;6 18 24 12 ];
set(h.h3,'vertices',p1');

% hub
x5 = .04*[sin(t-pi/n) sin(t-2*pi/n)];
y5 = .09*[ones(1,n) -ones(1,n)];
z5 = .04*[cos(t-pi/n) cos(t-2*pi/n)];
p5 = R*[x5;y5;z5];
p5 = [p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

set(h.h4,'vertices',p5.');
set(h.h5,'vertices',p5.');

end

function updateswingarm(h,O,R)
l=0.5;% swingarm length
w=0.2;% swingarm width
d1=0.04;%
d2=.4;%
d3=.45;%
d4=.55;%
d5=.35;%
d6=.40;%

w1=0.12;% swingarm width
w2=0.05;% swingarm front width
w3=0.095;% swingarm inner width
w4=0.01;%

h1=0.04;% swingarm height

x1=[-d1 d2  d3  d4  d4 d3 d2 -d1 -d1 d5 d6 d6 d5 -d1];
y1=[-w1 -w1 -w2 -w2 w2 w2 w1 w1 w3 w3 w4 -w4 -w3 -w3];
z1=[-h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1]/2;
p=R*[[x1 x1];[y1 y1];[z1 -z1]];
p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h1,'Vertices',p')
set(h.h2,'Vertices',p')
end

function updatesteeringhead(h,O,R,d3)
hp=0.0;
l=0.40;%fork length
% h=0.08;%
w=0.2;% width
d1=0.06;% outer diameter telescopic fork suspension tube
d2=0.04;% steering head joint diameter
%d3=100e-3;% fork offset
d4=20e-3 ;% Steering stem triple clamp overhang
t1=20e-3 ;% Steering stem triple clamp thickness
t2=150e-3;% steering head joint height
t3=0.05;% vertical offset
n=32;
t=linspace(-pi,pi,n);
x1=d1/2*cos(t);
y1=d1/2*sin(t);
h1=t2/2*ones(1,n)+hp;
h2=(t2/2-l)*ones(1,n)+hp;

p1=R*[x1+d3 x1+d3;y1+w/2 y1+w/2;h1+t3 h2+t3];
p1=[p1(1,:)+O(1);p1(2,:)+O(2);p1(3,:)+O(3)];
set(h.h1,'Vertices',p1');

p2=R*[x1+d3 x1+d3;y1-w/2 y1-w/2;h1+t3 h2+t3];
p2=[p2(1,:)+O(1);p2(2,:)+O(2);p2(3,:)+O(3)];
set(h.h2,'Vertices',p2');

x2=d2/2*cos(t);
y2=d2/2*sin(t);
h1=-t2/2*ones(1,n)+hp;
h2=t2/2*ones(1,n)+hp;

p3=R*[x2 x2;y2 y2;h1+t3 h2+t3];
p3=[p3(1,:)+O(1);p3(2,:)+O(2);p3(3,:)+O(3)];
set(h.h3,'Vertices',p3');

u1=linspace(0,pi-atan(2*d3/w),16);
u2=linspace(pi-atan(2*d3/w),pi,8);
u3=linspace(pi,pi+atan(2*d3/w),8);
u4=linspace(pi+atan(2*d3/w),2*pi,16);
%
t=linspace(-pi,pi,n);
x1=-d1/2*cos(t);
y1=d1/2*sin(t);

x4=[(d1/2+d4)+d3 x1+d3 (d1/2+d4)*cos(u1)+d3 (d2/2+d4)*cos(u2)  fliplr(x2) (d2/2+d4)*cos(u3) (d1/2+d4)*cos(u4)+d3 x1+d3 (d1/2+d4)+d3];
y4=[w/2 y1+w/2 (d1/2+d4)*sin(u1)+w/2  (d2/2+d4)*sin(u2) fliplr(y2) (d2/2+d4)*sin(u3)  (d1/2+d4)*sin(u4)-w/2 y1-w/2 -w/2];
h1=(t2/2-d4)*ones(1,length(x4))+hp;
h2=(t2/2-d4-t1)*ones(1,length(x4))+hp;

p4=R*[x4 x4;y4 y4;h1+t3 h2+t3];
p4=[p4(1,:)+O(1);p4(2,:)+O(2);p4(3,:)+O(3)];
set(h.h4,'Vertices',p4');

x5=[ (d1/2+d4)*cos(u1)+d3 (d2/2+d4)*cos(u2)   (d2/2+d4)*cos(u3) (d1/2+d4)*cos(u4)+d3  ];
y5=[ (d1/2+d4)*sin(u1)+w/2 (d2/2+d4)*sin(u2)  (d2/2+d4)*sin(u3) (d1/2+d4)*sin(u4)-w/2 ];

h1=(t2/2-d4)*ones(1,48)+hp;
h2=(t2/2-d4-t1)*ones(1,48)+hp;

p5=R*[x5 x5;y5 y5;h1+t3 h2+t3];
p5=[p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

set(h.h5,'Vertices',p5');

h1=-(t2/2-d4)*ones(1,length(x4))+hp;
h2=-(t2/2-d4-t1)*ones(1,length(x4))+hp;

p4=R*[x4 x4;y4 y4;h1+t3 h2+t3];
p4=[p4(1,:)+O(1);p4(2,:)+O(2);p4(3,:)+O(3)];
set(h.h6,'Vertices',p4');

h1=-(t2/2-d4)*ones(1,48)+hp;
h2=-(t2/2-d4-t1)*ones(1,48)+hp;

p5=R*[x5 x5;y5 y5;h1+t3 h2+t3];
p5=[p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

set(h.h7,'Vertices',p5');
end

function updatefrontfork(h,O,R)
l=0.6;%fork length
w=0.2;% width
d1=0.04;% inner diameter telescopic fork suspension tube
n=8;
t=linspace(-pi,pi,n+1);
t=t(1:end-1);
x1=d1/2*cos(t);
y1=d1/2*sin(t);
h1=-d1*ones(1,n);
h2=(l-d1)*ones(1,n);

p=R*[x1 x1;y1+w/2 y1+w/2;h1 h2];
p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h1,'Vertices',p');
set(h.h2,'Vertices',p');
p=R*[x1 x1;y1-w/2 y1-w/2;h1 h2];
p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h3,'Vertices',p');
set(h.h4,'Vertices',p');
end











function plotgroundsurface
% load groundsurface z y x
    [x,y]=meshgrid(linspace(-2,2,256));
    z=0.0001*rand(size(x));
%     save groundsurface x y z;
h=surf(fh.ax1,x,y,z); %fh.ax1,
set(h,'EdgeAlpha',0,'FaceLighting','gouraud','FaceColor',[0.06 0.05 0.05],...
    'AmbientStrength',0.5,'DiffuseStrength',0.5,'SpecularStrength',0.1,...
    'SpecularExponent',1);
end

