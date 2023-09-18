function voxeloc
%voxeloc() - Voxel Electrode Locator
%   This GUI widget was created to locate intracranial-EEG contact 
%   coordinates. Voxeloc is a semi-automated MATLAB widget that allows to 
%   rapidly and efficiently locate iEEG contact coordinates using 
%   post-op & pre-op images.
%   
%   Version:        0.9C
%   Contact:        jonathan.monney@unige.ch
%   Last Update:    18/09/2023
%
%   Current Version Updates:
%       - New output format with time-stamped .mat file that cannot be 
%         overwritten.
%       - MGRID copy saved in '*/elec_recon/final_output', along with
%       voxeloc.
%         '.mat' file.
%       - Log files and other text files automatically output from iELVis
%          dykstraElecPjct
%       - Output to BIDS format now implemented!
%       - New tab created to allow reordering of electrodes.
%       - New tab created for parcellation viewer (oblique slice) [work in
%       progress...]
%       - widget object restructured for cohesiveness.
%       - Loading of files from oblique tab.
%       - All volumes now loaded using MRIread ('YDir' reversed on axes for
%       proper display of imagesc), independantly of file format (.nii,
%       .mgh, .mgz).
%       - Added features to oblique slice tab: overlay parcellation on
%       either slice, adjust opacity level for overlay, apply opacity saves
%       the parameter and applies it to all slices.
%       - Possibility to export a PDF file of all oblique slices.
%       - Creation of new project parameters tab.
%       - Update of CT & T1 tabs layout and performance on PDF exporting.
%          
%       Note: electrode parameters may only be modified or updated in the
%       CT tab. After updating any electrode parameters, estimation must be
%       re-run in order to update contact locations. At this point, only
%       depth electrodes may be created (no grids or strips).
% 
%   Future Version Updates:
%       - Removal of "Reorder electrodes" tab and replace feature with up
%       and down arrow buttons above tree panel.
%       - Addition of an electrode color changing button above tree panel.
%       - Add option to create "grid" electrodes.
%       - Add option to create "strip" electrodes.
%
%   Created by J.P.Monney - Human Neuron Lab (Université de Genève)


% ======================================================================= %
% ========================== ENVIRONMENT SET-UP ========================= %
% ======================================================================= %

clearvars
clc

% ----------- Check all subfolders & functions added to path ------------ %

scriptPath = fileparts(which(mfilename));
if ~contains(path,genpath(scriptPath))
    addpath(genpath(scriptPath));
    if isfolder([scriptPath filesep 'ARCHIVE'])
        rmpath(genpath([scriptPath filesep 'ARCHIVE']));
    end
    savepath;
end
if contains(path,genpath([scriptPath filesep 'ARCHIVE']))
    rmpath(genpath([scriptPath filesep 'ARCHIVE']));
    savepath;
end

% --------------- Verify all required add-ons are installed ------------- %

addonsCheck();
mV = versionCheck();

% ----------- Check for new Git commits (bug fixes & updates) ----------- %

%gitAutoUpdate();

% --------------- Main figure & output variable declaration ------------- %

widget              = [];
toolkit             = java.awt.Toolkit.getDefaultToolkit();
jframe              = javax.swing.JFrame;
insets              = ...
    toolkit.getScreenInsets(jframe.getGraphicsConfiguration());
windTB              = insets.bottom;
fig_title           = sprintf('VOXELOC - by Human Neuron Lab');
screen_offset       = os_offset();                              %#ok<NASGU> 
monitorSize         = get(groot,'MonitorPositions');
numMonitors         = height(monitorSize);                      %#ok<NASGU> 
screenSize          = monitorSize(1,3:4);
widget.fig          = uifigure('Name',fig_title,...
                               'Color',[0.5,0.5,0.5],...
                               'Position',[1 1+windTB 1920 1050-windTB],...
                               'Pointer','watch');

if (screenSize(1) <= 1920) && (screenSize(2) <= 1080)
    widget.fig.WindowState = 'maximized';
    widget.root.monitorSize = ...
        [1 1+windTB screenSize(1) screenSize(2)-windTB-30];
else
    widget.root.monitorSize = [1 1+windTB 1920 1050-windTB];
end

widget              = update_outputData(widget);
widget.mV           = mV;
drawnow

projSetUpWindow(widget);

[widget,wip]        = drawCentralPanel(widget);
widget              = drawLeftPanel(widget,wip);
widget              = drawRightPanel(widget,wip);

widget.fig.Pointer  = 'arrow';
drawnow;


% ======================================================================= %
% ======================== CALLBACK DEFINITIONS ========================= %
% ======================================================================= %

widget              = defineCallbacks(widget);
widget.fig.Resize   = 'off';


% ======================================================================= %
% ========================== LOCAL FUNCTIONS ============================ %
% ======================================================================= %

function offset = os_offset

    if ispc
        os = 'pc';
    elseif ismac
        os = 'mac';
    elseif islinux
        os = 'linux';
    end
    
    switch os
        case 'pc'
            offset = 50;
        case {'mac','linux'}
            offset = 0;
    end

end

function addonsCheck

    addonsInstalled = matlab.addons.installedAddons;
    addonsNames = addonsInstalled(:,1);

    % Format: {'Toolbox Name','functionUsed()','script it appears in'; 
    %          ...}
    addonsRequired = ...
        {'Statistics and Machine Learning Toolbox','pdist2()','estimateButtonPushed.m'};
    addonsMissing = zeros(length(addonsRequired),1);
    [sAddonsRequired,~] = size(addonsRequired);
    [sAddonsNames,~] = size(addonsNames);
    for j = 1:sAddonsRequired
        for i = 1:sAddonsNames
            if isequal(addonsNames{i,1},addonsRequired{j,1})
                break
            elseif i == height(addonsNames)
                addonsMissing(j) = 1;
            end
        end
    end

    numMissingAddons = sum(addonsMissing);
    if numMissingAddons ~= 0
        msg1 = ['<strong>Add-On requirements missing for Voxeloc (', ...
            num2str(numMissingAddons), ') :</strong>\n\n'];
        fprintf(2,msg1);
        for l = 1:height(addonsMissing)
            if addonsMissing(l) == 1
                msg2 = ['<strong>\t- ', addonsRequired{l,1}, '</strong> ' ...
                    '(used for ', addonsRequired{l,2}, ...
                    ' -> "', addonsRequired{l,3}, '")\n\n'];
                fprintf(1,msg2);
            end
        end
        
        % To display the link to download the toolbox, force an error:
        if addonsMissing(1) == 1
            pdist2;
        end
    end
end

function mV = versionCheck
    matlabVersion = version('-release');
    matlabVersion = str2double(matlabVersion(1:4));
    if matlabVersion < 2022
        fprintf('\n<strong>Use Matlab version R2022a (or more recent) \nfor full functionality of Voxeloc.</strong>\n\n');
        mV = 0;
    else
        mV = 1;
    end
end

end
  