function changeElecColor(~,~,widget)
    currElec = widget.tree_Summary.SelectedNodes.Tag;
    oC = widget.glassbrain.UserData.electrodes.(currElec).Color;
    nC = uisetcolor(oC,'Select a color');
    figure(widget.fig);
    widget.glassbrain.UserData.electrodes.(currElec).Color = nC;
    widget = checkStatus(currElec,widget,[]);
    checkOblique(widget,'estimate');
    widget = widgetAutosave(widget);
end