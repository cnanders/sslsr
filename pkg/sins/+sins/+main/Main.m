classdef Main < HandlePlus
       
   
    % This class makes heavy use of dynamic fieldname syntax allows
    % accessing structure field with variable.  It looks like this
    %
    % a = 'car'
    % b = struct();
    % b.car = 'ferrari';
    % b.(a) % gives 'ferrari'
                
                
    properties (Constant, Access = private)
        
        % Name of devices in the pulldown
        
        dHeightButton = 24;
        dHeightText = 24;
        
        cPlotDataTypeCombined = 'Idet + Izero'
        cPlotDataTypeI0 = 'Izero'
        cPlotDataTypeIDet = 'Idet'
        
        cPlotYLimitTypeAuto = 'auto'
        cPlotYLimitTypeManual = 'manual'
        
        cPlotYScaleTypeLinear = 'linear'
        cPlotYScaleTypeLog = 'log'
        
        cNameLoadLockRecipe = 'load-lock.json';
        
        cDeviceMono = 'wav';
        cDeviceGrating = 'grating';
        cDeviceMaskX = 'mask x';
        cDeviceMaskY = 'mask y';
        cDeviceMaskZ = 'mask z';
        cDeviceMaskT = 'mask t';
        cDeviceDetX = 'det x';
        cDeviceDetT = 'det t';
        cDeviceFilterY = 'filter y';
        cDeviceMaskTDet2T = 'mask t det 2t';
        cDeviceTime = 'time';
        
        cTypeOneDevice = '1 axis';
        cTypeTwoDevice = '2 axis';
        cTypeScript = 'Script';
        cTypeLive = 'Live';
        
        % The name of field/prop in the recipe for each controlled device
        % and in the HIO struct
        
        cFieldMono = 'wav';
        cFieldGrating = 'grating'
        cFieldMaskX = 'maskX';
        cFieldMaskY = 'maskY';
        cFieldMaskZ = 'maskZ';
        cFieldMaskT = 'maskT';
        cFieldDetX = 'detX';
        cFieldDetT = 'detT';
        cFieldFilterY = 'filterY';
        cFieldDelay = 'delay';
        
        % {double 1x3} RGB triplet. Each value in range [0, 1]
        dColorBgStages = [.94 .94 .94]; % MATLAB default
        dColorBgFigure = [200 200 200]./255;
        
        dWidth = 1500
        dHeight = 530 % 650;
        
        dWidthPanelBorder = 0;
        dWidthPad = 10;
        dWidthBtn = 24
        
        dWidthEdit = 50
        dHeightEdit = 24
        dSizeMarker = 8
        
        dWidthScan = 800
        dHeightScan = 100
        
        dWidthSettings = 800
        dHeightSettings = 70
        
        dHeightResult = 250
        
        dWidthOperator = 80
        dWidthDir = 350
        dWidthEditSep = 5
        
        dWidthPanelStages = 675
        dHeightPanelStages = 250
        
        dWidthPanelMono = 675;
        dHeightPanelMono = 70;
        
        
        dHeightPanelPlotTools = 65;
        
        dWidthPanelPicoammeter = 300;
        dHeightPanelPicoammeter = 70; % 350;
        
        dHeightHio = 25;
        dHeightHioLabels = 17;
        dWidthHioName = 50;
        dWidthHioVal = 50;
        dWidthHioUnit = 60;
        dWidthHioStores = 90;
        dWidthHioRange = 120;
        lHioAskOnApiClick = false
        
        dWidthMeta = 200;
        dWidthSettle = 100;
        
        dWidthPlay = 60;
        
        dSizeFont = 8;
        
        cTooltipPlotTypeLog = 'Toggle y-axis on plots to be linear.  Currently logarithmic.';
        cTooltipPlotTypeLin = 'Toggle y-axis on plots to be logarithmic.  Currently linear.';
        cTooltipScanResume = 'Continue with the scan'
        cTooltipScanStart = 'Begin a new scan with the current configuration'
        cTooltipScanAbort = 'Abort the scan. All data up to now will be saved in the result.json file'
        cTooltipSwap = 'Flip device order.';
        
        cTooltipConnect = 'Connect all hardware to the real Api';
        cTooltipDisconnect = 'Disconnect all hardware (go into virtual mode)';
        
        cTooltipMeta = 'Unique identifying information about the sample.  Will be included in scan result.json file';
        cTooltipChooseDir = 'Change the directory where scan recipe/result files are saved.';
        cTooltipOperator = 'Name of the person running the experiment.';
        cTooltipSettle = 'Delay before acquiring after a scan state is reached.';
        
    end
    
	properties
        
        % Stuff you want to be able to load / save and allow 
        
        % {char 1xm} - absolute directory for top-level containing scan
        % folders
        cDirSave
        
        % {char 1xm} - absolute directory for saving current recipe.json and result.json files
        cDirScan
        
        uipType
        
        uipDevice1
        uieStart1
        uieStop1
        uieSteps1
        
        uipDevice2
        uieStart2
        uieStop2
        uieSteps2 
        
        uieOperator
        uieMeta
        uieSettle
        
        stStartStopStepsStore1
        stStartStopStepsStore2
        
        uitPlotType
        
        uipPlotDataType
        uipPlotYScaleType
        uipPlotYLimitType
        uipPlotYLimitMin
        uiePlotYLimitMax
        
    
    end
    
    properties (SetAccess = private)
    
        cName = 'main';
        cDir
        ceValues % cell of structures
        
        % HIOs
        % wav  
        % maskX
        % maskY
        % maskZ
        % maskT (theta)
        % detT (theta)
        % detX
        % filterX
        
        % HOs
        % iZero
        % iDet
        
        hioMono
        hioGrating
        hioMaskX
        hioMaskY
        hioMaskZ
        hioMaskT
        hioDetX
        hioDetT
        hioFilterY
        keithley
        
        % {double 1xm} x axis on 1D plot storage for the value of the scanned parameter
        d1DResultParam      
        % {double 1xm} y axis on 1D plot storage for iDet
        d1DResultIDet 
        % {double 1xm} y axis on 1D plot storage for iZero
        d1DResultIZero      
        
        % {double nxm} x mesh on mesh/contour plot 
        d2DResultParam1 
        % {double nxm} y mesn on mesh/contour plot
        d2DResultParam2
        % {double nxm} z mesh iDet
        d2DResultIDet 
        % {double nxm} z mesh iZero
        d2DResultIZero     
        
        % {double 1xm} storage for time of each set + acquire
        dTime 
        
        % {char 1xm} absolute directory of the application root
        cDirApp
        
        % {char 1xm} absolute full path (including filename and extension)
        % of .jar file fir SinsInstruments
        cPathJarSins
        
        % {char 1xm} absolute full path (including filename and extension)
        % of recipe file that is active
        cPathRecipe 
        % {char 1xm} absolute full path (including filename and extension)
        % of the last recipe file selected by the user (for "script" scans)
        cPathRecipeUser 
        % {double 1x1} fractional progress of the state scan 0 < progress <
        % 1. Used to update the activity status during the scan
        dProgress
        
        % {struct 1x1} storage of state units when live logging begins
        stUnitLive  
        
        % {struct 1x1} storage of state of the keithley (range, settings)
        % when scan begins
        stStateKeithley
        
        %{
        % {nus.sins2.Sins2Instruments 1x1}
        deviceSins
        % {cxro.common.device.axis.Axis 1x1}
        deviceMaskX
        % {cxro.common.device.axis.Axis 1x1}
        deviceMaskY
        % {cxro.common.device.axis.Axis 1x1}
        deviceMaskZ
        % {cxro.common.device.axis.Axis 1x1}
        deviceMaskT
        % {cxro.common.device.axis.Axis 1x1}
        deviceDetX
        % {cxro.common.device.axis.Axis 1x1}
        deviceDetT
        % {cxro.common.device.axis.Axis 1x1}
        deviceFilterY
        % {< InterfaceKeithley6482 1x1}
        deviceKeithley
        %}
        
    end
    
    properties (Access = private)
       
        % {char 1x1} absolute path of directory for saving state.mat file
        cDirSaveState
        clock 
        scan
        lIsScanning = false;
        hFigure
        
        
        uitPlay   % button to
        uibCancel
        
        uitxUnitLabel       % label for "Unit" column to go between "Device" and "Start"
        uitxUnit1
        uitxUnit2
        
        uitxPlotX
        uitxPlotY
        uitxPlotTypeLabel
        
       
        % Deprecated
        stMoveRequired      % struct of logicals that is used to store which 
                            % which need to be moved when setting a new
                            % state
        
        % Deprecated
        stMoveIssued        % struct of logical that stores which param move
                            % commands have been issued
       
        stHio   % Convient structure for storion all HIO instances for looping
        ceHIOs % Convenient way to store all of the HIOs for looping
        
        
        hPanelResult1D
        hPanelResult2D
        
        hAxes1D             % {1x1} handle of axes used for 1-device scan display
        hAxes2D1            % {1x1} handle of axes 1 (2D plot) for 2-device scan display
        hAxes2D2            % {1x1} handle of axes 2 (3D plot) for 2-device scan display
        
        hLines1DIDet        % {1xm} handles of lines on hAxes1D IDet
        hLines1DIZero       % {1xm} handles of lines on hAxes1D IZero
        hLegend1D           % {1x1} handle of legend on hAxes1D
        
        hLines2D1IDet        % {1xm} handles of lines on hAxes2D1 IDet
        hLines2D1IZero       % {1xm} handles of lines on hAxes2D1 IZero
        % {handle 1x(mxn)} handles of lines on hAxes2D2
        hLines2D2
        hLegend2D1           % {1x1} handle of legend on hAxes2D1
        
        % The reason we bother with storing the handles of the lines and
        % legend is that deleting and creating legends is performance heavy
        % so we only want to do it one time (since the legend never needs
        % to be modified).  The only way to clear an axes of its data
        % without deleting the legend is to store handles to the data
        % (lines / points, etc) and delete them.
        
        
        hPanelSettings
        hPanelStages
        hPanelMono
        hPanelScan
        hPanelPicoammeter
        hPanelPlotTools
        
        ticId
        ticIdStart
        
        uitxLabelTimeRemaining
        uitxLabelTimeElapsed
        uitxLabelTimeComplete
        uitxLabelStatus
        uitxLabelProgress
        
        uitxTimeRemaining 
        uitxTimeElapsed
        uitxTimeComplete
        uitxStatus
        uitxProgress
        
        
        dDaysStart       % fractional number of days since Jan 0, 0000 that scan started.
                            % use MATLABs datenum function for this. 
        

        pb % ProgressBar
        
        
        uitxLabelControlName
        uitxLabelControlVal
        uitxLabelControlUnit
        uitxLabelControlDest
        uitxLabelControlJog
        uitxLabelControlJogL
        uitxLabelControlJogR

        
        uibChooseRecipe
        uibOpenRecipe
        uitxRecipe
        
        uibSwap
        
        % listener handles for device events.  Need to store them because
        % when the devices are swapped, don't want to trigger the
        % resetPlot() each time a device / start/stop/steps is set
        
        lhOnDevice1Change
        lhOnStart1Change
        lhOnStop1Change
        lhOnSteps1Change 
        
        lhOnDevice2Change
        lhOnStart2Change
        lhOnStop2Change
        lhOnSteps2Change 
        
        u8Swap % storage for swap image
        
        uibChooseDir
        uitxDir
        uitxDirLabel
        
        uitStageApi % toggle for toggling all of the Apis at once
        
        
        uibLoadLock
        uibLoadLockSave
        
        
        uitxPlotIDetColor
        uitxPlotIZeroColor
        
    end
    
        
    events
        
        
    end
    

    
    methods
        
        
        function this = Main()
              
            this.clock = Clock('master');
            
            this.init();
           
                        
        end
        
        
        
        function onStateScanSetState(this, stUnit, stValue)
        %   @param {struct} stUnit - defines the unit of every degree of
        %       freedom that will be set
        %   @param {struct} stValue - defines the value of every degree of
        %       freedom that will be set
        
            % This implementation assumes that all motion can happen in 
            % parallel.  I.E., order doesn't matter.  If order matters, 
            % for some of the moves, you need to think about it is a series
            % circuit (or some things may need to be in series, others can happen 
            % in parallel, etc).  In this case you would 
            % would check stValue (or stUnit) for the presense of each
            % degree of freedom, in order, set that one, wait until it is
            % done, then proceed with the next degree of freedom and so
            % forth.  I can imagine doing this with a list of lists similar
            % to this.  This list assumes you can do mono and mask x, y, z
            % in parallel but have to wait for mask to stop moving until
            % you can do mask theta and then have to wait for that to
            % complete until the detector can be moved (x and theta on
            % detector can be moved in parallel).  I made this up, but you
            % can imagine a list like this and you have a function that
            % always pulls the first item from the list, executes the command,
            % waits for it to finish, then executes the second one. There 
            % could be a function called processParallelMotion()
            %  
            % Example:
            %
            % order = [
            %   ['mono', 'maskX', 'maskY', 'maskZ'],
            %   ['maskT'],
            %   ['detX', 'detT']
      
            
            this.ticId = tic;
            
            % Reset lMoveRequired and lMoveIssued for every prop
            
            ceNames = fieldnames(this.stHio);
            
            for n = 1:length(ceNames)
                this.stHio.(ceNames{n}).lMoveRequired = false;
                this.stHio.(ceNames{n}).lMoveIssued = false;
            end
            
            % Loop through all props that are being set and command them
            
            ceProps = fieldnames(stValue);
            for n = 1:length(ceProps)
                
                cUnit = stUnit.(ceProps{n}); 
                dValue = stValue.(ceProps{n});
                
                if strcmp(ceProps{n}, 'delay')
                    % Special case
                    cStatus = this.uitxStatus.cVal;
                    this.uitxStatus.cVal = sprintf('Pausing %1.2f s', dValue);
                    drawnow;
                    
                    pause(dValue);
                    
                    this.uitxStatus.cVal = cStatus;
                else
                    this.stHio.(ceProps{n}).lMoveRequired = true;
                    this.stHio.(ceProps{n}).hio.setDestCalDisplay(dValue, cUnit);
                    this.stHio.(ceProps{n}).hio.moveToDest();
                    this.stHio.(ceProps{n}).lMoveIssued = true;
                end
                
            end
                         
            
        end
        
         % See onStateScanSetState
         % This is a special case where we do setDestRaw() based on raw
         % units
         
         function onStateScanSetStateLL(this, stUnit, stValue)
        
            this.ticId = tic;
            
            % Reset lMoveRequired and lMoveIssued for every prop
            
            ceNames = fieldnames(this.stHio);
            
            for n = 1:length(ceNames)
                this.stHio.(ceNames{n}).lMoveRequired = false;
                this.stHio.(ceNames{n}).lMoveIssued = false;
            end
            
            % Loop through all props that are being set and command them
            
            ceProps = fieldnames(stValue);
            for n = 1:length(ceProps)
                
                cUnit = stUnit.(ceProps{n}); 
                dValue = stValue.(ceProps{n});
                
                if strcmp(ceProps{n}, 'delay')
                    % Special case
                    cStatus = this.uitxStatus.cVal;
                    this.uitxStatus.cVal = sprintf('Pausing %1.2f s', dValue);
                    drawnow;
                    
                    pause(dValue);
                    
                    this.uitxStatus.cVal = cStatus;
                else
                    this.stHio.(ceProps{n}).lMoveRequired = true;
                    % IMPORTANT. LL does not depend on units and always
                    % uses raw units.  The recipe also uses raw units.
                    this.stHio.(ceProps{n}).hio.setDestRaw(dValue); 
                    this.stHio.(ceProps{n}).hio.moveToDest();
                    this.stHio.(ceProps{n}).lMoveIssued = true;
                end
                
            end
                         
            
        end
        
        function lOut = onStateScanIsAtState(this, stUnit, stValue)
           
            % The complexity of setState(), i.e., lots of 
            % series operations vs. one large parallel operation, dictates
            % how complex this needs to be.  I decided to implement a
            % general approach that will work for the case of complex
            % serial operations.  The idea is that each device (HIO) is
            % wrapped with a lMoveRequired and lMoveIssued {locical} property.
            %
            % The beginning of setState(), loops through all devices
            % that will be controlled and sets the lMoveRequired flag ==
            % true for each one and false for non-controlled devices.  It also sets 
            % lMoveIssued === false for all controlled devices.  
            %
            % Once a device move is commanded, the lMoveIssued flag is set
            % to true.  These two flags provide a systematic way to check
            % isAtState: loop through all devices being controlled and only
            % return true when every one that needs to be moved has had its
            % move issued and also has isThere / lReady === true.
            
            % Ryan / Antine you might know a better way to do this nested
            % loop / conditional but I wanted readability and debugginb so
            % I made it verbose
            
            lDebug = false;            
            lOut = true;
                        
            ceNames = fieldnames(stValue);
            
            for n = 1:length(ceNames)
                
                % special case, skip delay
                if strcmp(ceNames{n}, 'delay')
                    continue;
                end
                
                
                if this.stHio.(ceNames{n}).lMoveRequired
                    if lDebug
                        this.msg(sprintf('onStateScanIsAtState() %s has move required', ceNames{n}));
                    end

                    if this.stHio.(ceNames{n}).lMoveIssued
                        
                        % move has been issued
                        if lDebug
                            this.msg(sprintf('onStateScanIsAtState() %s move issued', ceNames{n}));
                        end
                        
                        if this.stHio.(ceNames{n}).hio.lReady
                        	if lDebug
                                this.msg(sprintf('onStateScanIsAtState() %s reached dest', ceNames{n}));
                            end
 
                        else
                            % still isn't there.
                            if lDebug
                                this.msg(sprintf('onStateScanIsAtState() %s is still settling', ceNames{n}));
                            end
                            lOut = false;
                            return;
                        end
                    else
                        % need to move and hasn't been issued.
                        if lDebug
                            this.msg(sprintf('onStateScanIsAtState() %s move not yet issued', ceNames{n}));
                        end
                        
                        lOut = false;
                        return;
                    end                    
                else
                    
                    if lDebug
                        this.msg(sprintf('onStateScanIsAtState() %s N/A', ceNames{n}));
                    end
                   % don't need to move, this param is OK. Don't false. 
                end
            end
        end
        
        
        function onStateScanAcquire(this, stUnit)
        
        %ACQUIRE store new data, update any graphis / plots.  For
        %time-based scans, good way to implement probably to add a delay
        %here.
        %   @param {struct} stUnit - the the unit of each degree of freedom
        %   being controlled.
        
            % Global settle before acquiring
            
            this.uitxStatus.cVal = sprintf('Pausing %1.2f s', this.uieSettle.val());
            pause(this.uieSettle.val());
        
            stValue = this.getSystemState(stUnit);
            this.ceValues{this.scan.u8Index} = stValue;
            
            % Update plotting storage arrays with latest measurement
            
           
            
            switch this.uipType.val()
                case this.cTypeOneDevice
                    
                    cField = this.deviceField(this.uipDevice1.val());
                    
                    % Overwrite goal value of param with measured value
                    switch cField
                        case this.cFieldDelay
                            % do nothing
                        otherwise
                            this.d1DResultParam(this.scan.u8Index) = stValue.(cField);
                    end
                    
                    % Overwrite zero value with measured value
                    this.d1DResultIDet(this.scan.u8Index) = stValue.iDet;       
                    this.d1DResultIZero(this.scan.u8Index) = stValue.iZero; 
                
                case this.cTypeTwoDevice
                    
                    % 2D plot storage update
                                                           
                    % Each 2nd dim scan at a 1st dim value fills a column
                    % of the matrix (so row needs to increment as we do a
                    % 2nd dim scan and col stays fixed
                    
                    % Points per row = this.uieSteps2.val() + 1
                    
                    dRow = mod(this.scan.u8Index - 1, this.uieSteps2.val() + 1) + 1; % 2nd dim index
                    dCol = floor((this.scan.u8Index - 1) / (this.uieSteps2.val() + 1)) + 1; % 1st dim index
                    
                    this.d2DResultIDet(dRow, dCol) = stValue.iDet;
                    this.d2DResultIZero(dRow, dCol) = stValue.iZero;
                    
                    % 1D plot of current scan along 2nd dimension
                    
                    if dRow == 1
                        
                        % Started a new scan along 2nd dim.  Reset the 1D
                        % plot storage
                        
                        this.msg('Resetting 1D plot storage in 2D scan');
                        
                                                
                        % 2nd dimension values
                        dValues2 = linspace(...
                            this.uieStart2.val(), ...
                            this.uieStop2.val(), ...
                            this.uieSteps2.val() + 1 ...
                        );
                        
                        this.d1DResultParam = dValues2;
                        this.d1DResultIDet = zeros(size(dValues2));    
                        this.d1DResultIZero = zeros(size(dValues2));
                        
                    end
                    
                    cField = this.deviceField(this.uipDevice2.val());
                                        
                    % Overwrite goal value of param with measured value
                    switch cField
                        case this.cFieldDelay
                            % do nothing
                        otherwise
                            this.d1DResultParam(dRow) = stValue.(cField);
                    end
                    
                    this.d1DResultIDet(dRow) = stValue.iDet;     
                    this.d1DResultIZero(dRow) = stValue.iZero;
                    
                case this.cTypeScript
                    
                    % 1D plot storage for a custom recipe.  Plot the list
                    % of measurements.
                    
                    this.d1DResultParam(this.scan.u8Index) = this.scan.u8Index;            
                    this.d1DResultIDet(this.scan.u8Index) = stValue.iDet;     
                    this.d1DResultIZero(this.scan.u8Index) = stValue.iZero;
                    
                
                                                            
            end
            
            % this.dTime(this.scan.u8Index)
            this.updatePlot(stUnit); 
            this.updateStatus();
            
        end
        
        function lOut = onStateScanIsAcquired(this)
           lOut = true;  
        end
        
        
        function lOut = validateDest(this)
                
            lOut = true;
            return;
            
            % FIXME
            if abs(this.hioMaskX.destCal('m')) > 10
                
                
                cMsg = sprintf(...
                    'The destination %1.*f %s ABS (%1.*f %s REL) is now allowed.', ...
                    this.hioMaskX.unit().precision, ...
                    this.hioMaskX.destCal(this.hioMaskX.unit().name), ...
                    this.hioMaskX.unit().name, ...
                    this.hioMaskX.unit().precision, ...
                    this.hioMaskX.destCalDisplay(), ...
                    this.hioMaskX.unit().name ...
                );
                cTitle = sprintf('Position not allowed');
                msgbox(cMsg, cTitle, 'warn')
                
                                
                
                lOut = false;
            else 
                lOut = true;
            end
        end
        
        function buildFigure(this)
            
             % Figure
          
            if ishghandle(this.hFigure)
                % Bring to front
                figure(this.hFigure);
                return
            else 
            
                dScreenSize = get(0, 'ScreenSize');
                this.hFigure = figure( ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'Name', 'SINS Control', ...
                    'Color', this.dColorBgFigure, ...
                    'CloseRequestFcn', @this.onClose, ...
                    'Position', [ ...
                        (dScreenSize(3) - this.dWidth)/2 ...
                        (dScreenSize(4) - this.dHeight)/2 ...
                        this.dWidth ...
                        this.dHeight ...
                     ],... % left bottom width height
                    'Resize', 'off', ... 
                    'WindowButtonMotionFcn', @this.onWindowMouseMotion, ...
                    'HandleVisibility', 'on', ... % lets close all close the figure
                    'Visible', 'on' ...
                    );
                
                % 

                
                % pan(this.hFigure);
                % zoom(this.hFigure);
                % set(this.hFigure, 'toolbar', 'figure');
                datacursormode(this.hFigure, 'on');
            end
        end
        
        function build(this)
                       
            this.buildFigure();
            this.buildPanelMono();
            this.buildPanelStages();  
            this.buildPanelPicoammeter();
            this.buildPanelSettings();
            this.buildPanelScan();
            this.buildPanelResult(); % builds two panels
            this.buildPanelPlotTools();
            this.buildConnectAll();
           
            % Make sure the correct result panel is showing and update the
            % plot
            
            this.msg('build() calling onTypeChange()');
            this.onTypeChange([], []);
            %this.msg('build() calling updatePlot()');
            %this.updatePlot(this.getSystemUnits());
            
            this.onPlotYLimitTypeChange();

        end
        
        function deleteDevices(this)
            
            % RETURN %
            % initDevices() also returns
            return;
            
            
            this.msg('deleteDevices()');
            
            % this.deviceSins.destroy();
            this.deviceMaskX.destroy(); 
            this.deviceMaskY.destroy();
            this.deviceMaskZ.destroy();
            this.deviceMaskT.destroy();
            this.deviceDetX.destroy();
            this.deviceDetT.destroy();
            % this.deviceFilterY.destroy();
            
            delete(this.deviceKeithley);
            
        end
        
        function deleteHardwareUIMono(this)
        
            this.msg('deleteHardwareUIMono()');
            delete(this.hioMono);
            delete(this.hioGrating);
            
        end
        
        function deleteHardwareUIKeithley(this)
            this.msg('deleteHardwareUIKeithley()');
            delete(this.keithley); 
        end
        
        function deleteHardwareUIStages(this)
            this.msg('deleteHardwareUIStages()');
            
            delete(this.hioMaskX);
            delete(this.hioMaskY);
            delete(this.hioMaskZ);
            delete(this.hioMaskT);
            delete(this.hioDetX);
            delete(this.hioDetT);
            delete(this.hioFilterY);
            
        end
        
        function deletePanelSettings(this)
            
            this.msg('deletePanelSettings()');
            delete(this.uieOperator);
            delete(this.uieMeta);
            delete(this.uieSettle);
            delete(this.uibChooseDir);
            delete(this.uitxDir);
            delete(this.uitxDirLabel);
        end
        
        function deletePanelScan(this)
            
            this.msg('deletePanelScan()');
            delete(this.uipType);
            delete(this.uipDevice1);
            delete(this.uieStart1);
            delete(this.uieStop1);
            delete(this.uieSteps1);

            delete(this.uipDevice2);
            delete(this.uieStart2);
            delete(this.uieStop2);
            delete(this.uieSteps2);
            
            delete(this.uibSwap);
            
            delete(this.uitxUnitLabel);       % label for "Unit" column to go between "Device" and "Start"
            delete(this.uitxUnit1);
            delete(this.uitxUnit2);
            
            delete(this.uibChooseRecipe);
            delete(this.uibOpenRecipe);
            delete(this.uitxRecipe);
            
            delete(this.uitPlay);   % button to
            delete(this.uibCancel);

            delete(this.uitxLabelTimeRemaining);
            delete(this.uitxLabelTimeElapsed);
            delete(this.uitxLabelTimeComplete);
            delete(this.uitxLabelStatus);
            delete(this.uitxLabelProgress);

            delete(this.uitxTimeRemaining); 
            delete(this.uitxTimeElapsed);
            delete(this.uitxTimeComplete);
            delete(this.uitxStatus);
            delete(this.uitxProgress); 
        end
        
        function delete(this)
            
            this.msg('delete()');
            this.turnOff();
            
            this.save();
     
            this.deleteHardwareUIStages();
            this.deleteHardwareUIMono();
            this.deleteHardwareUIKeithley();
            
            this.deletePanelSettings();
            this.deletePanelScan();
            
            this.deleteDevices();
            
            delete(this.uitStageApi);
            delete(this.hFigure);
            delete(this.clock);
            
        end
        
        function turnOn(this)
           
            % HIOs
            ceNames = fieldnames(this.stHio);
            for n = 1:length(ceNames)
                this.stHio.(ceNames{n}).hio.turnOn();
            end
            
            % Keithley
            this.keithley.turnOn();
            
            
        end
        
        
        function turnOff(this)
            
            % HIOs
            ceNames = fieldnames(this.stHio);
            for n = 1:length(ceNames)
                this.stHio.(ceNames{n}).hio.turnOff();
            end
            
            % Keithley
            this.keithley.turnOff();
        end
        
       
        
        
        
               
    end
    
    methods (Access = protected)
            
         function load(this)
                        
            this.msg('load()');

            if exist(this.file(), 'file') == 2
                load(this.file()); % populates variable s in local workspace
                this.loadClassInstance(s); 
            end
            
         end
        
        function onClose(this, src, evt)
            this.msg('onClose()');
            this.delete();
        end
        
        function onSwapPress(this, src,evt)
            
            this.msg('onSwapPress()');
            this.removeDevice1Listeners();
            this.removeDevice2Listeners();
        
            u8Device1 = this.uipDevice1.u8Selected;
            cStart1 = this.uieStart1.val();
            cStop1 = this.uieStop1.val();
            cSteps1 = this.uieSteps1.val();
            
            u8Device2 = this.uipDevice2.u8Selected;
            cStart2 = this.uieStart2.val();
            cStop2 = this.uieStop2.val();
            cSteps2 = this.uieSteps2.val();
            
            
            this.uipDevice1.u8Selected = u8Device2;
            this.uieStart1.setVal(cStart2);
            this.uieStop1.setVal(cStop2);
            this.uieSteps1.setVal(cSteps2);
            
            this.uipDevice2.u8Selected = u8Device1;
            this.uieStart2.setVal(cStart1);
            this.uieStop2.setVal(cStop1);
            this.uieSteps2.setVal(cSteps1);
            
            this.updateUnit1();
            this.updateUnit2();
            
            this.addDevice1Listeners();
            this.addDevice2Listeners();
            this.resetPlot();
            
            
            
            
        end
        
        
        function onHIOUnitChange(this, src, evt)
        %ONHIOUNITCHANGE uitxUnit1 or uitxUnit2 may now be out of sync with
        %the display unit of the HIOs.  Update uitxUnit1/2 with latest
        %display units of HIOs.
        
            this.updateUnit1();
            this.updateUnit2();
            
        end
        
        function cOut = liveId(this)
            cOut = sprintf('%s-live-log', this.id());
        end
        
        function liveAcquire(this)
           
            % System state in units when live log began
            stValue = this.getSystemState(this.stUnitLive);   
            
            % Append iDet and iZero to stored values
            u8Index = length(this.d1DResultParam) + 1;
            this.d1DResultParam(u8Index) = u8Index;
            this.d1DResultIDet(u8Index) = stValue.iDet;     
            this.d1DResultIZero(u8Index) = stValue.iZero;
            
            % Update the plot display
            this.updatePlot(this.stUnitLive); 
            
            % Update text status
            this.updateStatus();
            
        end
           
        function liveResume(this)
            
            % Restart the timer
            this.lIsScanning = true;
            this.clock.add(@this.liveAcquire, this.liveId(), 0.1);
            
        end
        
        function liveStart(this)
                 
            this.msg('liveStart()');
            
            % Start a new scan
            this.lIsScanning = true;
            this.resetPlot();
            
            this.stUnitLive = this.getSystemUnits();
        
            this.resetStatus();
            this.ticIdStart = tic;
            this.dDaysStart = now;
                        
            % Acquire with clock
            this.clock.add(@this.liveAcquire, this.liveId(), 0.1);
            
            this.uitxStatus.cVal = 'Live logging';
            
            
        end
        
        function liveRemoveClockTask(this)
            if isvalid(this.clock) && ...
               this.clock.has(this.liveId())
                this.clock.remove(this.liveId());
            end 
        end
        
        
        function livePause(this)
            % Don't need to change lIsScanning
            % this.lIsScanning = true;  
            this.liveRemoveClockTask();
        end
        
        function liveStop(this)
            this.lIsScanning = false;
            this.liveRemoveClockTask(); 
            this.resetUI();
        end
        
        
        function onPlayChange(this, src, evt)
            
            this.msg('onPlayChange');
            
            switch this.uipType.val()
                                
                case this.cTypeLive % Special case, not using Scan
                   
                    % Handle start/pause/resume button in "Live" mode
                    
                    
                    if (this.uitPlay.lVal) % lVal just changed to on, so was not playing

                        if (this.lIsScanning)
                            % Button said "resume"
                            this.liveResume();

                        else
                            % Button said "start"
                            this.liveStart();                    
                        end

                        % Show the cancel button
                        this.uibCancel.show();


                    else % lVal just changed to off so was playing
                        
                        this.livePause();
                        this.uitPlay.setTextOff('Resume');
                        this.uitPlay.setTooltip(this.cTooltipScanResume);
                        this.uitxStatus.cVal = 'Paused';


                    end
                    
                    
                otherwise
                        
                    if (this.uitPlay.lVal) % lVal just changed to on, so was not playing

                        if (this.lIsScanning)

                            %Resume
                            this.scan.resume();

                        else
                            this.startNewScan();                    
                        end

                        % Show the stop button
                        this.uibCancel.show();



                    else % lVal just changed to off so was playing
                        this.scan.pause();
                        this.uitPlay.setTextOff('Resume');
                        this.uitPlay.setTooltip(this.cTooltipScanResume);
                        this.uitxStatus.cVal = sprintf('Paused (%1.1f%%)', this.dProgress * 100);

                    end
                    
            end
            
        end
        
        
        
        
        function save(this)
            
            this.msg('save()');
            
            % Create a nested recursive structure of all public properties
            s = this.saveClassInstance();            
                                    
            % Save
            
            save(this.file(), 's');
                        
        end
        
        function cReturn = file(this)
            
            this.checkDir(this.cDirSaveState);
            cReturn = fullfile(...
                this.cDirSaveState, ...
                [this.cName, '-saved-state.mat']...
            );
            
        end
        
    end
    
    methods (Access = private)
        
        
        
        function onChooseSaveDirPress(this, src, evt)
           
            cName = uigetdir(...
                this.cDirSave, ...
                'Please choose a directory' ...
            );
        
            if isequal(cName,0)
               return; % User clicked "cancel"
            end
            
            this.cDirSave = MicUtils.path2canonical(cName);
            this.updateDirLabel();            
        end
        
        function updateDirLabel(this)
            this.uitxDir.setTooltip(sprintf(...
                'The directory where scan recipe/result files are saved: %s', ...
                this.cDirSave ...
            ));
            this.uitxDir.cVal = MicUtils.truncate(this.cDirSave, 55, true);
        end
        
        
        function onCancelPress(this, src, evt)
            
            switch this.uipType.val()
                                
                case this.cTypeLive % Special case, not using Scan
                    this.uitPlay.lVal = false;
                    this.uitPlay.setTextOff('Resume');
                    this.uitPlay.setTooltip(this.cTooltipScanResume);
                    this.livePause();
                otherwise
                    
                    this.uitPlay.lVal = false; 
                    this.uitPlay.setTextOff('Resume');
                    this.uitPlay.setTooltip(this.cTooltipScanResume);
                    this.scan.pause();
            end
        end
        
        function onHioMonoTurnOn(this, src, evt)
            this.hioGrating.turnOn();
        end
        
        function onHioMonoTurnOff(this, src, evt)
            
            
 
            
            this.hioGrating.turnOff();
        end
        
        function updateAxesCrosshair(this)
            
           % If the mouse is inside the axes, turn the cursor into a
           % crosshair, else make sure it is an arrow
           
           if ~ishandle(this.hFigure)
               return;
           end
           
           if ~ishandle(this.hAxes1D)
               return;
           end
           
           if ~ishandle(this.hAxes2D1)
               return;
           end
    
           dCursor = get(this.hFigure, 'CurrentPoint');     % [left bottom]
           
           switch (this.uipType.val())
               case this.cTypeOneDevice
                   dAxes = get(this.hAxes1D, 'Position');             % [left bottom width height]
                   dPoint = get(this.hAxes1D, 'CurrentPoint');
               otherwise
                   dAxes = get(this.hAxes2D1, 'Position'); 
                   dPoint = get(this.hAxes2D1, 'CurrentPoint');
           end
           
           dPositionPanel = get(this.hPanelResult1D, 'Position');
           
           if isempty(dAxes)
               return;
           end
           
           dCursorLeft =    dCursor(1);
           dCursorBottom =  dCursor(2);
           
           % Need to include left/bottom of container panel to get correct
           % left / bottom of the Axes since its Position is relative to
           % its parent
           
           dAxesLeft =      dAxes(1) + dPositionPanel(1);
           dAxesBottom =    dAxes(2) + dPositionPanel(2);
           dAxesWidth =     dAxes(3);
           dAxesHeight =    dAxes(4);
           
           if   dCursorLeft >= dAxesLeft && ...
                dCursorLeft <= dAxesLeft + dAxesWidth && ...
                dCursorBottom >= dAxesBottom && ...
                dCursorBottom <= dAxesBottom + dAxesHeight
                if strcmp(get(this.hFigure, 'Pointer'), 'arrow')
                    set(this.hFigure, 'Pointer', 'crosshair')
                end
                this.uitxPlotX.cVal = sprintf('x: %1.3f', dPoint(1, 1));
                this.uitxPlotY.cVal = sprintf('y: %1.3e', dPoint(1, 2));
           else
                if ~strcmp(get(this.hFigure, 'Pointer'), 'arrow')
                    set(this.hFigure, 'Pointer', 'arrow')
                end
                this.uitxPlotX.cVal = 'x: [hover]';
                this.uitxPlotY.cVal = 'y: [hover]';
           end
        end
        
        function onWindowMouseMotion(this, src, evt)
           
           % this.msg('onWindowMouseMotion()');
           this.updateAxesCrosshair();
           
           
          
 
        end 
            
        function onAxesButtonDown(this, src, evt)
            this.msg('onAxesButtonDown');
            src.CurrentPoint
            
        end
        
        function onCancelConfirm(this, src, evt) 
             switch this.uipType.val()
                                
                case this.cTypeLive % Special case, not using Scan
                    this.liveStop();
                 otherwise
                    this.scan.stop(); % dispatches eScanComplete
             end
             
        end
        
        function onTypeChange(this, src, evt) 
                        
            this.msg('onTypeChange()');
            
            switch this.uipType.val()
                                
                case this.cTypeOneDevice
                    
                    this.hideDevice2UI();
                    this.hideScriptUI();
                    this.showUnitLabel();
                    this.showDevice1UI();
                    this.showPanel1D();
                    this.uitPlay.enable();
                    
                case this.cTypeTwoDevice
                    
                    this.hideScriptUI();
                    this.showUnitLabel();
                    this.showDevice1UI();
                    this.showDevice2UI();
                    this.showPanel2D();
                    this.uitPlay.enable();
                    
                case this.cTypeScript
                    
                    this.hideUnitLabel();
                    this.hideDevice1UI();
                    this.hideDevice2UI();
                    
                    this.showPanel1D();
                    this.showScriptUI();
                    
                    % Always update the active recipe to the latest one
                    % selected by the user.  This is necesary because "One
                    % Device" and "Two Device" scans create their own
                    % recipe files and update cPathRecipe. But we don't
                    % want "Script" mode to use the last recipe created
                    % for a "One Device" or "Two Device" scan type.
                    
                    this.cPathRecipe = this.cPathRecipeUser;
                    
                    % If a valid recipe struct can be built from the file
                    % at cPathRecipe, enable play. Otherwise, disable
                                        
                    
                    if ~isempty(this.cPathRecipeUser)
                        this.uitPlay.enable();
                    else
                        this.uitPlay.disable();
                    end
                    
                case this.cTypeLive
                    
                    
                    this.hideScriptUI();
                    this.hideDevice1UI();
                    this.hideDevice2UI();
                    this.hideUnitLabel();
                    this.showPanel1D();
                    this.uitPlay.enable();
                    
                
                    
                    
            end
            
            this.resetPlot();
            
        end
        
        function hideUnitLabel(this)
            this.uitxUnitLabel.hide();
        end
        
        function showUnitLabel(this)
            this.uitxUnitLabel.show();
        end
        
        function hideDevice1UI(this)
            % Also hides the labels since they are part of the Dim1 UIEdits
            this.uipDevice1.hide();
            this.uitxUnit1.hide();
            this.uieStart1.hide();
            this.uieStop1.hide();
            this.uieSteps1.hide();
            
        end
        
        function showDevice1UI(this)
            this.uipDevice1.show();
            this.uitxUnit1.show();
            this.uieStart1.show();
            this.uieStop1.show();
            this.uieSteps1.show();
        end
        
        function hideDevice2UI(this)
            this.uibSwap.hide();
            this.uipDevice2.hide();
            this.uitxUnit2.hide();
            this.uieStart2.hide();
            this.uieStop2.hide();
            this.uieSteps2.hide();
        end
        
        function showDevice2UI(this)
            this.uibSwap.show();
            this.uipDevice2.show();
            this.uitxUnit2.show();
            this.uieStart2.show();
            this.uieStop2.show();
            this.uieSteps2.show();
        end
        
        function showScriptUI(this)
            this.uibChooseRecipe.show();
            this.uitxRecipe.show();
            
            % Want to show the open button if 
            if ~isempty(this.cPathRecipeUser)
                this.uibOpenRecipe.show();
            end
        end
        
        function hideScriptUI(this)
            this.uibChooseRecipe.hide();
            this.uitxRecipe.hide();
            this.uibOpenRecipe.hide();
        end
        
        
        
        function resetUI(this)
            
            this.uitPlay.lVal = false;
            this.uitPlay.setTextOff('Start');
            this.uitPlay.setTooltip(this.cTooltipScanStart);
            this.uibCancel.hide();
            this.lIsScanning = false;
            this.uitxStatus.cVal = 'Ready';
            this.enableScanUI();
            
        end
        
        function onStateScanComplete(this, stUnit)
            
            this.msg('onStateScanComplete()');
            % this.dProgress = 0;
            this.saveScanResults(stUnit);
            this.resetUI();
        end
        
        function onStateScanAbort(this, stUnit)

            % NOTE - this can happen in the middle of an acquire
            this.msg('onStateScanAbort()');
            this.uitxStatus.cVal = sprintf('Aborted (%1.1f%%)', this.dProgress * 100);
            this.stopMotors();
            this.saveScanResults(stUnit, true);
            this.resetUI();
        end
                
        % Stop all potentially moving motors
        
        function stopMotors(this)
            
            this.msg('stopMotors()');
            
            ceNames = fieldnames(this.stHio);
            for n = 1:length(ceNames)
                this.stHio.(ceNames{n}).hio.stop();
            end
        end
        
        %{
        function handleScanComplete(this, src, evt)
            
            this.uitPlay.lVal = false;
            this.uitPlay.setTextOff('Play');
            this.uibCancel.hide();
            this.lIsScanning = false;
            this.uitxStatus.cVal = 'READY';
            this.enableScanUI();

            
            this.saveScanResults();
            
        end
        %}
        
        
        function saveLoadLockRecipe(this, stRecipe)
            
            this.msg('saveLoadLockRecipe()');
            this.uitxStatus.cVal = 'Writing LL recipe ...';

            cPathRecipe = this.getLoadLockRecipePath();
        
            stOptions = struct();
            stOptions.FileName = cPathRecipe;
            stOptions.Compact = 0; 
            
            savejson('', stRecipe, stOptions);            
            this.msg('Saved LL recipe: %s', cPathRecipe);
            
            this.uitxStatus.cVal = 'Saved LL recipe.';
            
        end
        
        function saveScanRecipe(this, stRecipe)
        %SAVESCANRECIPE Save a recipe struct to JSON and update
        %this.cPathRecipe with the full path to the saved file
        %   @param {struct} stRecipe - the recipe.  See classes/StateScan.m
        %       for information about the recipe struct
        
            % uses JSONLab 1.2 in functions/jsonlab-1.2
            
            this.uitxStatus.cVal = 'Writing recipe ...';
            
            cTimestamp = datestr(datevec(now), 'yyyymmdd-HHMMSS', 'local');
            cName = sprintf('%s-%s-Recipe.json', cTimestamp, this.uieMeta.val());
            
            this.checkDir(this.cDirScan);
            
            this.cPathRecipe = fullfile(...
                this.cDirScan, ...
                cName ...
            );
            
        
            stOptions = struct();
            stOptions.FileName = this.cPathRecipe;
            stOptions.Compact = 0; 
            savejson('', stRecipe, stOptions);            
            this.msg('Saved new recipe: %s', this.cPathRecipe);
            
        end
        
        % @param {struct} stUnit - the unit definitions that were used
        % during the scan
        % @param {logical} [lAborted = false] - true if the scan was aborted and
        % this is called from onStateScanAbort()
        
        function saveScanResults(this, stUnit, lAborted)
            this.msg('saveScanResults()');
            
            if nargin <3
                lAborted = false;
            end
            this.saveScanResultsJson(stUnit, lAborted);
            this.saveScanResultsCsv(stUnit, lAborted);
        end
        
        function saveScanResultsJson(this, stUnit, lAborted)
       
            this.msg('saveScanResultsJson()');
             
            this.uitxStatus.cVal = 'Saving JSON results ...';
            cTimestamp = datestr(datevec(now), 'yyyymmdd-HHMMSS', 'local');
            
            switch lAborted
                case true
                    cName = sprintf('%s-%s-Result-Aborted.json', cTimestamp, this.uieMeta.val());
                case false
                    cName = sprintf('%s-%s-Result.json', cTimestamp, this.uieMeta.val());
            end
            
            cPath = fullfile(...
                this.cDirScan, ...
                cName ...
            );
        
            stResult = struct();
            stResult.recipe = this.cPathRecipe;
            stResult.operator = this.uieOperator.val();
            stResult.meta = this.uieMeta.val();
            stResult.settle = this.uieSettle.val();
            stResult.unit = stUnit;
            stResult.keithley = this.stStateKeithley;
            stResult.values = this.ceValues;
            
            stOptions = struct();
            stOptions.FileName = cPath;
            stOptions.Compact = 0;
            
            
            savejson('', stResult, stOptions);     

        end
        
        function saveScanResultsCsv(this, stUnit, lAborted)
        
            this.msg('saveScanResultsCsv()');
            
            this.uitxStatus.cVal = 'Saving CSV results ...';
            cTimestamp = datestr(datevec(now), 'yyyymmdd-HHMMSS', 'local');
            
            switch lAborted
                case true
                    cName = sprintf('%s-%s-Result-Aborted.csv', cTimestamp, this.uieMeta.val());
                case false
                    cName = sprintf('%s-%s-Result.csv', cTimestamp, this.uieMeta.val());
            end
            
            cPath = fullfile(...
                this.cDirScan, ...
                cName ...
            );
             
            %{
            % Pre 2017.03.13
            stResult = MicUtils.cellOfSt2structAr(this.ceValues);
            tableResult = struct2table(stResult);
            writetable(tableResult, cPath);
            %}
            
            % 2017.03.13 Try 1
            % struct2csv(stResult, cPath);
            
            % 2017.03.13 Manual
            
            if isempty(this.ceValues)
                return
            end
            
            % Open the file
            fid = fopen(cPath, 'w');

            % Write the header
            % Type
            fprintf(fid, '# "%s"\n', this.uipType.val());
            % Deivice list
            switch this.uipType.val()
                                
                case this.cTypeOneDevice
                   fprintf(fid, '# "%s"\n', this.uipDevice1.val());
                case this.cTypeTwoDevice
                    fprintf(fid, '# "%s", "%s"\n', this.uipDevice1.val(), this.uipDevice2.val());
                otherwise
                    fprintf(fid, '#\n');

            end
            
            % Write the field names
            ceNames = fieldnames(this.ceValues{1});
            for n = 1:length(ceNames)
                fprintf(fid, '%s,', ceNames{n});
            end
            fprintf(fid, '\n');

            % Write values
            for n = 1 : length(this.ceValues)
                stValue = this.ceValues{n};
                if ~isstruct(stValue)
                    continue
                end
                ceNames = fieldnames(stValue);
                for m = 1 : length(ceNames)
                    switch ceNames{m}
                        case 'time'
                            fprintf(fid, '%s,', stValue.(ceNames{m}));
                        otherwise
                            fprintf(fid, '%1.3e,', stValue.(ceNames{m}));
                    end
                end
                fprintf(fid, '\n');
            end

            % Close the file
            fclose(fid);

        end
        
        
        function st = getSystemUnits(this)
           
            % Populate units based on UI settings
            
            st = struct();
            % HIOs
            ceNames = fieldnames(this.stHio);
            for n = 1:length(ceNames)
                st.(ceNames{n}) = this.stHio.(ceNames{n}).hio.unit().name;
                
            end
            st.time = 'local';
            st.delay = 's';
           
        end
        
        
        function st = getSystemState(this, stUnit)
        %getSystemState return structure containing the state of the system (the
        %values/units of all settings, sensors, etc.  There should be a
        %state definition somewhere that you can refer to
        
                       
            st = struct();
            % HIOs
            ceNames = fieldnames(this.stHio);
            for n = 1:length(ceNames)
                % st.(ceNames{n}) = this.stHio.(ceNames{n}).hio.valCal(stUnit.(ceNames{n}));
                st.(ceNames{n}) = this.stHio.(ceNames{n}).hio.valCalDisplay();
            end
            
            %{
            st.iZero = this.keithley.val(uint8(1));
            st.iDet = this.keithley.val(uint8(2));
            
            st.keithleyCh1Range = this.keithley.uipRange1.val().cLabel;
            st.keithleyCh1AutoRange = this.keithley.uipAutoRange1.val().cState;
            st.keithleyCh2Range = this.keithley.uipRange2.val().cLabel;
            st.keithleyCh2AutoRange = this.keithley.uipAutoRange2.val().cState;
            
            st.keithleyADCIntegrationPLC = this.keithley.uipSpeed.val().dVal;
            st.keithleyAvgFilterState = this.keithley.uipAveragingFilter1.val().cState;
            st.keithleyAvgFilterMode = this.keithley.uipAveragingFilter1.val().cMode;
            st.keithleyAvgFilterSize = this.keithley.uieAveragingFilterSize1.val();
            st.keithleyMedianFilterState = this.keithley.uipMedianFilter1.val().cState;
            st.keithleyMedianFilterRank = this.keithley.uipMedianFilter1.val().u8Rank;
            %}           
            
            
            st.iZero = this.keithley.getApi().read(uint8(1));
            st.iDet = this.keithley.getApi().read(uint8(2));
              
            %{
            st.keithleyCh1Range = this.keithley.getApi().getRange(1);
            st.keithleyCh1AutoRange = this.keithley.getApi().getAutoRangeState(1);
            st.keithleyCh2Range = this.keithley.getApi().getRange(2);
            st.keithleyCh2AutoRange = this.keithley.getApi().getAutoRangeState(2);
            
            st.keithleyADCIntegrationPeriod = this.keithley.getApi().getIntegrationPeriod();
            st.keithleyAvgFilterState = this.keithley.getApi().getAverageState(1);
            st.keithleyAvgFilterMode = this.keithley.getApi().getAverageMode(1);
            st.keithleyAvgFilterSize = this.keithley.getApi().getAverageCount(1);
            st.keithleyMedianFilterState = this.keithley.getApi().getMedianState(1);
            st.keithleyMedianFilterRank = this.keithley.getApi().getMedianRank(1);
            %}
            
            st.time = datestr(datevec(now), 'yyyy-mm-dd HH:MM:SS', 'local');
            
        end
        
        % @return {struct 1x1} - the state of the Keithley range and
        % settings
        function st = getKeithleyState(this)
            
            st = struct();
            
            st.ch1Range = this.keithley.getApi().getRange(1);
            st.ch1AutoRange = this.keithley.getApi().getAutoRangeState(1);
            st.ch2Range = this.keithley.getApi().getRange(2);
            st.ch2AutoRange = this.keithley.getApi().getAutoRangeState(2);
            
            st.adcIntegrationPeriod = this.keithley.getApi().getIntegrationPeriod();
            st.avgFilterState = this.keithley.getApi().getAverageState(1);
            st.avgFilterMode = this.keithley.getApi().getAverageMode(1);
            st.avgFilterSize = this.keithley.getApi().getAverageCount(1);
            st.medianFilterState = this.keithley.getApi().getMedianState(1);
            st.medianFilterRank = this.keithley.getApi().getMedianRank(1);
            
        end
        
        
        function stRecipe = buildRecipe(this)
           
            this.msg('buildRecipe()');
            
            switch this.uipType.val()
                case this.cTypeOneDevice
                    stRecipe = this.buildRecipe1D();                    
                case this.cTypeTwoDevice
                    stRecipe = this.buildRecipe2D(); 
                otherwise
            end
            
        end
        
        function stRecipe = buildRecipe1D(this)
                 
           
            this.msg('buildRecipe1D()');

            dValues = linspace(...
                this.uieStart1.val(), ...
                this.uieStop1.val(), ...
                this.uieSteps1.val() + 1 ...
            );
                        
            ceValues = cell(1, this.uieSteps1.val() + 1); % list of value structures
            
            for n = 1:length(dValues)                
                stValue = struct();
                
                switch this.uipDevice1.val()
                    case this.cDeviceMaskTDet2T % special case sets two fields at once
                        stValue.(this.cFieldMaskT) = dValues(n);
                        stValue.(this.cFieldDetT) = 2 * dValues(n);
                    case this.cDeviceTime % special case convert time values to delays
                        if n == 1
                            stValue.(this.cFieldDelay) = dValues(n);
                        else
                            stValue.(this.cFieldDelay) = dValues(n) - dValues(n - 1);
                        end
                    
                        
                    otherwise
                        cField = this.deviceField(this.uipDevice1.val());
                        stValue.(cField) = dValues(n);
                end
                
                ceValues{n} = stValue;
            end
                
            stRecipe = struct();
            stRecipe.unit = this.getSystemUnits();
            % stRecipe.keithley = this.getKeithleyState();
            stRecipe.values = ceValues;
            
        end
        
        function stRecipe = buildRecipe2D(this)
            
            this.msg('buildRecipe2D()');
            
            % 1st dimension values            
            dValues = linspace(...
                this.uieStart1.val(), ...
                this.uieStop1.val(), ...
                this.uieSteps1.val() + 1 ...
            );
            
            % 2nd dimension values
            dValues2 = linspace(...
                this.uieStart2.val(), ...
                this.uieStop2.val(), ...
                this.uieSteps2.val() + 1 ...
            );
            
            % Build list of value structures
            ceValues = cell(1, (this.uieSteps1.val() + 1) * (this.uieSteps2.val() + 1));
            dCount = 1;
            for n = 1:length(dValues)
                
                % Set the 1st dimension props
                switch this.uipDevice1.val()
                    case this.cDeviceMaskTDet2T % special case
                        stValue.(this.cFieldMaskT) = dValues(n);
                        stValue.(this.cFieldDetT) = 2 * dValues(n);
                    case this.cDeviceTime % special case convert time values to delays
                        if n == 1
                            stValue.(this.cFieldDelay) = dValues(n);
                        else
                            stValue.(this.cFieldDelay) = dValues(n) - dValues(n - 1);
                        end
                    otherwise
                        cField = this.deviceField(this.uipDevice1.val());
                        stValue.(cField) = dValues(n);
                end
                
                for m = 1:length(dValues2)
                    
                    % Set the 2nd dimension props
                    switch this.uipDevice2.val()
                        case this.cDeviceMaskTDet2T % special case
                            stValue.(this.cFieldMaskT) = dValues2(m);
                            stValue.(this.cFieldDetT) = 2 * dValues2(m);
                        
                        case this.cDeviceTime % special case convert time values to delays
                            if m == 1
                                stValue.(this.cFieldDelay) = dValues2(m);
                            else
                                stValue.(this.cFieldDelay) = dValues2(m) - dValues2(m - 1);
                            end
                        otherwise
                            cField = this.deviceField(this.uipDevice2.val());
                            stValue.(cField) = dValues2(m);
                    end
                    
                    % Add the value structure to the list
                    ceValues{dCount} = stValue;
                    
                    % Increment the count
                    dCount = dCount + 1;
                end
            end
                
            stRecipe = struct();
            stRecipe.unit = this.getSystemUnits();
            stRecipe.keithley = this.getKeithleyState();
            stRecipe.values = ceValues;
            
        end
        
        function createNewScanDir(this)
            
            this.uitxStatus.cVal = 'Creating scan dir ...';
            
            cTimestamp = datestr(datevec(now), 'yyyymmdd-HHMMSS', 'local');
            cName = sprintf('Scan-%s-%s', cTimestamp, this.uieMeta.val());
            
            this.cDirScan = fullfile(this.cDirSave, cName);
            this.checkDir(this.cDirScan);
            
        end
        
        function startNewScan(this)
            
            this.msg('startNewScan()');
            
            % Start a new scan
            this.lIsScanning = true;
            this.disableScanUI();
            this.resetPlot();
            this.createNewScanDir();
            
            % Only build and save if not using a user-defined recipe.
            
            switch (this.uipType.val())
                case { this.cTypeOneDevice, this.cTypeTwoDevice } 
                    
                    % Build a new recipe using the UI settings.  
                    
                    stRecipe = this.buildRecipe();
                    
                    % Save the recipe.  This also upates this.cPathRecipe
                    this.saveScanRecipe(stRecipe);
                    
                otherwise
                    % Use the cPathRecipe of the user's file
                    
            end
               
            % Build the recipe from .json file (we dogfood our own .json recipes always)
            
            [stRecipe, lError] = this.buildRecipeFromFile(this.cPathRecipe);             
            
            if lError 
                
                this.lIsScanning = false;
                this.uitxStatus.cVal = 'READY';
                this.enableScanUI();
                return;
                
            end
            

            % Create new StateScan and start it
            this.scan = StateScan(...
                this.clock, ...
                stRecipe, ...
                @this.onStateScanSetState, ...
                @this.onStateScanIsAtState, ...
                @this.onStateScanAcquire, ...
                @this.onStateScanIsAcquired, ...
                @this.onStateScanComplete, ...
                @this.onStateScanAbort ...
            );

        
            this.resetStatus();
            this.ticIdStart = tic;
            this.dDaysStart = now;
            
            this.ceValues = cell(size(stRecipe.values));
            this.dTime = zeros(size(stRecipe.values));
            
            % Store this so it can be reported in saveScanResults
            this.stStateKeithley = this.getKeithleyState();
            
            this.uitxStatus.cVal = sprintf('Scanning (%1.1f%%)', this.dProgress * 100);
            this.scan.start();

            % addlistener(this.scan, 'eScanComplete', @this.handleScanComplete); 
            
            
        end
        
        
        function resetStatus(this)
           
            this.uitxTimeComplete.cVal = '---';
            this.uitxTimeElapsed.cVal = '---';
            this.uitxTimeRemaining.cVal = '---';
            
        end
        
        
        function updateStatus(this)
               
            
            switch this.uipType.val()
                                
                case this.cTypeLive % Special case, not using Scan
                    this.dProgress = 1;
                otherwise
                    this.dProgress = this.scan.u8Index / length(this.scan.ceValues);
            end
            
            
            % Not currently showing these
            this.pb.setProgress(this.dProgress);
            this.uitxProgress.cVal = sprintf('%1.1f%%', this.dProgress * 100);
            
            % Are showing this
            this.uitxStatus.cVal = sprintf('Scanning (%1.1f%%)', this.dProgress * 100);
                        
            % Fractional days since the start of the scan.  Use this
            % because this is MATLAB's "DateNum" format, which the datestr
            % function can use.  toc returns the elapsed time in seconds
            % since "tic" was called
            
            dDaysElapsed = toc(this.ticIdStart) / (3600 * 24);
            
            % Use elapsed days and progress to estimate the number of days
            % for the entire scan to complete
            
            if this.dProgress == 0
                dDaysScan = 0;
            else
                dDaysScan = dDaysElapsed / this.dProgress;
            end
            
            dDaysRemaining = dDaysScan - dDaysElapsed;
            
            this.uitxTimeElapsed.cVal = datestr(dDaysElapsed, 'HH:MM:SS', 'local');
            
            % Add the estimated numbef of days for the full scan to the
            % number of days since Jan 0, 0000 (obtained with "now") to get
            % the estimated complete time.  
            
            try
                this.uitxTimeComplete.cVal = datestr(this.dDaysStart + dDaysScan, 'HH:MM:SS', 'local');
                this.uitxTimeRemaining.cVal = datestr(dDaysRemaining, 'HH:MM:SS', 'local');
            catch e
                this.dDaysStart
                dDaysScan
            end
            
        end
        
        function cLabel = devicePlotLabel(this, cDevice, stUnit)
            switch cDevice
                case this.cDeviceMaskTDet2T
                    % Special case
                    cLabel = sprintf(...
                        '%s (%s, %s)', ...
                        cDevice, ...
                        stUnit.(this.cFieldMaskT), ...
                        stUnit.(this.cFieldDetT) ...
                    );
                otherwise
                    cLabel = sprintf(...
                        '%s (%s)', ...
                        cDevice, ...
                        stUnit.(this.deviceField(cDevice)) ...
                    );                            
            end
        end
        
        function cLabel = devicePlotLabelWithValue(this, cDevice, stUnit)
            
        
            switch cDevice
                case this.cDeviceMaskTDet2T
                    
                    % e.g., mask t, det 2t = 50.01 deg, 100.02 deg

                    cLabel = sprintf('%s = %1.*f %s, %1.*f %s', ...
                        cDevice, ...
                        this.stHio.(this.cFieldMaskT).hio.unit().precision, ...
                        this.stHio.(this.cFieldMaskT).hio.valCal(stUnit.(this.cFieldMaskT)), ...
                        stUnit.(this.cFieldMaskT), ...
                        this.stHio.(this.cFieldDetT).hio.unit().precision, ...
                        this.stHio.(this.cFieldDetT).hio.valCal(stUnit.(this.cFieldDetT)), ...
                        stUnit.(this.cFieldDetT)...
                    ); 
                 
                case this.cDeviceTime
                    
                    % e.g., time = 1 s
                    cLabel = 'time = now';   
                    
                otherwise
                    
                    % e.g., mask x = 4.234 mm

                    cField = this.deviceField(cDevice);
                    cLabel = sprintf('%s = %1.*f %s', ...
                        cDevice, ...
                        this.stHio.(cField).hio.unit().precision, ...
                        this.stHio.(cField).hio.valCal(stUnit.(cField)), ...
                        stUnit.(cField)...
                    );   
                    
            end
        end
        
        function updatePlot(this, stUnit)
            
            this.msg('updatePlot');
            
            if  isempty(this.hAxes1D) || ...
                ~ishandle(this.hAxes1D) || ...
                isempty(this.hAxes2D1) || ...
                ~ishandle(this.hAxes2D1) || ...
                isempty(this.hAxes2D2) || ...
                ~ishandle(this.hAxes2D2)
                
                this.msg('updatePlot returning due to empty Axes handle');
                return;
            end
            
            
            switch (this.uipType.val())
                case this.cTypeOneDevice
                    
                    this.msg(sprintf('updatePlot() case: %s', this.cTypeOneDevice));

                    % Plot IDet, IZero vs. controlled device value

                    this.updateAxes1DData();
                                    
                    % set(this.hLines1DIDet, 'HitTest','off');
                    % set(this.hLines1DIZero, 'HitTest','off');
                    % title(this.hAxes1D, 'Results');
                                                            
                    xlabel(this.hAxes1D, this.devicePlotLabel(this.uipDevice1.val(), stUnit));
                    ylabel(this.hAxes1D, sprintf('I (%s)', 'A'));
                    
                    %}
                    
                    %{
                    grid(this.hAxes1D, 'minor');
                    set(...
                        this.hAxes1D, ...
                        'XMinorTick','on', ...
                        'YMinorTick','on' ...
                    )
                    %}
                    
                                        
                    set(this.hAxes1D, 'FontSize', this.dSizeFont);

                                
                case this.cTypeTwoDevice
                    
                    this.msg(sprintf('updatePlot() case: %s', this.cTypeTwoDevice));
                    % Plot of current 2nd dimension being scanned
                    
                   
                    
                    
                    this.updateAxes2D1Data();
                   
        
                    cLabel = sprintf(...
                        '%s at %s', ...
                        this.devicePlotLabel(this.uipDevice2.val(), stUnit), ...
                        this.devicePlotLabelWithValue(this.uipDevice1.val(), stUnit) ...
                    );
                    
                    xlabel(this.hAxes2D1, cLabel);
                    ylabel(this.hAxes2D1, sprintf('I (%s)', 'A'));
                    
                            
                    
                    % Set FontSize at end for some reason it is required to
                    % do it at the end
                    set(this.hAxes2D1, 'FontSize', this.dSizeFont);
                    
                    % 3D line plot
                    
                    % cla(this.hAxes2D2)
                    
                    % Remove old line series
                    
                    if ~isempty(this.hLines2D2) && all(ishandle(this.hLines2D2))
                        delete(this.hLines2D2);
                    end
                    
                    this.hLines2D2 = plot3(...
                        this.hAxes2D2, ...
                        this.d2DResultParam1, this.d2DResultParam2, this.d2DResultIDet, '.-', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                
                    %{
                    if this.uitPlotType.lVal
                        set(this.hAxes2D2, 'ZScale', 'log');
                    else
                        set(this.hAxes2D2, 'ZScale', 'linear');
                    end
                    
                    %}
                    
                    this.updateAxesZScale(this.hAxes2D2);


                
                    xlabel(this.hAxes2D2, this.devicePlotLabel(this.uipDevice1.val(), stUnit)); 
                    ylabel(this.hAxes2D2, this.devicePlotLabel(this.uipDevice2.val(), stUnit));  
                    zlabel(this.hAxes2D2, sprintf('Idet/Izero')); 
                
                    set(this.hAxes2D2, 'FontSize', this.dSizeFont);
                    % title(this.hAxes2D2, '2D Results');

                case {this.cTypeScript this.cTypeLive}
                    
                    cMsg = sprintf(...
                        'updatePlot() case: {%s %s}', ...
                        this.cTypeScript, ...
                        this.cTypeLive ...
                    );
                    this.msg(cMsg);
                    
                    % Plot IDet, IZero vs. Trial #
                    
                    % Delete old line series
                    
                    delete(this.hLines1DIDet);
                    delete(this.hLines1DIZero);
                    
                    this.hLines1DIDet = plot(...
                        this.hAxes1D, ...
                        this.d1DResultParam, this.d1DResultIDet, '.-r', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                    this.hLines1DIZero = plot(...
                        this.hAxes1D, ...
                        this.d1DResultParam, this.d1DResultIZero, '.-b', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                    % title(this.hAxes1D, 'Results');
                    xlabel(this.hAxes1D, sprintf('Trial'));
                    ylabel(this.hAxes1D, sprintf('I (%s)', 'A')); % FIXME
                    % xlim(this.hAxes, [0 max(this.dTime*1000)])
                    % ylim(this.hAxes, [-this.uieVoltsScale.val() this.uieVoltsScale.val()])
                    
                    % Draw legend first time
                    
                    if isempty(this.hLegend1D)
                    	this.hLegend1D = legend(this.hAxes1D, 'Idet','Izero');
                        set(this.hLegend1D, 'FontSize', this.dSizeFont);
                    end
                    
                    %{
                    dMin = min(this.d1DResultParam);
                    dMax = max(this.d1DResultParam);
                    if dMin < dMax
                        xlim(this.hAxes1D, [dMin dMax]);
                    end
                    %}
                    
                    set(this.hAxes1D, 'FontSize', this.dSizeFont);
                    
            end

            
        end
            
               
        % Get the name of the field/prop of the recipe/result that is being
        % varied in the 1D scan
        
        
        function cField = deviceField(this, cDevice)
        %Need a way to translate between "pretty" device names in the
        %device pulldown and the field name we assign to each device in the
        %HIO struct and in recipe JSON
        
            switch cDevice
                case this.cDeviceMono
                    cField = this.cFieldMono;
                case this.cDeviceMaskX
                    cField = this.cFieldMaskX;
                case this.cDeviceMaskY
                    cField = this.cFieldMaskY;
                case this.cDeviceMaskZ
                    cField = this.cFieldMaskZ;
                case this.cDeviceMaskT
                    cField = this.cFieldMaskT;
                case this.cDeviceDetX
                    cField = this.cFieldDetX;
                case this.cDeviceDetT
                    cField = this.cFieldDetT;
                case this.cDeviceFilterY
                    cField = this.cFieldFilterY;
                case this.cDeviceMaskTDet2T
                    % Special case where we are moving two devices but want
                    % to store mask t
                    cField = this.cFieldMaskT;
                case this.cDeviceTime
                    cField = this.cFieldDelay;
            end
            
        end
        
        function showPlotYLimitUi(this)
            this.uipPlotYLimitMin.show();
            this.uiePlotYLimitMax.show();
        end
        
        function hidePlotYLimitUi(this)
            this.uipPlotYLimitMin.hide();
            this.uiePlotYLimitMax.hide();
        end
        
        function showPanel1D(this)
            
            this.msg('showPanel1D()');
            
            set(this.hPanelResult1D, 'Visible', 'on');
            set(this.hPanelResult2D, 'Visible', 'off');
            
            %{
            set(this.hAxes1D, 'Visible', 'on');
            set(this.hAxes2D1, 'Visible', 'off');
            set(this.hAxes2D2, 'Visible', 'off');
            %}
        end
        
        function showPanel2D(this)
            
            this.msg('showPanel2D()');
            set(this.hPanelResult1D, 'Visible', 'off');
            set(this.hPanelResult2D, 'Visible', 'on');
            
            %{
            set(this.hAxes1D, 'Visible', 'off');
            set(this.hAxes2D1, 'Visible', 'on');
            set(this.hAxes2D2, 'Visible', 'on');
            %}
        end
        
        
        function disableScanUI(this)
            
            this.uipType.disable();
            this.uipDevice1.disable();
            this.uipDevice2.disable();
            
            this.uitxUnit1.disable();
            this.uieStart1.disable();
            this.uieStop1.disable();
            this.uieSteps1.disable();

            this.uitxUnit2.disable();
            this.uieStart2.disable();
            this.uieStop2.disable();
            this.uieSteps2.disable();
            this.uibSwap.disable();
            

            
        end
        
        function enableScanUI(this)
            
            this.uipType.enable();
            this.uipDevice1.enable();
            this.uipDevice2.enable();
            
            this.uitxUnit1.enable();
            this.uieStart1.enable();
            this.uieStop1.enable();
            this.uieSteps1.enable();

            this.uitxUnit2.enable();
            this.uieStart2.enable();
            this.uieStop2.enable();
            this.uieSteps2.enable();
            this.uibSwap.enable();
            
        end
        
        function onDevice1Change(this, src, evt)
            this.msg('onDevice1Change()');
            this.updateUnit1();
            this.updateStartStopSteps1();
            % No longer necessary since updateStartStopSteps1 triggers
            % onSteps1Change() which calls resetPlot().
            % this.resetPlot();
        end
        
        
        
        function onDevice2Change(this, src, evt)
            this.msg('onDevice2Change()');
            this.updateUnit2();
            this.updateStartStopSteps2();
            % No longer necessary since updateStartStopSteps1 triggers
            % onSteps2Change() which calls resetPlot().
            % this.resetPlot();
        end
        
        function onStart1Change(this, src, evt)
            this.msg('onStart1Change()');
            cField = this.deviceField(this.uipDevice1.val());
            this.stStartStopStepsStore1.(cField).start = src.val();
            this.resetPlot();
        end
        function onStop1Change(this, src, evt)
            this.msg('onStop1Change()');
            cField = this.deviceField(this.uipDevice1.val());
            this.stStartStopStepsStore1.(cField).stop = src.val();
            this.resetPlot();
        end
        function onSteps1Change(this, src, evt)
            this.msg('onSteps1Change()');
            cField = this.deviceField(this.uipDevice1.val());
            this.stStartStopStepsStore1.(cField).steps = src.val();
            this.resetPlot();
        end
        function onStart2Change(this, src, evt)
            this.msg('onStart2Change()');
            cField = this.deviceField(this.uipDevice2.val());
            this.stStartStopStepsStore2.(cField).start = src.val();
            this.resetPlot();
        end
        function onStop2Change(this, src, evt)
            this.msg('onStop2Change()');
            cField = this.deviceField(this.uipDevice2.val());
            this.stStartStopStepsStore2.(cField).stop = src.val();
            this.resetPlot();
        end
        function onSteps2Change(this, src, evt)
            this.msg('onSteps2Change()');
            cField = this.deviceField(this.uipDevice2.val());
            this.stStartStopStepsStore2.(cField).steps = src.val();
            this.resetPlot();
        end
                        
        % Update start1, stop1, steps1 to last used values for the selected
        % device
        function updateStartStopSteps1(this)
            this.msg('updateStartStopSteps1()');
            cField = this.deviceField(this.uipDevice1.val());
            this.uieStart1.setValWithoutNotify(this.stStartStopStepsStore1.(cField).start);
            this.uieStop1.setValWithoutNotify(this.stStartStopStepsStore1.(cField).stop);
            this.uieSteps1.setVal(this.stStartStopStepsStore1.(cField).steps);
        end
        % Update start2, stop2, steps2 to last used values  for the selected
        % device
        function updateStartStopSteps2(this)
            this.msg('updateStartStopSteps2()');
            cField = this.deviceField(this.uipDevice2.val());
            this.uieStart2.setValWithoutNotify(this.stStartStopStepsStore2.(cField).start);
            this.uieStop2.setValWithoutNotify(this.stStartStopStepsStore2.(cField).stop);
            this.uieSteps2.setVal(this.stStartStopStepsStore2.(cField).steps);
        end
        
        function updateUnit1(this)
        %updateUnit1 Set uitxUnit1 to the display unit(s) of whatever 
        %device(s) is selected.  Special case for mask t, det 2t
        %   see also: updateUnit2
        
            switch this.uipDevice1.val()
                case this.cDeviceTime
                    this.uitxUnit1.cVal = 's';
                case this.cDeviceMaskTDet2T
                    this.uitxUnit1.cVal = sprintf(...
                        '%s, %s', ...
                        this.stHio.(this.cFieldMaskT).hio.unit().name, ...
                        this.stHio.(this.cFieldDetT).hio.unit().name ...
                    );
                otherwise
                    cField = this.deviceField(this.uipDevice1.val());
                    this.uitxUnit1.cVal = this.stHio.(cField).hio.unit().name;
            end
        end
        
        
        function updateUnit2(this)
        %updateUnit2 Set uitxUnit2 to the display unit(s) of whatever 
        %device(s) is selected.  Special case for mask t, det 2t
        %   see also: updateUnit1
        
            switch this.uipDevice2.val()
                case this.cDeviceTime
                    this.uitxUnit2.cVal = 's';
                case this.cDeviceMaskTDet2T
                    this.uitxUnit2.cVal = sprintf(...
                        '%s, %s', ...
                        this.stHio.(this.cFieldMaskT).hio.unit().name, ...
                        this.stHio.(this.cFieldDetT).hio.unit().name ...
                    );
                otherwise
                    cField = this.deviceField(this.uipDevice2.val());
                    this.uitxUnit2.cVal = this.stHio.(cField).hio.unit().name;
            end
        end
        
        function [stRecipe, lError] = buildRecipeFromFile(this, cPath)
           
            cMsg = sprintf('buildRecipeFromFile: %s', cPath);
            this.msg(cMsg);
            
            
            lError = false;
            
            if strcmp('', cPath) || ...
                isempty(cPath)
                % Has not been set
                lError = true;
                stRecipe = struct();
                return;
            end
                        
            if exist(cPath, 'file') ~= 2
                % File doesn't exist
                lError = true;
                stRecipe = struct();
                
                cMsg = sprintf(...
                    'The recipe file %s does not exist.', ...
                    cPath ...
                );
                cTitle = sprintf('Error reading recipe');
                msgbox(cMsg, cTitle, 'warn')
                
                return;
            end
            
            % File exists
            
            cStatus = this.uitxStatus.cVal;
            this.uitxStatus.cVal = 'Reading recipe ...';
            drawnow;
            
            stRecipe = loadjson(cPath);
            
            this.uitxStatus.cVal = cStatus;
            
            if ~this.validateRecipe(stRecipe)
                lError = true;
                return;
            end

        end
        
        function resetPlot(this)
            
            this.msg('resetPlot()');
            
            switch this.uipType.val()
                case this.cTypeOneDevice
                    
                    this.msg(sprintf('resetPlot() case: %s', this.cTypeOneDevice));
                    dValues = linspace(...
                        this.uieStart1.val(), ...
                        this.uieStop1.val(), ...
                        this.uieSteps1.val() + 1 ...
                    );
                    this.d1DResultParam = dValues;
                    this.d1DResultIDet = zeros(size(dValues));    
                    this.d1DResultIZero = zeros(size(dValues));
                    
                case this.cTypeTwoDevice
                    
                     this.msg(sprintf('resetPlot() case: %s', this.cTypeTwoDevice));
                     
                    % 1st dimension values            
                    dValues = linspace(...
                        this.uieStart1.val(), ...
                        this.uieStop1.val(), ...
                        this.uieSteps1.val() + 1 ...
                    );

                    % 2nd dimension values
                    dValues2 = linspace(...
                        this.uieStart2.val(), ...
                        this.uieStop2.val(), ...
                        this.uieSteps2.val() + 1 ...
                    );
                
                    % Initialize storage for the current scan on the 2nd dimension
                    % for the 1D plot on the left
                    
                    this.d1DResultParam = dValues2;
                    this.d1DResultIDet = zeros(size(dValues2));    
                    this.d1DResultIZero = zeros(size(dValues2));

                    % Initialize result storage for x, y, z mesh plotting
                    % Each 1D scan is a col of the matrix so the number of rows is
                    % the number of steps of the 2nd dimension. 
                    
                    [this.d2DResultParam1, this.d2DResultParam2] = meshgrid(dValues, dValues2);                               
                    this.d2DResultIDet = zeros(this.uieSteps2.val() + 1, this.uieSteps1.val() + 1);             
                    this.d2DResultIZero =  zeros(this.uieSteps2.val() + 1, this.uieSteps1.val() + 1);

                case this.cTypeScript
                    
                     this.msg(sprintf('resetPlot() case: %s', this.cTypeScript));
                    % Here we can't rely on the UI elements to give us
                    % information.  Need to load the recipe
                    
                    % Build a temporary recipe from the file for plotting 
                    [stRecipe, lError] = this.buildRecipeFromFile(this.cPathRecipe); 
                    
                    if ~lError
                        dNum = length(stRecipe.values); 
                        this.d1DResultParam = 1 : 1 : dNum;
                        this.d1DResultIDet = zeros(1, dNum);    
                        this.d1DResultIZero = zeros(1, dNum); 
                    else 
                        this.d1DResultParam = 0;
                        this.d1DResultIDet = 0;    
                        this.d1DResultIZero = 0; 
                    end
                    
                case this.cTypeLive
                    
                    this.msg(sprintf('resetPlot() case: %s', this.cTypeLive));
                    this.d1DResultParam = [];
                    this.d1DResultIDet = [];    
                    this.d1DResultIZero = [];
                    
                       
            end
            
            this.msg('resetPlot() calling updatePlot()');
            
            this.updateAxes1DXLimits();
            this.updateAxes2D1XLimits();
            this.updatePlot(this.getSystemUnits());

        end
        
        
        function lOut = validateRecipe(this, stRecipe)
        %VALIDATERECIPE validates a recipe structure.  See StateScan.  I
        %suppose StateScan could be responsible for doing this.
        
            lOut = true;
            
            %{
            cMsg = 'The script (.json) that you selected could not be parsed correctly.';
            cTitle = sprintf('Invalid .json script');
            msgbox(cMsg, cTitle, 'warn')
            %}
            
        end
        
        function onChooseRecipePress(this, src, evt)
           
            this.msg('onChooseRecipePress()');
                        
            [cName, cPath] = uigetfile(...
                '.json',...
                'Please choose a script', ...
                this.cDirSave ...
            );
        
            if isequal(cName,0)
               this.msg('onChooseRecipePress() user clicked "cancel".');
               return; % User clicked "cancel"
            end
            
            % Parse the recipe JSON file and validate
            
            cPathTemp = fullfile(cPath, cName);
            this.msg(sprintf('onChooseRecipePress() selected %s', cPathTemp));
            
            [stRecipe, lError] = this.buildRecipeFromFile(cPathTemp); 
                    
            if lError
                % Throw a message and return;
                return;
            end
              
            % Recipe file has been validated, can now update
            % cPathRecipeUser to the valid recipe path
            
            this.cPathRecipeUser = cPathTemp;
            this.cPathRecipe = cPathTemp;
            
            % This is the only place in the code that uitxRecipe is set
            
            this.uitxRecipe.setTooltip(this.cPathRecipe);
            this.uitxRecipe.cVal = MicUtils.truncate(this.cPathRecipe, 40, true);
            
            % Want to show the open button if 
            this.uibOpenRecipe.show();
            this.uitPlay.enable();
                    
            % Reset the plot
            this.resetPlot();
            
            
        end
        
        function onOpenRecipePress(this, src, evt)
            open(this.cPathRecipeUser);
        end
        
        function addDevice1Listeners(this)
            
            this.lhOnDevice1Change = addlistener(this.uipDevice1, 'eChange', @this.onDevice1Change);
            this.lhOnStart1Change = addlistener(this.uieStart1, 'eChange', @this.onStart1Change);
            this.lhOnStop1Change = addlistener(this.uieStop1, 'eChange', @this.onStop1Change);
            this.lhOnSteps1Change = addlistener(this.uieSteps1, 'eChange', @this.onSteps1Change);            
        end
        
        function removeDevice1Listeners(this)
           
            delete(this.lhOnDevice1Change);
            delete(this.lhOnStart1Change);
            delete(this.lhOnStop1Change);
            delete(this.lhOnSteps1Change);
        end
        
        function addDevice2Listeners(this)
            this.lhOnDevice2Change = addlistener(this.uipDevice2, 'eChange', @this.onDevice2Change);
            this.lhOnStart2Change = addlistener(this.uieStart2, 'eChange', @this.onStart2Change);
            this.lhOnStop2Change = addlistener(this.uieStop2, 'eChange', @this.onStop2Change);
            this.lhOnSteps2Change = addlistener(this.uieSteps2, 'eChange', @this.onSteps2Change);
        end
        
        function removeDevice2Listeners(this)
            delete(this.lhOnDevice2Change);
            delete(this.lhOnStart2Change);
            delete(this.lhOnStop2Change);
            delete(this.lhOnSteps2Change);
        end
        
        
        function buildPanelSettings(this)
            
             this.hPanelSettings = uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'Title', 'Settings', ...
                'Position', MicUtils.lt2lb([this.dWidthPad this.dWidthPad this.dWidthSettings this.dHeightSettings], this.hFigure) ...
            );
        
            dLeft = 20;
            dTop = 20;
            
            this.uitxDirLabel.build(...
                this.hPanelSettings, ...
                dLeft, ... % left
                dTop, ... % top
                20, ... % width
                20 ... % height
            );
        
            this.uitxDir.build(...
                this.hPanelSettings, ...
                dLeft + 20, ... % left
                dTop, ... % top
                this.dWidthDir, ... % width
                20 ... % height
            );
        
            this.uibChooseDir.build(...
                this.hPanelSettings, ...
                dLeft, ...
                dTop + 14, ...
                55, ...
                this.dHeightButton ...
            );
            dLeft = dLeft + this.dWidthDir;
            
            
            this.uieOperator.build(...
                this.hPanelSettings, ...
                dLeft, ... % left
                dTop, ... % top
                this.dWidthOperator, ... % width
                this.dHeightEdit ... % height
            );
            dLeft = dLeft + this.dWidthOperator + this.dWidthEditSep;
            
            this.uieMeta.build(...
                this.hPanelSettings, ...
                dLeft, ... % left
                dTop, ... % top
                this.dWidthMeta, ... % width
                this.dHeightEdit ... % height
            );
            dLeft = dLeft + this.dWidthMeta + this.dWidthEditSep;
            
            
            this.uieSettle.build(...
                this.hPanelSettings, ...
                dLeft, ... % left
                dTop, ... % top
                this.dWidthSettle, ... % width
                this.dHeightEdit ... % height
            );
            dLeft = dLeft + this.dWidthSettle + this.dWidthEditSep;
                        
        
            this.updateDirLabel();
            this.uibChooseDir.setTooltip(this.cTooltipChooseDir);
            this.uieOperator.setTooltip(this.cTooltipOperator);
            this.uieMeta.setTooltip(this.cTooltipMeta);
            this.uieSettle.setTooltip(this.cTooltipSettle);
            
        end
        
        
        function buildPanelScan(this)
            
            this.hPanelScan =  uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'Title', 'Scan', ...
                'Position', MicUtils.lt2lb([this.dWidthPad this.dHeightSettings + 20 this.dWidthScan this.dHeightScan], this.hFigure) ...
            );
            % 'BackgroundColor', [1 1 1], ...

            
            dShift = 10;
            dLeftCol1 = 10 + dShift;
            dLeftCol2 = 130 + dShift;
            dLeftCol3 = 255 + dShift;
            dLeftCol4 = 515 + dShift;
            dLeftCol5 = 600 + dShift;
            
            dLeft = dLeftCol1;
            dVSep = 30;
            dHSep = 10;
            
        
            dTop = 20;
            this.uipType.build(...
                this.hPanelScan, ...
                dLeft, ...
                dTop, ...
                100, 30 ...
            );
        
        
            % Unit label
            
            this.uitxUnitLabel.build(...
                this.hPanelScan, ...
                dLeftCol3, ...
                dTop, ...
                this.dWidthEdit, ...
                this.dHeightEdit ...
            );
            
            % 1st dimension config
            
            
            dLeft = dLeftCol2;
            dWidthPulldown = 120;
            dWidthHioUnit = 70;
            
            this.uipDevice1.build(...
                this.hPanelScan, ...
                dLeft, ...
                dTop, ...
                dWidthPulldown, 30 ...
            );
        
            dLeft = dLeftCol3;
            
            this.uitxUnit1.build(...
                this.hPanelScan, ...
                dLeft, ...
                dTop + 18, ...
                this.dWidthEdit, ...
                this.dHeightEdit ...
            );
        
            dLeft = dLeftCol3 + dWidthHioUnit;
            
            this.uieStart1.build(...
                this.hPanelScan, ...
                dLeft + 0 * (this.dWidthEdit + dHSep), ...
                dTop, ...
                this.dWidthEdit, this.dHeightEdit ...
            );
            this.uieStop1.build(...
                this.hPanelScan, ...
                dLeft + 1 * (this.dWidthEdit + dHSep), ...
                dTop, ...
                this.dWidthEdit, this.dHeightEdit ...
            );
            this.uieSteps1.build(...
                this.hPanelScan, ...
                dLeft + 2 * (this.dWidthEdit + dHSep), ...
                dTop, ...
                this.dWidthEdit, this.dHeightEdit ...
            );
            
            
            % 2nd dimension config
            
            dTop = 60;
            dLeft = dLeftCol2;
            
            this.uipDevice2.build(this.hPanelScan, ...
                dLeft, ...
                dTop, ...
                dWidthPulldown, 30 ...
            );
        
            this.uibSwap.build(this.hPanelScan, ...
                dLeft - 20, ...
                dTop, ...
                20, ...
                20 ...
            );
        
            dLeft = dLeftCol3;
            
            this.uitxUnit2.build(...
                this.hPanelScan, ...
                dLeft , ...
                dTop + 3, ...
                this.dWidthEdit, ...
                this.dHeightEdit ...
            );
            
            dLeft = dLeftCol3 + dWidthHioUnit;
            
            this.uieStart2.build(...
                this.hPanelScan, ...
                dLeft + 0 * (this.dWidthEdit + dHSep), ...
                dTop, ...
                this.dWidthEdit, this.dHeightEdit ...
            );
            this.uieStop2.build(...
                this.hPanelScan, ...
                dLeft + 1 * (this.dWidthEdit + dHSep), ...
                dTop, ...
                this.dWidthEdit, this.dHeightEdit ...
            );
            this.uieSteps2.build(...
                this.hPanelScan, ...
                dLeft + 2 * (this.dWidthEdit + dHSep), ...
                dTop, ...
                this.dWidthEdit, this.dHeightEdit ...
            );
        
        
            this.hideDevice2UI();
        
            % Choose File
            
            dTop = 35;
            
            this.uibChooseRecipe.build(...
                this.hPanelScan, ...
                dLeftCol2, ...
                dTop, ...
                100, ...
                this.dHeightButton ...
            );
        
            this.uitxRecipe.build(...
                this.hPanelScan, ...
                dLeftCol2 + 110, ...
                dTop + (this.dHeightButton - this.dHeightText)/2, ...
                250, ...
                this.dHeightText ...
            );
        
            this.uibOpenRecipe.build(...
                this.hPanelScan, ...
                dLeftCol2, ...
                dTop + 30, ...
                100, ...
                this.dHeightButton ...
            );
        
            this.uibChooseRecipe.hide();
            this.uitxRecipe.hide();
            this.uibOpenRecipe.hide();
            
            
            % Play and Abort buttons
            dLeft = dLeftCol4;
            
            dTop = 30;
            
            this.uitPlay.build(this.hPanelScan, ...
                dLeft, ...
                dTop, ...
                this.dWidthPlay, ...
                this.dHeightButton ...
            );
        
            this.uibCancel.build(this.hPanelScan, ...
                dLeft, ...
                dTop + 30, ...
                this.dWidthPlay, ...
                this.dHeightButton ...
            );
            this.uibCancel.hide();
            
            % Progress Bar

            %{
            this.pb.build(...
                this.hPanelScan, ...
                0, ...
                140 ...
            );
            %}
            % this.pb.hide();
            
            dTop = 20;
            dHeight = 15;
            
            dWidthLabel = 90;
            dWidthValue = 100;
            
            dLeftLabels = dLeftCol5;
            dLeftValue = dLeftLabels + dWidthLabel;
            
            this.uitxLabelStatus.build(this.hPanelScan, dLeftLabels,dTop, dWidthLabel, dHeight);
            this.uitxStatus.build(this.hPanelScan, dLeftValue, dTop, dWidthValue, dHeight);
            dTop = dTop + dHeight;
            
            %{
            this.uitxLabelProgress.build(this.hPanelScan, dLeftLabels,dTop, dWidthLabel, dHeight);
            this.uitxProgress.build(this.hPanelScan, dLeftValue, dTop, dWidthValue, dHeight);
            dTop = dTop + dHeight;
            %}
            
            this.uitxLabelTimeElapsed.build(this.hPanelScan, dLeftLabels, dTop, dWidthLabel, dHeight);            
            this.uitxTimeElapsed.build(this.hPanelScan, dLeftValue, dTop, dWidthValue, dHeight);
            dTop = dTop + dHeight;
            
            this.uitxLabelTimeRemaining.build(this.hPanelScan, dLeftLabels, dTop, dWidthLabel, dHeight);
            this.uitxTimeRemaining.build(this.hPanelScan, dLeftValue, dTop, dWidthValue, dHeight);
            dTop = dTop + dHeight;            
           
            this.uitxLabelTimeComplete.build(this.hPanelScan, dLeftLabels, dTop, dWidthLabel, dHeight);
            this.uitxTimeComplete.build(this.hPanelScan, dLeftValue, dTop, dWidthValue, dHeight);
            dTop = dTop + dHeight;                        
            
            dTop = 70; % reset
            dLeft = 600;
            dWidth = 55;
            
            this.uibSwap.setTooltip(this.cTooltipSwap);
            this.uitPlay.setTooltip(this.cTooltipScanStart);
            this.uibCancel.setTooltip(this.cTooltipScanAbort);
            
            % Set uipType to its current value to force the
            % onTypeChange listener sequence to fire off and update the
            % panels / plots
            
            this.uipType.u8Selected = this.uipType.u8Selected;

        end
        
        function buildPanelPlotTools(this)
            
            dColorBg = [1 1 1];
            dColorBgText = [1 1 1];
            
            % 'Title', 'Results (1D Scan)',...
            % 'BackgroundColor', dColorBg, ...

            dLeft = this.dWidthPad;
            dHeightTop = this.dHeightScan + this.dHeightSettings + 30 + this.dHeightResult;
            dWidthPanel = this.dWidthScan;
            this.hPanelPlotTools =  uipanel(...
                'Parent', this.hFigure,...
                'Title', 'Plot Tools', ...
                'Units', 'pixels',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'Position', MicUtils.lt2lb([dLeft dHeightTop dWidthPanel this.dHeightPanelPlotTools], this.hFigure) ...
            );
        
            dLeft = 10;
            dTop = 20;
            
            dPad = 10;
            dWidth = 110;
            
            this.uipPlotDataType.build(this.hPanelPlotTools, dLeft, dTop, dWidth, 24);
            dLeft = dLeft + dWidth + dPad;
            
            %{
            this.uitxPlotTypeLabel.build(...
                this.hPanelPlotTools, ...
                dLeft, ...
                dTop + 4, ...
                dWidth, ...
                16 ...
            );
            this.uitxPlotTypeLabel.setBackgroundColor(dColorBgText);
            
            dLeft = dLeft + dWidth;
        
            dWidth = 40;
            this.uitPlotType.build(this.hPanelPlotTools, dLeft, dTop, dWidth, this.dWidthBtn);
            dLeft = dLeft + dWidth + dPad;
            %}
            
            this.uipPlotYScaleType.build(this.hPanelPlotTools, dLeft, dTop, dWidth, 24);
            dLeft = dLeft + dWidth + dPad;
            
            this.uipPlotYLimitType.build(this.hPanelPlotTools, dLeft, dTop, dWidth, 24)
            dLeft = dLeft + dWidth + dPad;
            
            dWidth = 50;
            this.uipPlotYLimitMin.build(this.hPanelPlotTools, dLeft, dTop, dWidth, 24);
            dLeft = dLeft + dWidth + dPad;
            
            this.uiePlotYLimitMax.build(this.hPanelPlotTools, dLeft, dTop, dWidth, 24);
            dLeft = dLeft + dWidth + dPad;
            
            % x, y active value
            
            dLeft = dLeft + 100;
            dTop = 30;
            dWidth = 90;   
            this.uitxPlotX.build(...
                this.hPanelPlotTools, ...
                dLeft, ...
                dTop, ...
                dWidth, ...
                16 ...
            );
            %this.uitxPlotX.setBackgroundColor(dColorBgText);
        
            dTop = dTop + 10;
            this.uitxPlotY.build(...
                this.hPanelPlotTools, ...
                dLeft, ...
                dTop, ...
                dWidth, ...
                16 ...
            );
        
            dLeft = dLeft + 100;
        
            dTop = 30;
            this.uitxPlotIDetColor.build(...
                this.hPanelPlotTools, ...
                dLeft, ...
                dTop, ...
                dWidth, ...
                16 ...
            );
            this.uitxPlotIDetColor.setColor([1 0 0]);
            
            dTop = dTop + 10;
            this.uitxPlotIZeroColor.build(...
               this.hPanelPlotTools, ...
                dLeft, ...
                dTop, ...
                dWidth, ...
                16 ...
            );
            this.uitxPlotIZeroColor.setColor([0 0 1]);
        end
        
        
        function buildPanelResult(this)
            
            % 1D panel and axes
            dLeft = this.dWidthPad;
            dWidthPad = 0;
            dWidthPanel = this.dWidthScan; % this.dWidth - 2 * dWidthPad
            dHeightTop = this.dHeightScan + this.dHeightSettings + 20;
                        
            dColorBg = [hex2dec('d6') hex2dec('d6') hex2dec('d6')]/255;
            dColorBg = [1 1 1];
            
            % 'Title', 'Results (1D Scan)',...
            % 'BackgroundColor', dColorBg, ...

            
            this.hPanelResult1D =  uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'BackgroundColor', dColorBg, ...
                'Position', MicUtils.lt2lb([dLeft dHeightTop dWidthPanel this.dHeightResult], this.hFigure) ...
            );
        
            % 'Title', 'Results (2D Scan)',...
%                 'BackgroundColor', dColorBg, ...

            this.hPanelResult2D =  uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Clipping', 'on',...
                'Visible', 'off', ...
                'BorderWidth', this.dWidthPanelBorder, ...
                'BackgroundColor', dColorBg, ...
                'Position', MicUtils.lt2lb([dLeft dHeightTop dWidthPanel this.dHeightResult], this.hFigure) ...
            );
            
               
            dWidthPadL = 60;
            dWidthPadR = 40;
            dWidth = dWidthPanel - dWidthPadL - dWidthPadR;
            dTop = 20;
            dHeight = this.dHeightResult - dTop - 50;
            
            this.hAxes1D = axes(...
                'Parent', this.hPanelResult1D,...
                'Units', 'pixels',...
                'Position',MicUtils.lt2lb([dWidthPadL, dTop, dWidth, dHeight], this.hPanelResult1D),...
                'XColor', [0 0 0],...
                'YColor', [0 0 0],...
                'FontSize', this.dSizeFont, ...
                'HandleVisibility', 'on', ...
                'XMinorTick','on', ...
                'YMinorTick','on', ...
                'XMinorGrid','on', ...
                'YMinorGrid','on', ...
                'XGrid','on', ...
                'YGrid','on', ... 
                'NextPlot', 'add', ... % Important.  Look this up in help makes it so 
                'ButtonDownFcn', 'disp(''Axes click!'')' ...
            ); 
            % hold(this.hAxes1D, 'on');
        
            % 2D panel and axes
            
            dWidthPadL2 = 70;
            dWidth = (dWidthPanel - dWidthPadL - dWidthPadL2 - dWidthPadR)/2;
            
        
            this.hAxes2D1 = axes(...
                'Parent', this.hPanelResult2D,...
                'Units', 'pixels',...
                'Position',MicUtils.lt2lb([dWidthPadL,  dTop, dWidth, dHeight], this.hPanelResult2D),...
                'XColor', [0 0 0],...
                'YColor', [0 0 0],...
                'FontSize', this.dSizeFont, ...
                'XMinorTick','on', ...
                'YMinorTick','on', ...
                'XMinorGrid','on', ...
                'YMinorGrid','on', ...
                'XGrid','on', ...
                'YGrid','on', ...
                'HandleVisibility','on'...
            ); 
            hold(this.hAxes2D1, 'on');

        
            this.hAxes2D2 = axes(...
                'Parent', this.hPanelResult2D,...
                'Units', 'pixels',...
                'Position',MicUtils.lt2lb([dWidthPadL + dWidth + dWidthPadL2,  dTop, dWidth, dHeight], this.hPanelResult2D),...
                'XColor', [0 0 0],...
                'YColor', [0 0 0],...
                'View', [45 30], ... % Azimuth, Elevation (for 3D view angle)
                'FontSize', this.dSizeFont, ...
                'HandleVisibility','on'...
            );
        
            % Setting font size above is not working
            set(this.hAxes2D2,'FontSize', this.dSizeFont);
            rotate3d(this.hAxes2D2); 
            
            drawnow;
            
            % this.updatePlot();
            this.updatePlot(this.getSystemUnits());

            
        end
        
        function buildPanelPicoammeter(this)
           
            dPos = MicUtils.lt2lb(...
                [...
                    this.dWidthScan + 20 ...
                    10 + this.dHeightPanelMono + 10 + this.dHeightPanelStages  + 10 ...
                    this.dWidthPanelPicoammeter ...
                    this.dHeightPanelPicoammeter ...
                ], ...
                this.hFigure ...
            );
        
            this.hPanelPicoammeter =  uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Title', 'Keithley 6482',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'Position', dPos ...
            );
            
            this.keithley.build(this.hPanelPicoammeter, 0, 10);
            
        end
        
        function buildPanelMono(this)
            
            dPos = MicUtils.lt2lb(...
                [...
                    this.dWidthScan + 20  ... % l
                    10 ... % t
                    this.dWidthPanelMono ... % w
                    this.dHeightPanelMono ... % h
                ], ...
                this.hFigure ...
            );
        
            this.hPanelMono =  uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Title', 'Monochromator',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'BackgroundColor', this.dColorBgStages, ...
                'Position', dPos ...
            );
        
            dLeft = 10;
            dTop = 20 + this.dHeightHioLabels;
            dVSep = 25;
            
            dN = 0;
            this.hioMono.build(this.hPanelMono, dLeft, dTop + dN * this.dHeightHio - this.dHeightHioLabels);
            
            % Hack to place over the "stores" location of hioMono
            this.hioGrating.build(this.hPanelMono, 340, dTop + dN * this.dHeightHio);
            %{
            dN = dN + 1;
            this.hioGrating.build(this.hPanelMono, dLeft, dTop + dN * this.dHeightHio);
            %}
            
        end
        
        function buildPanelStages(this)
            
            dPos = MicUtils.lt2lb(...
                [...
                    this.dWidthScan + 20  ... % l
                    10 + this.dHeightPanelMono + 10 ... % t
                    this.dWidthPanelStages ... % w
                    this.dHeightPanelStages ... % h
                ], ...
                this.hFigure ...
            );
        
            this.hPanelStages =  uipanel(...
                'Parent', this.hFigure,...
                'Units', 'pixels',...
                'Title', 'Reflectometer',...
                'Clipping', 'on',...
                'BorderWidth', this.dWidthPanelBorder, ...
                'BackgroundColor', this.dColorBgStages, ...
                'Position', dPos ...
            );
        
            dLeft = 10;
            dTop = 20 + this.dHeightHioLabels;
            
            dN = 0;
            this.hioMaskX.build(this.hPanelStages, dLeft, dTop - this.dHeightHioLabels + dN * this.dHeightHio);
            dN = dN + 1;
            this.hioMaskY.build(this.hPanelStages, dLeft, dTop + dN * this.dHeightHio);
            dN = dN + 1;
            this.hioMaskZ.build(this.hPanelStages, dLeft, dTop + dN * this.dHeightHio);
            dN = dN + 1;
            this.hioMaskT.build(this.hPanelStages, dLeft, dTop + dN * this.dHeightHio);
            dN = dN + 1;
            this.hioDetX.build(this.hPanelStages, dLeft, dTop + dN * this.dHeightHio);
            dN = dN + 1;
            this.hioDetT.build(this.hPanelStages, dLeft, dTop + dN * this.dHeightHio);
            dN = dN + 1;
            this.hioFilterY.build(this.hPanelStages, dLeft, dTop + dN * this.dHeightHio);
            dN = dN + 1;
            
            dWidth = 120;
            this.uibLoadLock.build(this.hPanelStages, ...
                dLeft, ...
                dTop + dN * this.dHeightHio + 5, ...
                dWidth, ...
                this.dHeightButton ...
            );
            this.uibLoadLock.setTooltip('Send maskX,Y,Z,T to load lock state');

            this.uibLoadLockSave.build(this.hPanelStages, ...
                dLeft + dWidth + 10, ...
                dTop + dN * this.dHeightHio + 5, ...
                dWidth, ...
                this.dHeightButton ...
            ); 
            
            
            this.uibLoadLockSave.setTooltip('Save current maskX,Y,Z,T raw values as load lock state');
        end
        

        
        function buildConnectAll(this)
            
            dLeft = this.dWidthScan + 20;
            dTop = 430;
            
            this.uitStageApi.build(this.hFigure, dLeft, dTop, 120, this.dWidthBtn);
            
            % this.uitxLabelStagesApi.build(this.hPanel, dLeft, 6 + dTop, 50, 12);
            % dLeft = dLeft + 50;
            
        end
        
        function setApis(this)
            

            this.msg('setApis() RETURNING NOT SETTING DEVICES !!!!');
            return
            
            
            % Temporarily set all Apis to virtual Apis
            
            %{
            % HIOs
            ceNames = fieldnames(this.stHio);
            for n = 1:length(ceNames)
                cName = sprintf('%s-real', this.stHio.(ceNames{n}).hio.cName);
                this.stHio.(ceNames{n}).hio.setApi(ApivHardwareIOPlus(cName, 0, this.clock));
            end
            %}
            
            % Java hardware
            deviceSins = nus.sins2.Sins2Instruments();
            deviceMaskX = deviceSins.getMaskX(); 
            deviceMaskY = deviceSins.getMaskY();
            deviceMaskZ = deviceSins.getMaskZ();
            deviceMaskT = deviceSins.getMaskT();
            deviceDetX = deviceSins.getDetectorX(); 
            deviceDetT = deviceSins.getDetectorT();
            deviceFilterY = deviceSins.getFilterStage();
            deviceKeithley = ApiKeithley6482();
            
            % Keithley 
            this.keithley.setApi(deviceKeithley);
            
            
            % Mono, Filter Y special case for now FIX ME
            % this.stHio.(this.cFieldMono).hio.setApi(ApivHardwareIOPlus('mono-real', 0, this.clock));
            % this.stHio.(this.cFieldFilterY).hio.setApi(ApivHardwareIOPlus('filter-y-real', 0, this.clock));
              
            this.stHio.(this.cFieldMono).hio.setApi(sins.mono.ApiHardwareIOPlusFromMono('wav'));
            this.stHio.(this.cFieldGrating).hio.setApi(sins.mono.ApiHardwareIOPlusFromMono('grating'));
            this.stHio.(this.cFieldMaskX).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceMaskX))
            this.stHio.(this.cFieldMaskY).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceMaskY))
            this.stHio.(this.cFieldMaskZ).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceMaskZ))
            this.stHio.(this.cFieldMaskT).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceMaskT))
            this.stHio.(this.cFieldDetX).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceDetX))
            this.stHio.(this.cFieldDetT).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceDetT))
            this.stHio.(this.cFieldFilterY).hio.setApi(sins.axis.ApiHardwareIOPlusFromAxis(deviceFilterY))
            
            
            
        end
          
        function initPlotTools(this)
            
            this.msg('initPlotTools');
            
            
            this.uipPlotDataType = UIPopup( ...
                {this.cPlotDataTypeCombined, this.cPlotDataTypeIDet, this.cPlotDataTypeI0}, ...
                'Data (1D)', ...
                true...
            );
            
            
            this.uipPlotYScaleType = UIPopup( ...
                {this.cPlotYScaleTypeLinear, this.cPlotYScaleTypeLog}, ...
                'Y Scale', ...
                true...
            );
        
            this.uitxPlotTypeLabel = UIText('y-axis:');
            this.uitxPlotX = UIText('x: [hover]');
            this.uitxPlotY = UIText('y: [hover]');
            
            this.uitxPlotIDetColor = UIText('Idet');
            this.uitxPlotIZeroColor = UIText('Izero');
            
            this.uitPlotType = UIToggle( ...
                'Lin', ...   % (off) not active
                'Log' ...  % (on) active
            );
        
            
            this.uipPlotYLimitType = UIPopup( ...
                {this.cPlotYLimitTypeAuto, this.cPlotYLimitTypeManual}, ...
                'Y Limits', ...
                true...
            );
        
            this.uipPlotYLimitMin = UIEdit('Min', 'd', true, 'left');
            this.uiePlotYLimitMax = UIEdit('Max', 'd', true, 'left');
        
            this.uitPlotType.setTooltip(this.cTooltipPlotTypeLin);
            addlistener(this.uitPlotType, 'eChange', @this.onPlotTypeChange);
            
            addlistener(this.uipPlotDataType, 'eChange', @this.onPlotDataTypeChange);

            
            addlistener(this.uipPlotYScaleType, 'eChange', @this.onPlotYScaleTypeChange);
            
            addlistener(this.uipPlotYLimitType, 'eChange', @this.onPlotYLimitTypeChange);
            addlistener(this.uipPlotYLimitMin, 'eChange', @this.onPlotYLimitMinChange);
            addlistener(this.uiePlotYLimitMax, 'eChange', @this.onPlotYLimitMaxChange);
            
            % this.onPlotYLimitTypeChange();
            
        end
        
        function initConnectAll(this)
            
            st1 = struct();
            st1.lAsk        = true;
            st1.cTitle      = 'Switch?';
            st1.cQuestion   = 'Do you want to connect all hardware to the real Api?';
            st1.cAnswer1    = 'Yes.';
            st1.cAnswer2    = 'No not yet.';
            st1.cDefault    = st1.cAnswer2;

            st2 = struct();
            st2.lAsk        = true;
            st2.cTitle      = 'Switch?';
            st2.cQuestion   = 'Do you want to disconnect all hardware (go into virtual mode)?';
            st2.cAnswer1    = 'Yes of course!';
            st2.cAnswer2    = 'No not yet.';
            st2.cDefault    = st2.cAnswer2;

            this.uitStageApi = UIToggle( ...
                'Connect All', ...   % (off) not active
                'Disconnect All', ...  % (on) active
                false, ...
                [], ...
                [], ...
                st1, ...
                st2 ...
            );
        
            this.uitStageApi.setTooltip(this.cTooltipConnect);
            addlistener(this.uitStageApi, 'eChange', @this.onStageApiChange); 
            
        end
        
        
        function initHardwareUIMono(this)
            cPathConfigMono = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'mono.json' ...
            );
        
            cPathConfigGrating = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'grating.json' ...
            );
        
            configMono = ConfigHardwareIOPlus(cPathConfigMono);
            configGrating = ConfigHardwareIOPlus(cPathConfigGrating);
            
            
            % Mono
            this.hioMono = HardwareIOPlus(...
                'cName', 'wav', ...
                'cLabel', 'wav', ...
                'clock', this.clock, ...
                'config', configMono, ...
                'dColorBg', this.dColorBgStages, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthRange', this.dWidthHioRange, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthPadName', 29, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', false, ...
                'lShowInitState', false, ...
                'lShowStores', true, ...
                'lShowRange', true, ...
                'cLabelStores', 'Grating lines/mm', ...
                'fhValidateDest', @this.validateDest ... 
            );
            addlistener(this.hioMono, 'eTurnOn', @this.onHioMonoTurnOn);
            addlistener(this.hioMono, 'eTurnOff', @this.onHioMonoTurnOff);
            % Mono
            
             % 'dWidthPadStores', 177,  ...
                % 'dWidthPadUnit', 105, ...
                % 'dWidthPadName', 29, ...
            dWidthVal = 30;
            dWidthPadStores = 5;
            this.hioGrating = HardwareIOPlus(...
                'cName', 'grating', ...
                'cLabel', 'grating', ...
                'clock', this.clock, ...
                'config', configGrating, ...
                'dColorBg', this.dColorBgStages, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', dWidthVal, ...
                'dWidthPadStores', dWidthPadStores, ...
                'dWidthStores', this.dWidthHioStores - dWidthVal - dWidthPadStores, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowApi', false, ...
                'lShowName', false, ...
                'lShowLabels', false, ...
                'lShowDest', false, ...
                'lShowJog', false, ...
                'lShowStores', true, ...
                'lShowUnit', false, ...
                'lShowInitButton', false, ...
                'lShowInitState', false, ...
                'lShowZero', false, ...
                'lShowRel', false, ...
                'lShowPlay', false, ...
                'fhValidateDest', @this.validateDest ... 
            );
        end
        
                
        function initHardwareUIStages(this)
                                    
            
            cPathConfigMaskX = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'maskX.json' ...
            );
            
            cPathConfigMaskY = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'maskY.json' ...
            );
            cPathConfigMaskZ = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'maskZ.json' ...
            );
            
            cPathConfigMaskT = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'maskT.json' ...
            );
            cPathConfigDetX = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'detX.json' ...
            );
            cPathConfigDetT = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'detT.json' ...
            );
            
            cPathConfigFilterY = fullfile(...
                this.cDirApp, ...
                'config', ...
                'hiop', ...
                'filterY.json' ...
            );
            
            
            configMaskX = ConfigHardwareIOPlus(cPathConfigMaskX);
            configMaskY = ConfigHardwareIOPlus(cPathConfigMaskY);
            configMaskZ = ConfigHardwareIOPlus(cPathConfigMaskZ);
            configMaskT = ConfigHardwareIOPlus(cPathConfigMaskT);
            configDetX = ConfigHardwareIOPlus(cPathConfigDetX);
            configDetT = ConfigHardwareIOPlus(cPathConfigDetT);
            configFilterY = ConfigHardwareIOPlus(cPathConfigFilterY);
           
            
            % MaskX
            
            this.hioMaskX = HardwareIOPlus(...
                'cName', 'mask x', ...
                'cLabel', 'mask x', ...
                'clock', this.clock, ...
                'config', configMaskX, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ... 
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowLabels', true, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowRange', true, ...
                'lShowZero', true, ...
                'lShowRel', true ...
            ); 
            
            % MaskY
            
            this.hioMaskY = HardwareIOPlus(...
                'cName', 'mask y', ...
                'cLabel', 'mask y', ...
                'clock', this.clock, ...
                'config', configMaskY, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowLabels', false, ...
                'lShowZero', true, ...
                'lShowRange', true, ...
                'lShowRel', true ...
            );
            
            % MaskZ
            
            this.hioMaskZ = HardwareIOPlus(...
                'cName', 'mask z', ...
                'cLabel', 'mask z', ...
                'clock', this.clock, ...
                'config', configMaskZ, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowLabels', false, ...
                'lShowZero', true, ...
                'lShowRange', true, ...
                'lShowRel', true ...
            );
            
            % MaskT
            
            this.hioMaskT = HardwareIOPlus(...
                'cName', 'mask t', ...
                'cLabel', 'mask t', ...
                'clock', this.clock, ...
                'config', configMaskT, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowLabels', false, ...
                'lShowZero', true, ...
                'lShowRange', true, ...
                'lShowRel', true ...
            );
            
            % DetX
            
            this.hioDetX = HardwareIOPlus(...
                'cName', 'det x', ...
                'cLabel', 'det x', ...
                'clock', this.clock, ...
                'config', configDetX, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowLabels', false, ...
                'lShowZero', true, ...
                'lShowRange', true, ...
                'lShowRel', true ...
            );
            
            % DetT
            
            this.hioDetT = HardwareIOPlus(...
                'cName', 'det t', ...
                'cLabel', 'det t', ...
                'clock', this.clock, ...
                'config', configDetT, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowLabels', false, ...
                'lShowZero', true, ...
                'lShowRange', true, ...
                'lShowRel', true ...
            );
            
            % FilterY
            
            this.hioFilterY = HardwareIOPlus(...
                'cName', 'filter y', ...
                'cLabel', 'filter y', ...
                'clock', this.clock, ...
                'config', configFilterY, ...
                'dWidthName', this.dWidthHioName, ...
                'dWidthUnit', this.dWidthHioUnit, ...
                'dWidthVal', this.dWidthHioVal, ...
                'dWidthStores', this.dWidthHioStores, ...
                'dWidthRange', this.dWidthHioRange, ...
                'fhValidateDest', @this.validateDest, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'lShowInitButton', true, ...
                'lShowInitState', false, ...
                'lShowLabels', false, ...
                'lShowRange', true, ...
                'lShowZero', true, ...
                'lShowRel', true ...
            ); 

            
        end
        
        function initHioStruct(this)
            
            mono = struct();
            % mono.cName = 'mono';
            mono.hio = this.hioMono;
            mono.lMoveRequired = false;
            mono.lMoveIssued = false;
            
            % LEFT OFF HERE

            grating = struct();
            % mono.cName = 'mono';
            grating.hio = this.hioGrating;
            grating.lMoveRequired = false;
            grating.lMoveIssued = false;
            
            maskX = struct();
            % maskX.cName = 'maskX';
            maskX.hio = this.hioMaskX;
            maskX.lMoveRequired = false;
            maskX.lMoveIssued = false;
            
            maskY = struct();
            % maskY.cName = 'maskY';
            maskY.hio = this.hioMaskY;
            maskY.lMoveRequired = false;
            maskY.lMoveIssued = false;
            
            maskZ = struct();
            % maskZ.cName = 'maskZ';
            maskZ.hio = this.hioMaskZ;
            maskZ.lMoveRequired = false;
            maskZ.lMoveIssued = false;
            
            maskT = struct();
            % maskT.cName = 'maskT';
            maskT.hio = this.hioMaskT;
            maskT.lMoveRequired = false;
            maskT.lMoveIssued = false;
            
            detX = struct();
            % detX.cName = 'detX';
            detX.hio = this.hioDetX;
            detX.lMoveRequired = false;
            detX.lMoveIssued = false;
            
            detT = struct();
            % detT.cName = 'detT';
            detT.hio = this.hioDetT;
            detT.lMoveRequired = false;
            detT.lMoveIssued = false;
            
            filterY = struct();
            % filterY.cName = 'filterY';
            filterY.hio = this.hioFilterY;
            filterY.lMoveRequired = false;
            filterY.lMoveIssued = false;
            
            %{
            this.ceHIOs = {};
            this.ceHIOs{1} = mono;
            this.ceHIOs{2} = maskX;
            this.ceHIOs{3} = maskY;
            this.ceHIOs{4} = maskZ;
            this.ceHIOs{5} = maskT;
            this.ceHIOs{6} = detX;
            this.ceHIOs{7} = detT;
            this.ceHIOs{8} = filterY;
            %}
            
            this.stHio = struct();
            this.stHio.(this.cFieldMono) = mono;
            this.stHio.(this.cFieldGrating) = grating;
            this.stHio.(this.cFieldMaskX) = maskX;
            this.stHio.(this.cFieldMaskY) = maskY;
            this.stHio.(this.cFieldMaskZ) = maskZ;
            this.stHio.(this.cFieldMaskT) = maskT;
            this.stHio.(this.cFieldDetX) = detX;
            this.stHio.(this.cFieldDetT) = detT;
            this.stHio.(this.cFieldFilterY) = filterY;
            
        end
        
        function initHardwareUIKeithley(this)
            
            this.keithley = Keithley6482( ...
                'cName', 'keithley 6482', ...
                'clock', this.clock, ...
                'lAskOnApiClick', this.lHioAskOnApiClick, ...
                'dWidthPadData', 24, ...
                'dWidthName', 0, ...
                'lShowName', false, ...
                'lShowRange', false, ...
                'cLabelChannel1', 'channel 1', ...
                'cLabelChannel2', 'channel 2', ...
                'lShowSettings', false ...
            );
            
        end
        
        function initStartStopStepsStores(this)
                        
            this.initStartStopStepsStore1();
            this.initStartStopStepsStore2();
        end
                
        function initStartStopStepsStore1(this)
            
            this.stStartStopStepsStore1 = struct();
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMono)).start = 13.4;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMono)).stop = 13.6;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMono)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskX)).start = -5;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskX)).stop = 5;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskX)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskY)).start = -5;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskY)).stop = 5;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskY)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskZ)).start = -5;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskZ)).stop = 5;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskZ)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskT)).start = 10;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskT)).stop = 20;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskT)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceDetX)).start = 10;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceDetX)).stop = 20;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceDetX)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskT)).start = 20;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskT)).stop = 40;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskT)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceFilterY)).start = 0;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceFilterY)).stop = 20;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceFilterY)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskTDet2T)).start = 10;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskTDet2T)).stop = 20;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceMaskTDet2T)).steps = 11;
            
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceTime)).start = 0;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceTime)).stop = 60;
            this.stStartStopStepsStore1.(this.deviceField(this.cDeviceTime)).steps = 61;
            
        end
        
        
        function initStartStopStepsStore2(this)
            
            this.stStartStopStepsStore2 = struct();
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMono)).start = 13.4;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMono)).stop = 13.6;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMono)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskX)).start = -5;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskX)).stop = 5;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskX)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskY)).start = -5;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskY)).stop = 5;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskY)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskZ)).start = -5;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskZ)).stop = 5;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskZ)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskT)).start = 10;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskT)).stop = 20;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskT)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceDetX)).start = 10;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceDetX)).stop = 20;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceDetX)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskT)).start = 20;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskT)).stop = 40;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskT)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceFilterY)).start = 0;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceFilterY)).stop = 20;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceFilterY)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskTDet2T)).start = 10;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskTDet2T)).stop = 20;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceMaskTDet2T)).steps = 11;
            
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceTime)).start = 0;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceTime)).stop = 60;
            this.stStartStopStepsStore2.(this.deviceField(this.cDeviceTime)).steps = 61;
            
        end
        
        function initSettings(this)
            
            this.uibChooseDir = UIButton('Change');
            this.uitxDirLabel = UIText('Dir:');
            this.uitxDir = UIText('');
            this.uieOperator = UIEdit('Operator', 'c', true);
            this.uieMeta = UIEdit('Sample Metadata', 'c', true);
            this.uieSettle = UIEdit('Settle Time (s)', 'd', true);
            
            this.uieSettle.setVal(0);
            this.uieSettle.setMin(0);
        end
        
        
        function initDevices(this)
            
            return;
            
            this.msg('initDevices() connecting to hardware ...');
            this.deviceSins = nus.sins2.Sins2Instruments();
            this.deviceMaskX = this.deviceSins.getMaskX(); 
            this.deviceMaskY = this.deviceSins.getMaskY();
            this.deviceMaskZ = this.deviceSins.getMaskZ();
            this.deviceMaskT = this.deviceSins.getMaskT();
            this.deviceDetX = this.deviceSins.getDetectorX(); 
            this.deviceDetT = this.deviceSins.getDetectorT();
            this.deviceFilterY = this.deviceSins.getFilterStage();
            this.deviceKeithley = ApiKeithley6482();
            
        end
        
        function init(this)
            
            [cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));            

            this.cDirApp = fullfile(cDirThis, '..', '..', '..', '..');
            this.cDirSave = MicUtils.path2canonical(fullfile(this.cDirApp, 'scans'));
            
            this.initSettings();
                       
            this.cDirSaveState = fullfile( ...
                this.cDirApp, ...
                'save', ...
                'main' ...
            ); 
        
            
            this.initConnectAll();
            this.initPlotTools();
            
            this.initHardwareUIMono();
            this.initHardwareUIStages();
            this.initHardwareUIKeithley();
            this.initHioStruct();
            
            % this.initHardwareUI();
            
            this.initDevices();
            this.setApis();
                        
            this.uibLoadLock = UIButton('Sample -> LL');
            addlistener(this.uibLoadLock, 'ePress', @this.onLoadLockPress);
            
            this.uibLoadLockSave = UIButton('Save LL Pos');
            addlistener(this.uibLoadLockSave, 'eChange', @this.onLoadLockSavePress);
            
            this.uibChooseRecipe = UIButton('Choose Script');
            this.uibOpenRecipe = UIButton('Open Script');
            
            this.uitxRecipe = UIText('');
            
           
            
            this.uitPlay = UIToggle('Start', 'Pause');
            this.uibCancel = UIButton(...
                'Abort', ... % cLabel
                false, ... % lUseImg
                [], ... % u8Img
                true, ... % lAsk 
                'The scan is now paused.  Are you sure you want to abort?' ... % lMsg
            );
            
            this.uipType = UIPopup(...
                { ...
                    this.cTypeOneDevice, ...
                    this.cTypeTwoDevice, ...
                    this.cTypeScript, ...
                    this.cTypeLive, ...
                }, ...
                'Type', ...
                true ...
            );
        
            this.uipDevice1 = UIPopup(...
                { ...
                    this.cDeviceMono, ...
                    this.cDeviceMaskTDet2T, ...
                    this.cDeviceMaskX, ...
                    this.cDeviceMaskY, ...
                    this.cDeviceMaskZ, ...
                    this.cDeviceMaskT, ...
                    this.cDeviceDetX, ...
                    this.cDeviceDetT, ...
                    this.cDeviceFilterY, ...
                    this.cDeviceTime ...
                }, ...
                'Device', ...
                true ...
            );
        
            this.uipDevice2 = UIPopup(...
                { ...
                    this.cDeviceMono, ...
                    this.cDeviceMaskTDet2T, ...
                    this.cDeviceMaskX, ...
                    this.cDeviceMaskY, ...
                    this.cDeviceMaskZ, ...
                    this.cDeviceMaskT, ...
                    this.cDeviceDetX, ...
                    this.cDeviceDetT, ...
                    this.cDeviceFilterY, ...
                    this.cDeviceTime ...
                    
                }, ...
                'Device', ...
                false ...
            );
            this.uipDevice2.u8Selected = uint8(2); % Default to t, 2t
            
            
            this.uitxUnitLabel = UIText('Unit');
            
            this.uitxUnit1 = UIText('m (temp)');
            this.uieStart1 = UIEdit('Start', 'd', true);
            this.uieStop1 = UIEdit('Stop', 'd', true);
            this.uieSteps1 = UIEdit('Steps', 'd', true);
            
            this.uieStart1.setVal(13.4);
            this.uieStop1.setVal(13.6);
            this.uieSteps1.setVal(30);
            this.uieSteps1.setMin(1);
            
            this.uitxUnit2 = UIText('m (temp)');
            this.uieStart2 = UIEdit('Start 2', 'd', false);
            this.uieStop2 = UIEdit('Stop 2', 'd', false);
            this.uieSteps2 = UIEdit('Steps 2', 'd', false);
                        
            this.uieStart2.setVal(50);
            this.uieStop2.setVal(60);
            this.uieSteps2.setVal(20); 
            this.uieSteps2.setMin(1);
            
            
            this.u8Swap     = imread(fullfile(...
                this.cDirApp, ...
                'assets', ...
                'swap-20-2.png'...
            ));
            this.uibSwap = UIButton('S', true, this.u8Swap);
        
        
            this.uitxLabelStatus = UIText('Status:');
            this.uitxLabelProgress = UIText('Progress:');
            this.uitxLabelTimeRemaining = UIText('Time remaining:');
            this.uitxLabelTimeElapsed = UIText('Time elapsed:');
            this.uitxLabelTimeComplete = UIText('Time complete:');
            
            
            this.uitxStatus = UIText('READY', 'Left', 'bold');
            this.uitxProgress = UIText('0%');
            this.uitxTimeRemaining = UIText('');
            this.uitxTimeElapsed = UIText('');
            this.uitxTimeComplete = UIText('');
            

            this.resetStatus();
            
        
            stParams = struct();
            stParams.dWidth = 640;
            stParams.dHeight = 20;
            stParams.dSizeFont = 16;
            stParams.dWidthText = 60;
            stParams.dColorBg = [1 0.5 1];
            this.pb = ProgressBar(stParams);
            
            %{
            this.uitxLabelControlName = UIText('Device');
            this.uitxLabelControlVal = UIText('Val');
            this.uitxLabelControlUnit = UIText('Unit');
            this.uitxLabelControlDest = UIText('Goal');
            this.uitxLabelControlJogL = UIText('Jog-');
            this.uitxLabelControlJog = UIText('Step');
            this.uitxLabelControlJogR = UIText('Jog+');
            %}
            
            this.initStartStopStepsStores();
            
            % Load previous state before adding listeners
            this.load();

            
            
            ceNames = fieldnames(this.stHio);
            
            for n = 1:length(ceNames)
                addlistener(this.stHio.(ceNames{n}).hio, 'eUnitChange', @this.onHIOUnitChange);
            end
            

            addlistener(this.uitPlay, 'eChange', @this.onPlayChange);
            
            this.addDevice1Listeners();
            this.addDevice2Listeners();
                        
            addlistener(this.uipType, 'eChange', @this.onTypeChange);
            addlistener(this.uibCancel, 'ePress', @this.onCancelPress);
            addlistener(this.uibCancel, 'eChange', @this.onCancelConfirm); % they confirmed they want to cancel
        
            addlistener(this.uibChooseRecipe, 'ePress', @this.onChooseRecipePress);
            addlistener(this.uibOpenRecipe, 'ePress', @this.onOpenRecipePress);
            
            % Initialize units to correct value
            
            this.updateUnit1();
            this.updateUnit2();
            
            addlistener(this.uibSwap, 'ePress', @this.onSwapPress);
            addlistener(this.uibChooseDir, 'ePress', @this.onChooseSaveDirPress);
                        
        end
        
        function onPlotDataTypeChange(this, ~, ~)
           	this.updatePlot(this.getSystemUnits()); 
            this.updateAxes1DLegend();
            this.updateAxes2D1Legend();
        end
        
        function onPlotYScaleTypeChange(this, ~, ~)
            this.updateAxesYScale(this.hAxes1D);
            this.updateAxesYScale(this.hAxes2D1);
            this.updateAxesZScale(this.hAxes2D2);
           	% this.updatePlot(this.getSystemUnits());  
        end
          
        function onPlotYLimitTypeChange(this, ~, ~)
            switch this.uipPlotYLimitType.val
                case this.cPlotYLimitTypeAuto
                    this.hidePlotYLimitUi()
                case this.cPlotYLimitTypeManual
                    this.showPlotYLimitUi()
            end
            
            this.updateAxesYLimits(this.hAxes1D);
            this.updateAxesYLimits(this.hAxes2D1);
            
        end


        function onPlotYLimitMinChange(this, ~, ~)
            this.updateAxesYLimits(this.hAxes1D);
            this.updateAxesYLimits(this.hAxes2D1);
        end


        function onPlotYLimitMaxChange(this, ~, ~)
            this.updateAxesYLimits(this.hAxes1D);
            this.updateAxesYLimits(this.hAxes2D1);
        end
        
        
        function onPlotTypeChange(this, src, evt)
           if src.lVal
               src.setTooltip(this.cTooltipPlotTypeLog);
           else
               src.setTooltip(this.cTooltipPlotTypeLin);
           end
           
           this.updatePlot(this.getSystemUnits());
        end
        
        function onStageApiChange(this, src, evt)
            if src.lVal
                this.turnOn();
                src.setTooltip(this.cTooltipDisconnect);

            else
                this.turnOff();
                src.setTooltip(this.cTooltipConnect);
            end            
        end
        
        function onLoadLockSavePress(this, src, evt);
            this.msg('onLoadLockSavePress()'); 
            stRecipe = this.buildRecipeLoadLock();
            this.saveLoadLockRecipe(stRecipe);
            
        end
        
        % @return {char 1xm} - full path to load lock recipe file
        function c = getLoadLockRecipePath(this)
            
            this.msg('getLoadLockRecipePath()');
            
            cDir = fullfile(...
                this.cDirApp, ...
                'load-lock' ...
            );
            cDir = MicUtils.path2canonical(cDir);
            this.checkDir(cDir);
            
            c = fullfile(...
                cDir, ...
                'load-lock.json' ...
            );
        end
        
        function onLoadLockPress(this, src, evt)
            this.startLoadLockScan();
        end
        
        function startLoadLockScan(this)
                        
            % Load the load-lock.json recipe
            stRecipe = this.buildRecipeFromFile(this.getLoadLockRecipePath());
            
            % Create new StateScan and start it
            this.scan = StateScan(...
                this.clock, ...
                stRecipe, ...
                @this.onStateScanSetStateLL, ...
                @this.onStateScanIsAtState, ...
                @this.onStateScanAcquireLL, ... % doesn't do anything
                @this.onStateScanIsAcquired, ... % returns true
                @this.onStateScanCompleteLL, ...
                @this.onStateScanAbortLL ...
            );
        
            this.resetStatus();
            this.uitxStatus.cVal = 'Moving to LL ...';
            this.scan.start();
            
        end
        
        function stRecipe = buildRecipeLoadLock(this)
            
            
            % Build recipe structure.  Temporarily assume want to move
            % MaskT and DetT, but later on can make what it needs to be.
            % Special case where the recipe stores raw units without any
            % offset as set in the UI.  The setState during this scan will
            % have to be different and set the state using setValRaw()
            % instead of setValCalDisplay()
                        
            stUnit = struct();            
            stUnit.(this.cFieldMaskX) = this.stHio.(this.cFieldMaskX).hio.unit().name;
            stUnit.(this.cFieldMaskY) = this.stHio.(this.cFieldMaskY).hio.unit().name;
            stUnit.(this.cFieldMaskZ) = this.stHio.(this.cFieldMaskZ).hio.unit().name;
            stUnit.(this.cFieldMaskT) = this.stHio.(this.cFieldMaskT).hio.unit().name;
            
            % Value structure of LL state
            stValue = struct();
            stValue.(this.cFieldMaskX) = this.hioMaskX.valRaw();
            stValue.(this.cFieldMaskY) = this.hioMaskY.valRaw();
            stValue.(this.cFieldMaskZ) = this.hioMaskZ.valRaw();
            stValue.(this.cFieldMaskT) = this.hioMaskT.valRaw();
            
            
            ceValues = cell(1, 1); 
            ceValues{1} = stValue;
            
            stRecipe = struct();
            stRecipe.unit = stUnit;
            stRecipe.values = ceValues;
            
        end
        
        function onStateScanAcquireLL(this, stUnit)
            % Don't do anything
        end
        
        function onStateScanCompleteLL(this, stUnit)
            % Don't do anything
            this.uitxStatus.cVal = 'Sample at LL';
        end
        
        function onStateScanAbortLL(this, stUnit)
            % Don't do anything
        end
        
        % @param {handle 1x1} handle to the axes that is to be updated
        function updateAxesZScale(this, h)
            
            if  isempty(h) || ...
                ~ishandle(h)
                return
            end
            
            
            switch this.uipPlotYScaleType.val()
                case this.cPlotYScaleTypeLinear
                    set(h, 'ZScale', 'linear');
                case this.cPlotYScaleTypeLog
                    set(h, 'ZScale', 'log');
            end   
            
        end
        
        function updateAxes1DXLimits(this)
            
            if  isempty(this.hAxes1D) || ...
                ~ishandle(this.hAxes1D)
                return
            end
            
            dMin = min(this.d1DResultParam);
            dMax = max(this.d1DResultParam);
            if dMin ~= dMax
                xlim(this.hAxes1D, [dMin dMax]);
            end
            
            
        end
        
        function updateAxes2D1XLimits(this)
            
            if  isempty(this.hAxes2D1) || ...
                ~ishandle(this.hAxes2D1)
                return
            end
            
            dMin = min(this.d1DResultParam);
            dMax = max(this.d1DResultParam);
            if dMin ~= dMax
                xlim(this.hAxes2D1, [dMin dMax]);
            end
            
            % xlim(this.hAxes2D1, [this.d1DResultParam(1) this.d1DResultParam(end)]);
            
        end
        
        
        % @param {handle 1x1} handle to the axes that is to be updated
        function updateAxesYScale(this, h)
            
            %{
            if this.uitPlotType.lVal
                set(h, 'YScale', 'log');
            else
                set(h, 'YScale', 'linear');
            end
            %}
            
            if  isempty(h) || ...
                ~ishandle(h)
                return
            end
            
            switch this.uipPlotYScaleType.val()
                case this.cPlotYScaleTypeLinear
                    set(h, 'YScale', 'linear');
                case this.cPlotYScaleTypeLog
                    set(h, 'YScale', 'log');
            end            
        end
        
        % @param {handle 1x1} handle to the axes that is to be updated
        function updateAxesYLimits(this, h)
            
            if  isempty(h) || ...
                ~ishandle(h)
                return
            end
            
            
            switch this.uipPlotYLimitType.val()
                case this.cPlotYLimitTypeAuto
                    % do not set y limitis
                    % set to -inf +inf for auto
                    ylim(h, [-inf inf]);
                case this.cPlotYLimitTypeManual
                    if this.uiePlotYLimitMax.val() > this.uipPlotYLimitMin.val()                            
                        ylim(h, [this.uipPlotYLimitMin.val() this.uiePlotYLimitMax.val()])
                    else
                        ylim(h, [-inf inf]);
                    end
                otherwise
                    ylim(h, [-inf inf]);
            end
            
        end
        
        function updateAxes1DLegend(this)
            
            return;
            
            
            if  isempty(this.hAxes1D) || ...
                ~ishandle(this.hAxes1D)
                return
            end
            
            
            if ~isempty(this.hLegend1D) && ishandle(this.hLegend1D)
                delete(this.hLegend1D);
            end
            
            switch this.uipPlotDataType.val()
                case this.cPlotDataTypeCombined
                    this.hLegend1D = legend(this.hAxes1D, 'Idet','Izero');
                    % set(this.hLegend1D, 'FontSize', this.dSizeFont);
                case this.cPlotDataTypeIDet
                    this.hLegend1D = legend(this.hAxes1D, 'Idet');
                    % set(this.hLegend1D, 'FontSize', this.dSizeFont);
                case this.cPlotDataTypeI0
                    this.hLegend1D = legend(this.hAxes1D, 'Izero');
                    % set(this.hLegend1D, 'FontSize', this.dSizeFont);
            end
            
        end
        
        
        function updateAxes2D1Legend(this)
            
            return
            
            if  isempty(this.hAxes2D1) || ...
                ~ishandle(this.hAxes2D1)
                return
            end
            
            
            % Remove old line series
             if ~isempty(this.hLegend2D1) && ishandle(this.hLegend2D1)
                delete(this.hLegend2D1);
             end
                    
                    
            switch this.uipPlotDataType.val()
                
                case this.cPlotDataTypeCombined
                    this.hLegend2D1 = legend(this.hAxes2D1, 'Idet', 'Izero');
                    % set(this.hLegend2D1, 'FontSize', this.dSizeFont);
                case this.cPlotDataTypeIDet
                    this.hLegend2D1 = legend(this.hAxes2D1, 'Idet');
                    % set(this.hLegend2D1, 'FontSize', this.dSizeFont);
                case this.cPlotDataTypeI0
                    this.hLegend2D1 = legend(this.hAxes2D1, 'Izero');
                    % set(this.hLegend2D1, 'FontSize', this.dSizeFont);
            end
            
        end
        
        
        function updateAxes1DData(this)
            
            
            if  isempty(this.hAxes1D) || ...
                ~ishandle(this.hAxes1D)
                return
            end
            
            
            if ~isempty(this.hLines1DIDet) && ishandle(this.hLines1DIDet)
                delete(this.hLines1DIDet);
            end
            
            if ~isempty(this.hLines1DIZero) && ishandle(this.hLines1DIZero)
                delete(this.hLines1DIZero);
            end
            
            
                    
            switch this.uipPlotDataType.val()
                case this.cPlotDataTypeCombined
                    this.hLines1DIDet = plot(...
                        this.hAxes1D, ...
                        this.d1DResultParam, this.d1DResultIDet, '.-r', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                    this.hLines1DIZero = plot(...
                        this.hAxes1D, ...
                        this.d1DResultParam, this.d1DResultIZero, '.-b', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                    
                case this.cPlotDataTypeIDet
                    this.hLines1DIDet = plot(...
                        this.hAxes1D, ...
                        this.d1DResultParam, this.d1DResultIDet, '.-r', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                
                case this.cPlotDataTypeI0
                    this.hLines1DIZero = plot(...
                        this.hAxes1D, ...
                        this.d1DResultParam, this.d1DResultIZero, '.-b', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
            end
            
        end
        function updateAxes2D1Data(this)
            
            
             if  isempty(this.hAxes2D1) || ...
                ~ishandle(this.hAxes2D1)
                return
             end
            
                
             % Remove old line series
             if ~isempty(this.hLines2D1IDet) && ishandle(this.hLines2D1IDet)
                delete(this.hLines2D1IDet);
             end
             
             if ~isempty(this.hLines2D1IZero) && ishandle(this.hLines2D1IZero)
                delete(this.hLines2D1IZero);
             end
             
                    
            switch this.uipPlotDataType.val()
                
              
                case this.cPlotDataTypeCombined
                    this.hLines2D1IDet = plot(...
                        this.hAxes2D1, ...
                        this.d1DResultParam, this.d1DResultIDet, '.-r', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                    this.hLines2D1IZero = plot(...
                        this.hAxes2D1, ...
                        this.d1DResultParam, this.d1DResultIZero, '.-b', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                
                case this.cPlotDataTypeIDet
                    this.hLines2D1IDet = plot(...
                        this.hAxes2D1, ...
                        this.d1DResultParam, this.d1DResultIDet, '.-r', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
                   
                case this.cPlotDataTypeI0
                    this.hLines2D1IZero = plot(...
                        this.hAxes2D1, ...
                        this.d1DResultParam, this.d1DResultIZero, '.-b', ...
                        'MarkerSize', this.dSizeMarker ...
                    );
              
            end
        end
        
    end 
    
    
end

