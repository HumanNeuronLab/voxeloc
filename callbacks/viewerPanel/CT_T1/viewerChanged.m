function viewerChanged(~,evt,widget)

    currTab = evt.NewValue.Tag;
    prevTab = evt.OldValue.Tag;

    if isequal(currTab,'CT') && ...
            isfield(widget.glassbrain.UserData,'filePathCT')
        widget.params.panel_ElectrodeParams.Enable = 'on';
    else
        widget.params.panel_ElectrodeParams.Enable = 'off';
    end

    if ((isequal(prevTab,'CT') || isequal(prevTab,'T1')) &&...
            isfield(widget.glassbrain.UserData,'filePathCT') && ...
            isfield(widget.glassbrain.UserData,'filePathT1'))
        if isequal(prevTab,'CT')
            updateTab = 'T1';
            updateVol = 'T1vol';
        else
            updateTab = 'CT';
            updateVol = 'CTvol';
        end

        % Delete old dots
        widget = deleteContactDots(widget,prevTab,updateTab);

        for j = 1:numel(widget.viewer.(updateTab).ax_sliceView1.Children)
            CindexerPrev(j) = {widget.viewer.(prevTab).ax_sliceView1.Children(j).Tag};
            CindexerUpdate(j) = {widget.viewer.(updateTab).ax_sliceView1.Children(j).Tag};
            cverterPrev = str2double(CindexerPrev{j});
            if ~isempty(cverterPrev) && ~isnan(cverterPrev)
                cPlaneIdxPrev = j;
            end
            cverterUpdate = str2double(CindexerUpdate{j});
            if ~isempty(cverterUpdate) && ~isnan(cverterUpdate)
                cPlaneIdxUpdate = j;
            end
        end
        cCrossHairIdxPrev = find(contains(CindexerPrev,'coronal_crosshair'));
        cCrossHairIdxUpdate = find(contains(CindexerUpdate,'coronal_crosshair'));
        CindexerPrev{cPlaneIdxPrev} = cverterPrev;

        for k = 1:numel(widget.viewer.(updateTab).ax_sliceView2.Children)
            SindexerPrev(k) = {widget.viewer.(prevTab).ax_sliceView2.Children(k).Tag};
            SindexerUpdate(k) = {widget.viewer.(updateTab).ax_sliceView2.Children(k).Tag};
            cverterPrev = str2double(SindexerPrev{k});
            if ~isempty(cverterPrev) && ~isnan(cverterPrev)
                sPlaneIdxPrev = k;
            end
            cverterUpdate = str2double(SindexerUpdate{k});
            if ~isempty(cverterUpdate) && ~isnan(cverterUpdate)
                sPlaneIdxUpdate = k;
            end
        end
        sCrossHairIdxPrev = find(contains(SindexerPrev,'sagittal_crosshair'));
        sCrossHairIdxUpdate = find(contains(SindexerUpdate,'sagittal_crosshair'));
        SindexerPrev{sPlaneIdxPrev} = cverterPrev;

        for l = 1:numel(widget.viewer.(updateTab).ax_sliceView3.Children)
            AindexerPrev(l) = {widget.viewer.(prevTab).ax_sliceView3.Children(l).Tag};
            AindexerUpdate(l) = {widget.viewer.(updateTab).ax_sliceView3.Children(l).Tag};
            cverterPrev = str2double(AindexerPrev{l});
            if ~isempty(cverterPrev) && ~isnan(cverterPrev)
                aPlaneIdxPrev = l;
            end
            cverterUpdate = str2double(AindexerUpdate{l});
            if ~isempty(cverterUpdate) && ~isnan(cverterUpdate)
                aPlaneIdxUpdate = l;
            end
        end
        aCrossHairIdxPrev = find(contains(AindexerPrev,'axial_crosshair'));
        aCrossHairIdxUpdate = find(contains(AindexerUpdate,'axial_crosshair'));
        AindexerPrev{aPlaneIdxPrev} = cverterPrev;

        widget.viewer.(updateTab).slider_X.Value = widget.viewer.(prevTab).slider_X.Value;
        widget.viewer.(updateTab).slider_Y.Value = widget.viewer.(prevTab).slider_Y.Value;
        widget.viewer.(updateTab).slider_Z.Value = widget.viewer.(prevTab).slider_Z.Value;
        
        widget.viewer.(updateTab).field_Xvalue.Value = widget.viewer.(prevTab).field_Xvalue.Value;
        widget.viewer.(updateTab).field_Yvalue.Value = widget.viewer.(prevTab).field_Yvalue.Value;
        widget.viewer.(updateTab).field_Zvalue.Value = widget.viewer.(prevTab).field_Zvalue.Value;

        widget.viewer.(updateTab).label_voxelIntensity.Text = ['Voxel intensity: ' ...
            mat2str(round(widget.glassbrain.UserData.(updateVol)...
            (widget.viewer.(updateTab).field_Xvalue.Value,...
            widget.viewer.(updateTab).field_Yvalue.Value,...
            widget.viewer.(updateTab).field_Zvalue.Value)))];

%         if isequal(widget.viewer.(prevTab).label_contacts.Visible,'on')
%             widget.viewer.(updateTab).label_contacts.Visible = 'on';
%             widget.viewer.(updateTab).slider_contacts.Visible = 'on';
%             widget.viewer.(updateTab).button_correctContacts.Visible = 'on';
%             if widget.viewer.(prevTab).slider_contacts.Value == 1
%                 widget.viewer.CT.button_correctContacts.Enable = 'off';
%             end
%         else
%             widget.viewer.(updateTab).label_contacts.Visible = 'off';
%             widget.viewer.(updateTab).slider_contacts.Visible = 'off';
%             widget.viewer.(updateTab).button_correctContacts.Visible = 'off';
%         end

