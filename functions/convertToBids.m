function convertToBids(numElecs,widget)
    if nargin == 0
        numElecs = randi(15);
        for j = 1:numElecs
            listElecs{j,1} = ['Electrode' num2str(j)];
        end
    else
        for m = 1:numElecs
            cElec = ['Electrode' num2str(m)];
            listElecs{m,1} = widget.fig.UserData.(cElec).Name;
            listElecs{m,2} = widget.fig.UserData.(cElec).contact;
        end
    end

    %%% MAKE TSV AND JSON FILES ACTUALLY MEAN SOMETHING
    %%% COPY ANAT VOLUMES ETC
    
    vecElecs = 1:numElecs;
    strElecs = "";
    for m = 1:numElecs
        strElecs = append(strElecs,sprintf("<font style='color:crimson;'>%d\t</font>",vecElecs(m)));
    end

    fig = uifigure('Position',[200 100 600 700],'Name','VOXELOC BIDS Exporting');
    labelBidsExist = uilabel('Parent',fig,'Position',[20 fig.Position(4)-50 fig.Position(3)-40 22],...
        'Text','Does a BIDS folder already exist for this project?');
    toggleBidsExist = uiswitch('Parent',fig,'Items',{'Yes','No'},...
        'ItemsData',[1 0],'Value',0,'Position',[50 labelBidsExist.Position(2)-30 fig.Position(3)-40 22]);
    labelCreateBids = uilabel('Parent',fig,'Position',[20 toggleBidsExist.Position(2)-50 fig.Position(3)-40 22],...
        'Text',"Select where to create the project's BIDS folder:");
    labelSelectBids = uilabel('Parent',fig,'Position',[20 toggleBidsExist.Position(2)-50 fig.Position(3)-40 22],...
        'Text','Select existing BIDS folder location:','Visible','off');
    buttonCreateBids = uibutton('Parent',fig,'Position',[20 labelCreateBids.Position(2)-30 50 22],...
        'Text','Select','BackgroundColor',[1,0.65,0]);
    labelPath = uilabel('Parent',fig,'Position',[100 labelCreateBids.Position(2)-30 fig.Position(3)-120 22],...
        'Text','[PATH]','FontColor',[0.6 0.6 0.6],'Tag','false');

    panelBidsParams = uipanel('Parent',fig,'Position',[20 20 fig.Position(3)-40 labelPath.Position(2)-40]);
    labelProjectName = uilabel('Parent',panelBidsParams,'Position',[20 panelBidsParams.Position(4)-40 150 22],...
        'Text','Project name:');
    fieldProjectName = uieditfield('text','Parent',panelBidsParams,'FontColor',[0.8 0.8 0.8],...
        'Position',[20 labelProjectName.Position(2)-30 150 22],'Placeholder','ProjectName','Tag','false',...
        'Tooltip','Project name may only contain alphanumeric characters to comply with BIDS formatting.');
    labelSubjectID = uilabel('Parent',panelBidsParams,'Position',[190 panelBidsParams.Position(4)-40 150 22],...
        'Text','Subject ID:'); %#ok<NASGU> 
    fieldSubjectID = uieditfield('text','Parent',panelBidsParams,'FontColor',[0.8 0.8 0.8],...
        'Position',[190 labelProjectName.Position(2)-30 150 22],'Placeholder','SubjectID','Tag','false',...
        'Tooltip','Subject ID may only contain alphanumeric characters to comply with BIDS formatting.');
    labelSession = uilabel('Parent',panelBidsParams,'Position',[360 panelBidsParams.Position(4)-40 150 22],...
        'Text','Session (optional):'); %#ok<NASGU> 
    fieldSession = uieditfield('text','Parent',panelBidsParams,'FontColor',[0.8 0.8 0.8],...
        'Position',[360 labelProjectName.Position(2)-30 150 22],'Placeholder','(session)','Tag','false',...
        'Tooltip','Session field may only contain alphanumeric characters to comply with BIDS formatting.');
    labelBIDSfolder = uilabel('Parent',panelBidsParams,'Position',[20 fieldSession.Position(2)-40 fig.Position(3)-80 22],...
        'Text',"<font style='color:dimgray;'>.../</font><font style='color:crimson;'>[ProjectName]</font><font style='color:dimgray;'>/sub-</font><font style='color:crimson;'>[SubjectID]</font><font style='color:dimgray;'>/ieeg",'Interpreter','html');
    labelCoordSystem = uilabel('Parent',panelBidsParams,'Position',[20 labelBIDSfolder.Position(2)-40 150 22],...
        'Text',sprintf('Coordinate System:'));
    fieldCoordSystem = uidropdown('Parent',panelBidsParams,...
        'Items',{'Pixels', 'ACPC', 'Other', 'ICBM452AirSpace', 'ICBM452Warp5Space',...
        'IXI549Space', 'fsaverage', 'fsaverageSym', 'fsLR', 'MNIColin27',...
        'MNI152Lin', 'MNI152NLin2009aSym', 'MNI152NLin2009bSym', 'MNI152NLin2009cSym',...
        'MNI152NLin2009aAsym', 'MNI152NLin2009bAsym', 'MNI152NLin2009cAsym', 'MNI152NLin6Sym',...
        'MNI152NLin6ASym', 'MNI305', 'NIHPD', 'OASIS30AntsOASISAnts', 'OASIS30Atropos',...
        'Talairach', 'UNCInfant', 'fsaverage3', 'fsaverage4', 'fsaverage5',...
        'fsaverage6', 'fsaveragesym', 'UNCInfant0V21', 'UNCInfant1V21', 'UNCInfant2V21',...
        'UNCInfant0V22', 'UNCInfant1V22', 'UNCInfant2V22', 'UNCInfant0V23', 'UNCInfant1V23',...
        'UNCInfant2V23'},'Value','fsaverage',...
        'Position',[labelCoordSystem.Position(1)+labelCoordSystem.Position(3)+20 labelCoordSystem.Position(2) 150 22],'Tag','true');
    iconHelp3 = uiimage('Parent',panelBidsParams,'ImageSource',[fileparts(which('voxeloc.m')) filesep 'assets' filesep 'help.png'],...
        'Position',[fieldCoordSystem.Position(1)+fieldCoordSystem.Position(3)+20 fieldCoordSystem.Position(2) 20 20],...
        'Tooltip','If using standard FreeSurfer pre-processing pipeline, select "fsaverage".'); %#ok<NASGU> 
    checkAllElec = uicheckbox('Parent',panelBidsParams,'Value',1,'Text','Use same parameters for all electrodes',...
        'Position',[20 labelCoordSystem.Position(2)-40 fig.Position(3)-80 22]);

    panelElecParams = uipanel('Parent',panelBidsParams,'Position',[20 20 panelBidsParams.Position(3)-40 checkAllElec.Position(2)-40]);
    labelStrElecs = uilabel('Parent',panelElecParams,'Position',[10 panelElecParams.Position(4)-40 panelElecParams.Position(3)-20 22],...
        'Text',strElecs,'Interpreter','html','HorizontalAlignment','center','Enable','off','Tag','false');
    labelElecName = uilabel('Parent',panelElecParams,'Position',[10 labelStrElecs.Position(2)-40 panelElecParams.Position(3)-20 30],...
        'Text','ALL ELECTRODES','FontWeight','bold','FontSize',20,'HorizontalAlignment','center','Enable','off','Tag','all');
    buttonPrev = uibutton('push','Parent',panelElecParams,'Position',[round(panelElecParams.Position(3)*0.25-11) labelStrElecs.Position(2)-40 22 22],...
        'Text','<','Enable','off');
    buttonNext = uibutton('push','Parent',panelElecParams,'Position',[round(panelElecParams.Position(3)*0.75-11) labelStrElecs.Position(2)-40 22 22],...
        'Text','>','Enable','off');
    labelElecSurface = uilabel('Parent',panelElecParams,'Position',[20 buttonPrev.Position(2)-50 250 22],...
        'Text',sprintf('Contact surface (mm^2):')); %(mm^{2}):')),'Interpreter','tex');
    fieldElecSurface = uieditfield('numeric','Parent',panelElecParams,...
        'Position',[labelElecSurface.Position(1)+labelElecSurface.Position(3)+20 labelElecSurface.Position(2) 50 22],'Value',0,'Tag','false',...
        'UserData','surface');
    iconHelp1 = uiimage('Parent',panelElecParams,'ImageSource',[fileparts(which('voxeloc.m')) filesep 'assets' filesep 'help.png'],...
        'Position',[fieldElecSurface.Position(1)+fieldElecSurface.Position(3)+20 labelElecSurface.Position(2) 20 20],...
        'Tooltip',["The surface area of the contact is essentially calculated as that of a cylinder, where'h' is the length of the recording contact and 'D' is the diameter of the electrode shaft."  "The equation is:" "A = pi*D*h "]); %#ok<NASGU> 
    labelElecMaterial = uilabel('Parent',panelElecParams,'Position',[20 labelElecSurface.Position(2)-40 250 22],...
        'Text',sprintf('Contact material (recommended):'));
    fieldElecMaterial = uieditfield('text','Parent',panelElecParams,'FontColor',[0.8 0.8 0.8],...
        'Position',[labelElecMaterial.Position(1)+labelElecMaterial.Position(3)+20 labelElecMaterial.Position(2) 50 22],'Placeholder','Material','Tag','false',...
        'UserData','material');
    iconHelp2 = uiimage('Parent',panelElecParams,'ImageSource',[fileparts(which('voxeloc.m')) filesep 'assets' filesep 'help.png'],...
        'Position',[fieldElecMaterial.Position(1)+fieldElecMaterial.Position(3)+20 fieldElecMaterial.Position(2) 20 20],...
        'Tooltip',"Material of the contact (for example, Tin, Ag/AgCl, Gold)."); %#ok<NASGU> 
    labelElecManufacturer = uilabel('Parent',panelElecParams,'Position',[20 fieldElecMaterial.Position(2)-40 250 22],...
        'Text',sprintf('Contact manufacturer (recommended):'));
    fieldElecManufacturer = uieditfield('text','Parent',panelElecParams,'FontColor',[0.8 0.8 0.8],...
        'Position',[labelElecManufacturer.Position(1)+labelElecManufacturer.Position(3)+20 labelElecManufacturer.Position(2) 50 22],'Placeholder','Manufacturer','Tag','false',...
        'UserData','manufacturer');
    labelElecImpedance = uilabel('Parent',panelElecParams,'Position',[20 fieldElecManufacturer.Position(2)-40 250 22],...
        'Text',sprintf('Contact impedance (kOhm) (optional):'));
    fieldElecImpedance = uieditfield('numeric','Parent',panelElecParams,...
        'Position',[labelElecImpedance.Position(1)+labelElecImpedance.Position(3)+20 labelElecImpedance.Position(2) 50 22],'Value',0,'Tag','false',...
        'UserData','impedance');
    buttonEXPORT = uibutton('push','Text','Export','Enable','off','BackgroundColor',[1,0.65,0],...
        'Parent',panelElecParams,'Position',[panelElecParams.Position(3)-70 labelElecImpedance.Position(2) 50 22]);
    labelStrElecs.UserData.allValue = cell(numElecs,4);
    labelStrElecs.UserData.individualValue = cell(numElecs,4);
    [labelStrElecs.UserData.allValue{:,1},labelStrElecs.UserData.individualValue{:,1}] = ...
        deal(fieldElecSurface.Value);
    [labelStrElecs.UserData.allValue{:,2},labelStrElecs.UserData.individualValue{:,2}] = ...
        deal(fieldElecMaterial.Value);
    [labelStrElecs.UserData.allValue{:,3},labelStrElecs.UserData.individualValue{:,3}] = ...
        deal(fieldElecManufacturer.Value);
    [labelStrElecs.UserData.allValue{:,4},labelStrElecs.UserData.individualValue{:,4}] = ...
        deal(fieldElecImpedance.Value);
    [labelStrElecs.UserData.allState(1:numElecs,1:4),labelStrElecs.UserData.individualState(1:numElecs,1:4)] = ...
        deal(false);


    %stateCheck(labelPath,fieldProjectName,fieldSubjectID,fieldSession)

    % Callback definitions
    toggleBidsExist.ValueChangedFcn = {@toggleChange,labelCreateBids,labelSelectBids,fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT};
    buttonCreateBids.ButtonPushedFcn = {@projectPathSelect,toggleBidsExist,labelPath,fieldProjectName,fieldSubjectID,fieldSession,labelBIDSfolder,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT};
    checkAllElec.ValueChangedFcn = {@allElecsChanged,numElecs,labelStrElecs,buttonPrev,buttonNext,labelElecName,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,labelPath,fieldProjectName,fieldSubjectID,listElecs,buttonEXPORT};

    fieldProjectName.ValueChangingFcn = {@fieldChanging};
    fieldSubjectID.ValueChangingFcn = {@fieldChanging};
    fieldSession.ValueChangingFcn = {@fieldChanging};
    fieldElecManufacturer.ValueChangingFcn = {@fieldChanging};
    fieldElecMaterial.ValueChangingFcn = {@fieldChanging};
    fieldProjectName.ValueChangedFcn = {@fieldChanged,fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder,toggleBidsExist,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT};
    fieldSubjectID.ValueChangedFcn = {@fieldChanged,fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder,toggleBidsExist,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT};
    fieldSession.ValueChangedFcn = {@fieldChanged,fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder,toggleBidsExist,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT};
    fieldElecSurface.ValueChangedFcn = {@finalCheck,labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,checkAllElec,labelElecName,numElecs,buttonEXPORT,1};
    fieldElecManufacturer.ValueChangedFcn = {@finalCheck,labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,checkAllElec,labelElecName,numElecs,buttonEXPORT,1};
    fieldElecMaterial.ValueChangedFcn = {@finalCheck,labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,checkAllElec,labelElecName,numElecs,buttonEXPORT,1};
    fieldElecImpedance.ValueChangedFcn = {@finalCheck,labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,checkAllElec,labelElecName,numElecs,buttonEXPORT,1};
    buttonPrev.ButtonPushedFcn = {@changeElec,labelStrElecs,buttonPrev,buttonNext,labelElecName,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,numElecs,listElecs};
    buttonNext.ButtonPushedFcn = {@changeElec,labelStrElecs,buttonPrev,buttonNext,labelElecName,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,numElecs,listElecs};

    buttonEXPORT.ButtonPushedFcn = {@exportBIDS,labelStrElecs,checkAllElec,labelPath,labelBIDSfolder,fig,fieldSubjectID,fieldSession,numElecs,listElecs,fieldCoordSystem};
    
    % Callback functions
    function toggleChange(~,evt,labelC,labelS,ProjName,SubjID,Session,Path,BIDSfolder,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT)
        switch evt.Value
            case 1
                labelC.Visible = 'off';
                labelS.Visible = 'on';
                ProjName.Editable = 'off';
                ProjName.BackgroundColor = [0.94 0.94 0.94];
                if isequal(Path.Tag,'false')
                    ProjName.Value = '';
                    ProjName.FontColor = [0.8 0.8 0.8];
                    ProjName.Tag = 'false';
                    BIDSfolder.Text = "<font style='color:dimgray;'>.../</font><font style='color:crimson;'>[ProjectName]</font><font style='color:dimgray;'>/</font><font style='color:crimson;'>sub-[SubjectID]</font><font style='color:dimgray;'>/ieeg";
                else
                    fName = fileparts(Path.Text);%extractHTMLText(Path.Text));
                    [~,b] = fileparts(fName);
                    ProjName.Value = b;
                    ProjName.FontColor = [0 0 0];
                    ProjName.Tag = 'true';
                    Path.Text = fName;%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:forestgreen;'>%s</font>",a,b);
                    BIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font><font style='color:forestgreen;'>%s</font><font style='color:dimgray;'>/sub-</font><font style='color:crimson;'>%s</font><font style='color:dimgray;'>/ieeg</font>",b,'[SubjectID]');
                end
            case 0
                labelC.Visible = 'on';
                labelS.Visible = 'off';
                ProjName.Editable = 'on';
                ProjName.BackgroundColor = [1 1 1];
                ProjName.Value = '';
                ProjName.FontColor = [0.8 0.8 0.8];
                ProjName.Tag = 'false';
                BIDSfolder.Text = "<font style='color:dimgray;'>.../</font><font style='color:crimson;'>[ProjectName]</font><font style='color:dimgray;'>/sub-</font><font style='color:crimson;'>[SubjectID]</font><font style='color:dimgray;'>/ieeg";
                if isequal(Path.Tag,'true')
                    Path.Text = [Path.Text filesep '[ProjectName]'];%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:crimson;'>%s</font>",extractHTMLText(Path.Text),'[ProjectName]');
                end

        end
        stateCheck(ProjName,SubjID,Session,Path,BIDSfolder);
        finalCheck([],[],Path,ProjName,SubjID,labelStrElecs,[],[],[],[],checkAllElec,labelElecName,numElecs,buttonEXPORT,0);
    end

    function allElecsChanged(src,~,numElecs,labelStrElecs,buttonPrev,buttonNext,labelElecName,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,labelPath,fieldProjectName,fieldSubjectID,listElecs,buttonEXPORT)
        if src.Value == 0
            labelStrElecs.Enable = 'on';
            buttonPrev.Enable = 'off';
            buttonNext.Enable = 'on';
            labelElecName.Enable = 'on';
            labelElecName.Text = [listElecs{1,1} ' (1)'];
            labelElecName.Tag = '1';
            fieldElecSurface.Value = labelStrElecs.UserData.individualValue{1,1};
            fieldElecMaterial.Value = labelStrElecs.UserData.individualValue{1,2};
            fieldElecManufacturer.Value = labelStrElecs.UserData.individualValue{1,3};
            fieldElecImpedance.Value = labelStrElecs.UserData.individualValue{1,4};
        else
            labelStrElecs.Enable = 'off';
            buttonPrev.Enable = 'off';
            buttonNext.Enable = 'off';
            labelElecName.Enable = 'off';
            labelElecName.Text = 'ALL ELECTRODES';
            labelElecName.Tag = 'all';
            fieldElecSurface.Value = labelStrElecs.UserData.allValue{1,1};
            fieldElecMaterial.Value = labelStrElecs.UserData.allValue{1,2};
            fieldElecManufacturer.Value = labelStrElecs.UserData.allValue{1,3};
            fieldElecImpedance.Value = labelStrElecs.UserData.allValue{1,4};
        end
        fieldChanging(fieldElecSurface,fieldElecSurface);
        fieldChanging(fieldElecMaterial,fieldElecMaterial);
        fieldChanging(fieldElecManufacturer,fieldElecManufacturer);
        fieldChanging(fieldElecImpedance,fieldElecImpedance);
        finalCheck([],[],labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,[],[],[],[],src,labelElecName,numElecs,buttonEXPORT,0);
    end

    function projectPathSelect(src,~,BIDSExist,Path,ProjName,SubjID,Session,BIDSfolder,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT)
        switch BIDSExist.Value
            case 1
                src.Parent.Visible = 'off';
                A = uigetdir;
                src.Parent.Visible = 'on';
                [~,b] = fileparts(A);
                %Path.Interpreter = 'html';
                Path.Text = A;%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:forestgreen;'>%s</font>",a,b);
                ProjName.Value = b;
                ProjName.Tag = 'true';
                ProjName.FontColor = [0 0 0];
                Path.Tag = 'true';
                BIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font><font style='color:forestgreen;'>%s</font><font style='color:dimgray;'>/sub-</font><font style='color:crimson;'>%s</font><font style='color:dimgray;'>/ieeg</font>",b,'[SubjectID]');
            case 0
                src.Parent.Visible = 'off';
                A = uigetdir;
                src.Parent.Visible = 'on';
                %Path.Interpreter = 'html';
                Path.Tag = 'true';
                if isequal(ProjName.Tag,'true')
                    Path.Text = [A filesep ProjName.Value];%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:forestgreen;'>%s</font>",A,ProjName.Value);
                    BIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font><font style='color:forestgreen;'>%s</font><font style='color:dimgray;'>/sub-</font><font style='color:crimson;'>%s</font><font style='color:dimgray;'>/ieeg</font>",ProjName.Value,'[SubjectID]');
                else
                    Path.Text = [A filesep '[ProjectName]'];%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:crimson;'>%s</font>",A,'[ProjectName]');
                    BIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font><font style='color:crimson;'>%s</font><font style='color:dimgray;'>/sub-</font><font style='color:crimson;'>%s</font><font style='color:dimgray;'>/ieeg</font>",'[ProjectName]','[SubjectID]');
                end
        end
        src.BackgroundColor = [0.96 0.96 0.96];
        stateCheck(ProjName,SubjID,Session,Path,BIDSfolder);
        finalCheck([],[],Path,ProjName,SubjID,labelStrElecs,[],[],[],[],checkAllElec,labelElecName,numElecs,buttonEXPORT,0);
    end

    function fieldChanging(src,evt)
        if isequal(evt.Value,'')
            src.FontColor = [0.8 0.8 0.8];
            src.Tag = 'false';
        else
            src.FontColor = [0 0 0];
            src.Tag = 'true';
        end
