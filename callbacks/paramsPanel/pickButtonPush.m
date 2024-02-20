function pickButtonPush(data,~,widget)

    vol = widget.glassbrain.UserData.CTvol;
    idx = find(strcmp(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];
    if isequal(widget.fig.UserData.(field).Estimation, 'SUCCESS')
        widget.fig.UserData.(field).Estimation = 'RE-ESTIMATE';
    end
    if widget.params.checkbox_Snapping.Value == 1
        kernel = [2 2 2];
        X = widget.viewer.CT.field_Xvalue.Value;
        Y = widget.viewer.CT.field_Yvalue.Value;
        Z = widget.viewer.CT.field_Zvalue.Value;
        kernel_vol = vol(Y-kernel(1):Y+kernel(1),...
            X-kernel(2):X+kernel(2),Z-kernel(3):Z+kernel(3));
        val = max(max(max(kernel_vol)));
        [x,y,z] = ind2sub(size(kernel_vol),find(kernel_vol == val));
%         flag = false;
%         for x = 1:length(kernel_vol(1,:,:))
%             for y = 1:length(kernel_vol(:,1,:))
%                 for z = 1:length(kernel_vol(:,:,1))
%                     if kernel_vol(x,y,z) == val
%                         flag = true;
%                         break
%                     end
%                 end
%                 if flag == true
%                     break
%                 end
%             end
%             if flag == true
%                 break
%             end
%         end
        x_out = X + (y(1) - (1+kernel(1)));
        y_out = Y + (x(1) - (1+kernel(2)));
        z_out = Z + (z(1) - (1+kernel(3)));
        widget.viewer.CT.field_Xvalue.Value = x_out;
        widget.viewer.CT.field_Yvalue.Value = y_out;
        widget.viewer.CT.field_Zvalue.Value = z_out;
        n_evtX.Value = x_out;
        n_evtY.Value = y_out;
        n_evtZ.Value = z_out;
        
        fieldValueChanged(widget.viewer.CT.field_Xvalue,n_evtX,widget);
        fieldValueChanged(widget.viewer.CT.field_Yvalue,n_evtY,widget);
        fieldValueChanged(widget.viewer.CT.field_Zvalue,n_evtZ,widget);
    end
    switch data.Tag
        case 'Deepest'
            widget.params.field_XDeepest.Value = widget.viewer.CT.field_Xvalue.Value;
            widget.params.field_YDeepest.Value = widget.viewer.CT.field_Yvalue.Value;
            widget.params.field_ZDeepest.Value = widget.viewer.CT.field_Zvalue.Value;
            widget.fig.UserData.(field).deepestCoord = [widget.viewer.CT.field_Xvalue.Value widget.viewer.CT.field_Yvalue.Value widget.viewer.CT.field_Zvalue.Value];
            widget.tree.UserData.(field).deepestCoord.Text = ['Deepest contact coord. (X,Y,Z): ' mat2str(widget.fig.UserData.(field).deepestCoord)];
            widget.params.button_PickDeepest.BackgroundColor = [0.94,0.94,0.94];
        case 'Second'
            widget.params.field_XSecond.Value = widget.viewer.CT.field_Xvalue.Value;
            widget.params.field_YSecond.Value = widget.viewer.CT.field_Yvalue.Value;
            widget.params.field_ZSecond.Value = widget.viewer.CT.field_Zvalue.Value;
            widget.fig.UserData.(field).secondCoord = [widget.viewer.CT.field_Xvalue.Value widget.viewer.CT.field_Yvalue.Value widget.viewer.CT.field_Zvalue.Value];
            widget.tree.UserData.(field).secondCoord.Text = ['Second contact coord. (X,Y,Z): ' mat2str(widget.fig.UserData.(field).secondCoord)];
            widget.params.button_PickSecond.BackgroundColor = [0.94,0.94,0.94];
    end
    widget = checkStatus(field,widget);
end