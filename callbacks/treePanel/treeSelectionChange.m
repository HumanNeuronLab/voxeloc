function treeSelectionChange(~,evt,widget)
    
    currentTab = widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag;
    switch currentTab
        case 'CT'
            slider_contacts = widget.viewer.CT.slider_contacts;
            label_contacts = widget.viewer.CT.label_contacts;
            field_Xvalue1 = widget.viewer.CT.field_Xvalue;
            field_Yvalue1 = widget.viewer.CT.field_Yvalue;
            field_Zvalue1 = widget.viewer.CT.field_Zvalue;
            slider_x1 = widget.viewer.CT.slider_X;
            slider_y1 = widget.viewer.CT.slider_Y;
            slider_z1 = widget.viewer.CT.slider_Z;
            ax1 = widget.viewer.CT.ax_sliceView1;
            ax2 = widget.viewer.CT.ax_sliceView2;
            ax3 = widget.viewer.CT.ax_sliceView3;
            labelVI = widget.viewer.CT.label_voxelIntensity;
            button_correctContacts = widget.viewer.CT.button_correctContacts;
            artificial_evt.Value = widget.params.dropdown_ElectrodeSelector.Items(str2double(evt.SelectedNodes.Tag(10:end)));
            widget.params.dropdown_ElectrodeSelector.Value = {artificial_evt.Value};
            electrodeSelectionChanged(widget.params.dropdown_ElectrodeSelector,...
                artificial_evt,widget);
        case 'T1'
            if ~(isequal(widget.viewer.panel_CentralTabsMRI.SelectedTab.Title,'[select Anatomical NIfTI file (optional)]'))
                slider_contacts = widget.viewer.T1.slider_contacts;
                label_contacts = widget.viewer.T1.label_contacts;
                field_Xvalue1 = widget.viewer.T1.field_Xvalue;
                field_Yvalue1 = widget.viewer.T1.field_Yvalue;
                field_Zvalue1 = widget.viewer.T1.field_Zvalue;
                slider_x1 = widget.viewer.T1.slider_X;
                slider_y1 = widget.viewer.T1.slider_Y;
                slider_z1 = widget.viewer.T1.slider_Z;
                ax1 = widget.viewer.T1.ax_sliceView1;
                ax2 = widget.viewer.T1.ax_sliceView2;
                ax3 = widget.viewer.T1.ax_sliceView3;
                labelVI = widget.viewer.T1.label_voxelIntensity;
                button_correctContacts = widget.viewer.CT.button_correctContacts;
            else
                widget.panel_Centralwidget.viewer.panel_CentralTabsMRIMRI.SelectedTab = widget.viewer.CT.tab;
                slider_contacts = widget.viewer.CT.slider_contacts;
                label_contacts = widget.viewer.CT.label_contacts;
                field_Xvalue1 = widget.viewer.CT.field_Xvalue;
                field_Yvalue1 = widget.viewer.CT.field_Yvalue;
                field_Zvalue1 = widget.viewer.CT.field_Zvalue;
                slider_x1 = widget.viewer.CT.slider_X;
                slider_y1 = widget.viewer.CT.slider_Y;
                slider_z1 = widget.viewer.CT.slider_Z;
                ax1 = widget.viewer.CT.ax_sliceView1;
                ax2 = widget.viewer.CT.ax_sliceView2;
                ax3 = widget.viewer.CT.ax_sliceView3;
                labelVI = widget.viewer.CT.label_voxelIntensity;
                button_correctContacts = widget.viewer.CT.button_correctContacts;
            end
            artificial_evt.Value = widget.params.dropdown_ElectrodeSelector.Items(str2double(evt.SelectedNodes.Tag(10:end)));
            widget.params.dropdown_ElectrodeSelector.Value = {artificial_evt.Value};
            electrodeSelectionChanged(widget.params.dropdown_ElectrodeSelector,...
                artificial_evt,widget);
        case 'oblique'
            checkOblique(widget,'electrode');
    end

    currElec = str2double(evt.SelectedNodes.Tag(10:end));
    prevElec = findobj(widget.tree_Summary.Children,'Tag',['Electrode' num2str(currElec-1)]);
    if ~isempty(prevElec)
        widget.tree_buttonUp.Enable = 'on';
    else
        widget.tree_buttonUp.Enable = 'off';
    end

    nextElec = findobj(widget.tree_Summary.Children,'Tag',['Electrode' num2str(currElec+1)]);
    if ~isempty(nextElec)
        widget.tree_buttonDown.Enable = 'on';
    else
        widget.tree_buttonDown.Enable = 'off';
    end

    if isequal(widget.fig.UserData.(evt.SelectedNodes.Tag).Estimation,'SUCCESS')
        widget.tree_buttonColor.Enable = 'on';
    else
        widget.tree_buttonColor.Enable = 'off';
    end
end