function crossDrag(src,data,vol,vol_size,labelVI,ax1,ax2,ax3,...
    labelC,labelS,labelA,labelCVI,labelSVI,labelAVI,src_image,...
        second_image,second_crosshair,third_image,third_crosshair,p,widget)

    switch src.Tag(1)
        case 'c' % coronal crosshair moved: 2nd = sagittal, 3rd = axial
            pos = [round(data.CurrentPosition(1))...
                round(data.CurrentPosition(2)) str2double(src_image.Tag)];
            labelC.Text = ['Coronal Slice: ' mat2str(pos)];
            labelS.Text = ['Sagittal Slice: ' mat2str(pos)];
            labelA.Text = ['Axial Slice: ' mat2str(pos)];
            second_image.CData = reshape(vol(:,pos(1),:),[vol_size(1),vol_size(3)]);
            third_image.CData = rot90(reshape(vol(pos(2),:,:),[vol_size(2),vol_size(3)]));
            second_crosshair.Position = [pos(3) pos(2)];
            third_crosshair.Position = [pos(1) vol_size(3)-pos(3)];
            labelVI.Text = ['Voxel density: ' mat2str(round(vol(pos(2),pos(1),pos(3))))];
            second_image.Tag = num2str(pos(1));
            third_image.Tag = num2str(pos(2));
            labelCVI.Text = labelVI.Text;
            labelSVI.Text = labelVI.Text;
            labelAVI.Text = labelVI.Text;

        case 's' % sagittal crosshair moved: 2nd = coronal, 3rd = axial
            pos = [str2double(src_image.Tag)...
                round(data.CurrentPosition(2)) round(data.CurrentPosition(1))];
            labelC.Text = ['Coronal Slice: ' mat2str(pos)];
            labelS.Text = ['Sagittal Slice: ' mat2str(pos)];
            labelA.Text = ['Axial Slice: ' mat2str(pos)];
            second_image.CData = vol(:,:,pos(3));
            third_image.CData = rot90(reshape(vol(pos(2),:,:),[vol_size(2),vol_size(3)]));
            second_crosshair.Position = [pos(1) pos(2)];
            third_crosshair.Position = [pos(1) vol_size(3)-pos(3)];
            labelVI.Text = ['Voxel density: ' mat2str(round(vol(pos(2),pos(1),pos(3))))];
            second_image.Tag = num2str(pos(3));
            third_image.Tag = num2str(pos(2));
            labelCVI.Text = labelVI.Text;
            labelSVI.Text = labelVI.Text;
            labelAVI.Text = labelVI.Text;

        case 'a' % axial crosshair moved: 2nd = coronal, 3rd = sagittal
            pos = [round(data.CurrentPosition(1))...
                str2double(src_image.Tag) (vol_size(3)-round(data.CurrentPosition(2))+1)];
            labelC.Text = ['Coronal Slice: ' mat2str(pos)];
            labelS.Text = ['Sagittal Slice: ' mat2str(pos)];
            labelA.Text = ['Axial Slice: ' mat2str(pos)];
            second_image.CData = vol(:,:,pos(3));
            third_image.CData = reshape(vol(:,pos(1),:),[vol_size(1),vol_size(3)]);
            second_crosshair.Position = [pos(1) pos(2)];
            third_crosshair.Position = [pos(3) pos(2)];
            labelVI.Text = ['Voxel density: ' mat2str(round(vol(pos(2),pos(1),pos(3))))];
            second_image.Tag = num2str(pos(3));
            third_image.Tag = num2str(pos(1));
            labelCVI.Text = labelVI.Text;
            labelSVI.Text = labelVI.Text;
            labelAVI.Text = labelVI.Text;

    end

    p.field_X.Value = pos(1);
    p.slider_X.Value = pos(1);
    p.field_Y.Value = pos(2);
    p.slider_Y.Value = pos(2);
    p.field_Z.Value = pos(3);
    p.slider_Z.Value = pos(3);
    widget = contactDotDisplay(widget);
end