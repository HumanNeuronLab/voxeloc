function loadVoxelocFile(~,~,widget,autoload)
try
    if autoload == 1
        load(widget.autosave.UserData.filePath);
        widget.viewer.projectParams.field_autosaveFile.Text = 'autosave_vxlc.mat';
        widget.viewer.projectParams.field_autosaveFile.FontColor = [0 0 0];
        widget.viewer.projectParams.field_autosavePath.Text = fileparts(widget.autosave.UserData.filePath);
        widget.viewer.projectParams.field_autosavePath.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_autosaveFile.Color = [0 1 0];
    else
        try
            widget.fig.Visible = 'off';
            [file,path] = uigetfile({'*_vxlc.mat'},'Select Voxeloc autosave file',[fileparts(fileparts(widget.glassbrain.UserData.filePathCT)) filesep 'voxeloc' filesep]);
            load([path file]);
            widget.fig.Visible = 'on';
        catch
            widget.fig.Visible = 'on';
            disp([newline 'No autosave file selected...' newline]);
            return
        end
    end
    widget.viewer.logo.panel.Visible = 'on';
    widget.fig.Pointer = 'watch';
    if ~isequal(widget.glassbrain.UserData.patientID,autosave.glassbrain.patientID)
        answer1 = uiconfirm(widget.fig,...
                    ['The NIfTI and autosave files you have' ...
                        ' selected do not have the same patient ID.' ...
                        ' Please select the desired patient ID or cancel upload:'],...
                        'Patient ID conflict',...
                        'Options',{autosave.glassbrain.patientID,widget.glassbrain.UserData.patientID,'Cancel'},'DefaultOption',1,...
                        'Icon','warning');
        switch answer1
            case 'Cancel'
                disp([newline 'No autosave file selected...' newline]);
                return
            case autosave.glassbrain.patientID
                widget.glassbrain.UserData.patientID = autosave.glassbrain.patientID;
            case widget.glassbrains.Userdata.patientID
                autosave.glassbrain.patientID = widget.glassbrain.UserData.patientID;
        end
        if isequal(widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag,'CT')
            widget.viewer.panel_CentralTabsMRI.SelectedTab.Title = ...
                [widget.glassbrain.UserData.patientID ' | ' widget.glassbrain.UserData.fileNameCT];
        else
            widget.viewer.panel_CentralTabsMRI.SelectedTab.Title = ...
                [widget.glassbrain.UserData.patientID ' | ' widget.glassbrain.UserData.fileNameT1];
        end
    else
        % redundant...
        widget.glassbrain.UserData.patientID = autosave.glassbrain.patientID;
    end
    cF = dir(widget.autosave.UserData.filePath);
    widget.viewer.projectParams.field_forceSave.Text = datestr(cF.date,'HH:MM dd/mmm/yyyy');
    widget.viewer.projectParams.field_forceSave.FontColor = [0 0 0];
    widget.viewer.projectParams.field_patientID.Value = widget.glassbrain.UserData.patientID;
    widget.viewer.projectParams.field_patientID.FontColor = [0 0 0];
    widget.viewer.projectParams.lamp_patientID.Color = [0 1 0];
    widget.tree_Summary.Children.delete
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
        widget.viewer.projectParams.field_ctFile.Text = widget.glassbrain.UserData.fileNameCT;
        widget.viewer.projectParams.field_ctFile.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_ctFile.Color = [0 1 0];
        widget.viewer.projectParams.button_ctFile.BackgroundColor = [0.94 0.94 0.94];
    end
    if isfield(widget.glassbrain.UserData,'filePathCT')
        widget.viewer.projectParams.field_ctPath.Text = widget.glassbrain.UserData.filePathCT;
        widget.viewer.projectParams.field_ctPath.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_ctFile.Color = [0 1 0];
        widget.viewer.projectParams.button_ctFile.BackgroundColor = [0.94 0.94 0.94];
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
        selectFile(widget.viewer.CT.button_selectNifti,[],widget);
        widget.viewer.projectParams.field_t1File.Text = widget.glassbrain.UserData.fileNameT1;
        widget.viewer.projectParams.field_t1File.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_t1File.Color = [0 1 0];
        widget.viewer.projectParams.button_t1File.BackgroundColor = [0.94 0.94 0.94];
    end
    if isfield(widget.glassbrain.UserData,'filePathT1')
        widget.viewer.projectParams.field_t1Path.Text = widget.glassbrain.UserData.filePathT1;
        widget.viewer.projectParams.field_t1Path.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_t1File.Color = [0 1 0];
        widget.viewer.projectParams.button_ctFile.BackgroundColor = [0.94 0.94 0.94];
    end
    if isfield(widget.glassbrain.UserData,'reload')
        widget.glassbrain.UserData = rmfield(widget.glassbrain.UserData,'reload');
    end
    if isfield(widget.glassbrain.UserData,'filePathPARC')
        widget.viewer.oblique.label_niftiParc.Text = [widget.glassbrain.UserData.filePathPARC widget.glassbrain.UserData.fileNamePARC];
        widget.viewer.oblique.label_niftiParc.FontColor = [0 0 0];
        widget.viewer.oblique.button_niftiParc.BackgroundColor = [0.94,0.94,0.94];
        widget.viewer.projectParams.field_parcFile.Text = widget.glassbrain.UserData.fileNamePARC;
        widget.viewer.projectParams.field_parcFile.FontColor = [0 0 0];
        widget.viewer.projectParams.field_parcPath.Text = widget.glassbrain.UserData.filePathPARC;
        widget.viewer.projectParams.field_parcPath.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_parcFile.Color = [0 1 0];
        widget.viewer.projectParams.button_parcFile.BackgroundColor = [0.94 0.94 0.94];
    end

    if isfield(widget.glassbrain.UserData,'userID')
        widget.viewer.projectParams.field_userID.Value = widget.glassbrain.UserData.userID;
        widget.viewer.projectParams.field_userID.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_userID.Color = [0 1 0];
    elseif ~isempty(widget.viewer.projectParams.field_userID.Value)
        widget.glassbrain.UserData.userID = widget.viewer.projectParams.field_userID.Value;
    end

    if isfield(widget.glassbrain.UserData,'instLogoPath')
        widget.viewer.projectParams.field_instLogo.Visible = 'off';
        widget.viewer.projectParams.image_instLogo.Visible = 'on';
        widget.viewer.projectParams.image_instLogo.ImageSource = [widget.glassbrain.UserData.instLogoPath widget.glassbrain.UserData.instLogoFile];
        widget.viewer.projectParams.image_instLogo.Layout.Row = widget.viewer.projectParams.label_instLogo.Layout.Row;
        widget.viewer.projectParams.image_instLogo.Layout.Column = 2;
        widget.viewer.projectParams.button_instLogo.BackgroundColor = [0.94 0.94 0.94];
        widget.viewer.projectParams.lamp_instLogo.Color = [0 1 0];
    elseif isequal(widget.viewer.projectParams.image_instLogo.Visible,'on')
        cInstFile = dir(widget.viewer.projectParams.image_instLogo.ImageSource);
        widget.glassbrain.UserData.instLogoFile = cInstFile.name;
        widget.glassbrain.UserData.instLogoPath = [cInstFile.folder filesep];
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
    widget.viewer.projectParams.field_electrodes.Text = ['Completed: ' num2str(numSuccess) ' of ' num2str(allElec)];
    widget.viewer.projectParams.field_electrodes.FontColor = [0 0 0];
    if numSuccess == allElec
        widget.viewer.projectParams.lamp_electrodes.Color = [0 1 0];
    else
        widget.viewer.projectParams.lamp_electrodes.Color = [1 0 0];
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