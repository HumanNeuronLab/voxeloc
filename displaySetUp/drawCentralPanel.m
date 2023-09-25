function [widget,wip] = drawCentralPanel(widget)
%drawCentralPanel Summary of this function goes here
%   Detailed explanation goes here
%
% =========================================================================
% ========================== Slice viewer panel ===========================
% =========================================================================

scriptPath = fileparts(which('voxeloc.m'));


% ---- Display logo splashscreen whilst other panels set up graphically ---

pause(2);
wip = round(widget.fig.Position);


% ---------------------------- Create main tabs ---------------------------

widget.viewer.panel_CentralTabsMRI = uitabgroup('Parent',widget.fig,...
    'Position',round([(wip(3)-wip(4))/2,10,wip(4),wip(4)-20]));
widget.viewer.CT.tab = uitab('Parent',widget.viewer.panel_CentralTabsMRI,...
    'Title','[select CT NIfTI file]','Tag','CT','BackgroundColor',[1 1 1]);
widget.viewer.T1.tab = uitab('Parent',widget.viewer.panel_CentralTabsMRI,...
    'Title','[select Anatomical NIfTI file (optional)]','Tag','T1');
widget.viewer.oblique.tab = uitab('Parent',widget.viewer.panel_CentralTabsMRI,...
    'Title','Oblique Slice','Tag','oblique');
widget.viewer.projectParams.tab = uitab('Parent',widget.viewer.panel_CentralTabsMRI,...
    'Title','Project Parameters','Tag','project');
widget.glassbrain = uipanel('Parent',widget.fig,'Visible','off');
widget = logoDisplay(widget,scriptPath);
pause(2);
%widget.viewer.logo.panel.Visible = 'off';


% ----------------------------- CT Tab Set-Up -----------------------------

widget = buildVolViewer(widget,'CT');


% ----------------------------- T1 Tab Set-Up -----------------------------

widget = buildVolViewer(widget,'T1');


% ------------------------ GLASSBRAIN data Set-Up -------------------------

widget.glassbrain.UserData.ColorList = [[1 0 0];[1 135/255 0];[1 211/255 0];...
    [222/255 1 10/255];[161/255 1 10/255];[10/255 1 153/255];...
    [10/255 239/255 1];[20/255 125/255 245/255];[88/255 10/255 1];...
    [190/255 10/255 1];[1 153/255 153/255];[216/255 1 153/255];...
    [199/255 173/255 1];[157/255 201/255 251/255];[241/255 1 153/255];...
    [173/255 250/255 1];[173/255 1 221/255];[1 238/255 153/255];...
    [1 207/255 153/255];[233/255 173/255 1];[152/255 245/255 225/255];...
    [251/255 248/255 204/255];[247/255 37/255 133/255];[4/255 243/255 63/255]];


% ----------------------- Project Prameters Set-Up ------------------------

widget.viewer.projectParams.gridInner = uigridlayout('Parent',widget.viewer.projectParams.tab,...
    'ColumnWidth',{150,200,22,100,'1x'},'RowHeight',{22,22,22,22,22,22,22,22,22,22,'1x',35},...
    'RowSpacing',15,'Padding',[20 20 20 50],'Scrollable','on');

widget.viewer.projectParams.label_patientDir = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Patient folder:','FontWeight','bold');
widget.viewer.projectParams.lamp_patientDir = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[1 0 0]);
widget.viewer.projectParams.lamp_patientDir.Layout.Row = 1; widget.viewer.projectParams.lamp_patientDir.Layout.Column = 3;
widget.viewer.projectParams.button_patientDir = uibutton('Parent',widget.viewer.projectParams.gridInner,'Text','Select folder','BackgroundColor',[1,0.65,0],'Tag','DIR');
widget.viewer.projectParams.field_patientDir = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[Folder path]','FontColor',[0.6 0.6 0.6]);

widget.viewer.projectParams.label_autosaveFile = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Autosave file:','FontWeight','bold');
widget.viewer.projectParams.field_autosaveFile = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[No autosave file linked yet]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_autosaveFile = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[1 0.65 0]);
widget.viewer.projectParams.field_autosavePath = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.field_autosavePath.Layout.Column = 5;



widget.viewer.projectParams.label_patientID = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Patient ID:','FontWeight','bold');
widget.viewer.projectParams.field_patientID = uieditfield('Parent',widget.viewer.projectParams.gridInner,'Placeholder','[Patient_ID]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_patientID = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[1 0 0]);

widget.viewer.projectParams.label_ctFile = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','CT file:','FontWeight','bold');
widget.viewer.projectParams.label_ctFile.Layout.Row = 4;
widget.viewer.projectParams.label_ctFile.Layout.Column = 1;
widget.viewer.projectParams.field_ctFile = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[No CT file loaded yet]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_ctFile = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[1 0 0]);
widget.viewer.projectParams.button_ctFile = uibutton('Parent',widget.viewer.projectParams.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','CT');
widget.viewer.projectParams.field_ctPath = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);

widget.viewer.projectParams.label_t1File = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','T1 file:','FontWeight','bold');
widget.viewer.projectParams.field_t1File = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[No T1 file loaded yet]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_t1File = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[0.94 0.94 0.94]);
widget.viewer.projectParams.button_t1File = uibutton('Parent',widget.viewer.projectParams.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','T1');
widget.viewer.projectParams.field_t1Path = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);

widget.viewer.projectParams.label_parcFile = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Parcellation file:','FontWeight','bold');
widget.viewer.projectParams.field_parcFile = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[No parcellation file loaded yet]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_parcFile = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[0.94 0.94 0.94]);
widget.viewer.projectParams.button_parcFile = uibutton('Parent',widget.viewer.projectParams.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','PARC');
widget.viewer.projectParams.field_parcPath = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);

