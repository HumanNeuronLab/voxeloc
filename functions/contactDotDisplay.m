function widget = contactDotDisplay(widget)
    j1 = 1;
    j2 = 1;
    j3 = 1;
    currTab = widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag;
    switch currTab
        case 'CT'
            volName = 'CTvol';
        case 'T1'
            volName = 'T1vol';
    end
    if ~isfield(widget.glassbrain.UserData,volName)
        return
    end
    for i = 1:length(widget.viewer.(currTab).ax_sliceView1.Children)
        if isequal(widget.viewer.(currTab).ax_sliceView1.Children(i).Tag,'dot')
            idDelete1(j1) = i;
            j1 = j1+1;
        end
    end
    for i = 1:length(widget.viewer.(currTab).ax_sliceView2.Children)
        if isequal(widget.viewer.(currTab).ax_sliceView2.Children(i).Tag,'dot')
            idDelete2(j2) = i;
            j2 = j2+1;
        end
    end
    for i = 1:length(widget.viewer.(currTab).ax_sliceView3.Children)
        if isequal(widget.viewer.(currTab).ax_sliceView3.Children(i).Tag,'dot')
            idDelete3(j3) = i;
            j3 = j3+1;
        end
    end
    try
        widget.viewer.(currTab).ax_sliceView1.Children(idDelete1).delete
    catch
    end
    try
        widget.viewer.(currTab).ax_sliceView2.Children(idDelete2).delete
    catch
    end
    try
        widget.viewer.(currTab).ax_sliceView3.Children(idDelete3).delete
    catch
    end

    for i = 1:length(fieldnames(widget.fig.UserData))
        field = ['Electrode' num2str(i)];
        if isequal(widget.fig.UserData.(field).Estimation,'SUCCESS')
            xVal = widget.viewer.(currTab).slider_X.Value;
            yVal = widget.viewer.(currTab).slider_Y.Value;
            zVal = widget.viewer.(currTab).slider_Z.Value;
            widget.idX = find(...
                widget.fig.UserData.(field).contact(:,1) >= xVal-1 &...
                widget.fig.UserData.(field).contact(:,1) <= xVal+1);
            widget.idY = find(...
                widget.fig.UserData.(field).contact(:,2) >= yVal-1 &...
                widget.fig.UserData.(field).contact(:,2) <= yVal+1);
            widget.idZ = find(...
                widget.fig.UserData.(field).contact(:,3) >= zVal-1 &...
                widget.fig.UserData.(field).contact(:,3) <= zVal+1);

            hold(widget.viewer.(currTab).ax_sliceView1,'on');
            plot(widget.viewer.(currTab).ax_sliceView1,...
                widget.fig.UserData.(field).contact(widget.idZ,1), ...
                widget.fig.UserData.(field).contact(widget.idZ,2), ...
                'Marker','.','MarkerSize',15,'Tag','dot',...
                'Color',widget.glassbrain.UserData.electrodes.(field).Color);
            hold(widget.viewer.(currTab).ax_sliceView1,'off');

            hold(widget.viewer.(currTab).ax_sliceView2,'on');
            plot(widget.viewer.(currTab).ax_sliceView2,...
                widget.fig.UserData.(field).contact(widget.idX,3), ...
                widget.fig.UserData.(field).contact(widget.idX,2), ...
                'Marker','.','MarkerSize',15,'Tag','dot',...
                'Color',widget.glassbrain.UserData.electrodes.(field).Color);
            hold(widget.viewer.(currTab).ax_sliceView2,'off');

            hold(widget.viewer.(currTab).ax_sliceView3,'on');
            plot(widget.viewer.(currTab).ax_sliceView3,...
                widget.fig.UserData.(field).contact(widget.idY,1), ...
                length(widget.glassbrain.UserData.(volName)(1,:,1))-...
                widget.fig.UserData.(field).contact(widget.idY,3)+1, ...
                'Marker','.','MarkerSize',15,'Tag','dot',...
                'Color',widget.glassbrain.UserData.electrodes.(field).Color);
            hold(widget.viewer.(currTab).ax_sliceView3,'off');
        end
    end

end