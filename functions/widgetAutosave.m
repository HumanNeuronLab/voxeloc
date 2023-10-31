function widget = widgetAutosave(varargin)

widget = varargin{1};
if nargin == 2
    pV = varargin{2};
    cDisplay = pV.panel.Parent;
else
    cDisplay = widget.fig;
    varargin{2} = [];
    pV = 1;
end

% CALLED FROM checkStatus, checkOblique, reorderElectrodes @keyDown & @buttonUp
if ~isfolder(widget.glassbrain.UserData.voxelocDir)
    mkdir(widget.glassbrain.UserData.voxelocDir);
end
    
    if isempty(widget.autosave.UserData.filePath)
        widget.autosave.UserData.filePath = ...
                [widget.glassbrain.UserData.voxelocDir filesep 'autosave_voxeloc.mat'];
        if isfile(widget.autosave.UserData.filePath)
            if isequal(widget.autosave.UserData.overwrite,'on')
                % proceed to autosave
                fileSave(widget,varargin{2});
                return
            else
                overwriteOpt = uiconfirm(cDisplay,...
                    ['A previous autosave file for ' widget.glassbrain.UserData.patientID ' has been found. Would you like to load the previous autosave file or start a new file?'],...
                        'Previous Autosave Found',...
                        'Options',{'Load','Start New'},'DefaultOption',1,...
                        'Icon','question');
                switch overwriteOpt
                    case 'Load'
                        % Load // load widget.autosave.UserData.filePath
                        nSrc.mssg = 'load';
                        loadVoxelocFile(nSrc,[],widget,pV);
                        widget.autosave.UserData.overwrite = 'on';
                        figure(pV.panel.Parent);
                        return
                    case 'Start New'
                        widget.autosave.UserData.overwrite = 'on';
                        fileName = [widget.glassbrain.UserData.voxelocDir filesep 'archive_autosave_' datestr(now,'HHMM_ddmmmyy') '_voxeloc.mat'];
                        copyfile(widget.autosave.UserData.filePath,fileName);
                        % proceed to overwrite
                        fileSave(widget,varargin{2})
                        return
                end
            end
        else
            widget.autosave.UserData.overwrite = 'on';
            % proceed to autosave
            fileSave(widget,varargin{2});
            return
        end
    elseif isequal(widget.autosave.UserData.overwrite,'on')
        % proceed to autosave
        fileSave(widget,varargin{2});
        return
    elseif isequal(widget.autosave.UserData.overwrite,'ignore')
        return
    elseif isequal(widget.autosave.UserData.overwrite,'off')
        errorOpt = uiconfirm(cDisplay,'Error during autosave.',...
                        'Autosave job',...
                        'Options',{'Force autosave (recommended)','Ignore autosave'},'DefaultOption',1,...
                        'Icon','warning');
        switch errorOpt
            case 'Force autosave (recommended)'
                widget.autosave.UserData.overwrite = 'on';
                % proceed to autosave
                fileSave(widget,varargin{2});
                return
            case 'Ignore autosave'
                widget.autosave.UserData.overwrite = 'ignore';
                return
        end
    else
        widget.autosave.UserData.overwrite = 'ignore';
        return
    end

    function fileSave(widget,pV)
        for i = 1:length(fieldnames(widget.fig.UserData))
            field = ['Electrode' num2str(i)];
            autosave.fig.(field) = widget.fig.UserData.(field);
            autosave.glassbrain = widget.glassbrain.UserData;
        end
        save(widget.autosave.UserData.filePath,'autosave');
        if ~isempty(pV)
            pV.field_autosavePath.Text = 'autosave_voxeloc.mat';
            pV.field_autosaveFile.FontColor = [0.94 0.94 0.94];
            pV.lamp_autosaveFile.Color = [0 1 0];
            [path1,path0] = fileparts(widget.glassbrain.UserData.voxelocDir);
            [~,path1] = fileparts(path1);
            pV.field_autosaveFile.Text = ['...' filesep path1 filesep path0];
            pV.field_autosavePath.FontColor = [0.94 0.94 0.94];
            pV.label_autosaveFile.UserData.autosavePath = [widget.glassbrain.UserData.voxelocDir filesep pV.field_autosavePath.Text];
        end
%         widget.viewer.projectParams.field_autosaveFile.Text = 'autosave_voxeloc.mat';
%         widget.viewer.projectParams.field_autosaveFile.FontColor = [0 0 0];
%         widget.viewer.projectParams.field_autosavePath.Text = fileparts(widget.autosave.UserData.filePath);
%         widget.viewer.projectParams.field_autosavePath.FontColor = [0 0 0];
%         widget.viewer.projectParams.lamp_autosaveFile.Color = [0 1 0];
%         cF = dir(widget.autosave.UserData.filePath);
%         widget.viewer.projectParams.field_forceSave.Text = datestr(cF.date,'HH:MM dd/mmm/yyyy');
%         widget.viewer.projectParams.field_forceSave.FontColor = [0 0 0];
    end


end