function electrodeNameChanged(~,evt,widget)

    idx = find(contains(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    errorVal = 0;
    for i = 1:numel(widget.params.dropdown_ElectrodeSelector.Items)
        if isequal(widget.params.dropdown_ElectrodeSelector.Items{i},...
                [widget.params.radiogroup1.SelectedObject.Text widget.params.radiogroup2.SelectedObject.Text '_' evt.Value])
            widget.params.field_ElectrodeName.Value = evt.PreviousValue;
            warning('Another electrode already has this name.')
            errorVal = 1;
            break
        end
    end
    if errorVal == 1
        uialert(widget.fig,'Another electrode already has this name','Invalid Electrode Name');
        return
    end
    field = ['Electrode' num2str(idx)];
    if contains(evt.Value, ' ') || contains(evt.Value, '_')
        warning('Electrode name may not contains spaces or underscores.')
        widget.params.label_NameAcceptance.Text = ['Warning: rename electrode!' newline 'Electrode name may not contains spaces or underscores.'];
        widget.params.label_NameAcceptance.Visible = 'on';
        widget.params.label_NameAcceptance.FontColor = [1,0.65,0];
        widget.params.field_ElectrodeName.BackgroundColor = [1,0.95,0.95];
        widget.params.field_ElectrodeName.Value = evt.PreviousValue;
    else
        widget.params.label_NameAcceptance.Visible = 'off';
        widget.params.field_ElectrodeName.BackgroundColor = [1,1,1];
        widget.tree.UserData.(field).electrodeName.Text = [widget.params.radiogroup1.SelectedObject.Text ...
            widget.params.radiogroup2.SelectedObject.Text '_' evt.Value];
        widget.params.dropdown_ElectrodeSelector.Items{idx} = [widget.params.radiogroup1.SelectedObject.Text ...
            widget.params.radiogroup2.SelectedObject.Text '_' evt.Value];
        widget.params.dropdown_ElectrodeSelector.Value = widget.params.dropdown_ElectrodeSelector.Items{idx};
        widget.fig.UserData.(field).Name = [widget.params.radiogroup1.SelectedObject.Text ...
            widget.params.radiogroup2.SelectedObject.Text '_' evt.Value];
    end
    widget = checkStatus(field,widget);
end