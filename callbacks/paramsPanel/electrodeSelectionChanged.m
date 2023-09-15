function electrodeSelectionChanged(data,evt,widget)
    

    collapse(widget.tree_Summary);
    field = find(strcmp(data.Items,evt.Value));
    field = ['Electrode' num2str(field)];
    try
        expand(widget.tree.UserData.(field).electrodeName);
    catch
        warning('This electrode has the same name as another electrode. Please change the name.')
        return
    end

    switch widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag
        case 'CT'
            label_contact = widget.viewer.CT.label_contacts;
            slider_contact = widget.viewer.CT.slider_contacts;
            slider_X = widget.viewer.CT.slider_X;
            slider_Y = widget.viewer.CT.slider_Y;
            slider_Z = widget.viewer.CT.slider_Z;
        case 'T1'
            label_contact = widget.viewer.T1.label_contacts;
            slider_contact = widget.viewer.T1.slider_contacts;
            slider_X = widget.viewer.T1.slider_X;
            slider_Y = widget.viewer.T1.slider_Y;
            slider_Z = widget.viewer.T1.slider_Z;
    end


    try
        locator = strfind(widget.tree_Summary.SelectedNodes.Text,'_');
        elecName = widget.tree_Summary.SelectedNodes.Text(locator-2:end);
        if isempty(widget.tree_Summary.SelectedNodes) || ~(isequal(data.Value,elecName))
            if isnan(str2double(widget.tree_Summary.SelectedNodes.Text(9)))
                if contains(widget.tree_Summary.SelectedNodes.Text,'Deepest')
                    coords = widget.fig.UserData.(field).deepestCoord;
                    slider_X.Value = round(coords(1));
                    slider_Y.Value = round(coords(2));
                    slider_Z.Value = round(coords(3));
                    artificialEvent.Value = slider_X.Value;
                    sliderValueChanging(slider_X,artificialEvent,widget);
                    artificialEvent.Value = slider_Y.Value;
                    sliderValueChanging(slider_Y,artificialEvent,widget);
                    artificialEvent.Value = slider_Z.Value;
                    sliderValueChanging(slider_Z,artificialEvent,widget);
                elseif contains(widget.tree_Summary.SelectedNodes.Text,'Second')
                    coords = widget.fig.UserData.(field).secondCoord;
                    slider_X.Value = round(coords(1));
                    slider_Y.Value = round(coords(2));
                    slider_Z.Value = round(coords(3));
                    artificialEvent.Value = slider_X.Value;
                    sliderValueChanging(slider_X,artificialEvent,widget);
                    artificialEvent.Value = slider_Y.Value;
                    sliderValueChanging(slider_Y,artificialEvent,widget);
                    artificialEvent.Value = slider_Z.Value;
                    sliderValueChanging(slider_Z,artificialEvent,widget);
                else
                    currElectrode = find(contains(data.Items,data.Value));
                    widget.tree_Summary.SelectedNodes = widget.tree_Summary.Children(currElectrode);
                end
            end
        end
        if ~isnan(str2double(widget.tree_Summary.SelectedNodes.Text(9:10))) ||...
                ~isnan(str2double(widget.tree_Summary.SelectedNodes.Text(9)))
            if ~isnan(str2double(widget.tree_Summary.SelectedNodes.Text(9:10)))
                Value = str2double(widget.tree_Summary.SelectedNodes.Text(9:10));
            else
                Value = str2double(widget.tree_Summary.SelectedNodes.Text(9));
            end
            label_contact.Visible = 'on';
            label_contact.Text = ['Contact ' num2str(Value) ': ' mat2str(round(widget.fig.UserData.(field).contact(Value,:)))];
            slider_X.Value = round(widget.fig.UserData.(field).contact(Value,1));
            slider_Y.Value = round(widget.fig.UserData.(field).contact(Value,2));
            slider_Z.Value = round(widget.fig.UserData.(field).contact(Value,3));
        
            artificialEvent.Value = slider_X.Value;
            sliderValueChanging(slider_X,artificialEvent,widget);
            artificialEvent.Value = slider_Y.Value;
            sliderValueChanging(slider_Y,artificialEvent,widget);
            artificialEvent.Value = slider_Z.Value;
            sliderValueChanging(slider_Z,artificialEvent,widget);
            [n_contacts,~]  = size(widget.fig.UserData.(field).contact);
            slider_contact.Limits = [1 n_contacts];
            slider_contact.MajorTicks = (1:n_contacts);
            slider_contact.Value = Value;
            slider_contact.Visible = 'on';
            slider_contact.Visible = 'on';
            widget.viewer.CT.button_correctContacts.Visible = 'on';
            if Value ~= 1
                widget.viewer.CT.button_correctContacts.Enable = 'on';
            else
                widget.viewer.CT.button_correctContacts.Enable = 'off';
            end
            
        else
            expand(widget.tree.UserData.(field).contacts);
            [n_contacts,~]  = size(widget.fig.UserData.(field).contact);
            slider_contact.Limits = [1 n_contacts];
            slider_contact.MajorTicks = (1:n_contacts);
            slider_contact.Value = 1;
            slider_contact.Visible = 'on';
            label_contact.Text = ['Contact 1: ' mat2str(widget.fig.UserData.(field).contact(1,:))];
            label_contact.Visible = 'on';
            widget.viewer.CT.button_correctContacts.Enable = 'off';
            widget.viewer.CT.button_correctContacts.Visible = 'on';
        end
    catch
        slider_contact.Visible = 'off';
        label_contact.Visible = 'off';
        widget.viewer.CT.button_correctContacts.Visible = 'off';
    end
    try
        widget.params.field_ElectrodeName.Value = widget.fig.UserData.(field).Name(4:end);
        hemisphere = ['radio_' widget.fig.UserData.(field).Name(1)];
        widget.params.(hemisphere).Value = true;
    catch
        widget.params.field_ElectrodeName.Value = field;
        widget.params.radio_R.Value = true;
    end
    try
        widget.params.field_NumContacts.Value = widget.fig.UserData.(field).numContacts;
    catch
        widget.params.field_NumContacts.Value = 0;
    end
    try
        widget.params.field_ContactDistance.Value = widget.fig.UserData.(field).contactDist;
    catch
        widget.params.field_ContactDistance.Value = 0;
    end
    try
        widget.params.field_XDeepest.Value = widget.fig.UserData.(field).deepestCoord(1);
        widget.params.field_YDeepest.Value = widget.fig.UserData.(field).deepestCoord(2);
        widget.params.field_ZDeepest.Value = widget.fig.UserData.(field).deepestCoord(3);
    catch
        widget.params.field_XDeepest.Value = 0;
        widget.params.field_YDeepest.Value = 0;
        widget.params.field_ZDeepest.Value = 0;
    end
    try
        widget.params.field_XSecond.Value = widget.fig.UserData.(field).secondCoord(1);
        widget.params.field_YSecond.Value = widget.fig.UserData.(field).secondCoord(2);
        widget.params.field_ZSecond.Value = widget.fig.UserData.(field).secondCoord(3);
    catch
        widget.params.field_XSecond.Value = 0;
        widget.params.field_YSecond.Value = 0;
        widget.params.field_ZSecond.Value = 0;
    end
    
end