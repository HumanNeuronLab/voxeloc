function hemisphereChanged(~,evt,widget)

    idx = find(strcmp(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];
    artEvt.Value = widget.params.field_ElectrodeName.Value;
    artEvt.PreviousValue = ['X' widget.params.field_ElectrodeName.Value];
    electrodeNameChanged([],artEvt,widget);
    widget.tree.UserData.(field).electrodeName.Text = [evt.NewValue.Text ...
        widget.params.radiogroup2.SelectedObject.Text '_' widget.params.field_ElectrodeName.Value];
    widget.params.dropdown_ElectrodeSelector.Items{idx} = [evt.NewValue.Text ...
        widget.params.radiogroup2.SelectedObject.Text '_' widget.params.field_ElectrodeName.Value];
    widget.params.dropdown_ElectrodeSelector.Value = widget.params.dropdown_ElectrodeSelector.Items{idx};
    widget.fig.UserData.(field).Name = [evt.NewValue.Text ...
        widget.params.radiogroup2.SelectedObject.Text '_' widget.params.field_ElectrodeName.Value];
    widget = checkStatus(field,widget);
end