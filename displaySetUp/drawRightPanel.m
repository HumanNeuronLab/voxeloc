function widget = drawRightPanel(widget,wip)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% ---------------------- Electrodes Summary Panel ----------------------- %

widget.tree = uipanel('Parent',widget.fig,'Visible','on','Position',[widget.viewer.panel_CentralTabsMRI.Position(1)+widget.viewer.panel_CentralTabsMRI.Position(3)+10,60,...
    100,wip(4)-120],'BackgroundColor',widget.fig.Color,'BorderType','none');
widget.tree.Position(3) = wip(3)-widget.tree.Position(1)-10;
widget.tree_Grid = uigridlayout('Parent',widget.tree,'Padding',[0 0 0 0],...
    'ColumnWidth',{30,30,'1X',100,'1X',60},'RowHeight',{30,'1X',30},...
    'BackgroundColor',widget.fig.Color,'Scrollable','on');

widget.tree_buttonUp = uibutton('push','Parent',widget.tree_Grid,'BackgroundColor',[0.94 0.94 0.94],'Enable','off',...
    'Text','▲','Tag','UP');
widget.tree_buttonUp.Layout.Row = 1; widget.tree_buttonUp.Layout.Column = 1;
widget.tree_buttonDown = uibutton('push','Parent',widget.tree_Grid,'BackgroundColor',[0.94 0.94 0.94],'Enable','off',...
    'Text','▼','Tag','DOWN');
widget.tree_buttonDown.Layout.Row = 3; widget.tree_buttonDown.Layout.Column = 1;
widget.tree_buttonColor = uibutton('push','Parent',widget.tree_Grid,'BackgroundColor',[0.94 0.94 0.94],'Enable','off',...
    'Text','Color');
widget.tree_buttonColor.Layout.Row = 1; widget.tree_buttonColor.Layout.Column = 6;

widget.tree_Summary = uitree('Parent',widget.tree_Grid,'Enable','off');
widget.tree_Summary.Layout.Row = 2; widget.tree_Summary.Layout.Column = [1 6];
widget = createTreeNode(widget,widget.tree_Summary,'Electrode1');

widget.params.button_done = uibutton('Parent',widget.tree_Grid,'Enable','off','Text','Done');
widget.params.button_done.Layout.Row = 3; widget.params.button_done.Layout.Column = 4;

end