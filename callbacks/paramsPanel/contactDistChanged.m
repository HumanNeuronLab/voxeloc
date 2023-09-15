function contactDistChanged(~,evt,widget)
    
    idx = find(contains(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];
    if isequal(widget.fig.UserData.(field).Estimation, 'SUCCESS')
        widget.fig.UserData.(field).Estimation = 'RE-ESTIMATE';
    end
    widget.tree.UserData.(field).contactDistance.Text = ['Inter-contact distance (mm): ' num2str(evt.Value)];
    widget.fig.UserData.(field).contactDist = evt.Value;
    widget = checkStatus(field,widget);
end