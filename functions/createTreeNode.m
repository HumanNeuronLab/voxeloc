function widget = createTreeNode(widget,currTree,field)

    try
        widget.tree.UserData.(field).electrodeName = uitreenode('Parent',currTree,'Text',widget.fig.UserData.(field).Name,'Tag',field);
    catch
        widget.tree.UserData.(field).electrodeName = uitreenode('Parent',currTree,'Text',field,'Tag',field);
    end
    widget.tree.UserData.(field).numberContacts = uitreenode('Parent',widget.tree.UserData.(field).electrodeName,'Text',['Number of contacts: ' num2str(widget.fig.UserData.(field).numContacts)],'Tag',field);
    widget.tree.UserData.(field).contactDistance = uitreenode('Parent',widget.tree.UserData.(field).electrodeName,'Text',['Inter-contact distance (mm): ' num2str(widget.fig.UserData.(field).contactDist)],'Tag',field);
    widget.tree.UserData.(field).deepestCoord = uitreenode('Parent',widget.tree.UserData.(field).electrodeName,'Text',['Deepest contact coord. (X,Y,Z): ' mat2str(widget.fig.UserData.(field).deepestCoord)],'Tag',field);
    widget.tree.UserData.(field).secondCoord = uitreenode('Parent',widget.tree.UserData.(field).electrodeName,'Text',['Second contact coord. (X,Y,Z): ' mat2str(widget.fig.UserData.(field).secondCoord)],'Tag',field);
    if isequal(widget.fig.UserData.(field).Estimation, 'SUCCESS')
        widget.tree.UserData.(field).contacts = uitreenode('Parent',widget.tree.UserData.(field).electrodeName,'Text','Contact coordinates (X,Y,Z):','Tag',field);
        [n_contacts,~] = size(widget.fig.UserData.(field).contact);
        for i = 1:n_contacts
            uitreenode('Parent',widget.tree.UserData.(field).contacts,'Text',['Contact ' num2str(i) ': ' mat2str(round(widget.fig.UserData.(field).contact(i,:)))],'Tag',field);
        end
    end
end