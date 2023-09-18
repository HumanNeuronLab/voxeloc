<h1 align="center">VOX·E·LOC</h1>

<h3><a href="https://github.com/HumanNeuronLab/voxeloc/releases"><img src="https://github.com/jonathanmonney/misc_assets/blob/main/voxeloc/voxeloc_version.png" width="200" align="right"/></a><div align="left"><i>Voxel Electrode Locator</i></div></h3>


---

This GUI widget was created to help locate intracranial-EEG contact locations.
Voxeloc is a semi-automated MATLAB widget that allows to rapidly and 
efficiently locate iEEG contact coordinates using post-op & pre-op images.

To start: open Matlab and run voxeloc in the command line 
(ensure the folder containing the voxeloc.m file has been added to your 
list of paths).
The voxeloc function will open the GUI needed to run all electrode contact 
location estimations.

---

#### Current Version Updates:

- GUI created that allows i-EEG electrode location estimation based 
on the deepest contact's position and a second contact position
placed on the electrode's shaft.
Required parameters for each electrode are Name, Number of
Contacts, Distance Between Contacts (mm), Deepest Contact's
Coordinates, Second Contact Coordinates.
- New output format with time-stamped .mat file that cannot be 
overwritten.
- MGRID copy saved in '*/elec_recon/final_output', along with Voxeloc
'.mat' file.
- Log files and other text files automatically output from iELVis
dykstraElecPjct.
- Output to BIDS format now implemented!
- New tab created to allow reordering of electrodes.
- New tab created for parcellation viewer (oblique slice) [work in 
progress...].
- widget object restructured for cohesiveness.
- Loading of files from oblique tab.
- All volumes now loaded using MRIread ('YDir' reversed on axes for proper 
display of imagesc), independantly of file format (.nii, .mgh, .mgz).
- Added features to oblique slice tab: overlay parcellation on
either slice, adjust opacity level for overlay, apply opacity saves
the parameter and applies it to all slices.
- Possibility to export a PDF file of all oblique slices.
- Creation of new project parameters tab.
- Update of CT & T1 tabs layout and performance on PDF exporting.

*Note: electrode parameters may only be modified or updated in the
CT tab. After updating any electrode parameters, estimation must be
re-run in order to update contact locations. At this point, only
depth electrodes may be created (no grids or strips).*

#### Known bugs:
- Autoupdate requires work to function on all host OS & archiving.
- ! Must verify all requirements for MRIread are included in Voxeloc!
- Given new volume reading function, verify output coordinates are still 
accurate (using .mgrid to cross-verify in BioImageSuite).

#### Future Version Updates:
- Removal of "Reorder electrodes" tab and replace feature with up
and down arrow buttons above tree panel.
- Addition of an electrode color changing button above tree panel.
- Add option to create "grid" electrodes.
- Add option to create "strip" electrodes.

---

<p align="center"> <b><u>Voxeloc</u></b> 2023 
| <a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">Human Neuron Lab</a> - UNIGE 
| <a href="mailto:jonathan.monney@unige.ch">jonathan.monney@unige.ch</a></p>
<br>
<div align="center"><a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">
  <img src="https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/UNIGE_logo.png" width="200"/>
</a></div>

---
