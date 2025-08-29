function transferData(~,~,widget,pV,directionTransfer)
    switch directionTransfer
        case 'OUT'
            try
                % USER INFO
                if (~isempty(pV.label_userID.UserData.userID) && ~isfield(widget.glassbrain.UserData,'userID')) ||...
                    ~isequal(pV.label_userID.UserData.userID,widget.glassbrain.UserData.userID)
                    widget.glassbrain.UserData.userID = pV.label_userID.UserData.userID;
                end
                if ~isempty(pV.label_userID.UserData.userID)
                    widget.viewer.projectParams.tab.UserData.userID = pV.field_userID.Value;
                else
                    widget.viewer.projectParams.tab.UserData.userID = [];
                end

                % PATIENT INFO
                if (~isempty(pV.label_patientDir.UserData.patientDir) && ~isfield(widget.glassbrain.UserData,'patientDir')) ||...
                    ~isequal(pV.label_patientDir.UserData.patientDir,widget.glassbrain.UserData.patientDir)
                    widget.glassbrain.UserData.patientDir = pV.label_patientDir.UserData.patientDir;
                end
                if ~isempty(pV.label_patientDir.UserData.patientDir)
                    widget.viewer.projectParams.tab.UserData.patientDir = pV.field_patientDir.Text;
                else
                    widget.viewer.projectParams.tab.UserData.patientDir = [];
                end

                if (~isempty(pV.label_patientID.UserData.patientID) && ~isfield(widget.glassbrain.UserData,'patientID')) ||...
                    ~isequal(pV.label_patientID.UserData.patientID,widget.glassbrain.UserData.patientID)
                    widget.glassbrain.UserData.patientID = pV.label_patientID.UserData.patientID;
                end
                if ~isempty(pV.label_patientID.UserData.patientID)
                    widget.viewer.projectParams.tab.UserData.patientID = pV.field_patientID.Value;
                else
                    widget.viewer.projectParams.tab.UserData.patientID = [];
                end

                % VOXELOC DIR INFO
                if (~isempty(pV.label_voxelocFolder.UserData.voxDir) && ~isfield(widget.glassbrain.UserData,'voxelocDir')) ||...
                    ~isequal(pV.label_voxelocFolder.UserData.voxDir,widget.glassbrain.UserData.voxelocDir)
                    widget.glassbrain.UserData.voxelocDir = pV.label_voxelocFolder.UserData.voxDir;
                end
                if ~isempty(pV.label_voxelocFolder.UserData.voxDir)
                    widget.viewer.projectParams.tab.UserData.voxelocDir = pV.label_voxelocFolder.UserData.voxDir;
                else
                    widget.viewer.projectParams.tab.UserData.voxelocDir = [];
                end
                if (~isempty(pV.label_autosaveFile.UserData.autosavePath) && ~isfield(widget.autosave.UserData,'filePath')) ||...
                    ~isequal(pV.label_autosaveFile.UserData.autosavePath,widget.autosave.UserData.filePath)
                    widget.autosave.UserData.filePath = pV.label_autosaveFile.UserData.autosavePath;
                end
                if ~isempty(pV.label_autosaveFile.UserData.autosavePath)
                    widget.viewer.projectParams.tab.UserData.autosavePath = pV.field_autosaveFile.Text;
                    widget.viewer.projectParams.tab.UserData.autosaveFile = pV.field_autosavePath.Text;
                else
                    widget.viewer.projectParams.tab.UserData.autosavePath = [];
                    widget.viewer.projectParams.tab.UserData.autosaveFile = [];
                end

                % CT,T1,PARC FILES INFO
                if ~contains(pV.field_ctPath.Text,'[File')
                    widget.viewer.projectParams.tab.UserData.ctFile = pV.field_ctPath.Text;
                    widget.viewer.projectParams.tab.UserData.ctPath = pV.field_ctFile.Text;
                else
                    widget.viewer.projectParams.tab.UserData.ctFile = [];
                    widget.viewer.projectParams.tab.UserData.ctPath = [];
                end
                
                if ~contains(pV.field_parcPath.Text,'[File')
                    widget.viewer.projectParams.tab.UserData.t1File = pV.field_t1Path.Text;
                    widget.viewer.projectParams.tab.UserData.t1Path = pV.field_t1File.Text;
                else
                    widget.viewer.projectParams.tab.UserData.t1File = [];
                    widget.viewer.projectParams.tab.UserData.t1Path = [];
                end

                if ~contains(pV.field_parcPath.Text,'[File')
                    widget.viewer.projectParams.tab.UserData.parcFile = pV.field_parcPath.Text;
                    widget.viewer.projectParams.tab.UserData.parcPath = pV.field_parcFile.Text;
                else
                    widget.viewer.projectParams.tab.UserData.parcFile = [];
                    widget.viewer.projectParams.tab.UserData.parcPath = [];
                end

                % LOGO INFO
                if ~isempty(pV.label_instLogo.UserData)
                    if (~isempty(pV.label_instLogo.UserData.instLogoFile) && ~isfield(widget.glassbrain.UserData,'instLogoPath')) ||...
                        ~isequal([pV.label_instLogo.UserData.instLogoPath pV.label_instLogo.UserData.instLogoFile],widget.glassbrain.UserData.instLogoPath)
                        widget.glassbrain.UserData.instLogoPath = pV.label_instLogo.UserData.instLogoPath;
                    end
                    widget.viewer.projectParams.tab.UserData.instLogoPath = [pV.label_instLogo.UserData.instLogoPath pV.label_instLogo.UserData.instLogoFile];
                else
                    widget.viewer.projectParams.tab.UserData.instLogoPath = [];
                    widget.viewer.projectParams.tab.UserData.instLogoFile = [];
                end
                forceSave([],[],widget,pV)
                drawnow();
            catch
                disp('No data transfer');
                widget.fig.Pointer = 'arrow';
            end
        case 'IN'
    end

end