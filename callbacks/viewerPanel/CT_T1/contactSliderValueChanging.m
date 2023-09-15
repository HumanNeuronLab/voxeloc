function contactSliderValueChanging(data,evt,widget)

    idx = find(contains(widget.params.dropdown_ElectrodeSelector.Items, widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];
    Value = round(evt.Value);

    switch widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag
        case 'CT'
            slider_x = widget.viewer.CT.slider_X;
            slider_y = widget.viewer.CT.slider_Y;
            slider_z = widget.viewer.CT.slider_Z;
            label_contacts = widget.viewer.CT.label_contacts;
            data.Value = Value;
            if Value ~= 1
                widget.viewer.CT.button_correctContacts.Enable = 'on';
            else
                widget.viewer.CT.button_correctContacts.Enable = 'off';
            end
        case 'T1'
            slider_x = widget.viewer.T1.slider_X;
            slider_y = widget.viewer.T1.slider_Y;
            slider_z = widget.viewer.T1.slider_Z;
            label_contacts = widget.viewer.T1.label_contacts;
    end 

    
    widget.tree_Summary.SelectedNodes = widget.tree.UserData.(field).contacts.Children(Value);
    
    label_contacts.Text = ['Contact ' num2str(Value) ': ' mat2str(round(widget.fig.UserData.(field).contact(Value,:)))];
    slider_x.Value = round(widget.fig.UserData.(field).contact(Value,1));
    slider_y.Value = round(widget.fig.UserData.(field).contact(Value,2));
    slider_z.Value = round(widget.fig.UserData.(field).contact(Value,3));

    artificialEvent.Value = slider_x.Value;
    sliderValueChanging(slider_x,artificialEvent,widget);
    artificialEvent.Value = slider_y.Value;
    sliderValueChanging(slider_y,artificialEvent,widget);
    artificialEvent.Value = slider_z.Value;
    sliderValueChanging(slider_z,artificialEvent,widget);

end