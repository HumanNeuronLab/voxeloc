function exportPDF(~,~,widget)

    if ~isfield(widget.autosave.UserData,'filePath')
        return
    end

%     if ~isequal(widget.viewer.projectParams.lamp_userID.Color,[0 1 0])
%         widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.projectParams.tab;
%         message = {'To export a PDF, a user ID is required.'};
%         uialert(widget.fig,message,'Missing user ID',...
%         'Icon','warning');
%         return
%     end

    outPath = fileparts(widget.autosave.UserData.filePath);
    d = uiprogressdlg(widget.fig,'Title','Creating PDF output',...
        'Message','Opening the application');
    totalElecs = numel(fieldnames(widget.fig.UserData));
    numMssg = totalElecs*9+2;
    progressVal = 0;
    d.Message = 'Re-slicing all electrodes.';
    resliceOblique([],[],widget);
    progressVal = progressVal+1;
    d.Value = progressVal/numMssg;
    j = 1;
    for i = 1:totalElecs
        currElec = ['Electrode' num2str(i)];
        d.Message = ['Creating page for electrode' num2str(i) 'of ' num2str(totalElecs)];
        try
            outputDecision = isequal(widget.fig.UserData.(currElec).oblique.state,'SUCCESS');
        catch
            outputDecision = 0;
        end
        if outputDecision
            disp(['Creating PDF file for ' currElec]);
            fig1 = figure('PaperUnits','centimeters','PaperType','A4','Visible','off');
            scaleFactor = 0.75;
            paperSize = fig1.PaperSize.*scaleFactor;
            set(fig1,'Units','centimeters','Position',[0 0 paperSize(1) paperSize(2)],'MenuBar','none','ToolBar','none');
            headerRatios = [0.3 0.4 0.3];
            paramRatios = [0.65 0.35];
        
        
            % ---------------------------------------------------------------------
            %                                HEADER                                
            % ---------------------------------------------------------------------
            
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Creating header]'];
            d.Value = progressVal/numMssg;
            headerBOX = axes('Parent',fig1,'Units','centimeters','Position',...
                [0 ...
                fig1.Position(4)-(2*scaleFactor)-0.1 ...
                fig1.Position(3)-0.1 ...
                2*scaleFactor],'Box','on', ...
                'XTick',[headerRatios(1) headerRatios(1)+headerRatios(2)],...
                'YTick',[],'XTickLabel',[],'Clipping','on','XGrid','on',...
                'GridAlpha',1,'GridColor',[0 0 0],'TickLength',[0 0]);
            header1 = axes('Parent',fig1,'Units','centimeters','Position',...
                [0 ...
                fig1.Position(4)-(2*scaleFactor)-0.1 ...
                fig1.Position(3)*headerRatios(1)-0.1 ...
                2*scaleFactor],'YDir','reverse',...
                'Visible','off','Clipping','on');
            header1.XAxis.Visible = 'off'; header1.YAxis.Visible = 'off';
            if isfield(widget.glassbrain.UserData,'instLogoFile')
                instLogo = imagesc('Parent',header1,'CData',imread([widget.glassbrain.UserData.instLogoPath widget.glassbrain.UserData.instLogoFile]));
                header1.XLim = ([instLogo.XData(1)-instLogo.XData(2)*0.05 instLogo.XData(2)+instLogo.XData(2)*0.05]); % adds 10% padding
                header1.YLim = ([instLogo.YData(1)-instLogo.YData(2)*0.05 instLogo.YData(2)+instLogo.YData(2)*0.05]); % adds 10% padding
                axis(header1,'equal');
            end
            header2 = axes('Parent',fig1,'Units','centimeters','Position',...
                [header1.Position(1)+header1.Position(3) ...
                fig1.Position(4)-(2*scaleFactor)-0.1 ...
                fig1.Position(3)*headerRatios(2)-0.1 ...
                2*scaleFactor],'YDir','normal',...
                'Visible','off','Clipping','on');
            t1 = text('Parent',header2,'String','STEREO-EEG SLICES',...
                'Position',[0.5 0.75],'HorizontalAlignment','center','VerticalAlignment','middle',...
                'Interpreter','none','FontSize',16);
            t2 = text('Parent',header2,'String',widget.glassbrain.UserData.patientID,'FontWeight','bold',...
                'Position',[0.5 0.25],'HorizontalAlignment','center','VerticalAlignment','middle',...
                'Interpreter','none','FontSize',16);
            header3 = axes('Parent',fig1,'Units','centimeters','Position',...
                [header2.Position(1)+header2.Position(3) ...
                fig1.Position(4)-(2*scaleFactor)-0.1 ...
                fig1.Position(3)*headerRatios(3)-0.1 ...
                2*scaleFactor],'YDir','normal',...
                'Visible','off','Clipping','on');
            t3 = text('Parent',header3,'String',['Produced on: ' upper(datestr(now,'dd mmm yy'))],...
                'Position',[0.05 0.75],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            t4 = text('Parent',header3,'String',['Produced by: ' widget.viewer.projectParams.tab.UserData.userID],...
                'Position',[0.05 0.5],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            header4 = axes('Parent',fig1,'Units','centimeters','Position',...
                [header2.Position(1)+header2.Position(3) ...
                fig1.Position(4)-(2*scaleFactor)-0.1 ...
                fig1.Position(3)*headerRatios(3)-0.1 ...
                header3.Position(4)*0.4],'YDir','reverse',...
                'Visible','off','Clipping','on');
            voxelocLogo = imagesc('Parent',header4,'CData',imread('erwin_logo.png'));
            header4.XLim = ([voxelocLogo.XData(1)-voxelocLogo.XData(2)*0.05 voxelocLogo.XData(2)+voxelocLogo.XData(2)*0.05]); % adds 10% padding
            header4.YLim = ([voxelocLogo.YData(1)-voxelocLogo.YData(2)*0.05 voxelocLogo.YData(2)+voxelocLogo.YData(2)*0.05]); % adds 10% padding
            axis(header4,'equal');
            progressVal = progressVal+1;
        
        
            % ---------------------------------------------------------------------
            %                              PARAMETERS
            % ---------------------------------------------------------------------
        
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Writing electrode parameters]'];
            d.Value = progressVal/numMssg;
            textRatios = [0 0.2 0.5 0.7];
            paramPanel = axes('Parent',fig1,'Units','centimeters','Position',...
                [0 ...
                fig1.Position(4)-(4.5*scaleFactor) ...
                fig1.Position(3)*paramRatios(1) ...
                2*scaleFactor],'YDir','normal',...
                'Visible','off','Clipping','off');
            t5 = text('Parent',paramPanel,'String','Electrode:',...
                'Position',[textRatios(1) 2/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            t6 = text('Parent',paramPanel,'String',widget.fig.UserData.(currElec).Name(4:end),...
                'Position',[textRatios(2) 2/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10,'FontWeight','bold');
            t7 = text('Parent',paramPanel,'String','Hemisphere:',...
                'Position',[textRatios(3) 2/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            if isequal(widget.fig.UserData.(currElec).Name(1),'L')
                currHem = 'Left';
            else
                currHem = 'Right';
            end
            t8 = text('Parent',paramPanel,'String',currHem,...
                'Position',[textRatios(4) 2/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10,'FontWeight','bold');
        
            t9 = text('Parent',paramPanel,'String','Contact #:',...
                'Position',[textRatios(1) 1/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            t10 = text('Parent',paramPanel,'String',num2str(widget.fig.UserData.(currElec).numContacts),...
                'Position',[textRatios(2) 1/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10,'FontWeight','bold');
            t11 = text('Parent',paramPanel,'String','I-C dist.:',...
                'Position',[textRatios(3) 1/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            t12 = text('Parent',paramPanel,'String',[num2str(widget.fig.UserData.(currElec).contactDist) '(mm)'],...
                'Position',[textRatios(4) 1/3],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10,'FontWeight','bold');
        
            t13 = text('Parent',paramPanel,'String','Notes:',...
                'Position',[textRatios(1) 0],'HorizontalAlignment','left','VerticalAlignment','baseline',...
                'Interpreter','none','FontSize',10);
            t14 = line('Parent',paramPanel,'XData',[textRatios(2),1],'YData',[-0.1,-0.1]);
            paramPanel.XLim = [0 1]; paramPanel.YLim = [-0.1 1];
            progressVal = progressVal+1;
        
        
            % ---------------------------------------------------------------------
            %                          ELECTRODE DIAGRAM
            % ---------------------------------------------------------------------
            
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Creating electrode diagram]'];
            d.Value = progressVal/numMssg;
            electrodePanel = axes('Parent',fig1,'Units','centimeters','Position',...
                [0 ...
                fig1.Position(4)-(9*scaleFactor) ...
                fig1.Position(3)*paramRatios(1) ...
                4*scaleFactor],'YDir','reverse',...
                'Visible','off','Clipping','on');
            electrodeFigure(widget,currElec,outPath);
            diagName = [outPath filesep 'electrodeDiag.png'];
            electrodeImage = imagesc('Parent',electrodePanel,'CData',imread(diagName));
            electrodePanel.XLim = ([electrodeImage.XData(1) electrodeImage.XData(2)]);
            electrodePanel.YLim = ([electrodeImage.YData(1) electrodeImage.YData(2)]);
            axis(electrodePanel,'equal');
            progressVal = progressVal+1;
        
        
            % ---------------------------------------------------------------------
            %                               3D HEAD
            % ---------------------------------------------------------------------
            
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Printing 3D head]'];
            d.Value = progressVal/numMssg;
            head3DPanel = axes('Parent',fig1,'Units','centimeters','Position',...
                [paramPanel.Position(1)+paramPanel.Position(3) ...
                electrodePanel.Position(2) ...
                fig1.Position(3)*paramRatios(2) ...
                7*scaleFactor],'YDir','reverse',...
                'Visible','off','Clipping','on');
            widget.viewer.panel_CentralTabsMRI.SelectedTab = widget.viewer.oblique.tab;
            h = findobj(widget.tree_Summary.Children,'Tag',currElec);
            widget.tree_Summary.SelectedNodes = h(1);
            artEvt = widget.tree_Summary;
            treeSelectionChange([],artEvt,widget);
            drawnow();
            prevColor = widget.viewer.oblique.head3D.ax.Color;
            widget.viewer.oblique.head3D.ax.Color = [1 1 1];
            widget.viewer.oblique.head3D.patch_fmh.FaceAlpha = 0.85;
            drawnow();
            head3DFile = [outPath filesep 'head3D.png'];
            exportgraphics(widget.viewer.oblique.head3D.ax,head3DFile);
            widget.viewer.oblique.head3D.ax.Color = prevColor;
            widget.viewer.oblique.head3D.patch_fmh.FaceAlpha = 1;
            head3Dimage = imagesc('Parent',head3DPanel,'CData',imread(head3DFile));
            head3DPanel.XLim = ([head3Dimage.XData(1)-head3Dimage.XData(2)*0.05 head3Dimage.XData(2)+head3Dimage.XData(2)*0.05]); % adds 10% padding
            head3DPanel.YLim = ([head3Dimage.YData(1)-head3Dimage.YData(2)*0.05 head3Dimage.YData(2)+head3Dimage.YData(2)*0.05]); % adds 10% padding
            axis(head3DPanel,'equal');
            progressVal = progressVal+1;
        
        
            % ---------------------------------------------------------------------
            %                          4 SLICE DISPLAY
            % ---------------------------------------------------------------------
            
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Printing CT Vert slice]'];
            d.Value = progressVal/numMssg;
            panel1 = axes('Parent',fig1,'Units','centimeters','Position',...
                [0 ...
                fig1.Position(3)/2 ...
                fig1.Position(3)/2 ...
                fig1.Position(3)/2],'YDir','reverse',...
                'Visible','off','Clipping','on');
            ctVertFile = [outPath filesep 'ctVert.png'];
            exportgraphics(widget.viewer.oblique.ax_ctVert,ctVertFile);
            slice1 = imagesc('Parent',panel1,'CData',imread(ctVertFile));
            panel1.XLim = ([slice1.XData(1)-slice1.XData(2)*0.01 slice1.XData(2)+slice1.XData(2)*0.01]); % adds 10% padding
            panel1.YLim = ([slice1.YData(1)-slice1.YData(2)*0.01 slice1.YData(2)+slice1.YData(2)*0.01]); % adds 10% padding
            axis(panel1,'equal');
            progressVal = progressVal+1;
       
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Printing CT Hor slice]'];
            d.Value = progressVal/numMssg;
            panel2 = axes('Parent',fig1,'Units','centimeters','Position',...
                [0 ...
                0 ...
                fig1.Position(3)/2 ...
                fig1.Position(3)/2],'YDir','reverse',...
                'Visible','off','Clipping','on');
            ctHorFile = [outPath filesep 'ctHor.png'];
            exportgraphics(widget.viewer.oblique.ax_ctHor,ctHorFile);
            slice2 = imagesc('Parent',panel2,'CData',imread(ctHorFile));
            panel2.XLim = ([slice2.XData(1)-slice2.XData(2)*0.01 slice2.XData(2)+slice2.XData(2)*0.01]); % adds 10% padding
            panel2.YLim = ([slice2.YData(1)-slice2.YData(2)*0.01 slice2.YData(2)+slice2.YData(2)*0.01]); % adds 10% padding
            axis(panel2,'equal');
            progressVal = progressVal+1;
        
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Printing T1 Vert slice]'];
            d.Value = progressVal/numMssg;
            panel3 = axes('Parent',fig1,'Units','centimeters','Position',...
                [fig1.Position(3)/2 ...
                fig1.Position(3)/2 ...
                fig1.Position(3)/2 ...
                fig1.Position(3)/2],'YDir','reverse',...
                'Visible','off','Clipping','on');
            t1VertFile = [outPath filesep 't1Vert.png'];
            exportgraphics(widget.viewer.oblique.ax_t1Vert,t1VertFile);
            slice3 = imagesc('Parent',panel3,'CData',imread(t1VertFile));
            panel3.XLim = ([slice3.XData(1)-slice3.XData(2)*0.01 slice3.XData(2)+slice3.XData(2)*0.01]); % adds 10% padding
            panel3.YLim = ([slice3.YData(1)-slice3.YData(2)*0.01 slice3.YData(2)+slice3.YData(2)*0.01]); % adds 10% padding
            axis(panel3,'equal');
            progressVal = progressVal+1;
        
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Printing T1 Hor slice]'];
            d.Value = progressVal/numMssg;
            panel4 = axes('Parent',fig1,'Units','centimeters','Position',...
                [fig1.Position(3)/2 ...
                0 ...
                fig1.Position(3)/2 ...
                fig1.Position(3)/2],'YDir','reverse',...
                'Visible','off','Clipping','on');
            t1HorFile = [outPath filesep 't1Hor.png'];
            exportgraphics(widget.viewer.oblique.ax_t1Hor,t1HorFile);
            slice4 = imagesc('Parent',panel4,'CData',imread(t1HorFile));
            panel4.XLim = ([slice4.XData(1)-slice4.XData(2)*0.01 slice4.XData(2)+slice4.XData(2)*0.01]); % adds 10% padding
            panel4.YLim = ([slice4.YData(1)-slice4.YData(2)*0.01 slice4.YData(2)+slice4.YData(2)*0.01]); % adds 10% padding
            axis(panel4,'equal');
            progressVal = progressVal+1;
            
            % NOTE: PRINT FUNCTION AUTOMATICALLY CREATES A 0.25 INCH MARGIN!
            d.Message = ['Creating page for electrode ' num2str(i) '/' num2str(totalElecs) ': [Saving electrode PDF]'];
            d.Value = progressVal/numMssg;
            fileName = [outPath filesep currElec '_voxeloc.pdf'];
            print(fig1,'-dpdf',fileName,'-fillpage');
            figure(widget.fig);
            progressVal = progressVal+1;
            indepPdfs{j} = fileName;
            j = j+1;
            close(fig1);
        else
            disp(['Skipping ' currElec ' - No oblique slice (click "Re-slice" button after successful estimation).']);
            progressVal = progressVal+9;
        end
        d.Value = progressVal/numMssg;
    end
    d.Message = 'Merging individual electrode files into final PDF output file.';
    mergedFileName = [outPath filesep widget.glassbrain.UserData.patientID '_vxlc_' datestr(now,'HHMM_ddmmmyyyy') '.pdf'];
    mergePdfs(indepPdfs,mergedFileName);
    cellfun(@delete,indepPdfs);
    delete(ctVertFile);delete(ctHorFile);delete(t1VertFile);delete(t1HorFile);delete(head3DFile);
    d.Value = numMssg/numMssg;
    pause(1);
    close(d);
    
    % Merges the pdf-Documents in the input cell array fileNames into one
    % single pdf-Document with file name outputFile
    function mergePdfs(fileNames, outputFile)
        memSet = org.apache.pdfbox.io.MemoryUsageSetting.setupMainMemoryOnly();
        merger = org.apache.pdfbox.multipdf.PDFMergerUtility;
        cellfun(@(f) merger.addSource(f), fileNames)
        merger.setDestinationFileName(outputFile)
        merger.mergeDocuments(memSet)
    end
end