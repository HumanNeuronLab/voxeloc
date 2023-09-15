function numElectrodeChanged(~,evt,widget)
   
    output_electrodes = length(fieldnames(widget.fig.UserData));
    if (evt.Value > output_electrodes) && (evt.PreviousValue <= output_electrodes)
        for i = output_electrodes+1:evt.Value
            field = ['Electrode' num2str(i)];
            widget.params.dropdown_ElectrodeSelector.Items(i) = {field};
            widget = update_outputData(widget,field);
        end
        widget.params.dropdown_ElectrodeSelector.Value = widget.params.dropdown_ElectrodeSelector.Items{i};
    else
        for i = 1:evt.Value
            field = ['Electrode' num2str(i)];
            try
                widget.params.dropdown_ElectrodeSelector.Items(i) = {widget.fig.UserData.(field).Name};
            catch
                widget.params.dropdown_ElectrodeSelector.Items(i) = {field};
            end
        end
        widget.params.dropdown_ElectrodeSelector.Value = widget.params.dropdown_ElectrodeSelector.Items{i};
        widget.params.dropdown_ElectrodeSelector.Items = widget.params.dropdown_ElectrodeSelector.Items(1:i);
    end

    widget.tree_Summary.Children.delete
    for i = 1:evt.Value
        field = ['Electrode' num2str(i)];
        widget = createTreeNode(widget,widget.tree_Summary,field);
        widget = checkStatus(field,widget);
    end

    collapse(widget.tree_Summary);
    expand(widget.tree.UserData.(field).electrodeName);
    try
        expand(widget.tree.UserData.(field).contacts);
        [n_contacts,~] = size(widget.fig.UserData.(field).contact); 
        widget.slider_contacts.Value = 1;
        widget.slider_contacts.Limits = [1 n_contacts];
        widget.slider_contacts.MajorTicks = (1:n_contacts);
        widget.slider_contacts.Visible = 'on';
        widget.label_contacts.Text = ['Contact 1: ' mat2str(widget.fig.UserData.(field).contact(1,:))];
        widget.label_contacts.Visible = 'on';
    catch
        widget.slider_contacts.Visible = 'off';
        widget.label_contacts.Visible = 'off';
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