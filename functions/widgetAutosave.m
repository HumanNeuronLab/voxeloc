 function widget = widgetAutosave(widget)

% CALLED FROM checkStatus, checkOblique, reorderElectrodes @keyDown & @buttonUp
    if ~isfield(widget.glassbrain.UserData,'patientDir')
        widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.projectParams.tab;
        message = {'No patient folder currently selected','Please select current patient folder.'};
        m = uiconfirm(widget.fig,message,'Select Patient Folder',...
            'Icon','warning','Options',{'OK'});
        artEvt.EventName = 'ButtonPushed';
        patientIDchange([],artEvt,widget);
%         if ~isfolder([widget.glassbrain.UserData.patientDir filesep 'voxeloc' filesep])
%             mkdir([widget.glassbrain.UserData.patientDir filesep 'voxeloc' filesep]);
%         end
        return
    end
    
    if isempty(widget.autosave.UserData.filePath)
        widget.autosave.UserData.filePath = ...
                [widget.glassbrain.UserData.patientDir filesep 'voxeloc' filesep 'autosave_vxlc.mat'];
        if isfile(widget.autosave.UserData.filePath)
            if isequal(widget.autosave.UserData.overwrite,'on')
                % proceed to autosave
                fileSave(widget);
                return
            else
                overwriteOpt = uiconfirm(widget.fig,...
                    ['A previous autosave file for ' widget.glassbrain.UserData.patientID ' has been found. Would you like to load the previous autosave file or start a new file?'],...
                        'Previous Autosave Found',...
                        'Options',{'Load','Start New'},'DefaultOption',1,...
                        'Icon','question');
                switch overwriteOpt
                    case 'Load'
                        % Load // load widget.autosave.UserData.filePath
                        loadVoxelocFile([],[],widget,1);
                        widget.autosave.UserData.overwrite = 'on';
                        return
                    case 'Start New'
                        widget.autosave.UserData.overwrite = 'on';
                        fileName = [widget.glassbrain.UserData.patientDir 'voxeloc' filesep 'archive_autosave_' datestr(now,'HHMM_ddmmmyy') '_vxlc.mat'];
                        copyfile(widget.autosave.UserData.filePath,fileName);
                        % proceed to overwrite
                        fileSave(widget)
                        return
                end
            end
        else
            widget.autosave.UserData.overwrite = 'on';
            % proceed to autosave
            fileSave(widget);
            return
        end
    elseif isequal(widget.autosave.UserData.overwrite,'on')
        % proceed to autosave
        fileSave(widget);
        return
    elseif isequal(widget.autosave.UserData.overwrite,'ignore')
        return
    elseif isequal(widget.autosave.UserData.overwrite,'off')
        errorOpt = uiconfirm(widget.fig,'Error during autosave.',...
                        'Autosave job',...
                        'Options',{'Force autosave (recommended)','Ignore autosave'},'DefaultOption',1,...
                        'Icon','warning');
        switch errorOpt
            case 'Force autosave (recommended)'
                widget.autosave.UserData.overwrite = 'on';
                % proceed to autosave
                fileSave(widget);
                return
            case 'Ignore autosave'
                widget.autosave.UserData.overwrite = 'ignore';
                return
        end
    else
        widget.autosave.UserData.overwrite = 'ignore';
        return
    end

    function fileSave(widget)
        for i = 1:length(fieldnames(widget.fig.UserData))
            field = ['Electrode' num2str(i)];
            autosave.fig.(field) = widget.fig.UserData.(field);
            autosave.glassbrain = widget.glassbrain.UserData;
        end
        save(widget.autosave.UserData.filePath,'autosave');
        widget.viewer.projectParams.field_autosaveFile.Text = 'autosave_vxlc.mat';
        widget.viewer.projectParams.field_autosaveFile.FontColor = [0 0 0];
        widget.viewer.projectParams.field_autosavePath.Text = fileparts(widget.autosave.UserData.filePath);
        widget.viewer.projectParams.field_autosavePath.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_autosaveFile.Color = [0 1 0];
        cF = dir(widget.autosave.UserData.filePath);
        widget.viewer.projectParams.field_forceSave.Text = datestr(cF.date,'HH:MM dd/mmm/yyyy');
        widget.viewer.projectParams.field_forceSave.FontColor = [0 0 0];
    end


end