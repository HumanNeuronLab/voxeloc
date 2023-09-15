function applyOpacity(~,~,widget)

    widget.fig.Pointer = 'watch';
    widget.viewer.oblique.button_applyOpacity.Enable = 'off';
    drawnow();
    opVal = widget.viewer.oblique.slider_opacity.Value;
    for i = 1:numel(fieldnames(widget.fig.UserData))
        try
            currElec = ['Electrode' num2str(i)];
            idxVert = find(widget.fig.UserData.(currElec).oblique.image.sliceSEG_VertT1.AlphaData ~= 0);
            widget.fig.UserData.(currElec).oblique.image.sliceSEG_VertT1.AlphaData(idxVert) = opVal/100;
            widget.fig.UserData.(currElec).oblique.image.sliceSEG_VertCT.AlphaData(idxVert) = opVal/100;
            idxHor = find(widget.fig.UserData.(currElec).oblique.image.sliceSEG_HorT1.AlphaData ~= 0);
            widget.fig.UserData.(currElec).oblique.image.sliceSEG_HorT1.AlphaData(idxHor) = opVal/100;
            widget.fig.UserData.(currElec).oblique.image.sliceSEG_HorCT.AlphaData(idxHor) = opVal/100;
        catch
        end
    end
    widget = widgetAutosave(widget);
    widget.fig.Pointer = 'arrow';
end