widget.viewer.projectParams.label_electrodes = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Number of electrodes:','FontWeight','bold');
widget.viewer.projectParams.label_electrodes.Layout.Row = 7;
widget.viewer.projectParams.label_electrodes.Layout.Column = 1;
widget.viewer.projectParams.field_electrodes = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Completed: 0 of 0','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_electrodes = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[1 0 0]);

widget.viewer.projectParams.label_instLogo = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Institution Logo:','FontWeight','bold');
widget.viewer.projectParams.label_instLogo.Layout.Row = 8;
widget.viewer.projectParams.label_instLogo.Layout.Column = 1;
widget.viewer.projectParams.field_instLogo = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[No logo loaded yet]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_instLogo = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[0.94 0.94 0.94]);
widget.viewer.projectParams.image_instLogo = uiimage('Parent',widget.viewer.projectParams.gridInner,'ImageSource','erwin_logo.png','HorizontalAlignment','left','Visible','off');
widget.viewer.projectParams.image_instLogo.Layout.Row = widget.viewer.projectParams.label_instLogo.Layout.Row;
widget.viewer.projectParams.image_instLogo.Layout.Column = 2;
widget.viewer.projectParams.button_instLogo = uibutton('Parent',widget.viewer.projectParams.gridInner,'Text','Load Image','BackgroundColor',[1,0.65,0]);

widget.viewer.projectParams.label_userID = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','User name:','FontWeight','bold');
widget.viewer.projectParams.label_userID.Layout.Row = 9;
widget.viewer.projectParams.label_userID.Layout.Column = 1;
widget.viewer.projectParams.field_userID = uieditfield('Parent',widget.viewer.projectParams.gridInner,'Placeholder','[User name]','FontColor',[0.6 0.6 0.6]);
widget.viewer.projectParams.lamp_userID = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[1 0 0]);

widget.viewer.projectParams.label_forceSave = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','Last autosave:','FontWeight','bold');
widget.viewer.projectParams.label_forceSave.Layout.Row = 10;
widget.viewer.projectParams.label_forceSave.Layout.Column = 1;
widget.viewer.projectParams.field_forceSave = uilabel('Parent',widget.viewer.projectParams.gridInner,'Text','[No autosave yet]','FontColor',[0.6 0.6 0.6]); % datestr(A.date,'HH:MM dd/mmm/yyyy')
widget.viewer.projectParams.lamp_forceSave = uilamp('Parent',widget.viewer.projectParams.gridInner,'Color',[0.94 0.94 0.94]);
widget.viewer.projectParams.button_forceSave = uibutton('Parent',widget.viewer.projectParams.gridInner,'Text','Force Save','BackgroundColor',[0,0.65,1]);

progPath = fileparts(which('voxeloc.m'));
widget.viewer.projectParams.image_currentVersion = uiimage('Parent',widget.viewer.projectParams.gridInner,'ImageSource',[progPath filesep 'assets' filesep 'Voxeloc_version.png'],'HorizontalAlignment','right');
widget.viewer.projectParams.image_currentVersion.Layout.Row = numel(widget.viewer.projectParams.gridInner.RowHeight);
widget.viewer.projectParams.image_currentVersion.Layout.Column = numel(widget.viewer.projectParams.gridInner.ColumnWidth);


% ------------------------- Oblique Slice Set-Up --------------------------

widget.viewer.oblique.button_niftiCT = uibutton('Parent',widget.viewer.oblique.tab,'Text','Select CT file',...
    'Position',[15,widget.viewer.oblique.tab.Position(4)-37,100,22],'BackgroundColor',[1,0.65,0],...
    'Tag','CT');
widget.viewer.oblique.label_niftiCT = uilabel('Parent',widget.viewer.oblique.tab,'Text','[Select CT NIfTI file]',...
    'Position',[widget.viewer.oblique.button_niftiCT.Position(1)+widget.viewer.oblique.button_niftiCT.Position(3)+15,widget.viewer.oblique.button_niftiCT.Position(2),widget.viewer.oblique.tab.Position(3)-120,22],...
    'FontColor',[0.5 0.5 0.5],'Tag','CT');
widget.viewer.oblique.button_niftiT1 = uibutton('Parent',widget.viewer.oblique.tab,'Text','Select T1 file',...
    'Position',[15,widget.viewer.oblique.tab.Position(4)-67,100,22],'BackgroundColor',[1,0.65,0],...
    'Tag','T1');
widget.viewer.oblique.label_niftiT1 = uilabel('Parent',widget.viewer.oblique.tab,'Text','[Select T1 NIfTI file]',...
    'Position',[widget.viewer.oblique.button_niftiT1.Position(1)+widget.viewer.oblique.button_niftiT1.Position(3)+15,widget.viewer.oblique.button_niftiT1.Position(2),widget.viewer.oblique.tab.Position(3)-120,22],...
    'FontColor',[0.5 0.5 0.5],'Tag','T1');
widget.viewer.oblique.button_niftiParc = uibutton('Parent',widget.viewer.oblique.tab,'Text','Select Parc. file',...
    'Position',[15,widget.viewer.oblique.tab.Position(4)-97,100,22],'BackgroundColor',[1,0.65,0],...
    'Tag','PARC');
widget.viewer.oblique.label_niftiParc = uilabel('Parent',widget.viewer.oblique.tab,'Text','[Select Parcellation NIfTI file]',...
    'Position',[widget.viewer.oblique.button_niftiParc.Position(1)+widget.viewer.oblique.button_niftiParc.Position(3)+15,widget.viewer.oblique.button_niftiParc.Position(2),widget.viewer.oblique.tab.Position(3)-120,22],...
    'FontColor',[0.5 0.5 0.5],'Tag','PARC');
