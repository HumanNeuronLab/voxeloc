function patientIDchange(~,evt,widget)
    if isequal(evt.EventName,'ValueChanged')||isequal(evt.EventName,'ValueChanging')
        if isempty(evt.Value)
            widget.glassbrain.UserData.patientID = [];
        else
            widget.glassbrain.UserData.patientID = evt.Value;
        end
        return
    end
end