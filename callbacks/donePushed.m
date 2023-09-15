function donePushed(~,~,widget,fig,pos)
    
    path = fileparts(widget.autosave.UserData.filePath);
    if ~isfolder(path)
        mkdir(path);
    end
    cd(path);
    filenameMGRID = [widget.glassbrain.UserData.patientID '.mgrid'];
        
    for i = 1:widget.params.spinner_NumElectrodes.Value
        field = ['Electrode' num2str(i)];
        autosave.electrode.(field) = widget.fig.UserData.(field);
        if isfield(widget.glassbrain.UserData,'electrodes') && isfield(widget.glassbrain.UserData.electrodes,field)
            autosave.glassbrain.(field) = widget.glassbrain.UserData.electrodes.(field);
        end
    end
    autosave.filePath = [path filesep];
    autosave.patientID = widget.glassbrain.UserData.patientID;
    filenameMAT = [autosave.filePath autosave.patientID '_' datestr(now,'HHMM_ddmmmyy') '_vxlc.mat'];
    save(filenameMAT,'autosave');

    for z = 1:widget.params.spinner_NumElectrodes.Value
        field = ['Electrode' num2str(z)];
        final_outputData.(field) = widget.fig.UserData.(field);
        final_outputData.(field).Color = widget.glassbrain.UserData.electrodes.(field).Color;
        name_list(z) = {['    - ' final_outputData.(field).Name '\n']}; %#ok<AGROW>
    end

    saveMGRID(final_outputData,[path filesep filenameMGRID],widget.glassbrain.UserData.patientID);

    outputBIDS = uiconfirm(widget.fig,...
                    'Would you like to output to BIDS format?',...
                        'BIDS output',...
                        'Options',{'Yes','No'},'DefaultOption',1,...
                        'Icon','question');
    if isequal(outputBIDS,'Yes')
        convertToBids(widget.params.spinner_NumElectrodes.Value,widget);
    end

    w = 1;
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'rh.pial-outer-smoothed'])
        prjctCheck(1) = 1;
    else
        prjctCheck(1) = 0;
        mssg(w) = {['   surf' filesep 'rh.pial-outer-smoothed\n']};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'lh.pial-outer-smoothed'])
        prjctCheck(2) = 1;
    else
        prjctCheck(2) = 0;
        mssg(w) = {['   surf' filesep 'lh.pial-outer-smoothed\n']};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'rh.pial'])
        prjctCheck(3) = 1;
    else
        prjctCheck(3) = 0;
        mssg(w) = {['   surf' filesep 'rh.pial\n']};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'lh.pial'])
        prjctCheck(4) = 1;
    else
        prjctCheck(4) = 0;
        mssg(w) = {['   surf' filesep 'lh.pial\n']};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'rh.inflated'])
        prjctCheck(5) = 1;
    else
        prjctCheck(5) = 0;
        mssg(w) = {['   surf' filesep 'rh.inflated\n']};
        w = w+1;
    end
    if isfile([fileparts(fileparts(widget.glassbrain.UserData.filePathCT))...
            filesep 'surf' filesep 'lh.inflated'])
        prjctCheck(6) = 1;
    else
        prjctCheck(6) = 0;
        mssg(w) = {['   surf' filesep 'lh.inflated\n']};
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
        fprintf(['Missing files from:<strong>' fileparts(fileparts(widget.glassbrain.UserData.filePathCT)) '</strong>\n\n' mssg{:} ' \n\n\n']);
    end

    
    if exist([widget.glassbrain.UserData.filePathCT 'localization_process_' datestr(now,'yyyy-mm-dd') '.log'],'file')
        copyfile([widget.glassbrain.UserData.filePathCT 'localization_process_' datestr(now,'yyyy-mm-dd') '.log'],...
            [path filesep 'localization_process_' datestr(now,'yyyy-mm-dd') '.log']);
    end

    fprintf(2,'\n\nElectrode localization successful for:\n\n');
    fprintf(['<strong>' name_list{:} '</strong> \n\n\n']);
    
%         close(fig);

end