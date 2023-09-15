function fieldValueChanged(data,evt,widget)

    curr_field = data.Tag;

    switch widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag
        case 'CT'
            vol = widget.glassbrain.UserData.CTvol;
            ax1 = widget.viewer.CT.ax_sliceView1;
            ax2 = widget.viewer.CT.ax_sliceView2;
            ax3 = widget.viewer.CT.ax_sliceView3;
            labelC = widget.viewer.CT.label_coronalSlice;
            labelS = widget.viewer.CT.label_sagittalSlice;
            labelA = widget.viewer.CT.label_axialSlice;
            labelCVI = widget.viewer.CT.label_coronalVI;
            labelSVI = widget.viewer.CT.label_sagittalVI;
            labelAVI = widget.viewer.CT.label_axialVI;
            labelVI = widget.viewer.CT.label_voxelIntensity;
            slider1 = widget.viewer.CT.slider_X;
            slider2 = widget.viewer.CT.slider_Y;
            slider3 = widget.viewer.CT.slider_Z;
            field1 = widget.viewer.CT.field_Xvalue;
            field2 = widget.viewer.CT.field_Yvalue;
            field3 = widget.viewer.CT.field_Zvalue;
        case 'T1'
            vol = widget.glassbrain.UserData.T1vol;
            ax1 = widget.viewer.T1.ax_sliceView1;
            ax2 = widget.viewer.T1.ax_sliceView2;
            ax3 = widget.viewer.T1.ax_sliceView3;
            labelC = widget.viewer.T1.label_coronalSlice;
            labelS = widget.viewer.T1.label_sagittalSlice;
            labelA = widget.viewer.T1.label_axialSlice;
            labelCVI = widget.viewer.T1.label_coronalVI;
            labelSVI = widget.viewer.T1.label_sagittalVI;
            labelAVI = widget.viewer.T1.label_axialVI;
            labelVI = widget.viewer.T1.label_voxelIntensity;
            slider1 = widget.viewer.T1.slider_X;
            slider2 = widget.viewer.T1.slider_Y;
            slider3 = widget.viewer.T1.slider_Z;
            field1 = widget.viewer.T1.field_Xvalue;
            field2 = widget.viewer.T1.field_Yvalue;
            field3 = widget.viewer.T1.field_Zvalue;
    end

    vol_size = size(vol);
    switch curr_field
        case 'X field'
            
            pos = [evt.Value,field2.Value,field3.Value];
            for i = 1:length(ax1.Children)
                if isequal(ax1.Children(i).Type,'images.roi.crosshair')
                    ax1.Children(i).Position = [pos(1) pos(2)];
                end
            end
            for i = 1:length(ax2.Children)
                if isequal(ax2.Children(i).Type,'image')
                    ax2.Children(i).CData = reshape(vol(:,pos(1),:),[vol_size(1),vol_size(3)]);
                    ax2.Children(i).Tag = num2str(pos(1));
                elseif isequal(ax2.Children(i).Type,'images.roi.crosshair')
                    ax2.Children(i).Position = [pos(3) pos(2)];
                end
            end
            for i = 1:length(ax3.Children)
                if isequal(ax3.Children(i).Type,'images.roi.crosshair')
                    ax3.Children(i).Position = [pos(1) vol_size(3)-pos(3)+1];
                end
            end
            slider1.Value = evt.Value;

        case 'Y field'
            
            pos = [field1.Value,evt.Value,field3.Value];
            for i = 1:length(ax1.Children)
                if isequal(ax1.Children(i).Type,'images.roi.crosshair')
                    ax1.Children(i).Position = [pos(1) pos(2)];
                end
            end
            for i = 1:length(ax2.Children)
                if isequal(ax2.Children(i).Type,'images.roi.crosshair')
                    ax2.Children(i).Position = [pos(3) pos(2)];
                end
            end
            for i = 1:length(ax3.Children)
                if isequal(ax3.Children(i).Type,'image')
                    ax3.Children(i).CData = rot90(reshape(vol(pos(2),:,:),[vol_size(2),vol_size(3)]));
                    ax3.Children(i).Tag = num2str(pos(2));
                elseif isequal(ax3.Children(i).Type,'images.roi.crosshair')
                    ax3.Children(i).Position = [pos(1) vol_size(3)-pos(3)+1];
                end
            end
            slider2.Value = evt.Value;

        case 'Z field'
            
            pos = [field1.Value,field2.Value,evt.Value];
            for i = 1:length(ax1.Children)
                if isequal(ax1.Children(i).Type,'image')
                    ax1.Children(i).CData = vol(:,:,pos(3));
                    ax1.Children(i).Tag = num2str(pos(3));
                elseif isequal(ax1.Children(i).Type,'images.roi.crosshair')
                    ax1.Children(i).Position = [pos(1) pos(2)];
                end
            end
            for i = 1:length(ax2.Children)
                if isequal(ax2.Children(i).Type,'images.roi.crosshair')
                    ax2.Children(i).Position = [pos(3) pos(2)];
                end
            end
            for i = 1:length(ax3.Children)
                if isequal(ax3.Children(i).Type,'images.roi.crosshair')
                    ax3.Children(i).Position = [pos(1) vol_size(3)-pos(3)+1];
                end
            end
            slider3.Value = evt.Value;

    end
    labelVI.Text = ['Voxel intensity: ' num2str(round(vol(pos(2),pos(1),pos(3))))];
    labelC.Text = ['Coronal Slice: ' mat2str(pos)];
    labelS.Text = ['Sagittal Slice: ' mat2str(pos)];
    labelA.Text = ['Axial Slice: ' mat2str(pos)];
    labelCVI.Text = labelVI.Text;
    labelSVI.Text = labelVI.Text;
    labelAVI.Text = labelVI.Text;
    

end