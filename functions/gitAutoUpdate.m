function gitAutoUpdate
    try
        % Test if there is an internet connection
        java.net.InetAddress.getByName('www.google.com');
    catch
        return
    end

     % Test if git is installed
    [status,~] = system('git');
    if status == 0
         disp(['Try installing Git to get automatic ' ...
            'Voxeloc bug fixes and updates!']);
         return
    end

    % Get directory to current  script
    currDir = pwd;
    scriptPath = fileparts(which('voxeloc.m'));
    cd(scriptPath);

    % Test if there is not already a git folder
    if ~isfolder([scriptPath filesep '.git'])
        system(['git init ' scriptPath ' -b main']);
    end

    [~,~] = system(['git remote add origin ' ...
        'https://github.com/HumanNeuronLab/voxeloc.git']);
    [~,gitFetch] = system('git fetch --dry-run');
    if ~isempty(gitFetch) || isfile([scriptPath filesep '.updater'])
        fid                 = fopen([scriptPath filesep 'readme.txt']);
        readMeText          = fscanf(fid,'%s');
        vStr                = 'CurrentVersion:';
        idx                 = strfind(readMeText,vStr);
        wVersion       = readMeText(idx+length(vStr):idx+length(vStr)+2);
        if isfile([scriptPath filesep '.updater'])
            !rm -rf .updater
        end
        opts.Interpreter = 'tex';
        opts.Default = 'Pull latest version';
        quest = '\fontsize{10}A new version of Voxeloc exists!';
        answer1 = questdlg(quest, ...
	    'Voxeloc Update Check', ...
	    'Pull latest version','Not this time',opts);
        switch answer1
            case 'Pull latest version'
                [~,gitPull] = system('git pull origin main');
                if contains(gitPull,['error: Your local changes to the '...
                        'following files would be overwritten by merge:'])
                    opts.Interpreter = 'tex';
                    opts.Default = 'Copy current version into archive';
                    quest = ['\fontsize{10}What would you like to do with ' ...
                        'modifications made in current version of Voxeloc?'];
                    answer2 = questdlg(quest, ...
	                'Voxeloc Update Conflict', ...
	                'Copy current version into archive',...
                    'Overwrite all files with new version',...
                    'Cancel update',opts);
                    switch answer2
                        case 'Cancel update'
                            fprintf(2,['\n\n<strong>Current version (v' ...
                                wVersion ') of Voxeloc is not ' ...
                                'up-to-date.</strong>\n\n']);
                            !echo UpdateCancelled >> .updater
                            return
                        case 'Overwrite all files with new version'
                            opts.Interpreter = 'tex';
                            opts.Default = 'Cancel';
                            quest = '\fontsize{10}WARNING: You are about to overwrite current version of Voxeloc!';
                            answer3 = questdlg(quest, ...
	                        'Voxeloc Update Overwrite', ...
	                        'Yes, I confirm',...
                            'Cancel',opts);
                            switch answer3
                                case 'Yes, I confirm'
                                    !git reset --hard origin/main
                                case 'Cancel'
                                    fprintf(2,['\n\n<strong>Current version (v' wVersion ...
                                        ') of Voxeloc is not up-to-date.</strong>\n\n']);
                                    !echo UpdateCancelled >> .updater
                                    return
                            end
                        case 'Copy current version into archive'
                            % Create ARCHIVE folder if non-existent
                            if ~isfolder([scriptPath filesep 'ARCHIVE'])
                                mkdir(scriptPath, 'ARCHIVE');
                            end
                            incrNumb = 1;
                            % Create version-modulated subfolder
                            wVersion(2) = '_';
                            archDir = ['V_' wVersion 'x' num2str(incrNumb)];
                            while isfolder(['ARCHIVE' filesep archDir])
                                incrNumb = incrNumb + 1;
                                archDir = ['V_' wVersion 'x' num2str(incrNumb)];
                            end
                            mkdir([scriptPath '/ARCHIVE'], archDir);
                            %Create list of files to copy and not copy
                            listDir = dir(scriptPath);
                            j = 1;
                            for i = 1:length(listDir)
                                if ~isequal(listDir(i).name, 'ARCHIVE') && ...
                                        ~startsWith(listDir(i).name, '.')
                                    listCopy{j} = listDir(i).name; %#ok<AGROW> 
                                    j = j+1;
                                end
                            end
                            for i = 1:length(listCopy)
                                if isfolder([scriptPath filesep listCopy{i}])
                                    copyfile([scriptPath filesep listCopy{i}],...
                                    [scriptPath filesep 'ARCHIVE' filesep archDir filesep listCopy{i}]);
                                else
                                    copyfile([scriptPath filesep listCopy{i}],...
                                        [scriptPath filesep 'ARCHIVE' filesep archDir]);
                                end
                            end
                            fprintf(['\n\nArchive folder created: ' scriptPath filesep 'ARCHIVE' filesep archDir '\n\n']);
                            !git reset --hard origin/main
                    end
                end
                cd(currDir);
                fid = fopen([scriptPath filesep 'readme.txt']);
                readMeText = fscanf(fid,'%s');
                vStr = 'CurrentVersion:';
                idx = strfind(readMeText,vStr);
                widgetVersion = readMeText(idx+length(vStr):idx+length(vStr)+2);
                fprintf(['\n\n<strong>Current version (v' widgetVersion ...
                    ') of Voxeloc is up-to-date!</strong>\n\n']);
            case 'Not this time'
                fprintf(2,['\n\n<strong>Current version (v' wVersion ...
                    ') of Voxeloc is not up-to-date.</strong>\n\n']);
                !echo UpdateCancelled >> .updater
                return
        end

    else
        cd(currDir);
        fid = fopen([scriptPath filesep 'readme.txt']);
        readMeText = fscanf(fid,'%s');
        vStr = 'CurrentVersion:';
        idx = strfind(readMeText,vStr);
        widgetVersion = readMeText(idx+length(vStr):idx+length(vStr)+2);
        fprintf(['\n\n<strong>Current version (v' widgetVersion ...
            ') of Voxeloc is up-to-date!</strong>\n\n']);
    end
end