widget.viewer.oblique.button_reslice = uibutton('Parent',widget.viewer.oblique.tab,'Text','Re-slice',...
    'Position',[15,widget.viewer.oblique.tab.Position(4)-127,100,22],'BackgroundColor',[0.4 0.75 1],...
    'Tag','SLICE');
widget.viewer.oblique.panel = uipanel('Parent',widget.viewer.oblique.tab,...
    'Position',[10 10 widget.viewer.oblique.tab.Position(3)-20 widget.viewer.oblique.tab.Position(4)-150],...
    'BackgroundColor',[0.3 0.3 0.3]);%,'Visible','off');%,'Enable','off');

scFactor = 0.4;
widget.viewer.oblique.ax_ctVert = axes('Parent',widget.viewer.oblique.panel,...
    'XLim',[1 256],'YLim',[1 256],'YDir','reverse','Color',[0.3 0.3 0.3],...
    'XColor',[1 0.65 0],'YColor',[1 0.65 0],'LineWidth',2,...
    'XTick',[],'YTick',[],'Box','on','BoxStyle','full','Units','pixels',...
    'Position',round([10 (widget.viewer.oblique.panel.Position(4)*scFactor)+5 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15]));
widget.viewer.oblique.label_noSliceCTVert = uilabel('Parent',widget.viewer.oblique.panel,'Text','[No oblique slice for current electrode]',...
    'Position',widget.viewer.oblique.ax_ctVert.Position,...
    'FontColor',[1 0 0],'HorizontalAlignment','center','VerticalAlignment','center');
widget.viewer.oblique.ax_t1Vert = axes('Parent',widget.viewer.oblique.panel,...
    'XLim',[1 256],'YLim',[1 256],'YDir','reverse','Color',[0.3 0.3 0.3],...
    'XColor',[1 0.65 0],'YColor',[1 0.65 0],'LineWidth',2,...
    'XTick',[],'YTick',[],'Box','on','BoxStyle','full','Units','pixels',...
    'Position',round([widget.viewer.oblique.ax_ctVert.Position(1)+widget.viewer.oblique.ax_ctVert.Position(4)+10 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)+5 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15]));
widget.viewer.oblique.label_noSliceT1Vert = uilabel('Parent',widget.viewer.oblique.panel,'Text','[No oblique slice for current electrode]',...
    'Position',widget.viewer.oblique.ax_t1Vert.Position,...
    'FontColor',[1 0 0],'HorizontalAlignment','center','VerticalAlignment','center');
widget.viewer.oblique.ax_ctHor = axes('Parent',widget.viewer.oblique.panel,...
    'XLim',[1 256],'YLim',[1 256],'YDir','reverse','Color',[0.3 0.3 0.3],...
    'XColor',[0 0.65 1],'YColor',[0 0.65 1],'LineWidth',2,...
    'XTick',[],'YTick',[],'Box','on','BoxStyle','full','Units','pixels',...
    'Position',round([10 10 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15]));
widget.viewer.oblique.label_noSliceCTHor = uilabel('Parent',widget.viewer.oblique.panel,'Text','[No oblique slice for current electrode]',...
    'Position',widget.viewer.oblique.ax_ctHor.Position,...
    'FontColor',[1 0 0],'HorizontalAlignment','center','VerticalAlignment','center');
widget.viewer.oblique.ax_t1Hor = axes('Parent',widget.viewer.oblique.panel,...
    'XLim',[1 256],'YLim',[1 256],'YDir','reverse','Color',[0.3 0.3 0.3],...
    'XColor',[0 0.65 1],'YColor',[0 0.65 1],'LineWidth',2,...
    'XTick',[],'YTick',[],'Box','on','BoxStyle','full','Units','pixels',...
    'Position',round([widget.viewer.oblique.ax_ctVert.Position(1)+widget.viewer.oblique.ax_ctVert.Position(4)+10 ...
    10 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15 ...
    (widget.viewer.oblique.panel.Position(4)*scFactor)-15]));
widget.viewer.oblique.label_noSliceT1Hor = uilabel('Parent',widget.viewer.oblique.panel,'Text','[No oblique slice for current electrode]',...
    'Position',widget.viewer.oblique.ax_t1Hor.Position,...
    'FontColor',[1 0 0],'HorizontalAlignment','center','VerticalAlignment','center');
widget.viewer.oblique.label_elecName = uilabel('Parent',widget.viewer.oblique.panel,'Text','Electrode: ',...
    'Position',[0 ...
        widget.viewer.oblique.panel.Position(4)*0.9+45 ...    %widget.viewer.oblique.ax_t1Vert.Position(2)+widget.viewer.oblique.ax_t1Vert.Position(4)+2 ...
        widget.viewer.oblique.ax_t1Vert.Position(1)+widget.viewer.oblique.ax_t1Vert.Position(3) ...
        widget.viewer.oblique.panel.Position(4)*0.1-45],...
    'FontColor',[0.94 0.94 0.94],'HorizontalAlignment','center','VerticalAlignment','center',...
    'FontSize',26,'Visible','on');
remainingSpace = widget.viewer.oblique.label_elecName.Position(2)-(widget.viewer.oblique.ax_ctVert.Position(2)+widget.viewer.oblique.ax_ctVert.Position(4));
widget.viewer.oblique.slider_opacity = uislider('Parent',widget.viewer.oblique.panel,...
    'MajorTicks',[],'MinorTicks',[],'Limits',[5 100],'Position',round([15 ...
    widget.viewer.oblique.label_elecName.Position(2)-remainingSpace+30 ...
    widget.viewer.oblique.ax_t1Vert.Position(2)+widget.viewer.oblique.ax_t1Vert.Position(4)-15 ...
    3]),'Value',35,'MajorTickLabels',{});
