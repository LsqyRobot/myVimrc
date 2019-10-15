"For LaTex
iabbr eq \begin{equation}<cr><cr>\end{equation}<esc>
iabbr tab \begin{table}<cr><cr>\end{table}<esc>
iabbr array \left[<cr>\begin{array}{lll}<cr><cr>\end{array}<cr>\right]<esc>
iabbr case \begin{cases}<cr><cr>\end{cases}<esc>
iabbr split \begin{split}<cr><cr>\end{split}<esc>
iabbr ali  \begin{align}<cr><cr>\end{align}<esc>
iabbr fr \frac{}{}<esc>
iabbr tab \begin{table}<cr><cr>\end{table}<esc>
iabbr array \left[<cr>\begin{array}{lll}<cr><cr>\end{array}<cr>\right]<esc>
iabbr case \begin{cases}<cr><cr>\end{cases}<esc>
iabbr split \begin{split}<cr><cr>\end{split}<esc>
iabbr ali  \begin{align}<cr><cr>\end{align}<esc>
iabbr fr \frac{}{}<esc>
iabbr dot \dot{}<esc>
iabbr par \partial<esc>
"For Myself 
iabbr myquote You can not connecting the dots looking forward,<LF> but you can only connecting them looking backward.<esc>
"For Matlab
iabbr fori for i=1:n<cr><cr>end<esc>
iabbr mplot fiugre<cr>plot(x,y,'r-*','LineWidth',0.5)<cr>xlabel('xtag')<cr>ylabel('ytag')<cr>xlim([0,0])<cr>ylim([0,0])<cr>title('tit')<cr>legend('a')<esc>
iabbr function function [outputVar1 outputVar2]=myFunction(inputVar1,inputVar2)<cr>outputVar1=<cr>outputVar2=<cr>end<esc>
"For markDown 
iabbr vim ```vim<cr><cr>```<esc>
iabbr latex ```latex<cr><cr>```<esc>
iabbr matlab ```matlab<cr><cr>```<esc>
"For Robotics toolbox
iabbr rtbLinkIK function someRrobot<cr>obtainQ=IK(PoseRef)<cr>if length(PoseRef)~=N<cr>error('输入有误，请重新输入');<cr>end<cr>d=[0.399 0 0 0.451 0 0.082];<cr>a=[0 0.448 0.042 0 0 0];<cr>offset=0;<cr>alpha=[-pi/2 0 -pi/2 pi/2 -pi/2 0];<cr>Link1 = Link([0,d(1),a(1),alpha(1)],'standard');<cr> Link2 = Link([0,d(2),a(2),alpha(2)],'standard');<cr>Link3=Link([0,d(3),a(3),alpha(3)],'standard');<cr>Link4 = Link([0,d(4),a(4),alpha(4)],'standard');<cr>Link5 = Link([0,d(5),a(5),alpha(5)],'standard');<cr>Link6 = Link([0,d(6),a(6),alpha(6)],'standard');<cr>Link1.qlim=[-2*pi,2*pi];<cr>Link2.qlim=[-2*pi,2*pi];<cr> Link3.qlim=[-2*pi,2*pi] ;<cr>Link4.qlim=[-2*pi,2*pi]  ;<cr>Link5.qlim=[-2*pi,2*pi]  ;<cr>Link6.qlim=[-2*pi,2*pi];<cr>someRobot=SerialLink([Link1,Link2,Link3,Link4,Link5,Link6],'name','yourRobotName');<cr>W=[-1, 1 -1  1 -1 1 ];<cr>[px,py,pz]=deal(PoseRef(1),PoseRef(2),PoseRef(3));<cr>[Alpha,Beta,Gamma]=deal(PoseRef(4),PoseRef(5),PoseRef(6));<cr>nx=cos(Alpha)*cos(Beta);<cr>ny=cos(Alpha)*sin(Beta)*sin(Gamma)+sin(Alpha)*cos(Gamma);<cr>nz=sin(Alpha)*sin(Gamma)-cos(Alpha)*sin(Beta)*cos(Gamma);<cr>ox=sin(Alpha)*(-cos(Beta));<cr>oy=cos(Alpha)*cos(Gamma)-sin(Alpha)*sin(Beta)*sin(Gamma);<cr>oz=sin(Alpha)*sin(Beta)*cos(Gamma)+cos(Alpha)*sin(Gamma);<cr>ax=sin(Beta);<cr>ay=-cos(Beta)*sin(Gamma);<cr>az=cos(Beta)*cos(Gamma);<cr>end<esc>
iabbr rtbLinkFK function poseRef=FK(q)<cr>if length(q)~=6<cr>error('输入向量的关节角向量长度有误，请重新运行此脚本')<cr>end<cr>d=[0.399 0 0 0.451 0 0.082]; <cr>a=[0 0.448 0.042 0 0 0];<cr>offset=0;<cr>alpha= [-pi/2 0 -pi/2 pi/2 -pi/2 0];<cr>Link1 = Link([0,d(1),a(1),alpha(1)],'standard');<cr>Link2 = Link([0,d(2),a(2),alpha(2)],'standard');<cr>Link3 = Link([0,d(3),a(3),alpha(3)],'standard');<cr>Link4 = Link([0,d(4),a(4),alpha(4)],'standard');<cr>Link5 = Link([0,d(5),a(5),alpha(5)],'standard');<cr>Link6 = Link([0,d(6),a(6),alpha(6)],'standard');<cr>Link1.qlim=[-2*pi,2*pi]  ;<cr>Link2.qlim=[-2*pi,2*pi]  ;<cr>Link3.qlim=[-2*pi,2*pi]  ;<cr>Link4.qlim=[-2*pi,2*pi]  ;<cr>Link5.qlim=[-2*pi,2*pi]  ;<cr>Link6.qlim=[-2*pi,2*pi]  ;<cr>youRobotName=SerialLink([Link1,Link2,Link3,Link4,Link5,Link6],'name','yourRobotName');<cr>W=[-1, 1 -1  1 -1 1 ];<cr>figure<cr>yourRobotName.teach(q,'workspace',W,'noshading','tile1color',[0 0 0],'noshadow','jvec','linkcolor','g')	<cr>R=<cr>P=<cr>alpha = -atan2(R(1,2), R(1,1)); <cr>beta = atan(R(1,3)*cos(alpha)/R(1,1));<cr>gamma = -atan2(R(2,3), R(3,3));<cr>Alpha=alpha*180/pi;<cr>Beta=beta*180/pi;<cr>Gamma=gamma*180/pi;<cr>poseRef=[P(1),P(2),P(3),alpha,beta,gamma];<cr>fprintf('位置(xyz)分别为: %f,%f,%f,\t 姿态角(RPY)分别为为: %f,%f,%f',P(1),P(2),P(3),Alpha,Beta,Gamma);<cr>yourRobotName.teach(q,'workspace',W,'noshading','tile1color',[0 0 0],'noshadow','jvec','linkcolor','g')<cr>end <esc>
"For plantUML
iabbr umlFlow @startuml <cr>start <cr>:ClickServlet.handleRequest(); <cr>:new page; <cr>if (Page.onSecurityCheck) then (true) <cr>  :Page.onInit(); <cr>  if (isForward?) then (no) <cr>        :Process controls; <cr> if (continue processing?) then (no) <cr>          stop <cr>     endif <cr>      <cr>    if (isPost?) then (yes) <cr>      :Page.onPost(); <cr>  else (no) <cr>    :Page.onGet(); <cr>   endif <cr>      :Page.onRender(); <cr>  endif <cr>else (false) <cr>endif <cr> <cr>if (do redirect?) then (yes) <cr>  :redirect process; <cr>else <cr>  if (do forward?) then (yes) <cr> :Forward request; <cr>  else (no) <cr>  :Render page template; <cr>  endif <cr>endif <cr> <cr>stop <cr> <cr>@enduml<esc>
iabbr umlMind @startmindmap <cr>caption figure 1 <cr>title My super title <cr> <cr>* <&flag>Debian <cr>** <&globe>Ubuntu <cr>*** Linux Mint <cr>*** Kubuntu <cr>*** Lubuntu <cr>*** KDE Neon <cr>** <&graph>LMDE <cr>** <&pulse>SolydXK <cr>** <&people>SteamOS <cr>** <&star>Raspbian with a very long name <cr>*** <s>Raspmbc</s> => OSMC <cr>*** <s>Raspyfi</s> => Volumio <cr> <cr>header <cr>My super header <cr>endheader <cr> <cr>center footer My super footer <cr> <cr>legend right <cr>  Short <cr>  legend <cr>endlegend <cr>@endmindmap<esc>
iabbr umlOrg @startwbs <cr>* Business Process Modelling WBS <cr>** Launch the project <cr>*** Complete Stakeholder Research <cr>*** Initial Implementation Plan <cr>** Design phase <cr>*** Model of AsIs Processes Completed <cr>**** Model of AsIs Processes Completed1 <cr>**** Model of AsIs Processes Completed2 <cr>*** Measure AsIs performance metrics <cr>*** Identify Quick Wins <cr>** Complete innovate phase <cr>@endwbs<esc>
" For mySite
iabbr inline <span id = "inline-blue"> word </span><esc>
iabbr border <span id="inline-blue"> word </span><esc>






