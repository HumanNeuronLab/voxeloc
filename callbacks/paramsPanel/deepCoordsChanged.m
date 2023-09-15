function deepCoordsChanged(~,~,widget)
    
    idx = find(contains(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];
    if isequal(widget.fig.UserData.(field).Estimation, 'SUCCESS')
        widget.fig.UserData.(field).Estimation = 'RE-ESTIMATE';
    end
    deep_coords = [widget.params.field_XDeepest.Value widget.params.field_YDeepest.Value widget.params.field_ZDeepest.Value];
    widget.tree.UserData.(field).deepestCoord.Text = ['Deepest contact coord. (X,Y,Z): ' mat2str(deep_coords)];
    widget.fig.UserData.(field).deepestCoord = deep_coords;
    widget = checkStatus(field,widget);
end