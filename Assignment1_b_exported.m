classdef Assignment1_b_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        HistogramShrinkingButton  matlab.ui.control.Button
        HistogramStrechingButton  matlab.ui.control.Button
        UploadimageButton         matlab.ui.control.Button
        UIAxes4                   matlab.ui.control.UIAxes
        UIAxes3                   matlab.ui.control.UIAxes
        UIAxes2                   matlab.ui.control.UIAxes
        UIAxes                    matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadimageButton
        function UploadimageButtonPushed(app, event)
            global a; 
            [filename, pathname] = uigetfile('*.*', 'Pick an Image');
            filename=strcat(pathname,filename);
            a=imread(filename);
            imshow(a,'Parent',app.UIAxes);
            histogram(a,'Parent',app.UIAxes3);
        end

        % Button pushed function: HistogramStrechingButton
        function HistogramStrechingButtonPushed(app, event)
            global a;
            A=a;
            Cmi = double(min(A(:)));
            Cma = double(max(A(:)));

            Omi=0;
            Oma =255;
            S=size(A);
            for i=1:S(1)
                for j=1:S(2)
                    Cp = double(A(i,j));
                    O(i,j) = ((Cp-Cmi)*(Oma - Omi) / (Cma -Cmi)) + Omi;
                end
            end
            O = uint8(O);
            imshow(O,'Parent',app.UIAxes2);
            histogram(O,'Parent',app.UIAxes4);
        end

        % Button pushed function: HistogramShrinkingButton
        function HistogramShrinkingButtonPushed(app, event)
            global a;
            A=a;
           
            %ShrinkMax = 180;
            %ShrinkMin = 100;
            ShrinkMax = input('Please give maximum value::: ');
            ShrinkMin = input('Please give minimun value::: ');
            
            [width ,height ,~] = size(A);
            processedImage = A;
            
            [value, ~] = max(A,[],2);
            ImageMaxValue = max(max(value));
            
            [value, ~] = min(A,[],2);
            ImageMinValue = min(min(value));
            for col = 1 : 1 : width
                for row = 1 : 1 : height
                    processedImage(col,row) = round((double(ShrinkMax-ShrinkMin)/ double(ImageMaxValue-ImageMinValue)) * (double(A(col,row)-ImageMinValue)) + ShrinkMin);
                end
            end

            imshow(processedImage,'Parent',app.UIAxes2);
            histogram(processedImage,'Parent',app.UIAxes4);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 798 580];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Orignal Image')
            app.UIAxes.Position = [106 377 273 191];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Result Image')
            app.UIAxes2.Position = [220 44 258 199];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'Histogram of original image')
            app.UIAxes3.Position = [400 377 295 191];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.UIFigure);
            title(app.UIAxes4, 'Histogram of Result image')
            app.UIAxes4.Position = [528 44 253 199];

            % Create UploadimageButton
            app.UploadimageButton = uibutton(app.UIFigure, 'push');
            app.UploadimageButton.ButtonPushedFcn = createCallbackFcn(app, @UploadimageButtonPushed, true);
            app.UploadimageButton.Position = [254 312 292 48];
            app.UploadimageButton.Text = 'Upload image';

            % Create HistogramStrechingButton
            app.HistogramStrechingButton = uibutton(app.UIFigure, 'push');
            app.HistogramStrechingButton.ButtonPushedFcn = createCallbackFcn(app, @HistogramStrechingButtonPushed, true);
            app.HistogramStrechingButton.Position = [21 161 166 59];
            app.HistogramStrechingButton.Text = 'HistogramStreching';

            % Create HistogramShrinkingButton
            app.HistogramShrinkingButton = uibutton(app.UIFigure, 'push');
            app.HistogramShrinkingButton.ButtonPushedFcn = createCallbackFcn(app, @HistogramShrinkingButtonPushed, true);
            app.HistogramShrinkingButton.Position = [21 95 166 59];
            app.HistogramShrinkingButton.Text = 'Histogram Shrinking';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Assignment1_b_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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