widget.viewer.oblique.button_applyOpacity = uibutton('Parent',widget.viewer.oblique.panel,'Text','Apply',...
    'Position',[15 ...
    widget.viewer.oblique.slider_opacity.Position(2)+10 ...
    50 22],'BackgroundColor',[0.94 0.94 0.94],...
    'Tag','ApplyOpacity','Enable','off');
widget.viewer.oblique.label_opacity = uilabel('Parent',widget.viewer.oblique.panel,...
    'Text',['Parcellation opacity: ' num2str(widget.viewer.oblique.slider_opacity.Value) '%'],'Position',[80 ...
    widget.viewer.oblique.slider_opacity.Position(2)+10 ...
    widget.viewer.oblique.slider_opacity.Position(3) ...
    22],'FontColor',[0.94 0.94 0.94]);
widget.viewer.oblique.checkbox_segCT = uicheckbox('Parent',widget.viewer.oblique.panel,'Value',false,...
    'Text','Overlay Parcellation on CT','Position',...
    [widget.viewer.oblique.ax_ctVert.Position(1),...
    widget.viewer.oblique.label_opacity.Position(2)+widget.viewer.oblique.label_opacity.Position(4)+15,...
    widget.viewer.oblique.ax_ctVert.Position(3),22],'FontColor',[0.94 0.94 0.94]);
widget.viewer.oblique.checkbox_segT1 = uicheckbox('Parent',widget.viewer.oblique.panel,'Value',true,...
    'Text','Overlay Parcellation on T1','Position',...
    [widget.viewer.oblique.ax_t1Vert.Position(1),...
    widget.viewer.oblique.label_opacity.Position(2)+widget.viewer.oblique.label_opacity.Position(4)+15,...
    widget.viewer.oblique.ax_ctVert.Position(3),22],'FontColor',[0.94 0.94 0.94]);

widget.viewer.oblique.table = uitable('Parent',widget.viewer.oblique.panel,...
    'RowName',[],'ColumnName',[],'RowStriping','off','Position',...
    [widget.viewer.oblique.ax_t1Vert.Position(1)+widget.viewer.oblique.ax_t1Vert.Position(3)+10 ...
    50 ...
    widget.viewer.oblique.panel.Position(3)-(widget.viewer.oblique.ax_t1Vert.Position(1)+widget.viewer.oblique.ax_t1Vert.Position(3))-20 ...
    widget.viewer.oblique.ax_t1Vert.Position(2)+(widget.viewer.oblique.ax_t1Vert.Position(4)/2)],...
    'BackgroundColor',[0.3 0.3 0.3],'FontSize',12,'Visible','off');
widget.viewer.oblique.button_exportPDF = uibutton('Parent',widget.viewer.oblique.panel,'Text','Export PDF',...
    'Position',[widget.viewer.oblique.panel.Position(3)-110 ...
    10 100 30],'BackgroundColor',[0.4 0.75 1],...
    'Tag','ExportPDF','Enable','on');

colormap(widget.viewer.oblique.ax_ctVert,'bone');
colormap(widget.viewer.oblique.ax_ctHor,'bone');
colormap(widget.viewer.oblique.ax_t1Vert,'bone');
colormap(widget.viewer.oblique.ax_t1Hor,'bone');
fsParcPath = which('fs_parcellation.txt');
TEXT = readtable(fsParcPath);
TEXT = TEXT(:,1:6);
cmap(:,1) = TEXT{:,1};
cmap(:,2) = TEXT{:,3};
cmap(:,3) = TEXT{:,4};
cmap(:,4) = TEXT{:,5};
cmap(:,2:4) = cmap(:,2:4)./256;
brainRegions(:,1) = TEXT(:,1);
brainRegions(:,2) = TEXT(:,2);
widget.glassbrain.UserData.cmap = cmap;
widget.glassbrain.UserData.brainRegions = brainRegions;
widget = build3Dhead(widget);


% =========================================================================
% ===================== Splashscreen Set-Up function ======================
% =========================================================================

function widget = buildVolViewer(widget,currVol)

    widget.viewer.(currVol).tab.BackgroundColor = [0.94 0.94 0.94];
    widget.viewer.(currVol).grid = uigridlayout('Parent',widget.viewer.(currVol).tab,'ColumnWidth',{20,22,'1x',22,'1x'},'RowHeight',{20,'1x',22,22,10,'1x',22,22,10},'Padding',[10 10 10 10]);
    
    widget.viewer.(currVol).ax_sliceView1 = uiaxes('Parent',widget.viewer.(currVol).grid,...
        'Units','normalized','XTick',[],'YTick',[],'Tag','coronal ax','Color',[0.3,0.3,0.3],'YDir','reverse');%'XAxisLocation','top',
