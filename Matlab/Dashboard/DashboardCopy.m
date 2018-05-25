classdef Dashboard < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        InterfaceTab                    matlab.ui.container.Tab
        BRAKEButton                     matlab.ui.control.Button
        LeftdistancetoobjectGaugeLabel  matlab.ui.control.Label
        LeftDistGauge                   matlab.ui.control.LinearGauge
        RightdistancetoobjectGaugeLabel  matlab.ui.control.Label
        RightDistGauge                  matlab.ui.control.LinearGauge
        DirectionGaugeLabel             matlab.ui.control.Label
        DirectionGauge                  matlab.ui.control.SemicircularGauge
        MotorspeedGaugeLabel            matlab.ui.control.Label
        MotorspeedGauge                 matlab.ui.control.SemicircularGauge
        DashboardLabel                  matlab.ui.control.Label
        Forward                         matlab.ui.control.Button
        Backward                        matlab.ui.control.Button
        Right                           matlab.ui.control.Button
        Left                            matlab.ui.control.Button
        ManualcontrolsLabel             matlab.ui.control.Label
        OpenserialportButton            matlab.ui.control.Button
        CloseserialportButton           matlab.ui.control.Button
        comport                         matlab.ui.control.EditField
        ModeSelectionSwitchLabel        matlab.ui.control.Label
        ModeSelectionSwitch             matlab.ui.control.Switch
        StartDataloggingButton          matlab.ui.control.Button
        BatteryVoltage                  matlab.ui.control.Table
        NoconnectiontoKITTButton        matlab.ui.control.StateButton
        DataloggerTab                   matlab.ui.container.Tab
        DataloggerLabel                 matlab.ui.control.Label
        LeftDistGraph                   matlab.ui.control.UIAxes
        RightDistGraph                  matlab.ui.control.UIAxes
        DirectionGraph                  matlab.ui.control.UIAxes
        MotorspeedGraph                 matlab.ui.control.UIAxes
        SavedataloggingButton           matlab.ui.control.Button
        PlotButton                      matlab.ui.control.Button
    end

    
    methods (Access = private)
        
        function update(app)
            global index_log d_l d_r motorspeed direction d_l_log d_r_log motorspeed_log direction_log t voltage_log voltage
            %update the gauges
            app.getStatus()
            app.RightDistGauge.Value = d_r;
            app.LeftDistGauge.Value = d_l;
            app.DirectionGauge.Value = direction;
            app.MotorspeedGauge.Value = motorspeed;
            app.BatteryVoltage.Data = voltage;
            
            %update the datalogging
            index_log = index_log + 1;
            d_l_log(index_log) = d_l;
            d_r_log(index_log) = d_r;
            direction_log(index_log) = direction;
            motorspeed_log(index_log) = motorspeed;
            voltage_log(index_log) = voltage;
            t(index_log) = toc;
        end
        
        function getStatus(app)
            global d_l d_r motorspeed direction voltage
            if (app.NoconnectiontoKITTButton.Value == 0)
                if (app.ModeSelectionSwitch.Value == 'All sensors')
                    Str = EPOCommunications('transmit','S');
                    Index_l = strfind(Str, 'USL');
                    d_l = sscanf(Str(Index_l(1) + 3:end), '%g', 1);
                    Index_r = strfind(Str, 'USR');
                    d_r = sscanf(Str(Index_r(1) + 3:end), '%g', 1);
                    Index_d = strfind(Str, 'Dir.');
                    direction = sscanf(Str(Index_d(1) + 4:end), '%g', 1);
                    Index_m = strfind(Str, 'Mot.');
                    motorspeed = sscanf(Str(Index_m(1) + 4:end), '%g', 1);
                    Index_v = strfind(Str, 'V_batt');
                    voltage = sscanf(Str(Index_v(1) + 6:end), '%g', 1);
                else
                    Str = EPOCommunications('transmit','Sd');
                    Index_l = strfind(Str, 'USL');
                    d_l = sscanf(Str(Index_l(1) + 3:end), '%g', 1);
                    Index_r = strfind(Str, 'USR');
                    d_r = sscanf(Str(Index_r(1) + 3:end), '%g', 1);
                end
            end
            
        end
        
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global index_log motorspeed direction motorspeed_log direction_log d_l d_r d_l_log d_r_log t voltage_log
            voltage_log = 0;
            motorspeed_log = 0;
            motorspeed = 0;
            direction = 0;
            direction_log = 0;
            d_l = 0;
            d_r = 0;
            d_l_log = 0;
            d_r_log = 0;
            t = 0;
            index_log = 0;
            app.BatteryVoltage.Data = 0;
        end

        % Button pushed function: BRAKEButton
        function BRAKEButtonPushed(app, event)
            EPOCommunications('transmit','D150');
            EPOCommunications('transmit','M135');
            pause(2);
            EPOCommunications('transmit','M150');
        end

        % Callback function
        function GoButtonPushed(app, event)
            stopAtDistance(app.stop_distance.Value);
        end

        % Button pushed function: Forward
        function ForwardButtonPushed(app, event)
            EPOCommunications('transmit','D150');
            EPOCommunications('transmit','M165');
            pause(1)
            EPOCommunications('transmit','M150');
        end

        % Button pushed function: Backward
        function BackwardButtonPushed(app, event)
            EPOCommunications('transmit','D150');
            EPOCommunications('transmit','M140');
            pause(1)
            EPOCommunications('transmit','M150');
        end

        % Button pushed function: Right
        function RightButtonPushed(app, event)
            EPOCommunications('transmit','D200');
            EPOCommunications('transmit','M160');
            pause(1)
            EPOCommunications('transmit','M150');
        end

        % Button pushed function: Left
        function LeftButtonPushed(app, event)
            EPOCommunications('transmit','D100');
            EPOCommunications('transmit','M160');
            pause(1)
            EPOCommunications('transmit','M150');
        end

        % Button pushed function: SavedataloggingButton
        function SavedataloggingButtonPushed(app, event)
            saveDatalogging();
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            global d_l_log d_r_log t direction_log motorspeed_log
            plot(app.LeftDistGraph,t,d_l_log);
            plot(app.RightDistGraph,t,d_r_log);
            plot(app.DirectionGraph,t,direction_log);
            plot(app.MotorspeedGraph,t,motorspeed_log);
        end

        % Button pushed function: OpenserialportButton
        function OpenserialportButtonPushed(app, event)
            EPOCommunications('open',app.comport.Value)
        end

        % Button pushed function: CloseserialportButton
        function CloseserialportButtonPushed(app, event)
            EPOCommunications('close');
        end

        % Button pushed function: StartDataloggingButton
        function StartDataloggingButtonPushed(app, event)
            DashboardTimer = timer;
            DashboardTimer.ExecutionMode = 'fixedSpacing';
            DashboardTimer.Period = 0.05;
            DashboardTimer.TimerFcn = @(~,~)app.update;
            start(DashboardTimer)
            tic
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 639 705];
            app.UIFigure.Name = 'UI Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 2 639 704];

            % Create InterfaceTab
            app.InterfaceTab = uitab(app.TabGroup);
            app.InterfaceTab.Title = 'Interface';

            % Create BRAKEButton
            app.BRAKEButton = uibutton(app.InterfaceTab, 'push');
            app.BRAKEButton.ButtonPushedFcn = createCallbackFcn(app, @BRAKEButtonPushed, true);
            app.BRAKEButton.FontSize = 20;
            app.BRAKEButton.FontWeight = 'bold';
            app.BRAKEButton.Position = [33 45 565 62];
            app.BRAKEButton.Text = 'BRAKE!';

            % Create LeftdistancetoobjectGaugeLabel
            app.LeftdistancetoobjectGaugeLabel = uilabel(app.InterfaceTab);
            app.LeftdistancetoobjectGaugeLabel.HorizontalAlignment = 'center';
            app.LeftdistancetoobjectGaugeLabel.VerticalAlignment = 'top';
            app.LeftdistancetoobjectGaugeLabel.Position = [96 527 123 15];
            app.LeftdistancetoobjectGaugeLabel.Text = 'Left distance to object';

            % Create LeftDistGauge
            app.LeftDistGauge = uigauge(app.InterfaceTab, 'linear');
            app.LeftDistGauge.Limits = [0 400];
            app.LeftDistGauge.MajorTicks = [0 50 100 150 200 250 300 350 400];
            app.LeftDistGauge.Position = [33 543 251 58];

            % Create RightdistancetoobjectGaugeLabel
            app.RightdistancetoobjectGaugeLabel = uilabel(app.InterfaceTab);
            app.RightdistancetoobjectGaugeLabel.HorizontalAlignment = 'center';
            app.RightdistancetoobjectGaugeLabel.VerticalAlignment = 'top';
            app.RightdistancetoobjectGaugeLabel.Position = [407 527 132 15];
            app.RightdistancetoobjectGaugeLabel.Text = 'Right distance to object';

            % Create RightDistGauge
            app.RightDistGauge = uigauge(app.InterfaceTab, 'linear');
            app.RightDistGauge.Limits = [0 400];
            app.RightDistGauge.MajorTicks = [0 50 100 150 200 250 300 350 400];
            app.RightDistGauge.Position = [347 543 251 58];

            % Create DirectionGaugeLabel
            app.DirectionGaugeLabel = uilabel(app.InterfaceTab);
            app.DirectionGaugeLabel.HorizontalAlignment = 'center';
            app.DirectionGaugeLabel.VerticalAlignment = 'top';
            app.DirectionGaugeLabel.Position = [131 353 54 15];
            app.DirectionGaugeLabel.Text = 'Direction';

            % Create DirectionGauge
            app.DirectionGauge = uigauge(app.InterfaceTab, 'semicircular');
            app.DirectionGauge.Limits = [100 200];
            app.DirectionGauge.MajorTicks = [100 125 150 175 200];
            app.DirectionGauge.Position = [33 369 251 135];
            app.DirectionGauge.Value = 150;

            % Create MotorspeedGaugeLabel
            app.MotorspeedGaugeLabel = uilabel(app.InterfaceTab);
            app.MotorspeedGaugeLabel.HorizontalAlignment = 'center';
            app.MotorspeedGaugeLabel.VerticalAlignment = 'top';
            app.MotorspeedGaugeLabel.Position = [436.5 353 73 15];
            app.MotorspeedGaugeLabel.Text = 'Motor speed';

            % Create MotorspeedGauge
            app.MotorspeedGauge = uigauge(app.InterfaceTab, 'semicircular');
            app.MotorspeedGauge.Limits = [135 165];
            app.MotorspeedGauge.MajorTicks = [135 140 145 150 155 160 165];
            app.MotorspeedGauge.Position = [347 369 251 135];
            app.MotorspeedGauge.Value = 150;

            % Create DashboardLabel
            app.DashboardLabel = uilabel(app.InterfaceTab);
            app.DashboardLabel.VerticalAlignment = 'top';
            app.DashboardLabel.FontSize = 20;
            app.DashboardLabel.FontWeight = 'bold';
            app.DashboardLabel.Position = [1 657 110 26];
            app.DashboardLabel.Text = 'Dashboard';

            % Create Forward
            app.Forward = uibutton(app.InterfaceTab, 'push');
            app.Forward.ButtonPushedFcn = createCallbackFcn(app, @ForwardButtonPushed, true);
            app.Forward.FontSize = 26;
            app.Forward.FontWeight = 'bold';
            app.Forward.Position = [288.5 255 53 43];
            app.Forward.Text = '↑';

            % Create Backward
            app.Backward = uibutton(app.InterfaceTab, 'push');
            app.Backward.ButtonPushedFcn = createCallbackFcn(app, @BackwardButtonPushed, true);
            app.Backward.FontSize = 26;
            app.Backward.FontWeight = 'bold';
            app.Backward.Position = [289.5 171 53 43];
            app.Backward.Text = '↓';

            % Create Right
            app.Right = uibutton(app.InterfaceTab, 'push');
            app.Right.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPushed, true);
            app.Right.FontSize = 26;
            app.Right.FontWeight = 'bold';
            app.Right.Position = [341.5 213 53 43];
            app.Right.Text = '→';

            % Create Left
            app.Left = uibutton(app.InterfaceTab, 'push');
            app.Left.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPushed, true);
            app.Left.FontSize = 26;
            app.Left.FontWeight = 'bold';
            app.Left.Position = [236.5 213 53 43];
            app.Left.Text = '←';

            % Create ManualcontrolsLabel
            app.ManualcontrolsLabel = uilabel(app.InterfaceTab);
            app.ManualcontrolsLabel.VerticalAlignment = 'top';
            app.ManualcontrolsLabel.Position = [272 313 95 15];
            app.ManualcontrolsLabel.Text = 'Manual controls:';

            % Create OpenserialportButton
            app.OpenserialportButton = uibutton(app.InterfaceTab, 'push');
            app.OpenserialportButton.ButtonPushedFcn = createCallbackFcn(app, @OpenserialportButtonPushed, true);
            app.OpenserialportButton.Position = [150 139 103 26];
            app.OpenserialportButton.Text = 'Open serial port';

            % Create CloseserialportButton
            app.CloseserialportButton = uibutton(app.InterfaceTab, 'push');
            app.CloseserialportButton.ButtonPushedFcn = createCallbackFcn(app, @CloseserialportButtonPushed, true);
            app.CloseserialportButton.Position = [33 139 103 26];
            app.CloseserialportButton.Text = 'Close serial port';

            % Create comport
            app.comport = uieditfield(app.InterfaceTab, 'text');
            app.comport.Position = [33 171 97 20];
            app.comport.Value = '''\\.\COM3''';

            % Create ModeSelectionSwitchLabel
            app.ModeSelectionSwitchLabel = uilabel(app.InterfaceTab);
            app.ModeSelectionSwitchLabel.HorizontalAlignment = 'center';
            app.ModeSelectionSwitchLabel.FontWeight = 'bold';
            app.ModeSelectionSwitchLabel.Position = [59 265 94 22];
            app.ModeSelectionSwitchLabel.Text = 'Mode Selection';

            % Create ModeSelectionSwitch
            app.ModeSelectionSwitch = uiswitch(app.InterfaceTab, 'slider');
            app.ModeSelectionSwitch.Items = {'All sensors', 'Only distance sensors'};
            app.ModeSelectionSwitch.Position = [83 285 45 20];
            app.ModeSelectionSwitch.Value = 'All sensors';

            % Create StartDataloggingButton
            app.StartDataloggingButton = uibutton(app.InterfaceTab, 'push');
            app.StartDataloggingButton.ButtonPushedFcn = createCallbackFcn(app, @StartDataloggingButtonPushed, true);
            app.StartDataloggingButton.Position = [33 205 108 22];
            app.StartDataloggingButton.Text = 'Start Datalogging';

            % Create BatteryVoltage
            app.BatteryVoltage = uitable(app.InterfaceTab);
            app.BatteryVoltage.ColumnName = {'Battery voltage'};
            app.BatteryVoltage.RowName = {};
            app.BatteryVoltage.FontSize = 20;
            app.BatteryVoltage.Position = [457 243 106 55];

            % Create NoconnectiontoKITTButton
            app.NoconnectiontoKITTButton = uibutton(app.InterfaceTab, 'state');
            app.NoconnectiontoKITTButton.Text = 'No connection to KITT';
            app.NoconnectiontoKITTButton.Position = [40 309 135 22];

            % Create DataloggerTab
            app.DataloggerTab = uitab(app.TabGroup);
            app.DataloggerTab.Title = 'Data logger';

            % Create DataloggerLabel
            app.DataloggerLabel = uilabel(app.DataloggerTab);
            app.DataloggerLabel.VerticalAlignment = 'top';
            app.DataloggerLabel.FontSize = 20;
            app.DataloggerLabel.FontWeight = 'bold';
            app.DataloggerLabel.Position = [1 657 116 26];
            app.DataloggerLabel.Text = 'Data logger';

            % Create LeftDistGraph
            app.LeftDistGraph = uiaxes(app.DataloggerTab);
            title(app.LeftDistGraph, 'Left distance to wall')
            xlabel(app.LeftDistGraph, 'Time (s)')
            ylabel(app.LeftDistGraph, 'Distance (cm)')
            app.LeftDistGraph.GridAlpha = 0.15;
            app.LeftDistGraph.MinorGridAlpha = 0.25;
            app.LeftDistGraph.Box = 'on';
            app.LeftDistGraph.XGrid = 'on';
            app.LeftDistGraph.YGrid = 'on';
            app.LeftDistGraph.Position = [1 356 300 302];

            % Create RightDistGraph
            app.RightDistGraph = uiaxes(app.DataloggerTab);
            title(app.RightDistGraph, 'Right distance to wall')
            xlabel(app.RightDistGraph, 'Time (s)')
            ylabel(app.RightDistGraph, 'Distance (cm)')
            app.RightDistGraph.GridAlpha = 0.15;
            app.RightDistGraph.MinorGridAlpha = 0.25;
            app.RightDistGraph.Box = 'on';
            app.RightDistGraph.XGrid = 'on';
            app.RightDistGraph.YGrid = 'on';
            app.RightDistGraph.Position = [339 356 300 302];

            % Create DirectionGraph
            app.DirectionGraph = uiaxes(app.DataloggerTab);
            title(app.DirectionGraph, 'Direction')
            xlabel(app.DirectionGraph, 'Time (s)')
            ylabel(app.DirectionGraph, 'Direction')
            app.DirectionGraph.GridAlpha = 0.15;
            app.DirectionGraph.MinorGridAlpha = 0.25;
            app.DirectionGraph.Box = 'on';
            app.DirectionGraph.XGrid = 'on';
            app.DirectionGraph.YGrid = 'on';
            app.DirectionGraph.Position = [0 55 300 302];

            % Create MotorspeedGraph
            app.MotorspeedGraph = uiaxes(app.DataloggerTab);
            title(app.MotorspeedGraph, 'Motor speed')
            xlabel(app.MotorspeedGraph, 'Time (s)')
            ylabel(app.MotorspeedGraph, 'Motor speed')
            app.MotorspeedGraph.GridAlpha = 0.15;
            app.MotorspeedGraph.MinorGridAlpha = 0.25;
            app.MotorspeedGraph.Box = 'on';
            app.MotorspeedGraph.XGrid = 'on';
            app.MotorspeedGraph.YGrid = 'on';
            app.MotorspeedGraph.Position = [339 55 300 302];

            % Create SavedataloggingButton
            app.SavedataloggingButton = uibutton(app.DataloggerTab, 'push');
            app.SavedataloggingButton.ButtonPushedFcn = createCallbackFcn(app, @SavedataloggingButtonPushed, true);
            app.SavedataloggingButton.Position = [265.5 13 111 22];
            app.SavedataloggingButton.Text = 'Save datalogging';

            % Create PlotButton
            app.PlotButton = uibutton(app.DataloggerTab, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [102 13 100 22];
            app.PlotButton.Text = 'Plot';
        end
    end

    methods (Access = public)

        % Construct app
        function app = Dashboard

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end