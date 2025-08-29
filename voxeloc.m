function voxeloc
%voxeloc() - Voxel Electrode Locator
%   This GUI widget was created to locate intracranial-EEG contact 
%   coordinates. Voxeloc is a semi-automated MATLAB widget that allows to 
%   rapidly and efficiently locate iEEG contact coordinates using 
%   post-op & pre-op images.
%   
%   Version:        v0.9.6
%   Contact:        jonathan.monney@unige.ch
%   Last Update:    29/08/2025
%
%   Current Version Updates:
%       - Updated output file variable name ("voxelocOutput")
%       - Output file now contains probabilistic tissues labels and weights
%       based on the SEEG2parc function from Prof. Pierre Mégevand.
%       - Bug fixes and display update on project parameters window.
%       - BIDS .tsv now contains Tissue labels and weights if a
%       parcellation file has been provided to Voxeloc (eg. wmparc.nii).
%       - Upon exporting to BIDS, a shortcut link is created in the
%       subject's voxeloc folder (along with the autosave and export .mat
%       files).
%          
%       Note: electrode parameters may only be modified or updated in the
%       CT tab. After updating any electrode parameters, estimation must be
%       re-run in order to update contact locations. At this point, only
%       depth electrodes may be created (no grids or strips).
%
%   Known bugs:
%       - Oblique slices still doesn't render accurately
% 
%   Future Version Updates:
%       - For v1.0:
%          Fix the oblique slices to work.
%       - Add option to create "grid" & "strip" electrodes.
%       - Enhance compatibility and visualization methods.
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
widget.d            = uiprogressdlg(widget.fig,'Title',...
                        'Waiting for Project Set-Up parameters...');
drawnow

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
widget.transferSetupFcn = {@transferData,widget};

projSetUpWindow(widget,'init');


% ======================================================================= %
% ========================== LOCAL FUNCTIONS ============================ %
% ======================================================================= %

function offset = os_offset

    if ispc
        os = 'pc';
    elseif ismac
        os = 'mac';
    elseif isunix
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
    if matlabVersion < 2023
        fprintf('\n<strong>Use Matlab version R2023a (or more recent) \nfor full functionality of Voxeloc.</strong>\n\n');
        mV = 0;
    else
        mV = 1;
    end
end

end
  