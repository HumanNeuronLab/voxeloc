function transferData(~,~,widget,pV)
    try
        if ~isempty(pV.label_userID.UserData)
            widget.viewer.logo.panel.Visible = 'off';
            nevt.Value = pV.label_userID.UserData.userID;
            userIDchange([],nevt,widget);
            nevt = [];
        end
    
        if ~isempty(pV.label_patientDir.UserData)
            nevt.Value = pV.label_patientID.UserData.patientID;
            nevt.ValueDir = pV.label_patientDir.UserData.patientDir;
            nevt.EventName = 'ValueChanged';
            patientIDchange([],nevt,widget);
            nevt = [];
        end

        if ~isempty(pV.label_instLogo.UserData)
            nevt.ValueFile = pV.label_instLogo.UserData.instLogoFile;
            nevt.ValuePath = pV.label_instLogo.UserData.instLogoPath;
            instLogoLoad([],[],pV);
            nevt = [];
        end
        drawnow();
    catch
        disp('No data transfer');
    end

end