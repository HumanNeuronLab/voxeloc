<h1 align="center">VOX·E·LOC</h1>

<h3><a href="https://github.com/HumanNeuronLab/voxeloc/releases"><img src="https://github.com/jonathanmonney/misc_assets/blob/main/voxeloc/voxeloc_version.png" width="200" align="right"/></a><div align="left"><i>Voxel Electrode Locator</i></div></h3>

![Static Badge](https://img.shields.io/badge/v0.9P-20%C2%B7Feb%C2%B72024-blue?logo=github&link=https%3A%2F%2Fgithub.com%2FHumanNeuronLab%2Fvoxeloc%2Freleases){.callout}
.callout {
    float: right;
}


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
- Finalising beta runs to make sure all mains functions are operational.

*Note: electrode parameters may only be modified or updated in the
CT tab. After updating any electrode parameters, estimation must be
re-run in order to update contact locations. At this point, only
depth electrodes may be created (no grids or strips).*

#### Known bugs:
- Oblique slicing may generate errors in contact placement on map, but all 
parcellation locations per contact are grounded in absolute voxel-specific 
values (ie: true area).

#### Future Version Updates:
- Add option to create "grid" & "strip" electrodes.
- Enhance compatibility and visualization methods.

---

<p align="center"> <b><u>Voxeloc</u></b> 2023 
| <a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">Human Neuron Lab</a> - UNIGE 
| <a href="mailto:jonathan.monney@unige.ch">jonathan.monney@unige.ch</a></p>
<br>
<div align="center"><a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">
  <img src="https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/UNIGE_logo.png" width="200"/>
</a></div>

---
