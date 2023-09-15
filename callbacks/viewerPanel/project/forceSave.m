function forceSave(~,~,widget)
    try
        widget.viewer.projectParams.lamp_forceSave.Color = [0 0.65 1];
        drawnow();
        widget = widgetAutosave(widget);
        widget.viewer.projectParams.lamp_forceSave.Color = [0 1 0];
        pause(1);
        widget.viewer.projectParams.lamp_forceSave.Color = [0.94 0.94 0.94];
    catch
        widget.viewer.projectParams.lamp_forceSave.Color = [0.94 0.94 0.94];
    end
end