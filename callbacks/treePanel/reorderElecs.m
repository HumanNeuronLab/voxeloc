function reorderElecs(src,~,widget)
    
    widget.fig.Pointer = 'watch';
    drawnow();
    tic;
    elecName = widget.tree_Summary.SelectedNodes.Tag;
    currElec = str2double(elecName(10:end));
    permutor = linspace(1,numel(fieldnames(widget.fig.UserData)),numel(fieldnames(widget.fig.UserData)));
    if isequal(src.Tag,'UP')
        permutor(currElec) = permutor(currElec-1);
        permutor(currElec-1) = currElec;
        currElec= ['Electrode' num2str(currElec-1)];
    elseif isequal(src.Tag,'DOWN')
        permutor(currElec) = permutor(currElec+1);
        permutor(currElec+1) = currElec;
        currElec = ['Electrode' num2str(currElec+1)];
    end
    widget.fig.UserData = orderfields(widget.fig.UserData,permutor);
    widget.glassbrain.UserData.electrodes = orderfields(widget.glassbrain.UserData.electrodes,permutor);
    for i = 1:numel(permutor)
        fNames{i} = ['Electrode' num2str(i)];
    end
    widget.fig.UserData = cell2struct(struct2cell(widget.fig.UserData), fNames);
    widget.glassbrain.UserData.electrodes = cell2struct(struct2cell(widget.glassbrain.UserData.electrodes), fNames);
    artEvt.Value = numel(permutor);
    artEvt.PreviousValue = numel(permutor);
    numElectrodeChanged([],artEvt,widget);
    elecName = widget.fig.UserData.(currElec).Name;
    artEvt = [];
    artEvt.Value = elecName;
    widget.params.dropdown_ElectrodeSelector.Value = elecName;
    electrodeSelectionChanged(widget.params.dropdown_ElectrodeSelector,artEvt,widget);
    widget.tree_Summary.SelectedNodes = findobj(widget.tree_Summary.Children,'Text',elecName);
    treeSelectionChange([],widget.tree_Summary,widget);
    drawnow();
    widget.fig.Pointer = 'arrow';
end