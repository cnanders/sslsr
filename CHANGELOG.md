# 1.0.0-alpha.10

### sins.main.Main
- Steps field in GUI is now steps, not samples.  Samples = steps + 1. Updated all data storage and plotting to accommodate this change (requested by E. Gullikson)
- StateScan.onSetState() now calls setDestCalDisplay(), ensuring that the values entered to the scan match whatever unit and abs/rel is configured in the HardwareUIs
- config/maskZ.json now has a slope of -1 so + moves the stage up and - moves the stage down
- Now set xlim of 1D plots to bounds of the scan range.   If the user is editing start and stop and they are the same value, min() and max() are the same and MATLAB throws an error. I wrapped the xlim() in a check for non-equality between max() and min().
- Added a toggle to switch y-axis between linear and logarithmic
- Changed label on y-axis to A, not uA, which was incorrect.
- onStateScanAbort() now calls a new method, stopMotors(), which issues stop command to all motors
- Fixed problem with newly added cellOfSt2structAr() method. If the scan was aborted before any data was stored, every item in the cell array it was checking would be empty.  dIndex, the list of non-zero indexes of the cell, would also be empty and MATLAB would throw an error.  Now when dIndex is empty, an empty struct is returned. In this scenario, saveScanResultsCsv() does not write a .csv file since there is nothing to write.
- Added grid and minor grid to the 1D plots
- recipe.json, result.json and result.csv are now saved to a new folder for each scan.  I found that it was difficult to dig through the single folder of recipe.json, result.json and result.csv files and distinguish which sets belonged together.
- 

# 1.0.0-alpha.9

### sins.main.Main
- save() and load() now work. The entire state, including stStartStopStepsStore1 and 2, are saved on close.  Loading a fresh instance loads the previous state.
- fixed problem with delete() calling things out of order (the clock was getting deleted before hioGrating). I also separated delete() into several deleteHardwareUI*() methods


# 1.0.0-alpha.8

### sins.main.Main

- Added stored filter positions to config/filterY.json
- Built wrapper for controlling the wavelength
- Changed filename for recipe and result files.  The filename now reads {date}-{result}.{ext} instead of {result}-{date}.{ext}.
- Now save result.csv file in addition to result.json file
- Now store values of start, stop, steps for each device type and when device type changes, start, stop, steps are updated with the previous values from that device type.
- Made necessary updates to only update the plot one time when changing the device, despite setting three UIEdits (start, stop, steps) that all have onChange() handlers.
- Font size in plots now settable and uniform
- Relative paths that display in the GUI and in the results.json file are now canonical, i.e., C:\A\B\..\C reads C:\A\C
- Fixed error with updatePlot() for script scan types.  I was using case xxxx case xxxx right after one another, as you would do in JS but in matlab for a single case to handle multiple values, need to use a cell of the values.
- Making "change directory" "choose script" and "open script" 24 px tall to be consistent.
- Truncating script path to 30 characters so it does not wrap.
- Building hook to connect hioWav and hioGrating so turning on/off hioWav does same for hioGrating and also hacking the UI so they look like one component.
- Added dWidthPanelBorder property to turn all panel borders on/off
- Added dColorBgFigure to set background of figure.  This makes panels pop w/o using borders.
- Made the dir chooser and visualizer nicer.


# 1.0.0-alpha.7

### sins.axis.ApiHardwareIOPlusFromAxis
- Implemented a second approach for set() and isReady() that allow updates mid-move.  See notes in class file

### sins.main.Main

- Added device* properties, i.e., deviceSins, deviceMaskX, deviceMaskY, etc.  Anything prefixed with device directly talks to hardware
- Updated assignApis() to use ApiHardwareIO*FromAxis(deviceMaskX) 
- UNDO on items 1 and 2.  Found out that having properties of the class that reference Java objects is a problem. I now directly create the API
- Refactored delete() into several delete*() methods that compartmentally delete related groups of objects/references
- No longer contains properties that reference cxro.device.common.Axis objects.  This was causing problems.  Now when Java objects are instantiated they not connected to the sins.main.Main class

# 1.0.0-alpha.6

- Migrated Sslsr.m into sins.main.Main()
- Built sins.sins.SinsTest() class that builds maskT and filterY and connects to Carl's test jar
- refactored pkg directory so it can support multiple package root folders

# 1.0.0-alpha.5

- Migrating to mic.v1.0.0-alpha.33.  This required changing instances of Utils.\*() to MicUtils.\*()
- Building scoped package for project classes (outside of MIC library)

# 1.0.0-alpha.4

- Added Sample -> LL button on Stages panel and implemented a state scan to move the system to the LL state.  Currently the state is temporary.  Need to update with true LL state.
- Migrating to mic v1.0.0-alpha.26 (there was a bug in v1.0.0-alpha.25 due to names of API wrappers being ambiguous)

# 1.0.0-alpha.3

- Migrating to mic v1.0.0-alpha.25
- Using CamelCase consistent with mic v1.0.0-alpha.25.  E.g., API -> Api; APIV -> Apiv; HIOTX -> Hiotx


## Requirements

- https://github.com/cnanders/mic v1.0.0-alpha.25

# 1.0.0-alpha.2

- Moving to latest MIC release that includes complete Keithley6482

## Requirements

- https://github.com/cnanders/mic v1.0.0-alpha.20

# 1.0.0-alpha.1

## Requirements

- https://github.com/cnanders/mic v1.0.0-alpha.4