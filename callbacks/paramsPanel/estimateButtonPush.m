function estimateButtonPush (~, ~, widget) 
    
    idx = find(contains(widget.params.dropdown_ElectrodeSelector.Items,widget.params.dropdown_ElectrodeSelector.Value));
    field = ['Electrode' num2str(idx)];

    n_contacts      = widget.fig.UserData.(field).numContacts;
    contact_dist    = widget.fig.UserData.(field).contactDist;
    X1              = widget.fig.UserData.(field).deepestCoord(1);
    Y1              = widget.fig.UserData.(field).deepestCoord(2);
    Z1              = widget.fig.UserData.(field).deepestCoord(3);
    X2              = widget.fig.UserData.(field).secondCoord(1);
    Y2              = widget.fig.UserData.(field).secondCoord(2);
    Z2              = widget.fig.UserData.(field).secondCoord(3);

    if isfield(widget.fig.UserData.(field),'contact')
        widget.fig.UserData.(field).contact = [];
    end
    widget.fig.UserData.(field).contact(1,1) = X1;
    widget.fig.UserData.(field).contact(1,2) = Y1;
    widget.fig.UserData.(field).contact(1,3) = Z1;
    try
        widget.tree.UserData.(field).contacts.delete;
    catch
    end
    
    try
        
        delta_total  = pdist2(widget.fig.UserData.(field).deepestCoord,widget.fig.UserData.(field).secondCoord);
        delta_totalSquared = delta_total^2;

        if delta_total == 0
            warning('Both coordinates have same values - Please try updating coordinates');
            widget.fig.UserData.(field).Estimation = 'FAILED';
            widget = checkStatus(field,widget);
            return
        end
        delta_x         = (X2-X1)^2 / delta_totalSquared;
        delta_y         = (Y2-Y1)^2 / delta_totalSquared;
        delta_z         = (Z2-Z1)^2 / delta_totalSquared;
        var_x           = X2-X1;
        var_y           = Y2-Y1;
        var_z           = Z2-Z1;

        widget.tree.UserData.(field).contacts = uitreenode('Parent',widget.tree.UserData.(field).electrodeName,'Text','Contact coordinates (X,Y,Z):','Tag',field);
        uitreenode('Parent',widget.tree.UserData.(field).contacts,'Text',['Contact 1: ' mat2str(round(widget.fig.UserData.(field).contact(1,:)))],'Tag',field);
        expand(widget.tree.UserData.(field).contacts);
        fprintf('\n\n<strong>%s contact coordinates:</strong>\n\n',widget.params.dropdown_ElectrodeSelector.Value);
        disp(['Contact 1: ' mat2str(widget.fig.UserData.(field).contact(1,:))]);
        for i = 2:n_contacts
            if var_x >= 0
                X = widget.fig.UserData.(field).contact(i-1,1) + sqrt(delta_x * contact_dist^2);
            else
                X = widget.fig.UserData.(field).contact(i-1,1) - sqrt(delta_x * contact_dist^2);
            end
            if var_y >= 0
                Y = widget.fig.UserData.(field).contact(i-1,2) + sqrt(delta_y * contact_dist^2);
            else
                Y = widget.fig.UserData.(field).contact(i-1,2) - sqrt(delta_y * contact_dist^2);
            end
            if var_z >= 0
                Z = widget.fig.UserData.(field).contact(i-1,3) + sqrt(delta_z * contact_dist^2);
            else
                Z = widget.fig.UserData.(field).contact(i-1,3) - sqrt(delta_z * contact_dist^2);
            end
            if widget.params.checkbox_LocalMax.Value == 1
                kernel = [0.75 0.75 0.75];
                kernel_vol = widget.glassbrain.UserData.CTvol(round(Y-kernel(1)):round(Y+kernel(1)),...
                    round(X-kernel(2)):round(X+kernel(2)),round(Z-kernel(3)):round(Z+kernel(3)));
                val = max(max(max(kernel_vol)));
                [x,y,z] = ind2sub(size(kernel_vol),find(kernel_vol == val));
                X_out = round(X + (y(1) - (1+kernel(1))));
                Y_out = round(Y + (x(1) - (1+kernel(2))));
                Z_out = round(Z + (z(1) - (1+kernel(3))));
            else
                X_out = X;
                Y_out = Y;
                Z_out = Z;
            end
            widget.fig.UserData.(field).contact(i,1)  = X_out;
            widget.fig.UserData.(field).contact(i,2) = Y_out;
            widget.fig.UserData.(field).contact(i,3) = Z_out;
            
            uitreenode('Parent',widget.tree.UserData.(field).contacts,'Text',['Contact ' num2str(i) ': ' mat2str(round(widget.fig.UserData.(field).contact(i,:)))],'Tag',field);
            if widget.params.checkbox_LocalMax.Value == 1
                disp(['Contact ' num2str(i) ': ' mat2str(round(widget.fig.UserData.(field).contact(i,:),3)) newline 'Adjusted: [' num2str(y(1) - (1+kernel(1))) num2str(x(1) - (1+kernel(2))) num2str(z(1) - (1+kernel(3))) ']']);
            else
                disp(['Contact ' num2str(i) ': ' mat2str(round(widget.fig.UserData.(field).contact(i,:),3))]);
            end
            
        end

        widget.fig.UserData.(field).Estimation = 'SUCCESS';
        widget.viewer.CT.slider_contacts.MajorTicks = (1:n_contacts);
        widget.viewer.CT.slider_contacts.Limits = [1 n_contacts];
        widget.viewer.CT.slider_contacts.Value = 1;
        widget.viewer.CT.label_contacts.Text = ['Contact 1: ' mat2str(widget.fig.UserData.(field).contact(1,:))];
        widget.viewer.CT.slider_contacts.Visible = 'on';
        widget.viewer.CT.label_contacts.Visible = 'on';
        widget.viewer.CT.button_correctContacts.Visible = 'on';
        widget.viewer.CT.button_correctContacts.Enable = 'off';
        widget.glassbrain.UserData.electrodes.(field).Color = widget.glassbrain.UserData.ColorList(idx,:);
        widget.glassbrain.UserData.electrodes.(field).coord = [];
        widget.glassbrain.UserData.electrodes.(field).coord = widget.fig.UserData.(field).contact;
        if isfield(widget.glassbrain.UserData.electrodes.(field),'ElectrodevolView') % delete old electrode line in 3d view
            delete(widget.glassbrain.UserData.electrodes.(field).ElectrodevolView);
            widget.glassbrain.UserData.electrodes.(field) = rmfield(widget.glassbrain.UserData.electrodes.(field),'ElectrodevolView');
        end
        widget = contactDotDisplay(widget);
    catch
        widget.fig.UserData.(field).Estimation = 'FAILED';
        warning('Contact coordinates estimation failed - Please try updating coordinates');
    end
    widget = checkStatus(field,widget);
    checkOblique(widget,'estimate');
    widget = widgetAutosave(widget);
end