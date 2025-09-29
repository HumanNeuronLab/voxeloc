function checkOblique(widget,modus)

    widget.fig.Pointer = 'watch';
    widget.viewer.oblique.table.Visible = 'off';
    drawnow();
    try
        for axChild = 1:numel(widget.viewer.oblique.ax_ctVert.Children)
            widget.viewer.oblique.ax_ctVert.Children(axChild).Visible = 'off';
        end
        for axChild = 1:numel(widget.viewer.oblique.ax_t1Vert.Children)
            widget.viewer.oblique.ax_t1Vert.Children(axChild).Visible = 'off';
        end
        for axChild = 1:numel(widget.viewer.oblique.ax_ctHor.Children)
            widget.viewer.oblique.ax_ctHor.Children(axChild).Visible = 'off';
        end
        for axChild = 1:numel(widget.viewer.oblique.ax_t1Hor.Children)
            widget.viewer.oblique.ax_t1Hor.Children(axChild).Visible = 'off';
        end
    catch
    end
    widget.viewer.oblique.label_noSliceCTVert.Visible = 'off';
    widget.viewer.oblique.label_noSliceT1Vert.Visible = 'off';
    widget.viewer.oblique.label_noSliceCTHor.Visible = 'off';
    widget.viewer.oblique.label_noSliceT1Hor.Visible = 'off';

    drawnow();
    verifyCT = isfield(widget.glassbrain.UserData,'CTvol');
    verifyT1 = isfield(widget.glassbrain.UserData,'T1vol');
    verifyPARC = isfield(widget.glassbrain.UserData,'PARCvol');

    if ~verifyCT || ~verifyT1 || ~verifyPARC
        widget.viewer.oblique.panel.Enable = 'off';
        widget.viewer.oblique.label_noSliceCTVert.Visible = 'on';
        widget.viewer.oblique.label_noSliceT1Vert.Visible = 'on';
        widget.viewer.oblique.label_noSliceCTHor.Visible = 'on';
        widget.viewer.oblique.label_noSliceT1Hor.Visible = 'on';
        widget.viewer.oblique.label_elecName.Text = 'Electrode:';
        widget.viewer.oblique.label_elecName.Visible = 'off';
        widget.fig.Pointer = 'arrow';
    else
        if isequal(modus,'reslice') || isequal(modus,'estimate')
            elecOblique(widget,modus);
            for cElec = 1:numel(widget.params.dropdown_ElectrodeSelector.Items)
                selELec = ['Electrode' num2str(cElec)];
                if isfield(widget.fig.UserData.(selELec).oblique,'state') && isequal(widget.fig.UserData.(selELec).oblique.state,'SUCCESS')
                    ctcCoord = widget.fig.UserData.(selELec).contact;
                    for currCtc = 1:numel(widget.fig.UserData.(selELec).oblique.contacts.CT_Vert.XData)
                        regNum = widget.glassbrain.UserData.PARCvol(round(ctcCoord(currCtc,2)),round(ctcCoord(currCtc,1)),round(ctcCoord(currCtc,3)));
                        regIdx = widget.glassbrain.UserData.brainRegions.Var1 == regNum;
                        regName = widget.glassbrain.UserData.brainRegions.Var2{regIdx};
                        widget.fig.UserData.(selELec).oblique.contacts.regName{currCtc,:} = regName;
                        regColor = widget.glassbrain.UserData.cmap(regIdx,2:4);
                        widget.fig.UserData.(selELec).oblique.contacts.regColor(currCtc,:) = regColor;
                    end
                end
            end
        end
        try
            selectedElec = widget.tree_Summary.SelectedNodes.Tag;
        catch
            selectedElec = 'Electrode1';
        end
        try
            if isequal(widget.fig.UserData.(selectedElec).oblique.state,'SUCCESS')
                widget.viewer.oblique.table.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.image.sliceCT_Vert.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.image.sliceT1_Vert.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.image.sliceCT_Hor.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.image.sliceT1_Hor.Visible = 'on';
                if widget.viewer.oblique.checkbox_segCT.Value == 1
                    widget.fig.UserData.(selectedElec).oblique.image.sliceSEG_VertCT.Visible = 'on';
                    widget.fig.UserData.(selectedElec).oblique.image.sliceSEG_HorCT.Visible = 'on';
                end
                if widget.viewer.oblique.checkbox_segT1.Value == 1
                    widget.fig.UserData.(selectedElec).oblique.image.sliceSEG_VertT1.Visible = 'on';
                    widget.fig.UserData.(selectedElec).oblique.image.sliceSEG_HorT1.Visible = 'on';
                end
                widget.fig.UserData.(selectedElec).oblique.contacts.CT_Vert.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.contacts.T1_Vert.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.contacts.CT_Hor.Visible = 'on';
                widget.fig.UserData.(selectedElec).oblique.contacts.T1_Hor.Visible = 'on';
                

                widget = update3Dhead(widget);
                contactTable = widget.viewer.oblique.table;
                contactTable.Data = [];
                contactTable.ColumnWidth = {22,'auto'};
                contactTable.Data{1,1} = ' ';
                contactTable.Data{1,2} = 'Deepest contact';
                contactCoord = widget.fig.UserData.(selectedElec).contact;
                regionStyle = uistyle('FontWeight','normal','FontColor',[0.94 0.94 0.94],'BackgroundColor',[0.3 0.3 0.3]);
                addStyle(contactTable,regionStyle,'cell',[1,2]);
                regionStyle = uistyle('FontWeight','bold','FontColor',[0.94 0.94 0.94],'BackgroundColor',[0.3 0.3 0.3]);
                colorStyle = uistyle('FontWeight','bold','BackgroundColor',[0.3 0.3 0.3]);
                addStyle(contactTable,colorStyle,'cell',[1,1]);
                for III = 1:numel(widget.fig.UserData.(selectedElec).oblique.contacts.CT_Vert.XData)
                    regName = widget.fig.UserData.(selectedElec).oblique.contacts.regName{III,:};
                    regColor = widget.fig.UserData.(selectedElec).oblique.contacts.regColor(III,:);

                    contactTable.Data{III+1,2} = ['Contact ' num2str(III) ': ' strrep(regName,'-',' ')];
                    addStyle(contactTable,regionStyle,'cell',[III+1,2]);

                    contactTable.Data{III+1,1} = ' ';
                    colorStyle = uistyle('FontWeight','bold','BackgroundColor',regColor);
                    addStyle(contactTable,colorStyle,'cell',[III+1,1]);
                end
                contactTable.Data{III+2,1} = ' ';
                contactTable.Data{III+2,2} = 'Superficial contact';
                regionStyle = uistyle('FontWeight','normal','FontColor',[0.94 0.94 0.94],'BackgroundColor',[0.3 0.3 0.3]);
                addStyle(contactTable,regionStyle,'cell',[III+2,2]);
                colorStyle = uistyle('FontWeight','bold','BackgroundColor',[0.3 0.3 0.3]);
                addStyle(contactTable,colorStyle,'cell',[III+2,1]);
                availHeight = widget.viewer.oblique.head3D.panel.Position(2)-50;
                tableHeight = (III+2)*22+2;
                if availHeight >= tableHeight
                    contactTable.Position(2) = widget.viewer.oblique.head3D.panel.Position(2)-tableHeight;
                    contactTable.Position(4) = tableHeight;
                else
                    contactTable.Position(2) = widget.viewer.oblique.head3D.panel.Position(2)-availHeight;
                    contactTable.Position(4) = availHeight;
                end
                
            else
                widget.viewer.oblique.label_noSliceCTVert.Visible = 'on';
                widget.viewer.oblique.label_noSliceT1Vert.Visible = 'on';
                widget.viewer.oblique.label_noSliceCTHor.Visible = 'on';
                widget.viewer.oblique.label_noSliceT1Hor.Visible = 'on';
            end
            widget.viewer.oblique.label_elecName.Text = widget.fig.UserData.(selectedElec).Name;
            widget.viewer.oblique.label_elecName.Visible = 'on';
        catch
            widget.viewer.oblique.label_noSliceCTVert.Visible = 'on';
            widget.viewer.oblique.label_noSliceT1Vert.Visible = 'on';
            widget.viewer.oblique.label_noSliceCTHor.Visible = 'on';
            widget.viewer.oblique.label_noSliceT1Hor.Visible = 'on';
            widget.viewer.oblique.label_elecName.Text = 'Electrode:';
            widget.viewer.oblique.label_elecName.Visible = 'off';
            widget.viewer.oblique.table.Visible = 'off';
        end
        if isequal(modus,'reslice')
            widget = widgetAutosave(widget);
        end
        widget.viewer.oblique.panel.Enable = 'on';
        widget.fig.Pointer = 'arrow';
        drawnow();
    end

    
    %______________________________________________________________________
    %
    %------------------------- INTERNAL FUNCTIONS -------------------------
    %______________________________________________________________________
   

    function widget = update3Dhead(widget)
        try
            currElec = widget.tree_Summary.SelectedNodes.Tag;
        catch
            currElec = 'Electrode1';
        end
        currAz = widget.fig.UserData.(currElec).oblique.azimuth;
        preAz = widget.viewer.oblique.head3D.vertRotator.UserData;
        if isempty(preAz)
            preAz = 0;
        end
        currEl = widget.fig.UserData.(currElec).oblique.elevation;
        preEl = str2double(widget.viewer.oblique.head3D.horRotator.UserData);
        if isnan(preEl)
            preEl = 0;
        end

        nSteps = 1;
        vertPlaneRot = currAz-preAz;
        azStep = vertPlaneRot/nSteps;
        horPlaneRot  = (currEl-preEl);
        elStep = horPlaneRot/nSteps;
    
        [xSize,ySize,zSize] = size(widget.glassbrain.UserData.CTvol);

        quadrant = ones([1,2]);
        if (widget.fig.UserData.(currElec).secondCoord(1)-(xSize/2)) < 0
            quadrant(1) = 1; % 1 = Right / 2 = Left
        else
            quadrant(1) = 2;
        end
        if (widget.fig.UserData.(currElec).secondCoord(3)-(zSize/2)) > 0
            quadrant(2) = 1; % 1 = Anterior / 2 = Posterior
        else
            quadrant(2) = 2;
        end

        prevQuad = widget.viewer.oblique.head3D.HGrot.UserData;
        if isempty(prevQuad)
            prevQuad = 0;
        end
        if isequal(quadrant,[1 1])
            currQuad = 90;              % 90 deg = right anterior
            disp('Right Anterior');
        elseif isequal(quadrant,[1 2])
            currQuad = 180;             % 180 deg = right posterior
            disp('Right Posterior');
        elseif isequal(quadrant,[2 1])
            currQuad = 0;               % 0 deg = left anterior
            disp('Left Anterior');
        elseif isequal(quadrant,([2 2]))
            currQuad = -90;
            disp('Left Posterior');     % -90 deg = left posterior
        end

        deltaQuad = currQuad-prevQuad;
        
        if deltaQuad < -180
            deltaQuad = 90; % going from RP to LP
        elseif deltaQuad > 180
            deltaQuad = -90; %going from LP to RP
        end

        quadStep = deltaQuad/nSteps;

        for i = 1:nSteps
            vertDegChange = preAz+i*azStep;
            horDegChange = -(90+(preEl+i*elStep));
            quadDegChange = prevQuad+i*quadStep;
            widget.viewer.oblique.head3D.vertRotator.Matrix = makehgtform('zrotate',deg2rad(vertDegChange),'translate',[0 widget.fig.UserData.(currElec).oblique.depthVert-(ySize/2) 0]);
            widget.viewer.oblique.head3D.horRotator.Matrix = makehgtform('yrotate',deg2rad(horDegChange),'translate',[0 0 widget.fig.UserData.(currElec).oblique.depthHor-(zSize/2)]);
            widget.viewer.oblique.head3D.HGrot.Matrix = makehgtform('zrotate',deg2rad(quadDegChange));
            drawnow();
            pause(0.005);
        end
        widget.viewer.oblique.head3D.vertRotator.UserData = currAz;
        widget.viewer.oblique.head3D.horRotator.UserData = currEl;
        widget.viewer.oblique.head3D.HGrot.UserData = currQuad;
    end


    function elecOblique(widget,modus)
        for i = 1:numel(widget.params.dropdown_ElectrodeSelector.Items)
            currElec = ['Electrode' num2str(i)];
            elecEstimation = widget.fig.UserData.(currElec).Estimation;
            try
                if isequal(modus,'reslice')
                    elecOblSlice = 'FAILED';
                    widget.viewer.oblique.ax_ctVert.Children(:).delete
                    widget.viewer.oblique.ax_ctHor.Children(:).delete
                    widget.viewer.oblique.ax_t1Vert.Children(:).delete
                    widget.viewer.oblique.ax_t1Hor.Children(:).delete
                else
                    elecOblSlice = widget.fig.UserData.(currElec).oblique.state;
                end
            catch
                elecOblSlice = 'FAILED';
            end
            if isequal(elecEstimation,'SUCCESS') && isequal(elecOblSlice,'SUCCESS')
                verifyElectrodes(i) = 2;
            elseif isequal(elecEstimation,'SUCCESS') && isequal(elecOblSlice,'FAILED')
                verifyElectrodes(i) = 1;
            else
                verifyElectrodes(i) = 0;
            end
        end
    
        point   = [];
        output  = [];
        for j = find(ismember(verifyElectrodes,1))
            try
                % Name current electrode
                currElec    = ['Electrode' num2str(j)];
                ct          = widget.glassbrain.UserData.CTvol;
                t1          = widget.glassbrain.UserData.T1vol;
                seg         = widget.glassbrain.UserData.PARCvol;
                elecVal     = widget.fig.UserData;
                cmap        = widget.glassbrain.UserData.cmap;
                ax_ctVert   = widget.viewer.oblique.ax_ctVert;
                ax_ctHor    = widget.viewer.oblique.ax_ctHor;
                ax_t1Vert   = widget.viewer.oblique.ax_t1Vert;
                ax_t1Hor    = widget.viewer.oblique.ax_t1Hor;
            
            
                % 1. Retrieve current electrode's contact data and give temp. fictional
                % values within volume for location indexing after rotation (see
                % documentation for explanation).
                [contact,maxVal,realVal,ct] = getElecContacts(ct,elecVal,currElec);
                
            
                % 2. Azimuth and Elevation calculation for current electrode & volume
                % rotation for CT, T1 and SEG volumes based on az & el degrees (see
                % documentation for explanation).
                [elecVal,rotVolumes,az,el] = azelMagic(contact,ct,t1,seg,currElec,...
                    elecVal);
                
            
                % Work in progress for 3d Head --- equation not working right now
                depthLoc = round(contact(1,3)+abs(128-contact(1))/2);
                
            
                % 3. Determine on which plane (depth-wise) the electrode is located in
                % the rotated volume (see documentation for explanation).
                coord = getCoordDepth(rotVolumes,contact,maxVal);
                
            
                opacityValue = (widget.viewer.oblique.slider_opacity.Value/100);
                % 4. Retrieve current oblique slices' parcellation values for each 
                % voxel (see documentation for explanation).
                [ct,alphaArrV,colArrV,colArrH,alphaArrH] = getSliceParc(ct,realVal,...
                    rotVolumes,coord,cmap,contact,opacityValue);
            
            
                imElec = ['image' num2str(j)];
                pointElec = 'contacts';
                
                % 5. Determine point coordinates to plot each contact on the current
                % slice's plane (see documentation for explanation).
                point = getContactCoords(coord,imElec,contact,point);
                
                if isfield(widget.glassbrain.UserData.electrodes.(currElec),'Color')
                    elecColor = widget.glassbrain.UserData.electrodes.(currElec).Color;
                else
                    elecColor = widget.glassbrain.UserData.ColorList(j,:);
                end

                % 6. Create images from slices and plot contacts as points.
                output = sliceCreator(ax_ctVert,ax_ctHor,ax_t1Vert,ax_t1Hor,...
                    rotVolumes,coord,imElec,pointElec,alphaArrV,alphaArrH,colArrV,colArrH,...
                    point,output,elecColor);
                
                widget.fig.UserData.(currElec).oblique.azimuth = az;
                widget.fig.UserData.(currElec).oblique.elevation = el;
                widget.fig.UserData.(currElec).oblique.depthVert = mode(coord.depthVert);
                widget.fig.UserData.(currElec).oblique.depthVectorV = coord.depthVert;
                widget.fig.UserData.(currElec).oblique.depthHor = mode(coord.depthHor);
                widget.fig.UserData.(currElec).oblique.depthVectorH = coord.depthHor;
                widget.fig.UserData.(currElec).oblique.image = output.(imElec);
                widget.fig.UserData.(currElec).oblique.contacts = output.(pointElec);
        
                widget.fig.UserData.(currElec).oblique.state = 'SUCCESS';
                verifyElectrodes(j) = 2;
            catch
                widget.fig.UserData.(currElec).oblique.state = 'FAILED';
                verifyElectrodes(j) = 1;
            end
        end
    end
    
    % 1.
    function [contact,maxVal,realVal,ct] = getElecContacts(ct,elecVal,currElec)
        
        % Retrieve all contacts coordinates for current electrode
        contact = elecVal.(currElec).contact;
    
        maxVal = max(max(max(ct(:,:,:))));
    
        % Give a fictional value to each contac's voxel so it can be easily and
        % uniquely retrieved after rotation
        for a = 1:height(contact)
            realVal(a,:) = ct(round(contact(a,2)),round(contact(a,1)),round(contact(a,3)));
            ct(round(contact(a,2)),round(contact(a,1)),round(contact(a,3))) = ceil(a+maxVal);
        end
    end
    
    % 2.
    function [elecVal,rotVolumes,az,el] = azelMagic(contact,ct,t1,seg,currElec,elecVal)
        % ----------------------- Just trust the magic ------------------------
    
        % Calculate X,Y,Z deltas from deepest to most superficial contacts
        diffContact = contact(end,:)-contact(1,:);
    
        % Get azimuth and elevation from the shaft X,Y,Z deltas
        [az,el] = cart2sph(diffContact(1,1),diffContact(1,3),diffContact(1,2));
        az = -rad2deg(az); % convert from radians to degrees
        el = 90+rad2deg(el); % convert from radians to degrees
        elecVal.(currElec).azimuth = az;
        elecVal.(currElec).elevation = el;
        disp([currElec ': az = ' num2str(az) ' el = ' num2str(el)]);
    
        % Rotate Vertical slices by azimuth
        rotVolumes.ct_Vert  = [];
        rotVolumes.t1_Vert  = [];
        rotVolumes.seg_Vert = [];
        rotVolumes.ct_Vert  = round(imrotate3(ct,az,[0 1 0],...
            'nearest','crop','FillValues',0));
        rotVolumes.t1_Vert  = round(imrotate3(t1,az,[0 1 0],...
            'nearest','crop','FillValues',0));
        rotVolumes.seg_Vert = round(imrotate3(seg,az,[0 1 0],...
            'nearest','crop','FillValues',0));
    
        % Rotate Horizontal slices by elevation value
        rotVolumes.ct_Hor   = [];
        rotVolumes.t1_Hor   = [];
        rotVolumes.seg_Hor  = [];
        rotVolumes.ct_Hor   = imrotate3(rotVolumes.ct_Vert,el,[0 0 1],...
            'nearest','crop','FillValues',0);
        rotVolumes.ct_Hor   = round(imrotate3(rotVolumes.ct_Hor,90,[0 1 0]));
        rotVolumes.t1_Hor   = imrotate3(rotVolumes.t1_Vert,el,[0 0 1],...
            'nearest','crop','FillValues',0);
        rotVolumes.t1_Hor   = round(imrotate3(rotVolumes.t1_Hor,90,[0 1 0]));
        rotVolumes.seg_Hor  = imrotate3(rotVolumes.seg_Vert,el,[0 0 1],...
            'nearest','crop','FillValues',0);
        rotVolumes.seg_Hor  = round(imrotate3(rotVolumes.seg_Hor,90,[0 1 0]));
        
    end
    
    % 3.
    function coord = getCoordDepth(rotVolumes,contact,maxVal)
    
        coord.Vert = [];
        coord.Hor = [];
        coord.depthVert = [];
        coord.depthHor = [];
        for i = 1:height(contact)
            %----------------- Vertical Height determination ------------------
            % Find the index of the contact in the rotated volume
            idxVert = find(rotVolumes.ct_Vert(:,:,:) == ceil(i+maxVal));
            % Due to rotation, some contacts may be cropped. For this reason,
            % we give empty values to the vectors before retrieving their mode
            % value.
            if isempty(idxVert)
                idxVert = nan;
            elseif length(idxVert) > 1
                idxVert = idxVert(1);
            end
            % Convert the index into X,Y,Z coordinates
            [xVert,yVert,zVert] = ind2sub(size(rotVolumes.ct_Vert),idxVert);
            coord.Vert(i,:) = [xVert yVert];
            coord.depthVert(i) = zVert;
    
            %----------------- Horizontal Height determination ----------------
            % Find the index of the contact in the rotated volume
            idxHor = find(rotVolumes.ct_Hor(:,:,:) == ceil(i+maxVal));
            % Due to rotation, some contacts may be cropped. For this reason,
            % we give empty values to the vectors before retrieving their mode
            % value.
            if isempty(idxHor)
                idxHor = nan;
            elseif length(idxHor) > 1
                idxHor = idxHor(1);
            end
            % Convert the index into X,Y,Z coordinates
            [xHor,yHor,zHor] = ind2sub(size(rotVolumes.ct_Hor),idxHor);
            coord.Hor(i,:) = [xHor yHor];
            coord.depthHor(i) = zHor;
        end
    end
    
    % 4.
    function [ct,alphaArrV,colArrV,colArrH,alphaArrH] = getSliceParc(ct,realVal,rotVolumes,coord,cmap,contact,opacityValue)
        % Reset each contact's initial value (removed fictional value for easy
        % indexing and coordinate retrieval)
        for a = 1:height(contact)
            ct(round(contact(a,1)),round(contact(a,2)),round(contact(a,3))) = realVal(a,:);
        end
    
        % List all parcellation areas found on this slice
        listV = unique(round(rotVolumes.seg_Vert(:,:,mode(coord.depthVert))));
        % Create a slice with each voxel color coded per its parcellation area.
        alphaArrV = zeros(size(rotVolumes.seg_Vert(:,:,mode(coord.depthVert))));
        for i = 1:length(listV)
            [x,y] = find(rotVolumes.seg_Vert(:,:,mode(coord.depthVert)) == listV(i));
            validx = find(cmap(:,1) == listV(i));
            for j = 1:height(x)
                colArrV(x(j),y(j),1) = cmap(validx,2);
                colArrV(x(j),y(j),2) = cmap(validx,3);
                colArrV(x(j),y(j),3) = cmap(validx,4);
                if validx ~= 1
                    alphaArrV(x(j),y(j)) = opacityValue;
                end
            end
        end
    
        % List all parcellation areas found on this slice
        listH = unique(round(rotVolumes.seg_Hor(:,:,mode(coord.depthHor))));
        % Create a slice with each voxel color coded per its parcellation area.
        alphaArrH = zeros(size(rotVolumes.seg_Hor(:,:,mode(coord.depthHor))));
        for i = 1:length(listH)
            [x,y] = find(rotVolumes.seg_Hor(:,:,mode(coord.depthHor)) == listH(i));
            validx = find(cmap(:,1) == listH(i));
            for j = 1:height(x)
                colArrH(x(j),y(j),1) = cmap(validx,2);
                colArrH(x(j),y(j),2) = cmap(validx,3);
                colArrH(x(j),y(j),3) = cmap(validx,4);
                if validx ~= 1
                    alphaArrH(x(j),y(j)) = opacityValue;
                end
            end
        end
    end
    
    % 5.
    function point = getContactCoords(coord,imElec,contact,point)
    
        vertCoords(:,1) = coord.Vert(~isnan(coord.Vert(:,1)),1);
        vertCoords(:,2) = coord.Vert(~isnan(coord.Vert(:,2)),2);
        vertCoords(:,3) = find(~isnan(coord.Vert(:,1)));
        vertDiffs(:,1) = diff(vertCoords(:,1));
        vertDiffs(:,2) = diff(vertCoords(:,2));
        for j = 1: height(vertDiffs)
            vertDiffs(j,:) = round(vertDiffs(j,:)/(vertCoords(j+1,3)-vertCoords(j,3)));
        end

        horCoords(:,1) = coord.Hor(~isnan(coord.Hor(:,1)),1);
        horCoords(:,2) = coord.Hor(~isnan(coord.Hor(:,2)),2);
        horCoords(:,3) = find(~isnan(coord.Hor(:,1)));
        horDiffs(:,1) = diff(horCoords(:,1));
        horDiffs(:,2) = diff(horCoords(:,2));
        for j = 1: height(horDiffs)
            horDiffs(j,:) = round(horDiffs(j,:)/(horCoords(j+1,3)-horCoords(j,3)));
        end

        modeVert = mode(vertDiffs);
        modeHor = mode(horDiffs);

        counter = 1;
        for n = vertCoords(1,3)-1:-1:1
            point.Vert.(imElec)(n,1) = coord.Vert(vertCoords(1,3),1) - counter*modeVert(1);
            point.Vert.(imElec)(n,2) = coord.Vert(vertCoords(1,3),2) - counter*modeVert(2);
            counter = counter+1;
        end
        counter = 1;
        for o = vertCoords(1,3)+1:height(coord.Vert)
            point.Vert.(imElec)(o,1) = coord.Vert(vertCoords(1,3),1) + counter*modeVert(1);
            point.Vert.(imElec)(o,2) = coord.Vert(vertCoords(1,3),2) + counter*modeVert(2);
            counter = counter+1;
        end
        point.Vert.(imElec)(vertCoords(1,3),:) = coord.Vert(vertCoords(1,3),:);