%     widget.viewer.(currVol).ax_sliceView1.XLabel.String = 'X →';
%     widget.viewer.(currVol).ax_sliceView1.YLabel.String = '← Y';
    widget.viewer.(currVol).label_coronalXAxis = uilabel('Parent',widget.viewer.(currVol).grid,'Text','X →','FontColor',[0 0 0],'Visible','on','HorizontalAlignment','center','VerticalAlignment','bottom');
    widget.viewer.(currVol).label_coronalXAxis.Layout.Row = 1; widget.viewer.(currVol).label_coronalXAxis.Layout.Column = [2 3];
    widget.viewer.(currVol).label_coronalYAxis = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Y\newline↓','FontColor',[0 0 0],'Visible','on','HorizontalAlignment','center','VerticalAlignment','center','Interpreter','tex');
    widget.viewer.(currVol).label_coronalYAxis.Layout.Row = [2 5]; widget.viewer.(currVol).label_coronalYAxis.Layout.Column = 1;
    widget.viewer.(currVol).ax_sliceView1.Layout.Row = [2 5]; widget.viewer.(currVol).ax_sliceView1.Layout.Column = [2 3];
    widget.viewer.(currVol).label_coronalSlice = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Coronal Slice','FontColor',[1 1 1],'Visible','on');
    widget.viewer.(currVol).label_coronalSlice.Layout.Row = 3; widget.viewer.(currVol).label_coronalSlice.Layout.Column = 3;
    widget.viewer.(currVol).label_coronalVI = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Voxel density','FontColor',[1 1 1],'Visible','on');
    widget.viewer.(currVol).label_coronalVI.Layout.Row = 4; widget.viewer.(currVol).label_coronalVI.Layout.Column = 3;
    
    widget.viewer.(currVol).ax_sliceView2 = uiaxes('Parent',widget.viewer.(currVol).grid,...
        'Units','normalized','XTick',[],'YTick',[],'Tag','sagittal ax','Color',[0.3,0.3,0.3],'XDir','reverse','YDir','reverse');%'XAxisLocation','top',
%     widget.viewer.(currVol).ax_sliceView2.XLabel.String = '← Z';
%     widget.viewer.(currVol).ax_sliceView2.YLabel.String = ' ';
    widget.viewer.(currVol).label_sagittalXAxis = uilabel('Parent',widget.viewer.(currVol).grid,'Text','← Z','FontColor',[0 0 0],'Visible','on','HorizontalAlignment','center','VerticalAlignment','bottom');
    widget.viewer.(currVol).label_sagittalXAxis.Layout.Row = 1; widget.viewer.(currVol).label_sagittalXAxis.Layout.Column = [4 5];
    widget.viewer.(currVol).ax_sliceView2.Layout.Row = [2 5]; widget.viewer.(currVol).ax_sliceView2.Layout.Column = [4 5];
    widget.viewer.(currVol).label_sagittalSlice = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Sagittal Slice','FontColor',[1 1 1],'Visible','on');
    widget.viewer.(currVol).label_sagittalSlice.Layout.Row = 3; widget.viewer.(currVol).label_sagittalSlice.Layout.Column = 5;
    widget.viewer.(currVol).label_sagittalVI = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Voxel density','FontColor',[1 1 1],'Visible','on');
    widget.viewer.(currVol).label_sagittalVI.Layout.Row = 4; widget.viewer.(currVol).label_sagittalVI.Layout.Column = 5;
    
    widget.viewer.(currVol).ax_sliceView3 = uiaxes('Parent',widget.viewer.(currVol).grid,...
        'Units','normalized','XTick',[],'YTick',[],'Tag','axial ax','Color',[0.3,0.3,0.3],'YDir','reverse');%'XAxisLocation','top',
