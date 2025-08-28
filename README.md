<a href="https://github.com/HumanNeuronLab/voxeloc"><img src="https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/voxeloc_logoBG.png"/></a>

<h3><a href="https://github.com/HumanNeuronLab/voxeloc/releases"><img src="https://img.shields.io/badge/v0.9.2-28%C2%B7Aug%C2%B72025-blue?logo=github" width="150" align="right"/></a><div align="left"><i>Voxel Electrode Locator</i></div></h3>
<br />

This GUI widget was created to help locate intracranial-EEG contact locations.
Voxeloc is a semi-automated MATLAB widget that allows to rapidly and 
efficiently locate iEEG contact coordinates using post-op & pre-op images.
<br />

**To get started, click on the button below to find all tutorials on the wiki page:**
<br />

<div align="center"><a href="https://github.com/HumanNeuronLab/voxeloc/wiki"><img alt="Go to Wiki" src="https://img.shields.io/badge/Go%20to%20Wiki-blue?style=for-the-badge" width="150"></a></div>


---

#### Current Version Updates:
- Bug fixes, including "isunix" to replace typo "islinux" (many thanks to <a href="https://github.com/TimnaKleinman">Timna Kleinman</a> for spotting this).
- Reordering electrode mousing pointer render improved.
- Reordering electrode mousing pointer render improved.
- Bugs from autosave path fixed.
- Changed color is kept after re-estimating.
- Navigating contacts in tree on T1 fixed.

*Note: electrode parameters may only be modified or updated in the
CT tab. After updating any electrode parameters, estimation must be
re-run in order to update contact locations. At this point, only
depth electrodes may be created (no grids or strips).*

#### Known bugs:
- Oblique slicing may generate errors in contact placement on map, but all 
parcellation locations per contact are grounded in absolute voxel-specific 
values (ie: true area).
<div style="color:red;">If you encounter any bugs or issues, please <a href="https://github.com/HumanNeuronLab/voxeloc/issues/new">click here</a> to let us know so we can fix it!</div>

#### Future Version Updates:
- Add option to create "grid" & "strip" electrodes.
- Enhance compatibility and visualization methods.

---

<p align="center"> <b><u>Voxeloc</u></b> 2024 
| <a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">Human Neuron Lab</a> - UNIGE 
| <a href="mailto:jonathan.monney@unige.ch">jonathan.monney@unige.ch</a></p>
<br>
<div align="center">
  <a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">
  <img src="https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/HNL_logo.png" width="80"/></a>
  &emsp;&emsp;&emsp;
  <a href="https://www.unige.ch/medecine/neucli/en/groupes-de-recherche/1034megevand/">
  <img src="https://raw.githubusercontent.com/HumanNeuronLab/voxeloc/main/assets/UNIGE_logo.png" width="320"/>
</a></div>