%         stateCheck(fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder)
    end

    function fieldChanged(src,~,fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder,toggleBidsExist,labelStrElecs,checkAllElec,labelElecName,numElecs,buttonEXPORT)
        a = isstrprop(src.Value,'alphanum');
        src.Value = src.Value(a);
        stateCheck(fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder)
        if isequal(src.Placeholder,'ProjectName') && (toggleBidsExist.Value == 0) && isequal(labelPath.Tag,'true')
            A = fileparts(labelPath.Text);%extractHTMLText(labelPath.Text));
            if isempty(src.Value)
                labelPath.Text = [A filesep '[ProjectName]'];%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:crimson;'>%s</font>",A,'[ProjectName]');
            else
                labelPath.Text = [A filesep src.Value];%sprintf("<font style='color:dimgray;'>%s/</font><font style='color:forestgreen;'>%s</font>",A,src.Value);
        
            end
        end
        finalCheck([],[],labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,[],[],[],[],checkAllElec,labelElecName,numElecs,buttonEXPORT,0);
    end

    function finalCheck(src,evt,labelPath,fieldProjectName,fieldSubjectID,labelStrElecs,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,checkAllElec,labelElecName,numElecs,buttonEXPORT,flag) %#ok<INUSL> 
        if flag == 1
            switch src.UserData
                case 'surface'
                    idX = 1;
                    voidCheck = 0;
                case 'material'
                    idX = 2;
                    voidCheck = '';
                case 'manufacturer'
                    idX = 3;
                    voidCheck = '';
                case 'impedance'
                    idX = 4;
                    voidCheck = 0;
            end
            if ~isequal(evt.Value,voidCheck)
                src.Tag = 'true';
                if checkAllElec.Value == 1
                    [labelStrElecs.UserData.allValue{:,idX}] = deal(evt.Value);
                    [labelStrElecs.UserData.allState(:,idX)] = deal(true);
                else
                    labelStrElecs.UserData.individualValue{str2double(labelElecName.Tag),idX} = evt.Value;
                    labelStrElecs.UserData.individualState(str2double(labelElecName.Tag),idX) = true;
                end
            else
                src.Tag = 'false';
                if checkAllElec.Value == 1
                    [labelStrElecs.UserData.allValue{:,idX}] = deal(evt.Value);
                    [labelStrElecs.UserData.allState(:,idX)] = deal(false);
                else
                    labelStrElecs.UserData.individualValue{str2double(labelElecName.Tag),idX} = evt.Value;
                    labelStrElecs.UserData.individualState(str2double(labelElecName.Tag),idX) = false;
                end
            end
        end
        
        if checkAllElec.Value == 1
            listVarsComplete = find(all(labelStrElecs.UserData.allState(:,:),1));
            if any(ismember(listVarsComplete,1)) && (length(listVarsComplete) < 4)
                textColor = "dodgerBlue";
            elseif any(ismember(listVarsComplete,1)) && (length(listVarsComplete) == 4)
                textColor = "forestgreen";
            else
                textColor = "crimson";
            end
            vecElecs = 1:numElecs;
            strElecs = "";
            for i = 1:numElecs
                strElecs = append(strElecs,sprintf("<font style='color:%s;'>%d\t</font>",textColor,vecElecs(i)));
            end
            labelStrElecs.Text = strElecs;

            % CHECK TEST
            checkTest(1) = isequal(fieldProjectName.Tag,'true');
            checkTest(2) = isequal(fieldSubjectID.Tag,'true');
            checkTest(3) = isequal(labelPath.Tag,'true');
            checkTest(4) = (isequal(textColor,'dodgerBlue') || isequal(textColor,'forestgreen'));
        else
            vecElecs = 1:numElecs;
            strElecs = "";
            currElec = str2double(labelElecName.Tag);
            for i = 1:numElecs
                listVarsComplete = find(all(labelStrElecs.UserData.individualState(i,:),1));
                if any(ismember(listVarsComplete,1)) && (length(listVarsComplete) < 4)
                    textColor = "dodgerBlue";
                elseif any(ismember(listVarsComplete,1)) && (length(listVarsComplete) == 4)
                    textColor = "forestgreen";
                else
                    textColor = "crimson";
                end
                if i == currElec
                    strElecs = append(strElecs,sprintf("<b><font style='color:%s;'<span style='font-size:20px;'>%d\t</span></font></b>",textColor,vecElecs(i)));
                else
                    strElecs = append(strElecs,sprintf("<font style='color:%s;'<span style='font-size:16px;'>%d\t</span></font>",textColor,vecElecs(i)));
                end
            end
            labelStrElecs.Text = strElecs;
            % CHECK TEST
            checkTest(1) = isequal(fieldProjectName.Tag,'true');
            checkTest(2) = isequal(fieldSubjectID.Tag,'true');
            checkTest(3) = isequal(labelPath.Tag,'true');
            checkTest(4) = ~(contains(strElecs,"crimson"));
        end
        if all(checkTest)
            % disp([newline newline '     READY TO GO!    ' newline newline]);
            buttonEXPORT.Enable = 'on';
        else
            buttonEXPORT.Enable = 'off';
        end

    end

    function changeElec(src,~,labelStrElecs,buttonPrev,buttonNext,labelElecName,fieldElecSurface,fieldElecMaterial,fieldElecManufacturer,fieldElecImpedance,numElecs,listElecs)
        if isequal(src.Text,'>')
            buttonPrev.Enable = 'on';
            currElec = str2double(labelElecName.Tag)+1;
            labelElecName.Tag = num2str(currElec);
            if str2double(labelElecName.Tag) == numElecs
                src.Enable = 'off';
            end
        elseif isequal(src.Text,'<')
            buttonNext.Enable = 'on';
            currElec = str2double(labelElecName.Tag)-1;
            labelElecName.Tag = num2str(currElec);
            if str2double(labelElecName.Tag) == 1
                src.Enable = 'off';
            end
        end
        labelElecName.Text = [listElecs{currElec,1} ' (' num2str(currElec) ')'];
        vecElecs = 1:numElecs;
        strElecs = "";
        for i = 1:numElecs
            listVarsComplete = find(all(labelStrElecs.UserData.individualState(i,:),1));
            if any(ismember(listVarsComplete,1)) && (length(listVarsComplete) < 4)
                textColor = "dodgerBlue";
            elseif any(ismember(listVarsComplete,1)) && (length(listVarsComplete) == 4)
                textColor = "forestgreen";
            else
                textColor = "crimson";
            end
            if i == currElec
                strElecs = append(strElecs,sprintf("<b><font style='color:%s;'<span style='font-size:20px;'>%d\t</span></font></b>",textColor,vecElecs(i)));
            else
                strElecs = append(strElecs,sprintf("<font style='color:%s;'<span style='font-size:16px;'>%d\t</span></font>",textColor,vecElecs(i)));
            end
        end
        labelStrElecs.Text = strElecs;
        fieldElecSurface.Value = labelStrElecs.UserData.individualValue{currElec,1};
        fieldElecMaterial.Value = labelStrElecs.UserData.individualValue{currElec,2};
        fieldElecManufacturer.Value = labelStrElecs.UserData.individualValue{currElec,3};
        fieldElecImpedance.Value = labelStrElecs.UserData.individualValue{currElec,4};
    end

    function exportBIDS(~,~,labelStrElecs,checkAllElec,labelPath,labelBIDSfolder,fig,fieldSubjectID,fieldSession,numElecs,listElecs,fieldCoordSystem)
        projDir = labelPath.Text;%extractHTMLText(labelPath.Text);