%         disp(coord.Vert);
%         disp(point.Vert.(imElec));

        counter = 1;
        for n = horCoords(1,3)-1:-1:1
            point.Hor.(imElec)(n,1) = coord.Hor(horCoords(1,3),1) - counter*modeHor(1);
            point.Hor.(imElec)(n,2) = coord.Hor(horCoords(1,3),2) - counter*modeHor(2);
            counter = counter+1;
        end
        counter = 1;
        for o = horCoords(1,3)+1:height(coord.Hor)
            point.Hor.(imElec)(o,1) = coord.Hor(horCoords(1,3),1) + counter*modeHor(1);
            point.Hor.(imElec)(o,2) = coord.Hor(horCoords(1,3),2) + counter*modeHor(2);
            counter = counter+1;
        end
        point.Hor.(imElec)(horCoords(1,3),:) = coord.Hor(horCoords(1,3),:);
%         disp(coord.Hor);
%         disp(point.Hor.(imElec));
    end
    
    % 6.
    function output = sliceCreator(ax_ctVert,ax_ctHor,ax_t1Vert,ax_t1Hor,...
        rotVolumes,coord,imElec,pointElec,alphaArrV,alphaArrH,colArrV,colArrH,...
        point,output,elecColor)
        hold(ax_ctVert,"on")
        hold(ax_t1Vert,"on")
        hold(ax_ctHor,"on")
        hold(ax_t1Hor,"on")
    
        % Create the image for the vertical slice (CT,T1, Segmentation)
        output.(imElec).sliceCT_Vert = imagesc(rotVolumes.ct_Vert(:,:,mode(coord.depthVert)),'Parent',ax_ctVert,'Visible','off');
        output.(imElec).sliceT1_Vert = imagesc(rotVolumes.t1_Vert(:,:,mode(coord.depthVert)),'Parent',ax_t1Vert,'Visible','off');
        output.(imElec).sliceSEG_VertCT = imagesc(colArrV,'Parent',ax_ctVert,'Visible','off','AlphaData',alphaArrV);
        output.(imElec).sliceSEG_VertT1 = imagesc(colArrV,'Parent',ax_t1Vert,'Visible','off','AlphaData',alphaArrV);
    
        % Create the image for the horizontal slice (CT,T1, Segmentation)
        output.(imElec).sliceCT_Hor = imagesc(rotVolumes.ct_Hor(:,:,mode(coord.depthHor)),'Parent',ax_ctHor,'Visible','off');
        output.(imElec).sliceT1_Hor = imagesc(rotVolumes.t1_Hor(:,:,mode(coord.depthHor)),'Parent',ax_t1Hor,'Visible','off');
        output.(imElec).sliceSEG_HorCT = imagesc(colArrH,'Parent',ax_ctHor,'Visible','off','AlphaData',alphaArrH);
        output.(imElec).sliceSEG_HorT1 = imagesc(colArrH,'Parent',ax_t1Hor,'Visible','off','AlphaData',alphaArrH);
        
        colormap(ax_ctVert,'bone');
        colormap(ax_ctHor,'bone');
        colormap(ax_t1Vert,'bone');
        colormap(ax_t1Hor,'bone');
        axis(ax_ctVert,'square');
        axis(ax_t1Vert,'square');
        axis(ax_ctHor,'square');
        axis(ax_t1Hor,'square');
    
    
        % Plot the contacts of current electrode as points on each slice
        output.(pointElec).CT_Vert = plot(ax_ctVert,point.Vert.(imElec)(:,2),point.Vert.(imElec)(:,1),'.','MarkerSize',20,'Visible','off','LineStyle','-','LineWidth',1.5,'Color',elecColor);
        output.(pointElec).T1_Vert = plot(ax_t1Vert,point.Vert.(imElec)(:,2),point.Vert.(imElec)(:,1),'.','MarkerSize',20,'Visible','off','LineStyle','-','LineWidth',1.5,'Color',elecColor);

        output.(pointElec).CT_Hor = plot(ax_ctHor,point.Hor.(imElec)(:,2),point.Hor.(imElec)(:,1),'.','MarkerSize',20,'Visible','off','LineStyle','-','LineWidth',1.5,'Color',elecColor);
        output.(pointElec).T1_Hor = plot(ax_t1Hor,point.Hor.(imElec)(:,2),point.Hor.(imElec)(:,1),'.','MarkerSize',20,'Visible','off','LineStyle','-','LineWidth',1.5,'Color',elecColor);
    end

end