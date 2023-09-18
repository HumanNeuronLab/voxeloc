function projSetUpWindow(widget,varargin)
    screenSize      = widget.root.monitorSize(3:4);
    projectWindow   = uifigure('Name','Project Set-Up',...
                        'Color',[0.65,0.65,0.65],...
                        'Position',[(screenSize(1)-3*(round(screenSize(1)/2)/2)) ((screenSize(2)-round(screenSize(2)*0.75))/2) round(screenSize(1)/2) round(screenSize(2)*0.75)],...
                        'Pointer','arrow');
    d = uiprogressdlg(widget.fig,'Title','Waiting for Project Set-Up parameters...');
    
    if length(fieldnames(widget)) == 3
        widgetState = 'init';
    else
        widgetState = 'update';
    end

    paramsValues = paramsBuilder(projectWindow,widgetState);
    projectWindow.CloseRequestFcn = {@myCloseReq,widget,paramsValues,d};
    %close(d);
    A = webread('https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/voxeloc_version.txt');
    fid = fopen(which('voxeloc_version.txt'));
    B = fscanf(fid,'%s');
    fclose(fid);
    if isequal(A,B)
        paramsValues.label_newVersion.Text = 'Current version up-to-date ';
    else
        paramsValues.label_newVersion.Text = ['<a href="https://github.com/HumanNeuronLab/voxeloc">New version avaible (' A ')!</a>'];
    end
    function myCloseReq(src,~,widget,pV,d)
        validCheck = runcheck(pV,d);
        switch validCheck
            case 0
                selection = uiconfirm(src,'Closing this window will close Voxeloc',...
                    'Confirm Close'); 
                switch selection 
                    case 'OK'
                        delete(src);
                        delete(widget.fig);
                    case 'Cancel'
                        return 
                end
        end
    end
    function pV = paramsBuilder(pW,wS)
        switch wS
            case 'init'
                pV.panel = uipanel('Parent',pW,'Position',[20 20 pW.Position(3)-40 pW.Position(4)-40]);
                pV.gridInner = uigridlayout('Parent',pV.panel,...
                    'ColumnWidth',{150,200,22,100,'1x'},'RowHeight',{100,22,22,22,22,22,22,22,22,22,22,'1x',35},...
                    'RowSpacing',15,'Padding',[20 20 20 20],'Scrollable','on');
                drawCartouche(pV);
                pV.label_patientDir = uilabel('Parent',pV.gridInner,'Text','Patient folder:','FontWeight','bold');
                pV.lamp_patientDir = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.lamp_patientDir.Layout.Row = 2; pV.lamp_patientDir.Layout.Column = 3;
                pV.button_patientDir = uibutton('Parent',pV.gridInner,'Text','Select folder','BackgroundColor',[1,0.65,0],'Tag','DIR');
                pV.field_patientDir = uilabel('Parent',pV.gridInner,'Text','[Folder path]','FontColor',[0.6 0.6 0.6]);
                pV.check_matrix(1,1) = 0;
                
                pV.label_autosaveFile = uilabel('Parent',pV.gridInner,'Text','Autosave file:','FontWeight','bold');
                pV.field_autosaveFile = uilabel('Parent',pV.gridInner,'Text','[No autosave file linked yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_autosaveFile = uilamp('Parent',pV.gridInner,'Color',[1 0.65 0]);
                pV.field_autosavePath = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                pV.field_autosavePath.Layout.Column = 5;
                pV.check_matrix(2,1) = 0;
                
                
                
                pV.label_patientID = uilabel('Parent',pV.gridInner,'Text','Patient ID:','FontWeight','bold');
                pV.field_patientID = uieditfield('Parent',pV.gridInner,'Placeholder','[Patient_ID]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_patientID = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.check_matrix(3,1) = 0;
                
                pV.label_ctFile = uilabel('Parent',pV.gridInner,'Text','CT file:','FontWeight','bold');
                pV.label_ctFile.Layout.Row = 5;
                pV.label_ctFile.Layout.Column = 1;
                pV.field_ctFile = uilabel('Parent',pV.gridInner,'Text','[No CT file loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_ctFile = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.button_ctFile = uibutton('Parent',pV.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','CT');
                pV.field_ctPath = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                pV.check_matrix(4,1) = 0;
                
                pV.label_t1File = uilabel('Parent',pV.gridInner,'Text','T1 file:','FontWeight','bold');
                pV.field_t1File = uilabel('Parent',pV.gridInner,'Text','[No T1 file loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_t1File = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.button_t1File = uibutton('Parent',pV.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','T1');
                pV.field_t1Path = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                
                pV.label_parcFile = uilabel('Parent',pV.gridInner,'Text','Parcellation file:','FontWeight','bold');
                pV.field_parcFile = uilabel('Parent',pV.gridInner,'Text','[No parcellation file loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_parcFile = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.button_parcFile = uibutton('Parent',pV.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','PARC');
                pV.field_parcPath = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                
                pV.label_electrodes = uilabel('Parent',pV.gridInner,'Text','Number of electrodes:','FontWeight','bold');
                pV.label_electrodes.Layout.Row = 8;
                pV.label_electrodes.Layout.Column = 1;
                pV.field_electrodes = uilabel('Parent',pV.gridInner,'Text','Completed: 0 of 0','FontColor',[0.6 0.6 0.6]);
                pV.lamp_electrodes = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                
                pV.label_instLogo = uilabel('Parent',pV.gridInner,'Text','Institution Logo:','FontWeight','bold');
                pV.label_instLogo.Layout.Row = 9;
                pV.label_instLogo.Layout.Column = 1;
                pV.field_instLogo = uilabel('Parent',pV.gridInner,'Text','[No logo loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_instLogo = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.image_instLogo = uiimage('Parent',pV.gridInner,'ImageSource','erwin_logo.png','HorizontalAlignment','left','Visible','off');
                pV.image_instLogo.Layout.Row = pV.label_instLogo.Layout.Row;
                pV.image_instLogo.Layout.Column = 2;
                pV.button_instLogo = uibutton('Parent',pV.gridInner,'Text','Load Image','BackgroundColor',[1,0.65,0]);
                
                pV.label_userID = uilabel('Parent',pV.gridInner,'Text','User name:','FontWeight','bold');
                pV.label_userID.Layout.Row = 10;
                pV.label_userID.Layout.Column = 1;
                pV.field_userID = uieditfield('Parent',pV.gridInner,'Placeholder','[User name]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_userID = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.check_matrix(5,1) = 0;
                
                pV.label_forceSave = uilabel('Parent',pV.gridInner,'Text','Last autosave:','FontWeight','bold');
                pV.label_forceSave.Layout.Row = 11;
                pV.label_forceSave.Layout.Column = 1;
                pV.field_forceSave = uilabel('Parent',pV.gridInner,'Text','[No autosave yet]','FontColor',[0.6 0.6 0.6]); % datestr(A.date,'HH:MM dd/mmm/yyyy')
                pV.lamp_forceSave = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.button_forceSave = uibutton('Parent',pV.gridInner,'Text','Force Save','BackgroundColor',[0,0.65,1]);
                
                pV.label_newVersion = uilabel('Parent',pV.gridInner,'Text','lll','HorizontalAlignment','right','VerticalAlignment','bottom','Interpreter','html','FontSize',10);
                pV.label_newVersion.Layout.Row = numel(pV.gridInner.RowHeight)-1;
                pV.label_newVersion.Layout.Column = [numel(pV.gridInner.ColumnWidth)-1 numel(pV.gridInner.ColumnWidth)];

                progPath = fileparts(which('voxeloc.m'));
                pV.image_currentVersion = uiimage('Parent',pV.gridInner,'ImageSource',[progPath filesep 'assets' filesep 'Voxeloc_version.png'],'HorizontalAlignment','right');
                pV.image_currentVersion.Layout.Row = numel(pV.gridInner.RowHeight);
                pV.image_currentVersion.Layout.Column = [numel(pV.gridInner.ColumnWidth)-1 numel(pV.gridInner.ColumnWidth)];

            case 'update'

        end
    end
    function validCheck = runcheck(pV,d)
        d.Value = sum(pV.check_matrix)/height(pV.check_matrix);
        if all(pV.check_matrix)
            validCheck = 1;
        else
            validCheck = 0;
        end
    end
    function drawCartouche(pV)
        pV.panel_cartouche = uipanel('Parent',pV.gridInner);
        pV.panel_cartouche.Layout.Row = 1;
        pV.panel_cartouche.Layout.Column = [1,numel(pV.gridInner.ColumnWidth)];
        pV.grid_cartouche = uigridlayout('Parent',pV.panel_cartouche,...
                    'ColumnWidth',{'3x','4x','3x'},'RowHeight',{'1x','1x','1x','1x'},...
                    'RowSpacing',0,'Padding',[5 5 5 5],'Scrollable','off','BackgroundColor',[1 1 1]);
        try
            if isfield(widget.glassbrain.UserData,'instLogoFile')
                instLogo = imagesc('Parent',pV.header1,'CData',imread([widget.glassbrain.UserData.instLogoPath widget.glassbrain.UserData.instLogoFile]));
                pV.header1.XLim = ([instLogo.XData(1)-instLogo.XData(2)*0.05 instLogo.XData(2)+instLogo.XData(2)*0.05]); % adds 10% padding
                pV.header1.YLim = ([instLogo.YData(1)-instLogo.YData(2)*0.05 instLogo.YData(2)+instLogo.YData(2)*0.05]); % adds 10% padding
                axis(pV.header1,'equal');
            end
        catch
            pV.logoI_cartouche = uiimage('Parent',pV.grid_cartouche,'ImageSource',which('UNIGE_logo.png'));
            pV.logoI_cartouche.Layout.Row = [1,4];
            pV.logoI_cartouche.Layout.Column = 1;
        end
        pV.text1_cartouche = uilabel('Parent',pV.grid_cartouche,...
            'Text','<u>sEEG SLICES</u>','HorizontalAlignment','center',...
            'VerticalAlignment','center','FontSize',16,'Interpreter','html');
        pV.text1_cartouche.Layout.Row = [1,2]; pV.text1_cartouche.Layout.Column = 2;
        pV.text2_cartouche = uilabel('Parent',pV.grid_cartouche,...
            'Text','[Subject ID]','HorizontalAlignment','center',...
            'VerticalAlignment','center','FontSize',16,'FontWeight','bold');
        pV.text2_cartouche.Layout.Row = [3,4]; pV.text2_cartouche.Layout.Column = 2;
        pV.text3_cartouche = uilabel('Parent',pV.grid_cartouche,...
            'Text',['Produced on: ' upper(datestr(now,'dd mmm yy'))],'HorizontalAlignment','left',...
            'VerticalAlignment','bottom','FontSize',12);
        pV.text3_cartouche.Layout.Row = 1; pV.text3_cartouche.Layout.Column = 3;
        pV.text4_cartouche = uilabel('Parent',pV.grid_cartouche,...
            'Text','Produced by: [User ID]','HorizontalAlignment','left',...
            'VerticalAlignment','bottom','FontSize',12);
        pV.text4_cartouche.Layout.Row = 2; pV.text4_cartouche.Layout.Column = 3;
        
        pV.logoV_cartouche = uiimage('Parent',pV.grid_cartouche,'ImageSource',which('erwin_logo.png'));
        pV.logoV_cartouche.Layout.Row = [3,4];
        pV.logoV_cartouche.Layout.Column = 3;

    end
end