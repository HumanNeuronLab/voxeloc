function widget = update_outputData(widget,field)
    switch nargin
        case 1
            widget.fig.UserData = [];
            field = 'Electrode1';
    end
    widget.fig.UserData.(field).Name = [];
    widget.fig.UserData.(field).numContacts = [];
    widget.fig.UserData.(field).contactDist = [];
    widget.fig.UserData.(field).deepestCoord = [];
    widget.fig.UserData.(field).secondCoord = [];
    widget.fig.UserData.(field).Estimation = [];
end