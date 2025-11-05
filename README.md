This repository was created on August 8 to share Coulomb's editorial progress.

Currently, it includes the alpha version of Coulomb ver. 4.0.
Coulomb 4.0 is an upgraded MATLAB-based application for calculating and visualizing Coulomb stress changes in 2D and 3D. 
Although it should work on MATLAB versions 2024a or newer, it is more stable when run on 2025a or later.

Before running the app, please make sure the following MATLAB add-ons are installed:
  - Mapping Toolbox
  - Image Processing Toolbox
  - Curve Fitting Toolbox

While the calculation results are generally reliable, some unstable behavior has been observed under certain conditions.
In particular, there are occasional bugs in the ISC Earthquake Toolbox, where data downloads may not complete successfully.
We are continuing to debug this issue, so please keep an eye on future updates of coulomb.mlapp.

### Repository Structure
- `coulomb.mlapp` — Main MATLAB App Designer application  
- `input_files/` — Folder for storing the tomographic data files used for analysis
- `input_overlay_files/` — Folder containing overlay files used for analysis
- `preferences/`, 'slides/' — Configuration files used while the app is running
- Other .cou files — File where calculation results are saved

### How to Run
1. Be sure to open the directory "coulomb_ver4_alpha" on MATLAB.
2. Open `coulomb.mlapp` in MATLAB App Designer or run it directly from the MATLAB command window.
3. Load input fault and receiver data via the **Open/Save → Open Input File** menu.
4. Select the desired function mode (e.g., *Coulomb stress change*, *Displacement vectors*, *Strain field*).  
5. Executes calculations according to window instructions.

### Future Updates
- Implementation of 3D stress visualization  
- Enhanced documentation and help system  
- Full compatibility with MATLAB 2024a and later

### Contact
For questions, bug reports, or collaboration inquiries, please contact:  
  **Kaede Yoshizawa**  
  Graduate School of Science, Tohoku University  
  Email: yoshizawa.kaede.q1@dc.tohoku.ac.jp
