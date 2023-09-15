function secondCoordsChanged(~,~,widget)
   
    idx = find(contains(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];
    if isequal(widget.fig.UserData.(field).Estimation, 'SUCCESS')
        widget.fig.UserData.(field).Estimation = 'RE-ESTIMATE';
    end
    second_coords = [widget.params.field_XSecond.Value widget.params.field_YSecond.Value widget.params.field_ZSecond.Value];
    widget.tree.UserData.(field).secondCoord.Text = ['Second contact coord. (X,Y,Z): ' mat2str(second_coords)];
    widget.fig.UserData.(field).secondCoord = second_coords;
    widget = checkStatus(field,widget);
end