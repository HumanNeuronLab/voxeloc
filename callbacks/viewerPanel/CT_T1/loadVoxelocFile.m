function loadVoxelocFile(src,~,widget,autoload)
try
    if isequal(src.mssg,'load')
        load(widget.autosave.UserData.filePath);
    else
        try
            autoload.panel.Parent.Visible = 'off';
            [file,path] = uigetfile({'*_voxeloc.mat'},'Select Voxeloc file');
            load([path file],'autosave');
            autoload.panel.Parent.Visible = 'on';
            widget.autosave.UserData.filePath = [path file];
        catch
            autoload.panel.Parent.Visible = 'on';
            disp([newline 'No file selected...' newline]);
            return
        end
    end
    widget.viewer.logo.panel.Visible = 'on';
%     widget.fig.Pointer = 'watch';
%     if ~isequal(widget.glassbrain.UserData.patientID,autosave.glassbrain.patientID)
%         answer1 = uiconfirm(widget.fig,...
%                     ['The NIfTI and autosave files you have' ...
%                         ' selected do not have the same patient ID.' ...
%                         ' Please select the desired patient ID or cancel upload:'],...
%                         'Patient ID conflict',...
%                         'Options',{autosave.glassbrain.patientID,widget.glassbrain.UserData.patientID,'Cancel'},'DefaultOption',1,...
%                         'Icon','warning');
%         switch answer1
%             case 'Cancel'
%                 disp([newline 'No autosave file selected...' newline]);
%                 return
%             case autosave.glassbrain.patientID
%                 widget.glassbrain.UserData.patientID = autosave.glassbrain.patientID;
%             case widget.glassbrains.Userdata.patientID
%                 autosave.glassbrain.patientID = widget.glassbrain.UserData.patientID;
%         end
%         if isequal(widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag,'CT')
%             widget.viewer.panel_CentralTabsMRI.SelectedTab.Title = ...
%                 [widget.glassbrain.UserData.patientID ' | ' widget.glassbrain.UserData.fileNameCT];
%         else
%             widget.viewer.panel_CentralTabsMRI.SelectedTab.Title = ...
%                 [widget.glassbrain.UserData.patientID ' | ' widget.glassbrain.UserData.fileNameT1];
%         end
%     else
%         % redundant...
%         widget.glassbrain.UserData.patientID = autosave.glassbrain.patientID;
%     end
    cF = dir(widget.autosave.UserData.filePath);
    autoload.field_forceSave.Text = datestr(cF.date,'HH:MM dd/mmm/yyyy');
    autoload.field_forceSave.FontColor = [0.94 0.94 0.94];
    widget.tree_Summary.Children.delete

    % DATA TRANSFER HAPPENS HERE
    widget.fig.UserData = autosave.fig;
    widget.glassbrain.UserData = autosave.glassbrain;

    for i = 1:numel(fieldnames(autosave.fig))
        field = ['Electrode' num2str(i)];
        widget = createTreeNode(widget,widget.tree_Summary,field);
        widget = checkStatus(field,widget,0);
        try
            widget.params.dropdown_ElectrodeSelector.Items{i} = autosave.fig.(field).Name;
        catch
            widget.params.dropdown_ElectrodeSelector.Items{i} = ['Electrode' num2str(i)];
        end
    end
    widget.params.spinner_NumElectrodes.Value = i;
    evt.Value = widget.params.dropdown_ElectrodeSelector.Items{i};
    data = widget.params.dropdown_ElectrodeSelector;
    widget.params.dropdown_ElectrodeSelector.Value = evt.Value;
    widget.tree_Summary.SelectedNodes = widget.tree_Summary.Children(i);
    electrodeSelectionChanged(data,evt,widget);
    currTab = widget.viewer.panel_CentralTabsMRI.SelectedTab;
    if isfield(widget.glassbrain.UserData,'fileNameCT')
        widget.viewer.CT.label_selectNifti.Text = widget.glassbrain.UserData.fileNameCT;
        widget.viewer.CT.button_selectNifti.BackgroundColor = [0.94,0.94,0.94];
        widget.viewer.CT.tab.Title = [widget.glassbrain.UserData.patientID ' | ' widget.glassbrain.UserData.fileNameCT];
        widget.viewer.oblique.label_niftiT1.Text = [widget.glassbrain.UserData.filePathCT widget.glassbrain.UserData.fileNameCT];
        widget.viewer.oblique.label_niftiCT.FontColor = [0 0 0];
        widget.viewer.oblique.button_niftiCT.BackgroundColor = [0.94,0.94,0.94];
        widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.CT.tab;
        widget.glassbrain.UserData.reload = [];
        selectFile(widget.viewer.CT.button_selectNifti,[],widget);
        autoload.field_ctPath.Text = widget.glassbrain.UserData.fileNameCT;
        autoload.field_ctPath.FontColor = [0.94,0.94,0.94];
        autoload.lamp_ctFile.Color = [0 1 0];
    end
    if isfield(widget.glassbrain.UserData,'filePathCT')
        [path1,~] = fileparts(widget.glassbrain.UserData.filePathCT);
        [path2,path1] = fileparts(path1);
        [~,path2] = fileparts(path2);
        autoload.field_ctFile.Text = ['...' filesep path2 filesep path1];
        autoload.field_ctFile.FontColor = [0.94,0.94,0.94];
    end
    if isfield(widget.glassbrain.UserData,'fileNameT1')
        widget.viewer.T1.label_selectNifti.Text = widget.glassbrain.UserData.fileNameT1;
        widget.viewer.T1.button_selectNifti.BackgroundColor = [0.94,0.94,0.94];
        widget.viewer.T1.tab.Title = [widget.glassbrain.UserData.patientID ' | ' widget.glassbrain.UserData.fileNameT1];
        widget.viewer.oblique.label_niftiT1.Text = [widget.glassbrain.UserData.filePathT1 widget.glassbrain.UserData.fileNameT1];
        widget.viewer.oblique.label_niftiT1.FontColor = [0 0 0];
        widget.viewer.oblique.button_niftiT1.BackgroundColor = [0.94,0.94,0.94];
        widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.T1.tab;
        widget.glassbrain.UserData.reload = [];
        selectFile(widget.viewer.T1.button_selectNifti,[],widget);
        autoload.field_t1Path.Text = widget.glassbrain.UserData.fileNameT1;
        autoload.field_t1Path.FontColor = [0.94,0.94,0.94];
        autoload.lamp_t1File.Color = [0 1 0];
    end
    if isfield(widget.glassbrain.UserData,'filePathT1')
        [path1,~] = fileparts(widget.glassbrain.UserData.filePathT1);
        [path2,path1] = fileparts(path1);
        [~,path2] = fileparts(path2);
        autoload.field_t1File.Text = ['...' filesep path2 filesep path1];
        autoload.field_t1File.FontColor = [0.94,0.94,0.94];
    end
    if isfield(widget.glassbrain.UserData,'reload')
        widget.glassbrain.UserData = rmfield(widget.glassbrain.UserData,'reload');
    end
    if isfield(widget.glassbrain.UserData,'fileNamePARC')
        autoload.field_parcPath.Text = widget.glassbrain.UserData.fileNamePARC;
        autoload.field_parcPath.FontColor = [0.94,0.94,0.94];
        autoload.lamp_parcFile.Color = [0 1 0];
    end
    if isfield(widget.glassbrain.UserData,'filePathPARC')
        widget.viewer.oblique.label_niftiParc.Text = [widget.glassbrain.UserData.filePathPARC widget.glassbrain.UserData.fileNamePARC];
        widget.viewer.oblique.label_niftiParc.FontColor = [0 0 0];
        widget.viewer.oblique.button_niftiParc.BackgroundColor = [0.94,0.94,0.94];
        [path1,~] = fileparts(widget.glassbrain.UserData.filePathPARC);
        [path2,path1] = fileparts(path1);
        [~,path2] = fileparts(path2);
        autoload.field_parcFile.Text = ['...' filesep path2 filesep path1];
        autoload.field_parcFile.FontColor = [0.94,0.94,0.94];
    end
    widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.CT.tab;
    if isfield(widget.glassbrain.UserData,'userID') && ~isempty(widget.glassbrain.UserData.userID)
        autoload.field_userID.Value = widget.glassbrain.UserData.userID;
        autoload.field_userID.FontColor = [0 0 0];
        autoload.lamp_userID.Color = [0 1 0];
        autoload.label_userID.UserData.userID = autoload.field_userID.Value;
    else
        widget.glassbrain.UserData.userID = [];
    end
    if isfield(widget.glassbrain.UserData,'patientID') && ~isempty(widget.glassbrain.UserData.patientID)
        autoload.field_patientID.Value = widget.glassbrain.UserData.patientID;
        autoload.field_patientID.FontColor = [0 0 0];
        autoload.lamp_patientID.Color = [0 1 0];
        autoload.label_patientID.UserData.patientID = autoload.field_patientID.Value;
    else
        widget.glassbrain.UserData.patientID = [];
    end
    if isfield(widget.glassbrain.UserData,'patientDir') && ~isempty(widget.glassbrain.UserData.patientDir)
        [path2,path1] = fileparts(widget.glassbrain.UserData.patientDir);
        [~,path2] = fileparts(path2);
        autoload.field_patientDir.FontColor = [0.94,0.94,0.94];
        autoload.lamp_patientDir.Color = [0 1 0];
        autoload.field_patientDir.Text = ['...' filesep path2 filesep path1];
        autoload.label_patientDir.UserData.patientDir = autoload.field_patientDir.Text;
    else
        widget.glassbrain.UserData.patientDir = [];
    end
    if isfield(widget.autosave.UserData,'filePath')
        [path1,file] = fileparts(widget.autosave.UserData.filePath);
        [path2,path1] = fileparts(path1);
        [~,path2] = fileparts(path2);
        autoload.field_autosavePath.Text = [file '.mat'];
        autoload.field_autosavePath.FontColor = [0.94,0.94,0.94];
        autoload.lamp_autosaveFile.Color = [0 1 0];
        autoload.field_autosaveFile.Text = ['...' filesep path2 filesep path1];
        autoload.field_autosaveFile.FontColor = [0.94,0.94,0.94];
        autoload.field_voxelocFolder.Text = ['...' filesep path2 filesep path1];
        autoload.field_voxelocFolder.FontColor = [0.94,0.94,0.94];
        autoload.lamp_voxelocFolder.Color = [0 1 0];

        autoload.label_voxelocFolder.UserData.voxDir = autoload.field_voxelocFolder.Text;
        autoload.label_autosaveFile.UserData.autosavePath = widget.autosave.UserData.filePath;

    end

    if isfield(widget.glassbrain.UserData,'instLogoPath')
        autoload.image_instLogo.ImageSource = widget.glassbrain.UserData.instLogoPath;
        [autoload.label_instLogo.UserData.instLogoPath,autoload.label_instLogo.UserData.instLogoFile,fileExt] = ...
            fileparts(widget.glassbrain.UserData.instLogoPath);
        autoload.label_instLogo.UserData.instLogoFile = [autoload.label_instLogo.UserData.instLogoFile fileExt];
        autoload.label_instLogo.UserData.instLogoPath = [autoload.label_instLogo.UserData.instLogoPath filesep];
        autoload.image_instLogo.Visible = 'on';
        autoload.field_instLogo.Visible = 'off';
        autoload.logoI_cartouche.ImageSource = widget.glassbrain.UserData.instLogoPath;
        autoload.lamp_instLogo.Color = [0 1 0];
        widget.viewer.projectParams.tab.UserData.instLogoPath = widget.glassbrain.UserData.instLogoPath;
    end


    numSuccess = 0;
    for allElec = 1:numel(fieldnames(widget.fig.UserData))
        cElec = ['Electrode' num2str(allElec)];
        if isequal(widget.fig.UserData.(cElec).Estimation,'SUCCESS')
            numSuccess = numSuccess+1;
        end
        try
            widget.fig.UserData.(cElec).oblique.image.sliceCT_Vert.Parent = widget.viewer.oblique.ax_ctVert;
            widget.fig.UserData.(cElec).oblique.image.sliceT1_Vert.Parent = widget.viewer.oblique.ax_t1Vert;
            widget.fig.UserData.(cElec).oblique.image.sliceSEG_VertCT.Parent = widget.viewer.oblique.ax_ctVert;
            widget.fig.UserData.(cElec).oblique.image.sliceSEG_VertT1.Parent = widget.viewer.oblique.ax_t1Vert;
            widget.fig.UserData.(cElec).oblique.image.sliceCT_Hor.Parent = widget.viewer.oblique.ax_ctHor;
            widget.fig.UserData.(cElec).oblique.image.sliceT1_Hor.Parent = widget.viewer.oblique.ax_t1Hor;
            widget.fig.UserData.(cElec).oblique.image.sliceSEG_HorCT.Parent = widget.viewer.oblique.ax_ctHor;
            widget.fig.UserData.(cElec).oblique.image.sliceSEG_HorT1.Parent = widget.viewer.oblique.ax_t1Hor;
            widget.fig.UserData.(cElec).oblique.contacts.CT_Vert.Parent = widget.viewer.oblique.ax_ctVert;
            widget.fig.UserData.(cElec).oblique.contacts.T1_Vert.Parent = widget.viewer.oblique.ax_t1Vert;
            widget.fig.UserData.(cElec).oblique.contacts.CT_Hor.Parent = widget.viewer.oblique.ax_ctHor;
            widget.fig.UserData.(cElec).oblique.contacts.T1_Hor.Parent = widget.viewer.oblique.ax_t1Hor;
        catch
        end
    end

    try
        widget.viewer.oblique.slider_opacity.Value = max(max(widget.fig.UserData.(cElec).oblique.image.sliceSEG_VertT1.AlphaData))*100;
        widget.viewer.oblique.label_opacity.Text = ['Parcellation opacity: ' num2str(widget.viewer.oblique.slider_opacity.Value) '%'];
    catch
    end
    widget.viewer.panel_CentralTabsMRI.SelectedTab = currTab;
    figure(widget.fig);
    widget.viewer.logo.panel.Visible = 'off';
    widget.tree_Summary.Enable = 'on';
    widget.fig.Pointer = 'arrow';
catch
    disp('Error while loading previous autosave file...')
    widget.viewer.logo.panel.Visible = 'off';
    widget.fig.Pointer = 'arrow';
end