%     widget.viewer.(currVol).ax_sliceView3.XLabel.String = ' ';
%     widget.viewer.(currVol).ax_sliceView3.YLabel.String = 'Z →';
    widget.viewer.(currVol).label_axialYAxis = uilabel('Parent',widget.viewer.(currVol).grid,'Text','↑\newlineZ','FontColor',[0 0 0],'Visible','on','HorizontalAlignment','center','VerticalAlignment','center','Interpreter','tex');
    widget.viewer.(currVol).label_axialYAxis.Layout.Row = [6 9]; widget.viewer.(currVol).label_axialYAxis.Layout.Column = 1;
    widget.viewer.(currVol).ax_sliceView3.Layout.Row = [6 9]; widget.viewer.(currVol).ax_sliceView3.Layout.Column = [2 3];
    widget.viewer.(currVol).label_axialSlice = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Axial Slice','FontColor',[1 1 1],'Visible','on');
    widget.viewer.(currVol).label_axialSlice.Layout.Row = 7; widget.viewer.(currVol).label_axialSlice.Layout.Column = 3;
    widget.viewer.(currVol).label_axialVI = uilabel('Parent',widget.viewer.(currVol).grid,'Text','Voxel density','FontColor',[1 1 1],'Visible','on');
    widget.viewer.(currVol).label_axialVI.Layout.Row = 8; widget.viewer.(currVol).label_axialVI.Layout.Column = 3;
    
    % axis(widget.viewer.(currVol).ax_sliceView1,'equal','square');
    % axis(widget.viewer.(currVol).ax_sliceView2,'equal','square');
    % axis(widget.viewer.(currVol).ax_sliceView3,'equal','square');
    
    widget.viewer.(currVol).panel_sliceView4 = uigridlayout('Parent',widget.viewer.(currVol).grid,'ColumnWidth',{20,50,20,'1X',20,80},'RowHeight',{30,22,22,22,22,30,22,'1X',22,30},...
        'Tag','slice params panel 1','Scrollable','on');
    widget.viewer.(currVol).panel_sliceView4.Layout.Row = [6 9]; widget.viewer.(currVol).panel_sliceView4.Layout.Column = [4 5];
    widget.viewer.(currVol).button_selectNifti = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Select NIfTI file','BackgroundColor',[1,0.65,0]);
    widget.viewer.(currVol).button_selectNifti.Layout.Row = 1; widget.viewer.(currVol).button_selectNifti.Layout.Column = [1 3];
    widget.viewer.(currVol).label_selectNifti = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','[Select NIfTI file]');
    widget.viewer.(currVol).label_selectNifti.Layout.Row = 1; widget.viewer.(currVol).label_selectNifti.Layout.Column = [4 5];
    widget.viewer.(currVol).button_resetView = uibutton('Parent', widget.viewer.(currVol).panel_sliceView4,'Text','Reset View','Enable','off','BackgroundColor',[0.5,0.5,0.5],'FontColor',[0.8,0.8,0.8]);
    widget.viewer.(currVol).button_resetView.Layout.Row = 1; widget.viewer.(currVol).button_resetView.Layout.Column = 6;
    
    widget.viewer.(currVol).label_voxelIntensity = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Voxel intensity:','Tag','Voxel Intensity');
    widget.viewer.(currVol).label_voxelIntensity.Layout.Row = 2; widget.viewer.(currVol).label_voxelIntensity.Layout.Column = [1 6];
    
    widget.viewer.(currVol).label_Xvalue = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','X:');
    widget.viewer.(currVol).label_Xvalue.Layout.Row = 3; widget.viewer.(currVol).label_Xvalue.Layout.Column = 1;
    widget.viewer.(currVol).label_Yvalue = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Y:');
    widget.viewer.(currVol).label_Yvalue.Layout.Row = 4; widget.viewer.(currVol).label_Yvalue.Layout.Column = 1;
    widget.viewer.(currVol).label_Zvalue = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Z:');
    widget.viewer.(currVol).label_Zvalue.Layout.Row = 5; widget.viewer.(currVol).label_Zvalue.Layout.Column = 1;
    
    widget.viewer.(currVol).field_Xvalue = uieditfield('numeric','Parent',widget.viewer.(currVol).panel_sliceView4,'HorizontalAlignment','center','Tag','X field','Enable','off');
    widget.viewer.(currVol).field_Xvalue.Layout.Row = 3; widget.viewer.(currVol).field_Xvalue.Layout.Column = 2;
    widget.viewer.(currVol).field_Yvalue = uieditfield('numeric','Parent',widget.viewer.(currVol).panel_sliceView4,'HorizontalAlignment','center','Tag','Y field','Enable','off');
    widget.viewer.(currVol).field_Yvalue.Layout.Row = 4; widget.viewer.(currVol).field_Yvalue.Layout.Column = 2;
    widget.viewer.(currVol).field_Zvalue = uieditfield('numeric','Parent',widget.viewer.(currVol).panel_sliceView4,'HorizontalAlignment','center','Tag','Z field','Enable','off');
    widget.viewer.(currVol).field_Zvalue.Layout.Row = 5; widget.viewer.(currVol).field_Zvalue.Layout.Column = 2;
    
    widget.viewer.(currVol).button_smallerX = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','<','Tag','X','Enable','off');
    widget.viewer.(currVol).button_smallerX.Layout.Row = 3; widget.viewer.(currVol).button_smallerX.Layout.Column = 3;
    widget.viewer.(currVol).button_smallerY = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','<','Tag','Y','Enable','off');
    widget.viewer.(currVol).button_smallerY.Layout.Row = 4; widget.viewer.(currVol).button_smallerY.Layout.Column = 3;
    widget.viewer.(currVol).button_smallerZ = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','<','Tag','Z','Enable','off');
    widget.viewer.(currVol).button_smallerZ.Layout.Row = 5; widget.viewer.(currVol).button_smallerZ.Layout.Column = 3;
    
    widget.viewer.(currVol).slider_X = uislider('Parent',widget.viewer.(currVol).panel_sliceView4,'MajorTicks',[],'MinorTicks',[],'Tag','X slider','Enable','off');
    widget.viewer.(currVol).slider_X.Layout.Row = 3; widget.viewer.(currVol).slider_X.Layout.Column = 4;
    widget.viewer.(currVol).slider_Y = uislider('Parent',widget.viewer.(currVol).panel_sliceView4,'MajorTicks',[],'MinorTicks',[],'Tag','Y slider','Enable','off');
    widget.viewer.(currVol).slider_Y.Layout.Row = 4; widget.viewer.(currVol).slider_Y.Layout.Column = 4;
    widget.viewer.(currVol).slider_Z = uislider('Parent',widget.viewer.(currVol).panel_sliceView4,'MajorTicks',[],'MinorTicks',[],'Tag','Z slider','Enable','off');
    widget.viewer.(currVol).slider_Z.Layout.Row = 5; widget.viewer.(currVol).slider_Z.Layout.Column = 4;
    
    widget.viewer.(currVol).button_greaterX = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','>','Tag','X','Enable','off');
    widget.viewer.(currVol).button_greaterX.Layout.Row = 3; widget.viewer.(currVol).button_greaterX.Layout.Column = 5;
    widget.viewer.(currVol).button_greaterY = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','>','Tag','Y','Enable','off');
    widget.viewer.(currVol).button_greaterY.Layout.Row = 4; widget.viewer.(currVol).button_greaterY.Layout.Column = 5;
    widget.viewer.(currVol).button_greaterZ = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','>','Tag','Z','Enable','off');
    widget.viewer.(currVol).button_greaterZ.Layout.Row = 5; widget.viewer.(currVol).button_greaterZ.Layout.Column = 5;
    
    if isequal(currVol,'CT')
        widget.viewer.(currVol).label_contacts = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Contacts: ','Tag','Contact label','Visible','off');
        widget.viewer.(currVol).label_contacts.Layout.Row = 7; widget.viewer.(currVol).label_contacts.Layout.Column = [1 5];
        widget.viewer.(currVol).slider_contacts = uislider('Parent',widget.viewer.(currVol).panel_sliceView4,'MajorTicks',[],'MinorTicks',[],'Visible','off','Tag','Contact slider');
        widget.viewer.(currVol).slider_contacts.Layout.Row = 8; widget.viewer.(currVol).slider_contacts.Layout.Column = [3 5];
        
        widget.viewer.(currVol).button_correctContacts = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Correct','Enable','off','Visible','off');
        widget.viewer.(currVol).button_correctContacts.Layout.Row = 7; widget.viewer.(currVol).button_correctContacts.Layout.Column = 6;
        
        widget.viewer.(currVol).divider_centralPanel = uilabel('Parent',widget.viewer.(currVol).panel_sliceView4,'HorizontalAlignment','center','Text','___________________________________');
        widget.viewer.(currVol).divider_centralPanel.Layout.Row = 9; widget.viewer.(currVol).divider_centralPanel.Layout.Column = [1 6];
        widget.viewer.(currVol).button_load = uibutton('Parent',widget.viewer.(currVol).panel_sliceView4,'Text','Load Voxeloc file','Enable','off');
        widget.viewer.(currVol).button_load.Layout.Row = 10; widget.viewer.(currVol).button_load.Layout.Column = [1 3];
    end
    
    widget.viewer.(currVol).transform = uipanel('Parent',widget.fig,'Visible','off');
    widget.viewer.(currVol).transform.UserData.permutations = 0;
    widget.viewer.(currVol).transform.UserData.rotations = 0;
    widget.viewer.(currVol).transform.UserData.action = 'none';
    
    widget.viewer.(currVol).ax1_toolbar = axtoolbar(widget.viewer.(currVol).ax_sliceView1,...
            {'pan','zoomin','zoomout','restoreview'});
    widget.viewer.(currVol).ax2_toolbar = axtoolbar(widget.viewer.(currVol).ax_sliceView2,...
            {'pan','zoomin','zoomout','restoreview'});
    widget.viewer.(currVol).ax3_toolbar = axtoolbar(widget.viewer.(currVol).ax_sliceView3,...
            {'pan','zoomin','zoomout','restoreview'});
