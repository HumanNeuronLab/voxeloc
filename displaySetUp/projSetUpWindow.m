function projSetUpWindow(widget,widgetState)

    % widgetState ('init' or 'update')

    screenSize      = widget.root.monitorSize(3:4);
    projectWindow   = uifigure('Name','Project Set-Up',...
                        'Color',[0.22 0.22 0.22],...
                        'Position',[(screenSize(1)-3*(round(screenSize(1)/2)/2)) ((screenSize(2)-round(screenSize(2)*0.75))/2) round(screenSize(1)/2) round(screenSize(2)*0.75)],...
                        'Pointer','arrow');
    
    paramsValues = paramsBuilder(projectWindow,widgetState,widget);
    projectWindow.CloseRequestFcn = {@myCloseReq,widget,paramsValues};
    
    A = webread('https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/voxeloc_version.txt');
    fid = fopen(which('voxeloc_version.txt'));
    B = fscanf(fid,'%s');
    fclose(fid);
    if isequal(A,B)
        paramsValues.label_newVersion.Text = 'Current version up-to-date ';
    else
        paramsValues.label_newVersion.Text = ['<a href="https://github.com/HumanNeuronLab/voxeloc">New version avaible (' A ')!</a>'];
    end

    function myCloseReq(src,~,widget,pV)
        validCheck = runcheck([],[],pV,widget.d,0);
        switch validCheck
            case 0
                selection = uiconfirm(src,'Closing this window will close Voxeloc',...
                    'Confirm Close'); 
                switch selection 
                    case 'OK'
                        delete(src);
                        close(widget.d);
                        delete(widget.fig);
                    case 'Cancel'
                        return 
                end
            case 1
                transferData(pV,[],widget,pV);
                widget.viewer.logo.panel.Visible = 'off';
                delete(src);
                close(widget.d);
        end
    end

    function pV = paramsBuilder(pW,wS,widget)
        switch wS
            case 'init'
                pV.panel = uipanel('Parent',pW,'Position',[20 20 pW.Position(3)-40 pW.Position(4)-40]);
                pV.gridInner = uigridlayout('Parent',pV.panel,...
                    'ColumnWidth',{150,200,22,100,'1x'},'RowHeight',{100,22,22,22,22,22,22,22,22,22,22,'1x',35},...
                    'RowSpacing',15,'Padding',[20 20 20 20],'Scrollable','on','BackgroundColor',[0.24 0.24 0.24]);
                pV = drawCartouche(pV);

                pV.label_userID = uilabel('Parent',pV.gridInner,'Text','User name:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_userID.Layout.Row = 2;pV.label_userID.Layout.Column = 1;
                pV.field_userID = uieditfield('Parent',pV.gridInner,'Placeholder','[User name]','FontColor',[0.6 0.6 0.6],'BackgroundColor',[0.85 0.85 0.85]);
                pV.lamp_userID = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.check_matrix(4,1) = 0;

                pV.label_patientDir = uilabel('Parent',pV.gridInner,'Text','Patient folder:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_patientDir.Layout.Row = 3; pV.label_patientDir.Layout.Column = 1;
                pV.field_patientDir = uilabel('Parent',pV.gridInner,'Text','[Folder path]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_patientDir = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.lamp_patientDir.Layout.Row = 3; pV.lamp_patientDir.Layout.Column = 3;
                pV.button_patientDir = uibutton('Parent',pV.gridInner,'Text','Select folder','BackgroundColor',[1,0.65,0],'Tag','DIR');
                pV.check_matrix(1,1) = 0;

                pV.label_patientID = uilabel('Parent',pV.gridInner,'Text','Patient ID:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_patientID.Layout.Row = 4; pV.label_patientID.Layout.Column = 1;
                pV.field_patientID = uieditfield('Parent',pV.gridInner,'Placeholder','[Patient_ID]','FontColor',[0.6 0.6 0.6],'BackgroundColor',[0.85 0.85 0.85]);
                pV.lamp_patientID = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.check_matrix(2,1) = 0;
                
                pV.label_voxelocFolder = uilabel('Parent',pV.gridInner,'Text','Voxeloc Folder:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_voxelocFolder.Layout.Row = 5; pV.label_voxelocFolder.Layout.Column = 1;
                pV.field_voxelocFolder = uilabel('Parent',pV.gridInner,'Text','[Folder path]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_voxelocFolder = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.button_voxelocFolder = uibutton('Parent',pV.gridInner,'Text','Select folder','BackgroundColor',[1,0.65,0],'Tag','DIR_VOX');
                pV.check_matrix(6,1) = 0;

                pV.label_autosaveFile = uilabel('Parent',pV.gridInner,'Text','Autosave file:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_autosaveFile.Layout.Row = 6; pV.label_autosaveFile.Layout.Column = 1;
                pV.field_autosaveFile = uilabel('Parent',pV.gridInner,'Text','[No autosave file linked yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_autosaveFile = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.field_autosavePath = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                pV.field_autosavePath.Layout.Column = 5;
                
                pV.label_ctFile = uilabel('Parent',pV.gridInner,'Text','CT file:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_ctFile.Layout.Row = 7;
                pV.label_ctFile.Layout.Column = 1;
                pV.field_ctFile = uilabel('Parent',pV.gridInner,'Text','[No CT file loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_ctFile = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                pV.button_ctFile = uibutton('Parent',pV.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','CT');
                pV.field_ctPath = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                pV.check_matrix(3,1) = 0;
                
                pV.label_t1File = uilabel('Parent',pV.gridInner,'Text','T1 file:','FontWeight','bold','FontColor',[1 1 1]);
                pV.field_t1File = uilabel('Parent',pV.gridInner,'Text','[No T1 file loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_t1File = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.button_t1File = uibutton('Parent',pV.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','T1');
                pV.field_t1Path = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                
                pV.label_parcFile = uilabel('Parent',pV.gridInner,'Text','Parcellation file:','FontWeight','bold','FontColor',[1 1 1]);
                pV.field_parcFile = uilabel('Parent',pV.gridInner,'Text','[No parcellation file loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_parcFile = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.button_parcFile = uibutton('Parent',pV.gridInner,'Text','Load .nii','BackgroundColor',[1,0.65,0],'Tag','PARC');
                pV.field_parcPath = uilabel('Parent',pV.gridInner,'Text','[File path]','FontColor',[0.6 0.6 0.6]);
                
%                 pV.label_electrodes = uilabel('Parent',pV.gridInner,'Text','Number of electrodes:','FontWeight','bold');
%                 pV.label_electrodes.Layout.Row = 9;
%                 pV.label_electrodes.Layout.Column = 1;
%                 pV.field_electrodes = uilabel('Parent',pV.gridInner,'Text','Completed: 0 of 0','FontColor',[0.6 0.6 0.6]);
%                 pV.lamp_electrodes = uilamp('Parent',pV.gridInner,'Color',[1 0 0]);
                
                pV.label_instLogo = uilabel('Parent',pV.gridInner,'Text','Institution Logo:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_instLogo.Layout.Row = 10;
                pV.label_instLogo.Layout.Column = 1;
                pV.field_instLogo = uilabel('Parent',pV.gridInner,'Text','[No logo loaded yet]','FontColor',[0.6 0.6 0.6]);
                pV.lamp_instLogo = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.image_instLogo = uiimage('Parent',pV.gridInner,'ImageSource',which('UNIGE_logo.png'),'HorizontalAlignment','left','Visible','off');
                pV.image_instLogo.Layout.Row = pV.label_instLogo.Layout.Row;
                pV.image_instLogo.Layout.Column = 2;
                pV.button_instLogo = uibutton('Parent',pV.gridInner,'Text','Load Image','BackgroundColor',[1,0.65,0]);
                
                pV.label_forceSave = uilabel('Parent',pV.gridInner,'Text','Last autosave:','FontWeight','bold','FontColor',[1 1 1]);
                pV.label_forceSave.Layout.Row = 11;
                pV.label_forceSave.Layout.Column = 1;
                pV.field_forceSave = uilabel('Parent',pV.gridInner,'Text','[No autosave yet]','FontColor',[0.6 0.6 0.6]); % datestr(A.date,'HH:MM dd/mmm/yyyy')
                pV.lamp_forceSave = uilamp('Parent',pV.gridInner,'Color',[0.94 0.94 0.94]);
                pV.button_forceSave = uibutton('Parent',pV.gridInner,'Text','Force Save','BackgroundColor',[0,0.65,1]);
                
                pV.label_newVersion = uilabel('Parent',pV.gridInner,'Text','lll','HorizontalAlignment','right','VerticalAlignment','bottom','Interpreter','html','FontSize',10,'FontColor',[1 1 1]);
                pV.label_newVersion.Layout.Row = numel(pV.gridInner.RowHeight)-1;
                pV.label_newVersion.Layout.Column = [numel(pV.gridInner.ColumnWidth)-1 numel(pV.gridInner.ColumnWidth)];

                pV.button_Validate = uibutton('Parent',pV.gridInner,'Text','Next','BackgroundColor',[1,0.65,0],'Tag','DONE','Enable','off');
                pV.button_Validate.Layout.Row = numel(pV.gridInner.RowHeight);
                pV.button_Validate.Layout.Column = 1;

                progPath = fileparts(which('voxeloc.m'));
                pV.image_currentVersion = uiimage('Parent',pV.gridInner,'ImageSource',[progPath filesep 'assets' filesep 'Voxeloc_version.png'],'HorizontalAlignment','right');
                pV.image_currentVersion.Layout.Row = numel(pV.gridInner.RowHeight);
                pV.image_currentVersion.Layout.Column = [numel(pV.gridInner.ColumnWidth)-1 numel(pV.gridInner.ColumnWidth)];

                pV.field_userID.ValueChangingFcn = {@runcheck, pV,widget.d,1};
                pV.field_userID.ValueChangedFcn = {@runcheck, pV,widget.d,1};

                pV.field_patientID.ValueChangingFcn = {@runcheck, pV,widget.d,2};
                pV.field_patientID.ValueChangedFcn = {@runcheck, pV,widget.d,2};
                pV.button_patientDir.ButtonPushedFcn = {@runcheck, pV,widget.d,2};
                pV.button_voxelocFolder.ButtonPushedFcn = {@runcheck, pV,widget.d,6};

                pV.button_ctFile.ButtonPushedFcn = {@runcheck, pV,widget.d,3};
                pV.button_t1File.ButtonPushedFcn = {@runcheck, pV,widget.d,3};
                pV.button_parcFile.ButtonPushedFcn = {@runcheck, pV,widget.d,3};
                
                pV.button_instLogo.ButtonPushedFcn = {@runcheck, pV,widget.d,4};
                pV.button_forceSave.ButtonPushedFcn = {@runcheck, pV,widget.d,5};
            case 'update'

        end
    end
    
    function validCheck = runcheck(src,evt,pV,d,idVal)
        switch idVal
            case 1
                if isempty(evt.Value)
                    pV.lamp_userID.Color = [1 0 0];
                    pV.label_userID.UserData = [];
                    pV.text4_cartouche.Text = 'Produced by: [User ID]';
                else
                    pV.field_userID.FontColor = [0 0 0];
                    pV.lamp_userID.Color = [0 1 0];
                    pV.label_userID.UserData.userID = evt.Value;
                    pV.text4_cartouche.Text = ['Produced by: ' evt.Value];
                end
            case 2
                if isequal(evt.EventName,'ValueChanged')||isequal(evt.EventName,'ValueChanging')
                    if isempty(evt.Value)
                        pV.lamp_patientID.Color = [1 0 0];
                        pV.label_patientID.UserData.userID = [];
                        pV.text2_cartouche.Text = '[Subject ID]';
                    else
                        pV.field_patientID.FontColor = [0 0 0];
                        pV.lamp_patientID.Color = [0 1 0];
                        pV.label_patientID.UserData.userID = evt.Value;
                        pV.text2_cartouche.Text = evt.Value;
                        drawnow;
                        widget.glassbrain.UserData.patientID = pV.field_patientID.Value;
                    end
                elseif isequal(evt.EventName,'ButtonPushed')
                    pV.panel.Parent.Visible = 'off';
                    cDir = uigetdir('Select patient folder');
                    pV.panel.Parent.Visible = 'on';
                    figure(pV.panel.Parent);
                    if cDir ~= 0
                        [path1,pV.label_patientID.UserData.patientID] = fileparts(cDir);
                        [path2,path1] = fileparts(path1);
                        [~,path2] = fileparts(path2);
                        pV.label_patientDir.UserData.patientDir = cDir;
                        pV.field_patientDir.Text = ['...' filesep path2 filesep path1 filesep pV.label_patientID.UserData.patientID];
                        pV.field_patientDir.FontColor = [0.94 0.94 0.94];
                        pV.lamp_patientDir.Color = [0 1 0];
                        pV.field_patientID.Value = pV.label_patientID.UserData.patientID;
                        pV.field_patientID.FontColor = [0 0 0];
                        pV.lamp_patientID.Color = [0 1 0];
                        pV.text2_cartouche.Text = pV.label_patientID.UserData.patientID;
                        widget.glassbrain.UserData.patientID = pV.field_patientID.Value;
                        widget.glassbrain.UserData.patientDir = cDir;
                    end
                end
            case 3
                pV.panel.Parent.Visible = 'off';
                if isfield(pV.label_patientDir.UserData,'patientDir')
                    [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',pV.label_patientDir.UserData.patientDir);
                else
                    [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file');
                end
                pV.panel.Parent.Visible = 'on';
                figure(pV.panel.Parent);
                switch src.Tag
                    case 'CT'
                        if (file ~= 0)
                            pV.button_ctFile.UserData.filePath = [path file];
                            [~,path1] = fileparts(path(1:end-1));
                            pV.field_ctFile.Text = ['...' filesep path1 filesep file];
                            pV.field_ctFile.FontColor = [0.94 0.94 0.94];
                            pV.lamp_ctFile.Color = [0 1 0];
                            pV.field_ctPath.Text = file;
                            pV.field_ctPath.FontColor = [0.94 0.94 0.94];
                            pV.check_matrix(4,1) = 1;
                        else
                            pV.field_ctFile.FontColor = [0.6 0.6 0.6];
                            pV.lamp_ctFile.Color = [1 0 0];
                            pV.button_ctFile.UserData = [];
                            pV.field_ctFile.Text = '[No CT file loaded yet]';
                            pV.field_ctPath.Text = '[File path]';
                            pV.field_ctPath.FontColor = [0.6 0.6 0.6];
                            pV.check_matrix(4,1) = 0;
                        end
                    case 'T1'
                        if (file ~= 0)
                            pV.button_t1File.UserData.filePath = [path file];
                            [~,path1] = fileparts(path(1:end-1));
                            pV.field_t1File.Text = ['...' filesep path1 filesep file];
                            pV.field_t1File.FontColor = [0.94 0.94 0.94];
                            pV.lamp_t1File.Color = [0 1 0];
                            pV.field_t1Path.Text = file;
                            pV.field_t1Path.FontColor = [0.94 0.94 0.94];
                        else
                            pV.field_t1File.FontColor = [0.6 0.6 0.6];
                            pV.lamp_t1File.Color = [0.94 0.94 0.94];
                            pV.button_t1File.UserData = [];
                            pV.field_t1File.Text = '[No T1 file loaded yet]';
                            pV.field_t1Path.Text = '[File path]';
                            pV.field_t1Path.FontColor = [0.6 0.6 0.6];
                        end
                    case 'PARC'
                        if (file ~= 0)
                            pV.button_parcFile.UserData.filePath = [path file];
                            [~,path1] = fileparts(path(1:end-1));
                            pV.field_parcFile.Text = ['...' filesep path1 filesep file];
                            pV.field_parcFile.FontColor = [0.94 0.94 0.94];
                            pV.lamp_parcFile.Color = [0 1 0];
                            pV.field_parcPath.Text = file;
                            pV.field_parcPath.FontColor = [0.94 0.94 0.94];
                        else
                            pV.field_parcFile.FontColor = [0.6 0.6 0.6];
                            pV.lamp_parcFile.Color = [0.94 0.94 0.94];
                            pV.button_parcFile.UserData = [];
                            pV.field_parcFile.Text = '[No parcellation file loaded yet]';
                            pV.field_parcPath.Text = '[File path]';
                            pV.field_parcPath.FontColor = [0.6 0.6 0.6];
                        end
                end
            case 4
                pV.panel.Parent.Visible = 'off';
                [file,path] = uigetfile({'*.jpg;*.jpeg;*.png','*.svg'},'Select institution logo');
                pV.panel.Parent.Visible = 'on';
                figure(pV.panel.Parent);
                if ischar(file) && ischar(path)
                    pV.label_instLogo.UserData.instLogoPath = path;
                    pV.label_instLogo.UserData.instLogoFile = file;
                    pV.field_instLogo.Visible = 'off';
                    pV.image_instLogo.Visible = 'on';
                    pV.image_instLogo.ImageSource = [path file];
                    pV.lamp_instLogo.Color = [0 1 0];
                    pV.logoI_cartouche.ImageSource = [path file];
                else
                    pV.label_instLogo.UserData = [];
                    pV.field_instLogo.Visible = 'on';
                    pV.image_instLogo.Visible = 'off';
                    pV.image_instLogo.ImageSource = which('UNIGE_logo.png');
                    pV.lamp_instLogo.Color = [0.94 0.94 0.94];
                    pV.logoI_cartouche.ImageSource = which('UNIGE_logo.png');
                end
            case 5
                forceSave([],[],pV);
            case 6
                if ~isfield(widget.glassbrain.UserData,'patientDir') || ~isfield(widget.glassbrain.UserData,'patientID')
                    fig = pV.panel.Parent;
                    message = "Please select patient directory and confirm patient ID before selecting Voxeloc folder.";
                    uialert(fig,message,"Patient ID & directory required", ...
                        "Icon","warning");
                    return
                end
                pV.panel.Parent.Visible = 'off';
                cDir = uigetdir('Select Voxeloc folder');
                pV.panel.Parent.Visible = 'on';
                figure(pV.panel.Parent);
                if cDir ~= 0
                    [path1,pV.label_voxelocFolder.UserData.voxDir] = fileparts(cDir);
                    if isequal(pV.label_voxelocFolder.UserData.voxDir,'voxeloc')
                        cDir = path1;
                        [path1,path0] = fileparts(path1);
                        pV.label_voxelocFolder.UserData.voxDir = path0;
                    end
                    [~,path1] = fileparts(path1);
                    pV.field_voxelocFolder.Text = ['...' filesep path1 filesep pV.label_voxelocFolder.UserData.voxDir filesep 'voxeloc'];
                    pV.field_voxelocFolder.FontColor = [0.94 0.94 0.94];
                    pV.lamp_voxelocFolder.Color = [0 1 0];
                    widget.glassbrain.UserData.voxelocDir = [cDir filesep 'voxeloc'];
                    widget = widgetAutosave(widget,pV);
                    pV.check_matrix(6,1) = 1;
                end
        end
        if ~isempty(pV.label_patientDir.UserData)
            pV.check_matrix(1,1) = 1;
        else
            pV.check_matrix(1,1) = 0;
        end
        if ~isempty(pV.label_patientID.UserData)
            pV.check_matrix(2,1) = 1;
        else
            pV.check_matrix(2,1) = 0;
        end
        if isequal(pV.lamp_ctFile.Color,[0 1 0])
            pV.check_matrix(3,1) = 1;
        else
            pV.check_matrix(3,1) = 0;
        end
        if isequal(pV.lamp_userID.Color,[0 1 0])
            pV.check_matrix(4,1) = 1;
        else
            pV.check_matrix(4,1) = 0;
        end
        if ~isempty(pV.label_userID.UserData)
            pV.check_matrix(5,1) = 1;
        else
            pV.check_matrix(5,1) = 0;
        end
        if isequal(pV.lamp_voxelocFolder.Color,[0 1 0])
            pV.check_matrix(6,1) = 1;
        else
            pV.check_matrix(6,1) = 0;
        end
        d.Value = sum(pV.check_matrix)/height(pV.check_matrix);
        if all(pV.check_matrix)
            validCheck = 1;
            pV.button_Validate.Enable = 'on';
        else
            validCheck = 0;
            pV.button_Validate.Enable = 'off';
        end
    end
    
    function pV = drawCartouche(pV)
        pV.panel_cartouche = uipanel('Parent',pV.gridInner);
        pV.panel_cartouche.Layout.Row = 1;
        pV.panel_cartouche.Layout.Column = [1,numel(pV.gridInner.ColumnWidth)];
        pV.grid_cartouche = uigridlayout('Parent',pV.panel_cartouche,...
                    'ColumnWidth',{'3x','4x','3x'},'RowHeight',{'1x','1x','1x','1x'},...
                    'RowSpacing',0,'Padding',[5 5 5 5],'Scrollable','off','BackgroundColor',[0.8 0.8 0.8 ]);
        if isequal(widgetState,'update')
            if isfield(widget.glassbrain.UserData,'instLogoFile')
                instLogo = imagesc('Parent',pV.header1,'CData',imread([widget.glassbrain.UserData.instLogoPath widget.glassbrain.UserData.instLogoFile]));
                pV.header1.XLim = ([instLogo.XData(1)-instLogo.XData(2)*0.05 instLogo.XData(2)+instLogo.XData(2)*0.05]); % adds 10% padding
                pV.header1.YLim = ([instLogo.YData(1)-instLogo.YData(2)*0.05 instLogo.YData(2)+instLogo.YData(2)*0.05]); % adds 10% padding
                axis(pV.header1,'equal');
            end
        elseif isequal(widgetState,'init')
            pV.logoI_cartouche = uiimage('Parent',pV.grid_cartouche,'ImageSource',which('UNIGE_logo.png'));
            pV.logoI_cartouche.Layout.Row = [1,4];
            pV.logoI_cartouche.Layout.Column = 1;
        end
        pV.text1_cartouche = uilabel('Parent',pV.grid_cartouche,...
            'Text','<u>PROJECT PARAMETERS</u>','HorizontalAlignment','center',...
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
        
        pV.logoV_cartouche = uiimage('Parent',pV.grid_cartouche,'ImageSource',which('voxeloc_logo.png'));
        pV.logoV_cartouche.Layout.Row = [3,4];
        pV.logoV_cartouche.Layout.Column = 3;

    end

end