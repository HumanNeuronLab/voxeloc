function patientIDchange(~,evt,widget)
    if isequal(evt.EventName,'ValueChanged')
        if isempty(evt.Value)
            widget.viewer.projectParams.lamp_patientID.Color = [1 0 0];
            widget.glassbrain.UserData.patientID = [];
        else
            widget.viewer.projectParams.field_patientID.FontColor = [0 0 0];
            widget.viewer.projectParams.lamp_patientID.Color = [0 1 0];
            widget.glassbrain.UserData.patientID = evt.Value;
        end
        return
    elseif isequal(evt.EventName,'ButtonPushed')
        try
            if isfield(widget.glassbrain.UserData,'filePathCT')
                cDir = uigetdir(widget.glassbrain.UserData.filePathCT,'Select patient folder');
            elseif isfield(widget.glassbrain.UserData,'filePathT1')
                cDir = uigetdir(widget.glassbrain.UserData.filePathT1,'Select patient folder');
            elseif isfield(widget.glassbrain.UserData,'patientDir')
                cDir = uigetdir(widget.glassbrain.UserData.patientDir,'Select patient folder');
            else
                cDir = uigetdir('Select patient folder');
            end
            if cDir ~= 0
                widget.glassbrain.UserData.patientDir = cDir;
                widget.viewer.projectParams.field_patientDir.Text = cDir;
                widget.viewer.projectParams.field_patientDir.FontColor = [0 0 0];
                widget.viewer.projectParams.lamp_patientDir.Color = [0 1 0];
                [~,widget.glassbrain.UserData.patientID] = fileparts(cDir);
                widget.viewer.projectParams.field_patientID.Value = widget.glassbrain.UserData.patientID;
                widget.viewer.projectParams.field_patientID.FontColor = [0 0 0];
                widget.viewer.projectParams.lamp_patientID.Color = [0 1 0];
                if ~isfolder([widget.glassbrain.UserData.patientDir filesep 'voxeloc' filesep])
                    mkdir([widget.glassbrain.UserData.patientDir filesep 'voxeloc' filesep]);
                end
            widget = widgetAutosave(widget);
            end
        catch
            cDir = uigetdir('Select patient folder');
            if cDir ~= 0
                widget.label_patientDir.UserData.patientDir = cDir;
                widget.field_patientDir.Text = cDir;
                widget.field_patientDir.FontColor = [0 0 0];
                widget.lamp_patientDir.Color = [0 1 0];
                [~,widget.label_patientID.UserData.patientID] = fileparts(cDir);
                widget.field_patientID.Value = widget.label_patientID.UserData.patientID;
                widget.field_patientID.FontColor = [0 0 0];
                widget.lamp_patientID.Color = [0 1 0];
            end
        end
        
    end
end