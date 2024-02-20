function selectFile(data, ~, widget)

    tab_Viewer = widget.viewer.panel_CentralTabsMRI.SelectedTab;
    if ~isfield(widget.glassbrain.UserData,'patientDir')
        widget = widgetAutosave(widget);
        widget.viewer.panel_CentralTabsMRI.SelectedTab = tab_Viewer;
        if isequal(tab_Viewer.Tag,'CT')
            widget.params.panel_ElectrodeParams.Enable = "on";
        end
        return
    end
    volLoad = 'MRI';
    if isequal(tab_Viewer.Tag, 'oblique') && ~isequal(data.Tag, 'PARC')
        widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.(data.Tag).tab;
        tab_Viewer = widget.viewer.panel_CentralTabsMRI.SelectedTab;
    elseif isequal(tab_Viewer.Tag, 'project') && ~isequal(data.Tag, 'PARC')
        widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.(data.Tag).tab;
        tab_Viewer = widget.viewer.panel_CentralTabsMRI.SelectedTab;
    elseif isequal(data.Tag, 'PARC')
        volLoad = 'PARC';
    end

    switch volLoad
        case 'MRI'
            currTab = tab_Viewer.Tag;
            ax1 = widget.viewer.(currTab).ax_sliceView1;
            ax2 = widget.viewer.(currTab).ax_sliceView2;
            ax3 = widget.viewer.(currTab).ax_sliceView3;
            labelCslice = widget.viewer.(currTab).label_coronalSlice;
            labelSslice = widget.viewer.(currTab).label_sagittalSlice;
            labelAslice = widget.viewer.(currTab).label_axialSlice;
            labelCVI = widget.viewer.(currTab).label_coronalVI;
            labelSVI = widget.viewer.(currTab).label_sagittalVI;
            labelAVI = widget.viewer.(currTab).label_axialVI;
            labelButton = widget.viewer.(currTab).label_selectNifti;
            labelVI = widget.viewer.(currTab).label_voxelIntensity;
            panel4 = widget.viewer.(currTab).panel_sliceView4;
            volName = [currTab 'vol'];
            selectButton = widget.viewer.(currTab).button_selectNifti;
            try
               widget.viewer.(currTab).ax_sliceView1.Children.delete;
               widget.viewer.(currTab).ax_sliceView2.Children.delete;
               widget.viewer.(currTab).ax_sliceView3.Children.delete;
            catch
            end

            if isequal(currTab,'CT')
                obliqueButton = widget.viewer.oblique.button_niftiCT;
                obliqueLabel = widget.viewer.oblique.label_niftiCT;
%                 projectButton = widget.viewer.projectParams.button_ctFile;
%                 projectFile = widget.viewer.projectParams.field_ctFile;
%                 projectPath = widget.viewer.projectParams.field_ctPath;
%                 projectLamp = widget.viewer.projectParams.lamp_ctFile;
                
            elseif isequal(currTab,'T1')
                obliqueButton = widget.viewer.oblique.button_niftiT1;
                obliqueLabel = widget.viewer.oblique.label_niftiT1;
