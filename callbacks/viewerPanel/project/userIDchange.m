function userIDchange(~,evt,widget)
    if isempty(evt.Value)
        widget.glassbrain.UserData.userID = [];
    else
        widget.glassbrain.UserData.userID = evt.Value;
    end
end