%         widget.viewer.(updateTab).label_contacts.Text = widget.viewer.(prevTab).label_contacts.Text;
%         widget.viewer.(updateTab).slider_contacts.Value = widget.viewer.(prevTab).slider_contacts.Value;

        widget.viewer.(updateTab).ax_sliceView1.Children(cCrossHairIdxUpdate).Position = ...
            widget.viewer.(prevTab).ax_sliceView1.Children(cCrossHairIdxPrev).Position;
        widget.viewer.(updateTab).ax_sliceView1.Children(cPlaneIdxUpdate).Tag = ...
            widget.viewer.(updateTab).ax_sliceView1.Children(cPlaneIdxPrev).Tag;
        widget.viewer.(updateTab).ax_sliceView1.Children(cPlaneIdxUpdate).CData = ...
            widget.glassbrain.UserData.(updateVol)(:,:,CindexerPrev{cPlaneIdxPrev});
        widget.viewer.(updateTab).label_coronalSlice.Text = widget.viewer.(prevTab).label_coronalSlice.Text;
        widget.viewer.(updateTab).label_coronalVI.Text = widget.viewer.(updateTab).label_voxelIntensity.Text;

        vol_size = size(widget.glassbrain.UserData.(updateVol));
        widget.viewer.(updateTab).ax_sliceView2.Children(sCrossHairIdxUpdate).Position = ...
            widget.viewer.(prevTab).ax_sliceView2.Children(sCrossHairIdxPrev).Position;
        widget.viewer.(updateTab).ax_sliceView2.Children(sPlaneIdxUpdate).Tag = ...
            widget.viewer.(updateTab).ax_sliceView2.Children(sPlaneIdxPrev).Tag;
        widget.viewer.(updateTab).ax_sliceView2.Children(sPlaneIdxUpdate).CData = ...
            reshape(widget.glassbrain.UserData.(updateVol)(:,SindexerPrev{sPlaneIdxPrev},:),[vol_size(1),vol_size(3)]);
        widget.viewer.(updateTab).label_sagittalSlice.Text = widget.viewer.(prevTab).label_sagittalSlice.Text;
        widget.viewer.(updateTab).label_sagittalVI.Text = widget.viewer.(updateTab).label_voxelIntensity.Text;

        widget.viewer.(updateTab).ax_sliceView3.Children(aCrossHairIdxUpdate).Position = ...
            widget.viewer.(prevTab).ax_sliceView3.Children(aCrossHairIdxPrev).Position;
        widget.viewer.(updateTab).ax_sliceView3.Children(aPlaneIdxUpdate).Tag = ...
            widget.viewer.(updateTab).ax_sliceView3.Children(aPlaneIdxPrev).Tag;
        widget.viewer.(updateTab).ax_sliceView3.Children(aPlaneIdxUpdate).CData = ...
            rot90(reshape(widget.glassbrain.UserData.(updateVol)(AindexerPrev{aPlaneIdxPrev},:,:),[vol_size(2),vol_size(3)]));
        widget.viewer.(updateTab).label_axialSlice.Text = widget.viewer.(prevTab).label_axialSlice.Text;
        widget.viewer.(updateTab).label_axialVI.Text = widget.viewer.(updateTab).label_voxelIntensity.Text;
    
    end
    if isequal(currTab,'order')
        reorderElecs(widget);

    elseif isequal(currTab,'oblique')
        checkOblique(widget,'tab');

    elseif isequal(currTab,'CT') || isequal(currTab,'T1')
        widget = contactDotDisplay(widget);
    end

    function widget = deleteContactDots(widget,prevTab,updateTab)
        gBis = 1;
        for g = 1:numel(widget.viewer.(prevTab).ax_sliceView1.Children)
            if isequal(widget.viewer.(prevTab).ax_sliceView1.Children(gBis).Tag,'dot')
                widget.viewer.(prevTab).ax_sliceView1.Children(gBis).delete;
            else
                gBis = gBis+1;
            end
        end
        hBis = 1;
        for h = 1:numel(widget.viewer.(prevTab).ax_sliceView2.Children)
            if isequal(widget.viewer.(prevTab).ax_sliceView2.Children(hBis).Tag,'dot')
                widget.viewer.(prevTab).ax_sliceView2.Children(hBis).delete;
            else
                hBis = hBis+1;
            end
        end
        iBis = 1;
        for i = 1:numel(widget.viewer.(prevTab).ax_sliceView3.Children)
            if isequal(widget.viewer.(prevTab).ax_sliceView3.Children(iBis).Tag,'dot')
                widget.viewer.(prevTab).ax_sliceView3.Children(iBis).delete;
            else
                iBis = iBis+1;
            end
        end
        gBis = 1;
        for g = 1:numel(widget.viewer.(updateTab).ax_sliceView1.Children)
            if isequal(widget.viewer.(updateTab).ax_sliceView1.Children(gBis).Tag,'dot')
                widget.viewer.(updateTab).ax_sliceView1.Children(gBis).delete;
            else
                gBis = gBis+1;
            end
        end
        hBis = 1;
        for h = 1:numel(widget.viewer.(updateTab).ax_sliceView2.Children)
            if isequal(widget.viewer.(updateTab).ax_sliceView2.Children(hBis).Tag,'dot')
                widget.viewer.(updateTab).ax_sliceView2.Children(hBis).delete;
            else
                hBis = hBis+1;
            end
        end
        iBis = 1;
        for i = 1:numel(widget.viewer.(updateTab).ax_sliceView3.Children)
            if isequal(widget.viewer.(updateTab).ax_sliceView3.Children(iBis).Tag,'dot')
                widget.viewer.(updateTab).ax_sliceView3.Children(iBis).delete;
            else
                iBis = iBis+1;
            end
        end
    end
end