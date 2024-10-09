function widget = drawLeftPanel(widget,wip)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% ---------------------- Electrode Parameter Panel ---------------------- %

widget.params.panel_ElectrodeParams = uipanel('Parent',widget.fig,'Enable','off',...
    'Position',[round(widget.viewer.panel_CentralTabsMRI.Position(1)/2-150),...
    (wip(4)-700)/2,300,700],'BorderType','none');
widget.params.grid = uigridlayout('Parent',widget.params.panel_ElectrodeParams,'Scrollable','on','Padding',[0 30 0 0],...
    'ColumnWidth',{'1X',50,50,50,50,'1X'},'RowHeight',{30,22,22,'1X',22,22,22,22,0,'1X',22,22,22,22,22,22,22,22,'1X',30});

if widget.viewer.panel_CentralTabsMRI.Position(1) < 320
    widget.params.panel_ElectrodeParams.Position(1) = 10;
    widget.params.panel_ElectrodeParams.Position(3) = widget.viewer.panel_CentralTabsMRI.Position(1)-20;
end
widget.params.label_PanelTitle = uilabel('Parent',widget.params.grid,'Text','Electrode Parameters','BackgroundColor',[0.8 0.8 0.8],'FontSize',14,'HorizontalAlignment','center');
widget.params.label_PanelTitle.Layout.Row = 1; widget.params.label_PanelTitle.Layout.Column = [1 6];

widget.params.label_NumElectrodes = uilabel('Parent',widget.params.grid,'HorizontalAlignment','left','FontWeight','bold','Text','Number of electrodes:');
widget.params.label_NumElectrodes.Layout.Row = 2; widget.params.label_NumElectrodes.Layout.Column = [2 4];

widget.params.spinner_NumElectrodes = uispinner('Parent',widget.params.grid,'Limits',[1 20],'ValueDisplayFormat','%.0f','HorizontalAlignment','center','FontWeight','bold','Value',1);
widget.params.spinner_NumElectrodes.Layout.Row = 2; widget.params.spinner_NumElectrodes.Layout.Column = 5;

widget.params.dropdown_ElectrodeSelector = uidropdown('Parent',widget.params.grid,'Items',{'Electrode1'},'Value','Electrode1');
widget.params.dropdown_ElectrodeSelector.Layout.Row = 3; widget.params.dropdown_ElectrodeSelector.Layout.Column = [2 5];

widget.params.divider1 = uilabel('Parent',widget.params.grid,'HorizontalAlignment','center','Text','______________________________','FontColor',[0.8 0.8 0.8]);
widget.params.divider1.Layout.Row = 4; widget.params.divider1.Layout.Column = [1 6];

widget.params.label_ElectrodeName = uilabel('Parent',widget.params.grid,'Text','Electrode name:');
widget.params.label_ElectrodeName.Layout.Row = 5; widget.params.label_ElectrodeName.Layout.Column = [2 5];

widget.params.radiogroup1 = uibuttongroup('Parent',widget.params.grid,'BorderType','none');
widget.params.radiogroup1.Layout.Row = [6 7]; widget.params.radiogroup1.Layout.Column = 2;
widget.params.radio_R = uiradiobutton('Parent',widget.params.radiogroup1,'Value',true,'Text','R',...
    'Position',[5,32,30,22]);
widget.params.radio_L = uiradiobutton('Parent',widget.params.radiogroup1,'Text','L',...
    'Position',[5,0,30,22]);

widget.params.radiogroup2 = uibuttongroup('Parent',widget.params.grid,'BorderType','none');
widget.params.radiogroup2.Layout.Row = [6 8]; widget.params.radiogroup2.Layout.Column = 3;
widget.params.radio_D = uiradiobutton('Parent',widget.params.radiogroup2,'Text','D','Value',true,...
    'Position',[5,64,30,22]);
widget.params.radio_S = uiradiobutton('Parent',widget.params.radiogroup2,'Text','S','Enable','off',...
    'Position',[5,32,30,22]);
widget.params.radio_G = uiradiobutton('Parent',widget.params.radiogroup2,'Text','G','Enable','off',...
    'Position',[5,0,30,22]);

widget.params.field_ElectrodeName = uieditfield('Parent',widget.params.grid,'Value',widget.params.dropdown_ElectrodeSelector.Value);
widget.params.field_ElectrodeName.Layout.Row = 6; widget.params.field_ElectrodeName.Layout.Column = [4 5];

widget.params.label_NameAcceptance = uilabel('Parent',widget.params.grid,'Text','[Name accepted status]','HorizontalAlignment','center','Visible','off');
widget.params.label_NameAcceptance.Layout.Row = 9; widget.params.label_NameAcceptance.Layout.Column = [2 5];

widget.params.divider2 = uilabel('Parent',widget.params.grid,'HorizontalAlignment','center','Text','______________________________','FontColor',[0.8 0.8 0.8]);
widget.params.divider2.Layout.Row = 10; widget.params.divider2.Layout.Column = [1 6];

