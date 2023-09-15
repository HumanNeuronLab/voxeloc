function smallerButtonPush(data,~,widget)
    switch data.Tag
        case 'X'
            if isequal(widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag, 'CT')
                slider = widget.viewer.CT.slider_X;
                slider.Value = widget.viewer.CT.slider_X.Value - 1;
                new.Value = slider.Value; 
                sliderValueChanging(slider,new,widget);
            else
                slider = widget.viewer.T1.slider_X;
                slider.Value = widget.viewer.T1.slider_X.Value - 1;
                new.Value = slider.Value; 
                sliderValueChanging(slider,new,widget);
            end
        case 'Y'
            if isequal(widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag, 'CT')
                slider = widget.viewer.CT.slider_Y;
                slider.Value = widget.viewer.CT.slider_Y.Value - 1;
                new.Value = slider.Value; 
                sliderValueChanging(slider,new,widget);
            else
                slider = widget.viewer.T1.slider_Y;
                slider.Value = widget.viewer.T1.slider_Y.Value - 1;
                new.Value = slider.Value; 
                sliderValueChanging(slider,new,widget);
            end
        case 'Z'
            if isequal(widget.viewer.panel_CentralTabsMRI.SelectedTab.Tag, 'CT')
                slider = widget.viewer.CT.slider_Z;
                slider.Value = widget.viewer.CT.slider_Z.Value - 1;
                new.Value = slider.Value; 
                sliderValueChanging(slider,new,widget);
            else
                slider = widget.viewer.T1.slider_Z;
                slider.Value = widget.viewer.T1.slider_Z.Value - 1;
                new.Value = slider.Value; 
                sliderValueChanging(slider,new,widget);
            end
    end
end