%                 projectButton = widget.viewer.projectParams.button_ctFile;
%                 projectFile = widget.viewer.projectParams.field_t1File;
%                 projectPath = widget.viewer.projectParams.field_t1Path;
%                 projectLamp = widget.viewer.projectParams.lamp_ctFile;
            end
    
        cMap = 'bone';
        crosshair_color = [1,0.65,0];
        colormap(ax1,cMap);
        colormap(ax2,cMap);
        colormap(ax3,cMap);
        widget.fig.Pointer = 'watch';
        drawnow
    
        if ~isfield(widget.glassbrain.UserData,'reload')
            if isequal(widget.viewer.CT.transform.UserData.action,'none')
                try
                    widget.fig.Visible = 'off';
                    if isfield(widget.glassbrain.UserData,'filePathCT')
                        [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',widget.glassbrain.UserData.filePathCT);
                    elseif isfield(widget.glassbrain.UserData,'filePathT1')
                        [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',widget.glassbrain.UserData.filePathT1);
                    elseif isfield(widget.glassbrain.UserData,'patientDir')
                        [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',widget.glassbrain.UserData.patientDir);
                    else
                         [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file');
                    end
                    widget.fig.Visible = 'on';
                    selectButton.BackgroundColor = [0.94,0.94,0.94];
                    obliqueButton.BackgroundColor = selectButton.BackgroundColor;
%                     projectButton.BackgroundColor = selectButton.BackgroundColor;
                    tmp_vol = MRIread([path file]);
                    widget.glassbrain.UserData.(volName) = [];
                    widget.glassbrain.UserData = rmfield(widget.glassbrain.UserData,volName);
                    widget.glassbrain.UserData.(volName) = tmp_vol.vol;
                    figure(widget.fig);
                    filePath = ['filePath' tab_Viewer.Tag];
                    widget.glassbrain.UserData.(filePath) = path;
                    fileName = ['fileName' tab_Viewer.Tag];
                    widget.glassbrain.UserData.(fileName) = file;
                    if isfield(widget.glassbrain.UserData,'patientID')
                        tab_Viewer.Title = [widget.glassbrain.UserData.patientID ' | ' file];
                    else
                        tab_Viewer.Title = file;
                    end
                    labelButton.Text = file;
                    obliqueLabel.Text = [path file];
                    obliqueLabel.FontColor = [0 0 0];
%                     projectFile.Text = file;
%                     projectFile.FontColor = [0 0 0];
%                     projectPath.Text = path;
%                     projectPath.FontColor = [0 0 0];
%                     projectLamp.Color = [0 1 0];
                    if isequal(tab_Viewer.Tag,'CT')
                        widget.autosave.UserData.filePath = [];
                    end
                    widget = widgetAutosave(widget);
                    widget.viewer.panel_CentralTabsMRI.SelectedTab = tab_Viewer;
                catch
                    widget.fig.Visible = 'on';
                    disp([newline 'No NIfTI file selected...' newline]);
                    widget.fig.Pointer = 'arrow';
                    return
                end
            elseif isequal(widget.viewer.CT.transform.UserData.action,'resetView')
                widget.viewer.CT.transform.UserData.action = 'none';
            end
        
            if isequal(tab_Viewer.Tag,'CT')% && mainView == 1
                widget.params.panel_ElectrodeParams.Enable = 'on';
                widget.tree_Summary.Enable = 'on';
                collapse(widget.tree_Summary);
                widget.params.button_PickDeepest.BackgroundColor = [1,0.65,0];
                widget.params.button_PickSecond.BackgroundColor = [1,0.65,0];
                if isfield(widget.glassbrain.UserData,'CTvolView')
                    widget.glassbrain.UserData.CTvolView = [];
                    widget.glassbrain.UserData = rmfield(widget.glassbrain.UserData,'CTvolView');
                end
            elseif isequal(tab_Viewer.Tag,'T1')% || mainView == 0
                if isfield(widget.glassbrain.UserData,'T1volView')
                    widget.glassbrain.UserData.T1volView = [];
                    widget.glassbrain.UserData = rmfield(widget.glassbrain.UserData,'T1volView');
                end
                if isequal(widget.viewer.CT.slider_contacts.Visible,'on')
                   for i = 1:length(tab_Viewer.Children)
                        indexer4(i) = {tab_Viewer.Children(i).Tag};
                    end
                    paramsPanel = find(contains(indexer4,'slice params panel'));
                    for i = 1:length(tab_Viewer.Children(paramsPanel).Children)
                        indexer5(i) = {tab_Viewer.Children(paramsPanel).Children(i).Tag};
                    end
                    sliderContact = find(contains(indexer5,'Contact slider'));
                    labelContact = find(contains(indexer5,'Contact label'));
                    widget.viewer.T1.slider_contacts.Limits = widget.viewer.CT.slider_contacts.Limits;
                    widget.viewer.T1.slider_contacts.Value = widget.viewer.CT.slider_contacts.Value;
                    widget.viewer.T1.slider_contacts.MajorTicks = widget.viewer.CT.slider_contacts.MajorTicks;
                    widget.viewer.T1.label_contacts.Text = widget.viewer.CT.label_contacts.Text;
                    widget.viewer.CT.label_contacts.Visible = 'on';
                    widget.viewer.T1.slider_contacts.Visible = 'on';
                end
            end
        end
        
        vol_size = size(widget.glassbrain.UserData.(volName));
        ax1.XLim = [0,vol_size(2)];
        ax1.YLim = [0,vol_size(1)];
        ax2.XLim = [0,vol_size(3)];
        ax2.YLim = [0,vol_size(1)];
        ax3.XLim = [0,vol_size(2)];
        ax3.YLim = [0,vol_size(3)];
    
        slice_selection = ceil(vol_size(3)/2+1);
        labelVI.Text = ['Voxel density: ' ...
            mat2str(round(widget.glassbrain.UserData.(volName)(slice_selection,slice_selection,slice_selection)))];
        labelCVI.Text = labelVI.Text;
        labelCslice.Text = ['Coronal Slice: ' mat2str([slice_selection,slice_selection,slice_selection])];
        
        labelSVI.Text = labelVI.Text;
        labelSslice.Text = ['Sagittal Slice: ' mat2str([slice_selection,slice_selection,slice_selection])];
        
        labelAVI.Text = labelVI.Text;
        labelAslice.Text = ['Axial Slice: ' mat2str([slice_selection,slice_selection,slice_selection])];
    
        coronal_slice = widget.glassbrain.UserData.(volName)(:,:,slice_selection);
        sagittal_slice = widget.glassbrain.UserData.(volName)(:,slice_selection,:);
        sagittal_slice = reshape(sagittal_slice,[vol_size(1),vol_size(3)]);
        axial_slice = widget.glassbrain.UserData.(volName)(slice_selection,:,:);
        axial_slice = reshape(axial_slice,[vol_size(2),vol_size(3)]);
        axial_slice = rot90(axial_slice);
        
        widget.viewer.(tab_Viewer.Tag).coronal_image = imagesc('Parent',ax1,'CData',coronal_slice,'Tag',num2str(slice_selection));
        widget.viewer.(tab_Viewer.Tag).coronal_crosshair = drawcrosshair(ax1,'Position',[ceil(vol_size(2)/2+1),ceil(vol_size(1)/2+1)],...
            'Color',crosshair_color,'LineWidth',1.5,'Tag','coronal_crosshair');
        widget.viewer.(tab_Viewer.Tag).sagittal_image = imagesc('Parent',ax2,'CData',sagittal_slice,'Tag',num2str(slice_selection));
        widget.viewer.(tab_Viewer.Tag).sagittal_crosshair = drawcrosshair(ax2,'Position',[ceil(vol_size(2)/2+1),ceil(vol_size(1)/2+1)],...
            'Color',crosshair_color,'LineWidth',1.5,'Tag','sagittal_crosshair');
        widget.viewer.(tab_Viewer.Tag).axial_image = imagesc('Parent',ax3,'CData',axial_slice,'Tag',num2str(slice_selection));
        widget.viewer.(tab_Viewer.Tag).axial_crosshair = drawcrosshair(ax3,'Position',[ceil(vol_size(2)/2+1),ceil(vol_size(1)/2+1)],...
            'Color',crosshair_color,'LineWidth',1.5,'Tag','axial_crosshair');
    
        for i = 1:length(panel4.Children)
            tag{i} = panel4.Children(i).Tag; %#ok<AGROW> 
        end
    
        X_idx = find(contains(tag,'X'));
        for i = X_idx
            if contains(tag(i),'field')
                panel4.Children(i).Enable = 'on';
                panel4.Children(i).Value = slice_selection;
                p.field_X = panel4.Children(i);
            elseif contains(tag(i), 'slider')
                panel4.Children(i).Limits = [1,vol_size(2)];
                panel4.Children(i).Enable = 'on';
                panel4.Children(i).Value = slice_selection;
                p.slider_X = panel4.Children(i);
            else
                panel4.Children(i).Enable = 'on';
            end
        end
    
        Y_idx = find(contains(tag,'Y'));
        for i = Y_idx
            if contains(tag(i),'field')
                panel4.Children(i).Enable = 'on';
                panel4.Children(i).Value = slice_selection;
                p.field_Y = panel4.Children(i);
            elseif contains(tag(i), 'slider')
                panel4.Children(i).Limits = [1,vol_size(1)];
                panel4.Children(i).Enable = 'on';
                panel4.Children(i).Value = slice_selection;
                p.slider_Y = panel4.Children(i);
            else
                panel4.Children(i).Enable = 'on';
            end
        end
    
        Z_idx = find(contains(tag,'Z'));
        for i = Z_idx
            if contains(tag(i),'field')
                panel4.Children(i).Enable = 'on';
                panel4.Children(i).Value = slice_selection;
                p.field_Z = panel4.Children(i);
            elseif contains(tag(i), 'slider')
                panel4.Children(i).Limits = [1,vol_size(3)];
                panel4.Children(i).Enable = 'on';
                panel4.Children(i).Value = slice_selection;
                p.slider_Z = panel4.Children(i);
            else
                panel4.Children(i).Enable = 'on';
            end
        end
    
        drawnow
        widget.fig.Pointer = 'arrow';
        widget.viewer.CT.button_resetView.Enable = 'on';
%         widget.viewer.CT.button_load.Enable = 'on';
        widget = contactDotDisplay(widget);
        
        addlistener(widget.viewer.(tab_Viewer.Tag).coronal_crosshair,'MovingROI',@(src,data)crossDrag...
            (src,data,widget.glassbrain.UserData.(volName),vol_size,labelVI,ax1,ax2,ax3,...
            labelCslice,labelSslice,labelAslice,labelCVI,labelSVI,labelAVI,widget.viewer.(tab_Viewer.Tag).coronal_image,...
            widget.viewer.(tab_Viewer.Tag).sagittal_image,widget.viewer.(tab_Viewer.Tag).sagittal_crosshair,widget.viewer.(tab_Viewer.Tag).axial_image,widget.viewer.(tab_Viewer.Tag).axial_crosshair,p,widget));
        addlistener(widget.viewer.(tab_Viewer.Tag).sagittal_crosshair,'MovingROI',@(src,data)crossDrag...
            (src,data,widget.glassbrain.UserData.(volName),vol_size,labelVI,ax1,ax2,ax3,...
            labelCslice,labelSslice,labelAslice,labelCVI,labelSVI,labelAVI,widget.viewer.(tab_Viewer.Tag).sagittal_image,...
            widget.viewer.(tab_Viewer.Tag).coronal_image,widget.viewer.(tab_Viewer.Tag).coronal_crosshair,widget.viewer.(tab_Viewer.Tag).axial_image,widget.viewer.(tab_Viewer.Tag).axial_crosshair,p,widget));
        addlistener(widget.viewer.(tab_Viewer.Tag).axial_crosshair,'MovingROI',@(src,data)crossDrag...
            (src,data,widget.glassbrain.UserData.(volName),vol_size,labelVI,ax1,ax2,ax3,...
            labelCslice,labelSslice,labelAslice,labelCVI,labelSVI,labelAVI,widget.viewer.(tab_Viewer.Tag).axial_image,...
            widget.viewer.(tab_Viewer.Tag).coronal_image,widget.viewer.(tab_Viewer.Tag).coronal_crosshair,widget.viewer.(tab_Viewer.Tag).sagittal_image,widget.viewer.(tab_Viewer.Tag).sagittal_crosshair,p,widget));

        case 'PARC'
            obliqueButton = widget.viewer.oblique.button_niftiParc;
            obliqueLabel = widget.viewer.oblique.label_niftiParc;
            try
                widget.fig.Visible = 'off';
                if isfield(widget.glassbrain.UserData,'filePathCT')
                        [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',widget.glassbrain.UserData.filePathCT);
                elseif isfield(widget.glassbrain.UserData,'filePathT1')
                        [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',widget.glassbrain.UserData.filePathT1);
                elseif isfield(widget.glassbrain.UserData,'filePathPARC')
                    [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file',widget.glassbrain.UserData.filePathPARC);
                else
                     [file,path] = uigetfile({'*.nii;*.mgh;*.mgz'},'Select NIfTI file');
                end
                widget.fig.Visible = 'on';
                obliqueButton.BackgroundColor = [0.94,0.94,0.94];
%                 widget.viewer.projectParams.button_parcFile.BackgroundColor = [0.94,0.94,0.94];
%                 widget.viewer.projectParams.lamp_parcFile.Color = [0 1 0];
                tmp_vol = MRIread([path file]);
                widget.glassbrain.UserData.PARCvol = tmp_vol.vol;
                figure(widget.fig);
                filePath = 'filePathPARC';
                widget.glassbrain.UserData.(filePath) = path;
                fileName = 'fileNamePARC';
                widget.glassbrain.UserData.(fileName) = file;
                [~,widget.glassbrain.UserData.patientID] = fileparts(fileparts(fileparts(path)));
                obliqueLabel.Text = [path file];
                obliqueLabel.FontColor = [0 0 0];
                widget.fig.Pointer = 'arrow';
%                 widget.viewer.projectParams.field_parcFile.Text = file;
%                 widget.viewer.projectParams.field_parcFile.FontColor = [0 0 0];
%                 widget.viewer.projectParams.field_parcPath.Text = path;
%                 widget.viewer.projectParams.field_parcPath.FontColor = [0 0 0];
                try
                    checkOblique(widget,'reslice');
                catch
                end
            catch
                widget.fig.Visible = 'on';
                disp([newline 'No NIfTI file selected...' newline]);
                widget.fig.Pointer = 'arrow';
                return
            end
    end
end