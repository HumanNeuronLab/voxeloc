function transformVol(data,~,widget)

    if isequal(data.Text,'Rotate')
        widget.viewer.CT.transform.UserData.action = 'rotate';
    elseif isequal(data.Text,'Permute')
        widget.viewer.CT.transform.UserData.action = 'permute';
    end
    selectFile('CT',0,widget);
    if isfield(widget.glassbrain.UserData,'T1vol')
        selectFile('T1',0,widget);
    end
    widget.viewer.CT.transform.UserData.action = 'none';
    
end