end

function widget = logoDisplay(widget,scriptPath)

    logopath1 = [scriptPath filesep 'assets' filesep 'erwin_logo.png'];
    widget.viewer.logo.panel = uipanel('Parent',widget.fig,...
        'Position',[0,0,1922,1082],...
        'BackgroundColor',[0.37 0.37 0.37]);
    widget.viewer.logo.voxeloc = uiimage('Parent',widget.viewer.logo.panel,'ImageSource',logopath1,...
        'ScaleMethod','fit','Position',round([widget.root.monitorSize(3)/2-300 widget.root.monitorSize(4)/2-200 600 400]));
    logoPath2 = [scriptPath filesep 'assets' filesep 'UNIGE_logo.png'];
    widget.viewer.logo.unige = uiimage('Parent',widget.viewer.logo.panel,'ImageSource',logoPath2,...
        'Position',[widget.root.monitorSize(3)/2-100 20 200 200]);
    
%     logoPath2 = [scriptPath filesep 'assets' filesep 'loading.gif'];
%     widget.viewer.logo.unige2 = uiimage('Parent',widget.viewer.logo.panel,'ImageSource',logoPath2,...
%         'Position',[widget.fig.Position(3)/2-200 widget.fig.Position(4)/2-300 400 200]);
end

function widget = build3Dhead(widget)
    ct = zeros(256,256,256);
    widget.viewer.oblique.head3D.panel = uipanel('Parent',widget.viewer.oblique.panel,...
        'Position',[widget.viewer.oblique.ax_t1Vert.Position(1)+widget.viewer.oblique.ax_t1Vert.Position(3)+10 ...
        widget.viewer.oblique.ax_ctVert.Position(2)+(widget.viewer.oblique.ax_ctVert.Position(4)/2)+15 ...
        widget.viewer.oblique.panel.Position(3)-(widget.viewer.oblique.ax_t1Vert.Position(1)+widget.viewer.oblique.ax_t1Vert.Position(3)+10)...
        widget.viewer.oblique.panel.Position(4)-(widget.viewer.oblique.ax_t1Vert.Position(2)+(widget.viewer.oblique.ax_t1Vert.Position(4)/2)+15)],...
        'BackgroundColor',[0.3 0.3 0.3],'BorderType','none');