%         subjDir = extractHTMLText(labelBIDSfolder.Text);
%         tmpIdx = strfind(subjDir,'sub-');
%         subjDir = subjDir(tmpIdx:end);
        outDir = [projDir filesep 'sub-' fieldSubjectID.Value filesep 'ieeg'];
%         tmpIdx = []; %#ok<NASGU> 
%         tmpIdx = strfind(outDir,'/');
%         outDir(tmpIdx) = filesep;
        if ~isfolder(outDir)
            mkdir(outDir);
        end
        if isequal(fieldSession.Value,'')
            fid = fopen([outDir filesep 'sub-' fieldSubjectID.Value...
                '_coordsystem.json'],'w');
            outTSV.file = [outDir filesep 'sub-' fieldSubjectID.Value...
                '_electrodes.tsv'];
        else
            fid = fopen([outDir filesep 'sub-' fieldSubjectID.Value '_'...
                'ses-' fieldSession.Value '_coordsystem.json'],'w');
            outTSV.file = [outDir filesep 'sub-' fieldSubjectID.Value '_'...
                'ses-' fieldSession.Value '_electrodes.tsv'];
        end

        % JSON FILE EXPORT
        outJSON.iEEGCoordinateSystem = fieldCoordSystem.Value;
        outJSON.iEEGCoordinateUnits = 'mm';
        if isequal(fieldCoordSystem.Value,'fsaverage')
            outJSON.iEEGCoordinateSystemDescription = 'https://surfer.nmr.mgh.harvard.edu/';
        else
            outJSON.iEEGCoordinateSystemDescription = 'N/A';
        end
        outJSON.iEEGCoordinateProcessingDescription = 'none';
        outJSON.iEEGCoordinateProcessingReference = 'https://github.com/HumanNeuronLab/voxeloc';
        w = 1;
        if isfield(widget.glassbrain.UserData,'filePathCT')
            sourceCT = [widget.glassbrain.UserData.filePathCT widget.glassbrain.UserData.fileNameCT];
            if isequal(fieldSession.Value,'')
                fileCT = ['sub-' fieldSubjectID.Value...
                    '_' widget.glassbrain.UserData.fileNameCT];
            else
                fileCT = ['sub-' fieldSubjectID.Value '_'...
                    'ses-' fieldSession.Value '_' widget.glassbrain.UserData.fileNameCT];
            end
            destCT = [fileparts(outDir) filesep 'anat' filesep fileCT];
            if ~isfolder(fileparts(destCT))
                mkdir(fileparts(destCT));
            end
            copyfile(sourceCT,destCT);
            outJSON.IntendedFor{w} = destCT;
            w = w+1;
        end
        if isfield(widget.glassbrain.UserData,'filePathT1')
            sourceT1 = [widget.glassbrain.UserData.filePathT1 widget.glassbrain.UserData.fileNameT1];
            if isequal(fieldSession.Value,'')
                fileT1 = ['sub-' fieldSubjectID.Value...
                    '_' widget.glassbrain.UserData.fileNameT1];
            else
                fileT1 = ['sub-' fieldSubjectID.Value '_'...
                    'ses-' fieldSession.Value '_' widget.glassbrain.UserData.fileNameT1];
            end
            destT1 = [fileparts(outDir) filesep 'anat' filesep fileT1];
            if ~isfolder(fileparts(destT1))
                mkdir(fileparts(destT1));
            end
            copyfile(sourceT1,destT1);
            outJSON.IntendedFor{w} = destT1;
        end
        jsonString = jsonencode(outJSON,PrettyPrint=true);
        fprintf(fid,'%s',jsonString);
        fclose(fid);

        % TSV FILE EXPORT
        counter = 1;
        for l = 1:numElecs
            nContact = height(listElecs{l,2});
            for k = 1:nContact
                % if k == 1
                %     name = {[num2str(k) ' (deep)']};
                % elseif k == nContact
                %     name = {[num2str(k) ' (superficial)']};
                % else
                %     name = {num2str(k)};
                % end
                name = {[listElecs{l,1}(4:end) num2str(k)]};
                x = listElecs{l,2}(k,1);
                y = listElecs{l,2}(k,2);
                z = listElecs{l,2}(k,3);
                if checkAllElec.Value == 1
                    size = labelStrElecs.UserData.allValue{1,1};
                    material = labelStrElecs.UserData.allValue(1,2);
                    manufacturer = labelStrElecs.UserData.allValue(1,3);
                    if ~isequal(labelStrElecs.UserData.allValue{1,4},0)
                        impendance = labelStrElecs.UserData.allValue{1,4};
                    end
                else
                    size = labelStrElecs.UserData.individualValue{l,1};
                    material = labelStrElecs.UserData.individualValue(l,2);
                    manufacturer = labelStrElecs.UserData.individualValue(l,3);
                    impendance = labelStrElecs.UserData.individualValue{l,4};
                end
                group = {listElecs{l,1}(4:end)};
                hemisphere = {listElecs{l,1}(1)};
                if isequal(listElecs{l,1}(2),'D')
                    type = {'depth'};
                else
                    type = {'n/a'};
                end
                dimension = {['[1x' num2str(nContact) ']']};
                try
                    outTSV.table(counter,:) = table(name,x,y,z,size,...
                        material,manufacturer,group,...
                        hemisphere,type,impendance,dimension);
                catch
                    outTSV.table(counter,:) = table(name,x,y,z,size,...
                        material,manufacturer,group,...
                        hemisphere,type,dimension);
                end
                counter = counter+1;
            end
        end
        
        
        writetable(outTSV.table,outTSV.file,'FileType','text','Delimiter','\t');
        close(fig);
    end

    % Functions
    function stateCheck(fieldProjectName,fieldSubjectID,fieldSession,labelPath,labelBIDSfolder) %#ok<INUSL> 
        if isequal(fieldProjectName.Tag, 'false')
            if isequal(fieldSubjectID.Tag, 'false')
                if isequal(fieldSession.Tag, 'false')
                    labelBIDSfolder.Text = "<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:crimson;'>[ProjectName]</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:crimson;'>[SubjectID]</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>";
                else
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:crimson;'>[ProjectName]</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:crimson;'>[SubjectID]</font>" + ...
                        "<font style='color:dimgray;'>/ses-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldSession.Value);
                end
            else
                if isequal(fieldSession.Tag, 'false')
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:crimson;'>[ProjectName]</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldSubjectID.Value);
                else
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:crimson;'>[ProjectName]</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ses-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldSubjectID.Value,fieldSession.Value);
                end
            end
        else
            if isequal(fieldSubjectID.Tag, 'false')
                if isequal(fieldSession.Tag, 'false')
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:crimson;'>[SubjectID]</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldProjectName.Value);
                else
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:crimson;'>[SubjectID]</font>" + ...
                        "<font style='color:dimgray;'>/ses-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldProjectName.Value,fieldSession.Value);
                end
            else
                if isequal(fieldSession.Tag, 'false')
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldProjectName.Value,fieldSubjectID.Value);
                else
                    labelBIDSfolder.Text = sprintf("<font style='color:dimgray;'>.../</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/sub-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ses-</font>" + ...
                        "<font style='color:forestgreen;'>%s</font>" + ...
                        "<font style='color:dimgray;'>/ieeg</font>",fieldProjectName.Value,fieldSubjectID.Value,fieldSession.Value);
                end
            end
        end
    end
end