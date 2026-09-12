function [] = initialize_plot_app
% initialize_plot returns a figure handle structure

%  Create and then hide the figure as it is being constructed.
%fh.f = figure(112358); % ,'Tag','form1'
%clf;

figure_handle = findobj('Tag','figure_handle');

fh.f = figure_handle;
% set(fh.f,'Visible','off','Position',[360,500,1080,720]);

 movegui(fh.f,'center');
% view([45 30])
% axis;
fh.ax1 = axes(fh.f,'Tag','ax1');
c4 = uicontextmenu(fh.f);
fh.ax1.UIContextMenu = c4;

    uimenu(c4,'Label','grey','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','white','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','black','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','grid off','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','grid on','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','Box on','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','Box off','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','BoxStyle-back','Callback',@setbackgroundcolor4); 
    uimenu(c4,'Label','BoxStyle-full','Callback',@setbackgroundcolor4);
    uimenu(c4,'Label','restore axis','Callback',@setbackgroundcolor4); 
    uimenu(c4,'Label','disable axis','Callback',@setbackgroundcolor4); 
   
fh.ax1.XGrid='on';
fh.ax1.YGrid='on';
fh.ax1.ZGrid='on';
set(fh.ax1,'DataAspectRatio',[1 1 1],'Units','pixels','position',[20 20 1000 700])



% rotate3d on


%plotgroundsurface;