widget.params.label_NumContacts = uilabel('Parent',widget.params.grid,'Text','Number of contacts');
widget.params.label_NumContacts.Layout.Row = 11; widget.params.label_NumContacts.Layout.Column = [2 4];

widget.params.field_NumContacts = uieditfield(widget.params.grid,'numeric','HorizontalAlignment','center','Limits',[0 Inf]);
widget.params.field_NumContacts.Layout.Row = 11; widget.params.field_NumContacts.Layout.Column = 5;

widget.params.label_ContactDistance = uilabel('Parent',widget.params.grid,'Text','Inter-contact distance (mm)');
widget.params.label_ContactDistance.Layout.Row = 12; widget.params.label_ContactDistance.Layout.Column = [2 4];

widget.params.field_ContactDistance = uieditfield(widget.params.grid,'numeric','HorizontalAlignment','center','Limits',[0 Inf]);
widget.params.field_ContactDistance.Layout.Row = 12; widget.params.field_ContactDistance.Layout.Column = 5;

widget.params.label_DeepestContact = uilabel('Parent',widget.params.grid,'Text','Deepest point coordinates (X,Y,Z):');
widget.params.label_DeepestContact.Layout.Row = 13; widget.params.label_DeepestContact.Layout.Column = [2 5];
widget.params.button_PickDeepest = uibutton('push','Parent',widget.params.grid,'Tag','Deepest','Text','Pick','FontWeight','bold');
widget.params.button_PickDeepest.Layout.Row = 14; widget.params.button_PickDeepest.Layout.Column = 2;
widget.params.field_XDeepest = uieditfield(widget.params.grid,'numeric','Limits',[0 Inf],'HorizontalAlignment','center');
widget.params.field_XDeepest.Layout.Row = 14; widget.params.field_XDeepest.Layout.Column = 3;
widget.params.field_YDeepest = uieditfield(widget.params.grid,'numeric','Limits',[0 Inf],'HorizontalAlignment','center');
widget.params.field_YDeepest.Layout.Row = 14; widget.params.field_YDeepest.Layout.Column = 4;
widget.params.field_ZDeepest = uieditfield(widget.params.grid,'numeric','Limits',[0 Inf],'HorizontalAlignment','center');
widget.params.field_ZDeepest.Layout.Row = 14; widget.params.field_ZDeepest.Layout.Column = 5;

widget.params.label_SecondContact = uilabel('Parent',widget.params.grid,'Text','Second point coordinates (X,Y,Z):');
widget.params.label_SecondContact.Layout.Row = 15; widget.params.label_SecondContact.Layout.Column = [2 5];
widget.params.button_PickSecond = uibutton('push','Parent',widget.params.grid,'Tag','Second','Text','Pick','FontWeight','bold');
widget.params.button_PickSecond.Layout.Row = 16; widget.params.button_PickSecond.Layout.Column = 2;
widget.params.field_XSecond = uieditfield(widget.params.grid,'numeric','Limits',[0 Inf],'HorizontalAlignment','center');
widget.params.field_XSecond.Layout.Row = 16; widget.params.field_XSecond.Layout.Column = 3;
widget.params.field_YSecond = uieditfield(widget.params.grid,'numeric','Limits',[0 Inf],'HorizontalAlignment','center');
widget.params.field_YSecond.Layout.Row = 16; widget.params.field_YSecond.Layout.Column = 4;
widget.params.field_ZSecond = uieditfield(widget.params.grid,'numeric','Limits',[0 Inf],'HorizontalAlignment','center');
widget.params.field_ZSecond.Layout.Row = 16; widget.params.field_ZSecond.Layout.Column = 5;
widget.params.checkbox_Snapping = uicheckbox('Parent',widget.params.grid,'Value',true,'Text','Enable snapping');
widget.params.checkbox_Snapping.Layout.Row = 17; widget.params.checkbox_Snapping.Layout.Column = [2 5];
widget.params.checkbox_LocalMax = uicheckbox('Parent',widget.params.grid,'Value',false,'Text','Find local maximum');
widget.params.checkbox_LocalMax.Layout.Row = 18; widget.params.checkbox_LocalMax.Layout.Column = [2 5];

widget.params.divider3 = uilabel('Parent',widget.params.grid,'HorizontalAlignment','center','Text','______________________________','FontColor',[0.8 0.8 0.8]);
widget.params.divider3.Layout.Row = 19; widget.params.divider3.Layout.Column = [1 6];
widget.params.button_estimate = uibutton('push','Parent',widget.params.grid,'Enable','off','BackgroundColor',[1,0.65,0],'Text','Estimate','HorizontalAlignment','center');
widget.params.button_estimate.Layout.Row = 20; widget.params.button_estimate.Layout.Column = [2 5];

% ---------------------------- Autos Save Panel ---------------------------
widget.autosave = uipanel('Parent',widget.fig,'Visible','off');
widget.autosave.UserData.filePath = [];
widget.autosave.UserData.overwrite = 'off';
    
    

end