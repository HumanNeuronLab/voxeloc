function widget = checkStatus(field,widget,~)

    if ~isempty(widget.fig.UserData.(field).Name) && ~isempty(widget.fig.UserData.(field).numContacts)...
            && ~isempty(widget.fig.UserData.(field).contactDist) && ~isempty(widget.fig.UserData.(field).deepestCoord)...
            && ~isempty(widget.fig.UserData.(field).secondCoord) ...
            && (isempty(widget.fig.UserData.(field).Estimation) || isequal(widget.fig.UserData.(field).Estimation, 'READY'))
        widget.fig.UserData.(field).Estimation = 'READY';
        widget.params.button_estimate.BackgroundColor = [1,0.65,0];
        widget.params.button_estimate.Enable = 'on';
        widget.params.button_estimate.Text = 'Estimate';
        widget.tree.UserData.(field).electrodeName.Text = [widget.fig.UserData.(field).Name '    [ESTIMATE]'];
        if widget.mV == 1
            nElec = str2double(field(10:end));
            elecStyle = uistyle('Icon','info','IconAlignment','left','FontWeight','bold');
            currNode = widget.tree_Summary.Children(nElec);
            addStyle(widget.tree_Summary,elecStyle,"node",currNode);
        end
    elseif ~isempty(widget.fig.UserData.(field).Name) && ~isempty(widget.fig.UserData.(field).numContacts)...
            && ~isempty(widget.fig.UserData.(field).contactDist) && ~isempty(widget.fig.UserData.(field).deepestCoord)...
            && ~isempty(widget.fig.UserData.(field).secondCoord) && isequal(widget.fig.UserData.(field).Estimation,'FAILED')
        widget.params.button_estimate.BackgroundColor = [1,0.65,0];
        widget.params.button_estimate.Enable = 'on';
        widget.params.button_estimate.Text = 'Re-estimate';
        widget.tree.UserData.(field).electrodeName.Text = [widget.fig.UserData.(field).Name '    [RE-ESTIMATE]'];
        if widget.mV == 1
            nElec = str2double(field(10:end));
            elecStyle = uistyle('BackgroundColor',[1 1 1],'Icon','warning','IconAlignment','left','FontWeight','bold');
            currNode = widget.tree_Summary.Children(nElec);
            addStyle(widget.tree_Summary,elecStyle,"node",currNode);
        end
    elseif ~isempty(widget.fig.UserData.(field).Name) && ~isempty(widget.fig.UserData.(field).numContacts)...
            && ~isempty(widget.fig.UserData.(field).contactDist) && ~isempty(widget.fig.UserData.(field).deepestCoord)...
            && ~isempty(widget.fig.UserData.(field).secondCoord) && isequal(widget.fig.UserData.(field).Estimation,'RE-ESTIMATE')
        widget.params.button_estimate.BackgroundColor = [1,0.65,0];
        widget.params.button_estimate.Enable = 'on';
        widget.params.button_estimate.Text = 'Re-estimate';
        widget.tree.UserData.(field).electrodeName.Text = [widget.fig.UserData.(field).Name '    [RE-ESTIMATE]'];
        if widget.mV == 1
            if isfield(widget.glassbrain.UserData.electrodes.(field),'Color')
                bgColor = widget.glassbrain.UserData.electrodes.(field).Color;
            else
                bgColor = widget.glassbrain.UserData.ColorList(nElec,:);
            end
            nElec = str2double(field(10:end));
            elecStyle = uistyle('BackgroundColor',bgColor,...
                'Icon','info','IconAlignment','left','FontWeight','bold');
            currNode = widget.tree_Summary.Children(nElec);
            addStyle(widget.tree_Summary,elecStyle,"node",currNode);
        end
    elseif ~isempty(widget.fig.UserData.(field).Name) && ~isempty(widget.fig.UserData.(field).numContacts)...
            && ~isempty(widget.fig.UserData.(field).contactDist) && ~isempty(widget.fig.UserData.(field).deepestCoord)...
            && ~isempty(widget.fig.UserData.(field).secondCoord) && isequal(widget.fig.UserData.(field).Estimation,'SUCCESS')
        widget.params.button_estimate.BackgroundColor = [0.95,0.95,0.95];
        widget.params.button_estimate.Enable = 'off';
        widget.params.button_estimate.Text = 'Estimation successful';
        if widget.mV == 1
            if isfield(widget.glassbrain.UserData.electrodes.(field),'Color')
                bgColor = widget.glassbrain.UserData.electrodes.(field).Color;
            else
                bgColor = widget.glassbrain.UserData.ColorList(nElec,:);
            end
            nElec = str2double(field(10:end));
            elecStyle = uistyle('BackgroundColor',bgColor,...
                'Icon','success','IconAlignment','left','FontWeight','bold');
            currNode = widget.tree_Summary.Children(nElec);
            addStyle(widget.tree_Summary,elecStyle,"node",currNode);
            widget.tree.UserData.(field).electrodeName.Text = widget.fig.UserData.(field).Name;
        else
            widget.tree.UserData.(field).electrodeName.Text = ['✓ ' widget.fig.UserData.(field).Name];
        end
    else
        widget.params.button_estimate.BackgroundColor = [1,0.65,0];
        widget.params.button_estimate.Enable = 'off';
        widget.params.button_estimate.Text = 'Estimate';
    end
    if isempty(widget.fig.UserData.(field).deepestCoord)
        widget.params.button_PickDeepest.BackgroundColor = [1,0.65,0];
    else
        widget.params.button_PickDeepest.BackgroundColor = [0.95,0.95,0.95];
    end
    if isempty(widget.fig.UserData.(field).secondCoord)
        widget.params.button_PickSecond.BackgroundColor = [1,0.65,0];
    else
        widget.params.button_PickSecond.BackgroundColor = [0.95,0.95,0.95];
    end
    
    numElectrodes = length(widget.params.dropdown_ElectrodeSelector.Items);
    
    ready_check = zeros(numElectrodes,1);
    for i = 1:numElectrodes
        currField = ['Electrode' num2str(i)];
        if isequal(widget.fig.UserData.(currField).Estimation, 'SUCCESS')
            ready_check(i) = 1;
        else
            ready_check(i) = 0;
        end
    end
    widget.viewer.projectParams.field_electrodes.Text = ['Completed: ' num2str(sum(ready_check)) ' of ' num2str(numElectrodes)];
    ready_check = sum(ready_check)/numElectrodes;
    if ready_check == 1
        widget.params.button_done.Enable = 'on';
        widget.params.button_done.BackgroundColor = [1,0.65,0];
        widget.viewer.projectParams.lamp_electrodes.Color = [0 1 0];
    else
        widget.params.button_done.Enable = 'off';
        widget.params.button_done.BackgroundColor = [0.95,0.95,0.95];
        widget.viewer.projectParams.lamp_electrodes.Color = [1 0 0];
    end
    try
        cF = dir(widget.autosave.UserData.filePath);
        widget.viewer.projectParams.field_forceSave.Text = datestr(cF.date,'HH:MM dd/mmm/yyyy');
        widget.viewer.projectParams.field_forceSave.FontColor = [0 0 0];
    catch
    end

    if nargin == 2
%         for i = 1:length(fieldnames(widget.fig.UserData))
%             field = ['Electrode' num2str(i)];
%             autosave.electrode.(field) = widget.fig.UserData.(field);
%             if isfield(widget.glassbrain.UserData,'electrodes') && isfield(widget.glassbrain.UserData.electrodes,field)
%                 autosave.glassbrain.(field) = widget.glassbrain.UserData.electrodes.(field);
%             end
%         end
%         autosave.filePath = fileparts(fileparts(widget.glassbrain.UserData.filePathCT));
%         autosave.patientID = widget.glassbrain.UserData.patientID;
%         fileName = [autosave.filePath filesep autosave.patientID '_vxlc.mat'];
%         if isfile(fileName)
%             if ~isfield(widget.glassbrain.UserData,'overwrite')
%                 widget.glassbrain.UserData.overwrite = uiconfirm(widget.fig,'A previous autosave file already exists for this patient. Would you like to overwrite the previous file?',...
%                     'Overwrite autosave file',...
%                     'Options',{'Yes','No'},'DefaultOption',1,...
%                     'Icon','warning');
%             end
%             switch widget.glassbrain.UserData.overwrite
%                 case 'Yes'
%                     save(fileName,'autosave');
%             end
%         end
    end
   
end