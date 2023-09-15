function resetView(~,~,widget)
    data = widget.viewer.panel_CentralTabsMRI.SelectedTab;
    widget.viewer.CT.transform.UserData.action = 'resetView';
    selectFile(data, [], widget)

end