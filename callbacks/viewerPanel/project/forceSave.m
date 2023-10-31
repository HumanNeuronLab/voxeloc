function forceSave(~,~,widget,pV)
    try
%         widget.viewer.projectParams.lamp_forceSave.Color = [0 0.65 1];
%         drawnow();
        if nargin == 4
            pV.lamp_forceSave.Color = [0 0.5 1];
            drawnow();
        end
        widget = widgetAutosave(widget);
        if nargin == 4
            cF = dir(widget.autosave.UserData.filePath);
            pause(0.5);
            pV.field_forceSave.Text = datestr(cF.date,'HH:MM dd/mmm/yyyy');
            pV.field_forceSave.FontColor = [0.94 0.94 0.94];
            pV.lamp_forceSave.Color = [0.94 0.94 0.94];
            drawnow()
        end
%         widget.viewer.projectParams.lamp_forceSave.Color = [0 1 0];
%         pause(1);
%         widget.viewer.projectParams.lamp_forceSave.Color = [0.94 0.94 0.94];
    catch
%         widget.viewer.projectParams.lamp_forceSave.Color = [0.94 0.94 0.94];
    end
end