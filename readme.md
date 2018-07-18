# **Afterimage**
## **NHCS Post-Image Finalization**

## Function
The function of this .bat file is to speed up the process after a machine is freshly imaged from SCCM. 

It does the following:
* Determines whether office is activated
  * If not, opens word, waits for activation window, closes word
* Opens device manager
* Determines machine model number and current bios version, matches it against the network drive's most recent version for that particular machine, copies the files, and begins the install.

## Execution
The main file that needs to be run is afterimage1_auto.bat. If you download this and run it, you will likely have issues with paths, as it is not self-contained.

The afterimage1_auto.bat file copies the afterimage2.bat file to the desktop.
afterimage2.bat needs to be run from the desktop to delete itself, not manually deleted.