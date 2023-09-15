function opacityValueChanged(src,~,widget)

    widget.viewer.oblique.slider_opacity.Value = round(src.Value/5)*5;
    widget.viewer.oblique.label_opacity.Text = ['Parcellation opacity: ' num2str(widget.viewer.oblique.slider_opacity.Value) '%'];
    currElec = widget.tree_Summary.SelectedNodes.Tag;
    idxVert = find(widget.fig.UserData.(currElec).oblique.image.sliceSEG_VertT1.AlphaData ~= 0);
    widget.fig.UserData.(currElec).oblique.image.sliceSEG_VertT1.AlphaData(idxVert) = widget.viewer.oblique.slider_opacity.Value/100;
    widget.fig.UserData.(currElec).oblique.image.sliceSEG_VertCT.AlphaData(idxVert) = widget.viewer.oblique.slider_opacity.Value/100;
    idxHor = find(widget.fig.UserData.(currElec).oblique.image.sliceSEG_HorT1.AlphaData ~= 0);
    widget.fig.UserData.(currElec).oblique.image.sliceSEG_HorT1.AlphaData(idxHor) = widget.viewer.oblique.slider_opacity.Value/100;
    widget.fig.UserData.(currElec).oblique.image.sliceSEG_HorCT.AlphaData(idxHor) = widget.viewer.oblique.slider_opacity.Value/100;
    widget.viewer.oblique.button_applyOpacity.Enable = 'on';
end