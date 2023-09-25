function instLogoLoad(~,evt,widget)
    path = evt.ValuePath;
    file = evt.ValueFile;
    widget.glassbrain.UserData.instLogoPath = path;
    widget.glassbrain.UserData.instLogoFile = file;
    widget.viewer.projectParams.field_instLogo.Visible = 'off';
    widget.viewer.projectParams.image_instLogo.Visible = 'on';
    widget.viewer.projectParams.image_instLogo.ImageSource = [path file];
    widget.viewer.projectParams.image_instLogo.Layout.Row = widget.viewer.projectParams.label_instLogo.Layout.Row;
    widget.viewer.projectParams.image_instLogo.Layout.Column = 2;
    widget.viewer.projectParams.button_instLogo.BackgroundColor = [0.94 0.94 0.94];
    widget.viewer.projectParams.lamp_instLogo.Color = [0 1 0];
end