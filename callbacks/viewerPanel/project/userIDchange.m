function userIDchange(~,evt,widget)
    if isempty(evt.Value)
        widget.viewer.projectParams.lamp_userID.Color = [1 0 0];
        widget.glassbrain.UserData.userID = [];
    else
        widget.viewer.projectParams.field_userID.FontColor = [0 0 0];
        widget.viewer.projectParams.lamp_userID.Color = [0 1 0];
        widget.glassbrain.UserData.userID = evt.Value;
    end
end