% there are 16 reference frames
v = [1 0 0;0 0 0;0 1 0;0 0 0;0 0 1;0 0 0];
f = [1 2 3 4 5 6];
c = [0 0 1;0 0 1;0 .5 0;0 .5 0;1 0 0;1 0 0];
fh.r01 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r02 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r03 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r04 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r05 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r06 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r07 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r08 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r09 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r10 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r11 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r12 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r13 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r14 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r15 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r16 = patch(fh.ax1,'Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);

% initialize coms
fh.c1 = initializecom;
fh.c2 = initializecom;
fh.c3 = initializecom;
fh.c4 = initializecom;
fh.c5 = initializecom;
fh.c6 = initializecom;


% initialize wheels
fh.fwl = initializewheel;
fh.rwl = initializewheel;

% initialize bodies
fh.swa = initializeswingarm;
fh.sth = initializesteeringhead;
fh.ffo = initializefrontfork;

light(fh.ax1,'Position',[1 0 0],'Style','infinite');
light(fh.ax1,'Position',[0 1 0],'Style','infinite');
light(fh.ax1,'Position',[0 0 1],'Style','infinite');

% assignin('base','fh',fh);
data = figure_handle.UserData;
data.fh = fh;
data.Index = 1;

figure_handle.UserData = data;


%% local function
function h = initializewheel
r2=0;r1=0;R=eye(3);O=[0 0 0];
n=64;
t=linspace(-pi,pi,n);
[u v] = meshgrid(t,linspace(-pi/2,pi/2,16));
h.h1    =surface(fh.ax1,(r2+r1*cos(v)).*cos(u),r1*sin(v),(r2+r1*cos(v)).*sin(u));
set(h.h1,'EdgeAlpha',0,'FaceLighting','gouraud','FaceColor',[0.01 0.01 0.01],'AmbientStrength',1,'DiffuseStrength',1);

% rim
f  =reshape([1:n;[(n+2):(2*n) n+1]],2*n,1);
f1 =[f circshift(f,-1) circshift(f,-2)];

x1 = [r2*sin(t) (r2-.02)*sin(t-pi/n) (r2-.02)*sin(t-2*pi/n) r2* sin(t-3*pi/n)];
y1 = [r1*ones(1,n) (r1-.01)*ones(1,n) -(r1-.01)*ones(1,n) -r1*ones(1,n)];
z1 = [r2*cos(t) (r2-.02)*cos(t-pi/n) (r2-.02)*cos(t-2*pi/n) r2* cos(t-3*pi/n)];

p  = R*[x1;y1;z1];
p  = [p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

h.h2 = patch(fh.ax1,'vertices',p.','faces',[f1;f1+n;f1+n*2],'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
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
h.h3=patch(fh.ax1,'vertices',p1','faces',f3,'FaceColor',[0.9 1 0.1],'EdgeAlpha',0.3,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');

% hub
x5 = .04*[sin(t-pi/n) sin(t-2*pi/n)];
y5 = .09*[ones(1,n) -ones(1,n)];
z5 = .04*[cos(t-pi/n) cos(t-2*pi/n)];
p5 = R*[x5;y5;z5];
p5 = [p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

h.h4=patch(fh.ax1,'vertices',p5.','faces',f1,'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
h.h5=patch(fh.ax1,'vertices',p5.','faces',[1:n;n+1:2*n],'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
end

function h = initializesteeringhead

n=32;

faces_matrix1 = [1:n;n+1:2*n];
faces_matrix2=[];
for i=1:n-1
    faces_matrix2(i,:) = [i i+1 n+i+1 n+i];
end
faces_matrix3 = [1:146;146+1:2*146];
faces_matrix4=[];
for i=1:47
    faces_matrix4(i,:) = [i i+1 47+i+2 47+i+1];
end
faces_matrix4(48,:) = [48 1 49 96];
h.h1=patch(fh.ax1,'Vertices',zeros( 64,3),'Faces',faces_matrix2,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h2=patch(fh.ax1,'Vertices',zeros( 64,3),'Faces',faces_matrix2,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h3=patch(fh.ax1,'Vertices',zeros( 64,3),'Faces',faces_matrix2,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h4=patch(fh.ax1,'Vertices',zeros(292,3),'Faces',faces_matrix3,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h5=patch(fh.ax1,'Vertices',zeros( 96,3),'Faces',faces_matrix4,'FaceColor',[0.5 0.6  0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h6=patch(fh.ax1,'Vertices',zeros(292,3),'Faces',faces_matrix3,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h7=patch(fh.ax1,'Vertices',zeros( 96,3),'Faces',faces_matrix4,'FaceColor',[0.5 0.6  0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
end

function h = initializefrontfork
n=8;
faces_matrix1 = [1:n;n+1:2*n];
faces_matrix2 = zeros(7,4);
for i=1:n-1
    faces_matrix2(i,:) = [i i+1 n+i+1 n+i];
end
faces_matrix2(n,:) = [n 1 n+1 2*n];
h.h1=patch(fh.ax1,'Vertices',zeros(16,3),'Faces',faces_matrix1,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h2=patch(fh.ax1,'Vertices',zeros(16,3),'Faces',faces_matrix2,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h3=patch(fh.ax1,'Vertices',zeros(16,3),'Faces',faces_matrix1,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
h.h4=patch(fh.ax1,'Vertices',zeros(16,3),'Faces',faces_matrix2,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2);
end

function h = initializeswingarm
f1 = [1:14; 15:28];
f2 = [1 2 16 15;2 3 17 16;3 4 18 17;4 5 19 18;5 6 20 19;6 7 21 20; ...
    7 8 22 21;8 9 23 22; 9 10 24 23;10 11 25 24;11 12 26 25;12 13 27 26;13 14 28 27;14 1 15 28];
h.h1=patch(fh.ax1,'Vertices',zeros(28,3),'Faces',f1,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
h.h2=patch(fh.ax1,'Vertices',zeros(28,3),'Faces',f2,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
end

function h = initializecom
f = [1 2 3;2 4 5;2 5 3;3 5 6;4 7 8;4 8 5;5 8 9;5 9 6;6 9 10;7 11 12;7 12 8;8 12 13;8 13 9;9 13 14;9 14 10;10 14 15];
f1=[f;f+15;f+30;f+45];
h.h1=patch(fh.ax1,'Vertices',zeros(60,3),'Faces',f1,'FaceColor',[0 0 0],'EdgeAlpha',0,'FaceLighting','phong','DiffuseStrength',0.2,'FaceAlpha',0.8);
h.h2=patch(fh.ax1,'Vertices',zeros(60,3),'Faces',f1,'FaceColor',[1 1 0],'EdgeAlpha',0,'FaceLighting','phong','DiffuseStrength',0.2,'FaceAlpha',0.8);
end

        function []=setbackgroundcolor4(source,~)
                    
                    % axesXe=findobj('Tag','axes2');
                    % AxeS6=findobj('Tag','axes5');
                    %figureX=findobj('Tag','figure1');     
                    

            switch source.Label
                case 'grey'                    
                   % figure1.Color = [.94 .94 .94]  ;% (default)       
                    
                   fh.ax1.Color = [.94 .94 .94] ;
                  %  figureX.ToolBar='none';
                  %                     MenuBar — Figure menu bar display
                        % 'figure' (default) | 'none'
                case 'white'
                    fh.ax1.Color = 'w';
                   %   figure1.ForegroundColor='k';
                    
                case 'black'
                     fh.ax1.Color = 'k';
                    %  figure1.BackgroundColor = 'none';
                    % drawnow;
                case 'grid off'
                    fh.ax1.XGrid='off';
                    fh.ax1.YGrid='off';
                    fh.ax1.ZGrid='off';
                case 'grid on'
                    fh.ax1.XGrid='on';
                    fh.ax1.YGrid='on';
                    fh.ax1.ZGrid='on';
                case 'Box on'
                    fh.ax1.Box='on';
                case 'Box off'
                    fh.ax1.Box='off';
                case 'BoxStyle-back'
                    fh.ax1.BoxStyle='back';
                case 'BoxStyle-full'
                    fh.ax1.BoxStyle='full';
               
                case 'disable axis'
                    fh.ax1.XColor=fh.ax1.Color;
                    fh.ax1.YColor=fh.ax1.Color;
                    fh.ax1.ZColor=fh.ax1.Color;
                 case 'restore axis'
                    fh.ax1.XColor='k';
                    fh.ax1.YColor='k';
                    fh.ax1.ZColor='k';
            end
        end
end