%         [0 ...
%         widget.viewer.oblique.ax_t1Vert.Position(2)+widget.viewer.oblique.ax_t1Vert.Position(4)+2 ...
%         widget.viewer.oblique.ax_t1Vert.Position(1)+widget.viewer.oblique.ax_t1Vert.Position(3) ...
%         widget.viewer.oblique.panel.Position(4)-(widget.viewer.oblique.ax_t1Vert.Position(2)+widget.viewer.oblique.ax_t1Vert.Position(4))],...
        
    widget.viewer.oblique.head3D.headPath = which('fmh.mat');
    widget.viewer.oblique.head3D.fmh = load(widget.viewer.oblique.head3D.headPath);
    widget.viewer.oblique.head3D.fmh = widget.viewer.oblique.head3D.fmh.fmh;
    widget.viewer.oblique.head3D.ax = axes('Parent',widget.viewer.oblique.head3D.panel,...
        'Color',widget.viewer.oblique.panel.BackgroundColor,'Units','normalized','Position',[0 0 1 1]);
    widget.viewer.oblique.head3D.HGrot = hgtransform(widget.viewer.oblique.head3D.ax);
    widget.viewer.oblique.head3D.HG1 = hgtransform(widget.viewer.oblique.head3D.HGrot);
    widget.viewer.oblique.head3D.HG2 = hgtransform(widget.viewer.oblique.head3D.HG1);
    widget.viewer.oblique.head3D.patch_fmh = patch(widget.viewer.oblique.head3D.ax,'Faces',widget.viewer.oblique.head3D.fmh.faces,...
        'Vertices',widget.viewer.oblique.head3D.fmh.vertices);
    widget.viewer.oblique.head3D.patch_fmh.YData = ...
        widget.viewer.oblique.head3D.patch_fmh.YData-(min(min(widget.viewer.oblique.head3D.patch_fmh.YData)));
    set(widget.viewer.oblique.head3D.patch_fmh,'ZData',...
        widget.viewer.oblique.head3D.patch_fmh.ZData-(max(max(widget.viewer.oblique.head3D.patch_fmh.ZData)/2)),...
        'YData',widget.viewer.oblique.head3D.patch_fmh.YData-(max(max(widget.viewer.oblique.head3D.patch_fmh.YData)/2)),...
        'FaceColor',[1 1 1],'EdgeAlpha',0,'FaceLighting','gouraud',...
        'SpecularStrength',0.25,'AmbientStrength',0.4,'DiffuseStrength',0.6,...
        'Parent',widget.viewer.oblique.head3D.HG2);
    view(widget.viewer.oblique.head3D.ax,225,10);
    %axis(widget.viewer.oblique.head3D.ax,'tight','equal','vis3d');
    set(widget.viewer.oblique.head3D.ax,'Color',widget.viewer.oblique.panel.BackgroundColor,'GridAlpha',0,'Projection','perspective');
    widget.viewer.oblique.head3D.ax.XAxis.Visible = 'off';
    widget.viewer.oblique.head3D.ax.YAxis.Visible = 'off';
    widget.viewer.oblique.head3D.ax.ZAxis.Visible = 'off';
    hold(widget.viewer.oblique.head3D.ax,'on');
    minX = floor(min(min(widget.viewer.oblique.head3D.patch_fmh.XData)));
    maxX = ceil(max(max(widget.viewer.oblique.head3D.patch_fmh.XData)));
    minY = floor(min(min(widget.viewer.oblique.head3D.patch_fmh.YData)));
    maxY = ceil(max(max(widget.viewer.oblique.head3D.patch_fmh.YData)));
    minZ = floor(min(min(widget.viewer.oblique.head3D.patch_fmh.ZData)));
    maxZ = ceil(max(max(widget.viewer.oblique.head3D.patch_fmh.ZData)));
    scaleFactor = size(ct,2)/(abs(minY)+abs(maxY));
    zTranslate = minZ*0.2;
    widget.viewer.oblique.head3D.HG1.Matrix = makehgtform('scale',scaleFactor,'translate',[0 0 zTranslate]);
    
    widget.viewer.oblique.head3D.cLight = camlight(widget.viewer.oblique.head3D.ax,'headlight');
    widget.viewer.oblique.head3D.toolbar = axtoolbar(widget.viewer.oblique.head3D.ax,...
        {'rotate','restoreview'});
    
    widget.viewer.oblique.head3D.planeVert = [[size(ct,1)/2 size(ct,1)/2 -size(ct,1)/2 -size(ct,1)/2];
                [0 0 0 0];
                [-size(ct,3)/2 size(ct,3)/2 size(ct,3)/2 -size(ct,3)/2]];
    widget.viewer.oblique.head3D.planeHor =  [[size(ct,1)/2 -size(ct,1)/2 -size(ct,1)/2 size(ct,1)/2];
                [size(ct,2)/2 size(ct,2)/2 -size(ct,2)/2 -size(ct,2)/2];
                [0 0 0 0]];
    widget.viewer.oblique.head3D.vertRotator = hgtransform(widget.viewer.oblique.head3D.HGrot);
    widget.viewer.oblique.head3D.plane1 = patch(widget.viewer.oblique.head3D.ax,widget.viewer.oblique.head3D.planeVert(1,:),widget.viewer.oblique.head3D.planeVert(2,:),widget.viewer.oblique.head3D.planeVert(3,:),[0 0 0 0]);
    set(widget.viewer.oblique.head3D.plane1,'FaceColor',[1 0.75 0.45],'LineWidth',2,'FaceAlpha',0.15,...
        'Parent',widget.viewer.oblique.head3D.vertRotator);
    widget.viewer.oblique.head3D.plane1.EdgeColor = [1 0.75 0];
    widget.viewer.oblique.head3D.horRotator = hgtransform(widget.viewer.oblique.head3D.vertRotator);
    widget.viewer.oblique.head3D.plane2 = patch(widget.viewer.oblique.head3D.ax,widget.viewer.oblique.head3D.planeHor(1,:),widget.viewer.oblique.head3D.planeHor(2,:),widget.viewer.oblique.head3D.planeHor(3,:),[0 0 0 0]);
    set(widget.viewer.oblique.head3D.plane2,'FaceColor',[0.65 0.75 1],'LineWidth',2,'FaceAlpha',0.15,...
        'Parent',widget.viewer.oblique.head3D.horRotator);
    widget.viewer.oblique.head3D.plane2.EdgeColor = [0 0.75 1];
    widget.viewer.oblique.head3D.ax.XLim = [-size(ct,1)/2-30 size(ct,1)/2+30];
    widget.viewer.oblique.head3D.ax.YLim = [-size(ct,2)/2-30 size(ct,2)/2+30];
    widget.viewer.oblique.head3D.ax.ZLim = [-size(ct,3)/2-80 size(ct,3)/2+30];
    axis(widget.viewer.oblique.head3D.ax,'tight','equal','vis3d');
end

end