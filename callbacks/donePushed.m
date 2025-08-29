function donePushed(~,~,widget,fig,pos)
    
    d = uiprogressdlg(fig,'Title','Exporting your data...',...
        'Indeterminate','on');
    drawnow;
    
    path = fileparts(widget.autosave.UserData.filePath);
    if ~isfolder(path)
        mkdir(path);
    end
    cd(path);
    filenameMGRID = [widget.glassbrain.UserData.patientID '.mgrid'];
    cfg.elecCoord = [];
    counter = 1;
        
    for i = 1:widget.params.spinner_NumElectrodes.Value
        field = ['Electrode' num2str(i)];
        voxelocOutput.electrodes.(field) = widget.fig.UserData.(field);
        if isfield(widget.glassbrain.UserData,'electrodes') && isfield(widget.glassbrain.UserData.electrodes,field)
            voxelocOutput.electrodes.(field).Color = widget.glassbrain.UserData.electrodes.(field).Color;
        end
        cfg.elecCoord = [cfg.elecCoord;widget.fig.UserData.(field).contact];
        for j = 1:height(widget.fig.UserData.(field).contact)
            cfg.elecNames{counter,1} = [widget.fig.UserData.(field).Name(4:end) num2str(j)];
            cfg.elecType{counter,1} = widget.fig.UserData.(field).Name(2);
            cfg.elecHem{counter,1} = widget.fig.UserData.(field).Name(1);
            counter = counter +1;
        end
    end

    for z = 1:widget.params.spinner_NumElectrodes.Value
        field = ['Electrode' num2str(z)];
        final_outputData.(field) = widget.fig.UserData.(field);
        final_outputData.(field).Color = widget.glassbrain.UserData.electrodes.(field).Color;
        name_list(z) = {['    - ' final_outputData.(field).Name '\n']}; %#ok<AGROW>
    end

    saveMGRID(final_outputData,[path filesep filenameMGRID],widget.glassbrain.UserData.patientID);

    if isfield(widget.glassbrain.UserData,'PARCvol') && isfield(widget.glassbrain.UserData.electrodes,'Electrode1')
        cfg.parcVol = widget.glassbrain.UserData.PARCvol;
        cfg.parcPath = widget.glassbrain.UserData.filePathPARC;
        cfg.filePath = path;
        cfg.dataType = 'Voxeloc';
        cfg.parcType = 'DK';
        [elecTable,tissueLabels,tissueWeights] = SEEG2parc(cfg);
    end
    counter = 1;
    for i = 1:widget.params.spinner_NumElectrodes.Value
        field = ['Electrode' num2str(i)];
        for j = 1:height(widget.fig.UserData.(field).contact)
            voxelocOutput.electrodes.(field).tissueLabels{j,:} = string(tissueLabels{counter,:});
            voxelocOutput.electrodes.(field).tissueWeights{j,:} = tissueWeights{counter,:};
            counter = counter +1;
        end
    end

    voxelocOutput.filePath = [path filesep];
    voxelocOutput.patientID = widget.glassbrain.UserData.patientID;
    filenameMAT = [voxelocOutput.filePath voxelocOutput.patientID '_' datestr(now,'HHMM_ddmmmyy') '_voxeloc.mat'];
    save(filenameMAT,'voxelocOutput');


    % close the dialog box
    close(d)
    outputBIDS = uiconfirm(widget.fig,...
                    'Would you like to output to BIDS format?',...
                        'BIDS output',...
                        'Options',{'Yes','No'},'DefaultOption',1,...
                        'Icon','question');
    if isequal(outputBIDS,'Yes')
        if exist('tissueWeights')
            convertToBids(widget.params.spinner_NumElectrodes.Value,widget, voxelocOutput);
        else
            convertToBids(widget.params.spinner_NumElectrodes.Value,widget);
        end
    end

    w = 1;
    if endsWith(widget.glassbrain.UserData.filePathCT,filesep)
        widget.glassbrain.UserData.filePathCT = fileparts(widget.glassbrain.UserData.filePathCT);
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'rh.pial-outer-smoothed'])
        prjctCheck(1) = 1;
    else
        prjctCheck(1) = 0;
        mssg(w) = {['   surf' filesep 'rh.pial-outer-smoothed' newline]};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'lh.pial-outer-smoothed'])
        prjctCheck(2) = 1;
    else
        prjctCheck(2) = 0;
        mssg(w) = {['   surf' filesep 'lh.pial-outer-smoothed' newline]};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'rh.pial'])
        prjctCheck(3) = 1;
    else
        prjctCheck(3) = 0;
        mssg(w) = {['   surf' filesep 'rh.pial' newline]};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'lh.pial'])
        prjctCheck(4) = 1;
    else
        prjctCheck(4) = 0;
        mssg(w) = {['   surf' filesep 'lh.pial' newline]};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'rh.inflated'])
        prjctCheck(5) = 1;
    else
        prjctCheck(5) = 0;
        mssg(w) = {['   surf' filesep 'rh.inflated' newline]};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'lh.inflated'])
        prjctCheck(6) = 1;
    else
        prjctCheck(6) = 0;
        mssg(w) = {['   surf' filesep 'lh.inflated' newline]};
    end

    if all(prjctCheck)
        global globalFsDir;
        if ~isempty(globalFsDir)
            global tmpStoreFsDir;
            tmpStoreFsDir = globalFsDir;
        end
        globalFsDir = fileparts(fileparts(widget.glassbrain.UserData.filePathCT(1:end-1)));
        dykstraElecPjct_E(widget.glassbrain.UserData.patientID);
    
        if exist('tmpStoreFsDir','var')
            globalFsDir = tmpStoreFsDir;
        end
    else
        fprintf(1,['\n\n<strong>iELVis surface projection and visual outputs using ' ...
            'Dykstra Projection method impossible.</strong>\n\n']);
        fprintf(['Missing files from <strong>%s </strong>\n\n%s \n\n\n'],fileparts(fileparts(widget.glassbrain.UserData.filePathCT)),[mssg{:}]);
    end

    
    if exist([widget.glassbrain.UserData.filePathCT 'localization_process_' datestr(now,'yyyy-mm-dd') '.log'],'file')
        copyfile([widget.glassbrain.UserData.filePathCT 'localization_process_' datestr(now,'yyyy-mm-dd') '.log'],...
            [path filesep 'localization_process_' datestr(now,'yyyy-mm-dd') '.log']);
    end

    fprintf(1,'<strong>Electrode localization successful for:</strong>\n\n');
    fprintf(['<strong>' name_list{:} '</strong> \n\n\n']);

    [~,oName,oExt] = fileparts(filenameMAT);
    linkText = ['Your data has been exported to:' newline newline oName oExt];
    
    uialert(widget.fig,linkText,'Success!','Icon','success');
    
    
%         close(fig);

end