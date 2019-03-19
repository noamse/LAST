% Focuser class  
% Package: +obs/+focuser/
% Description: A class for controlling the focuser
%              See http://www.dogratian.com/products/index.php/menu-sensors/menu-usb-tnh-type-a-sht10
%              The class open a serial object to communicate with the
%              sensor.
% Tested : Matlab R2016a
%     By : David Polishook                    Feb 2019
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Example: % Create a Focuser object
%          FC=obs.FocusController('/dev/tty.usbserial-OP3BCIFI');
%          % Send an absolute location
%          lynxMoveAbs(FC,pos,focuser)
%          % Send a relative location
%          lynxMoveRel(FC,DeltaPos,focuser)
%          % close/open FC.ComObj tcpip object
%          open(FC); close(FC);
% Reliable: 2
%--------------------------------------------------------------------------

classdef FocusController < handle
    properties (SetAccess = public)
        % generic fields
        Status         = false;                         % false - readings are unreliable, true - ok
%        Data           @ stack                          % Stack object containing data history
%        DataCol        = {'JD','FocusPos'};      % Stack object columns
%        DataUnits      = {'day',''};                % Stack object column units
         
        
        % specific fields

%         Focus             = NaN;                        % last Temp
%         FocusUnits        = '';                        % Temp units
%         LastJD            = NaN;                        % JD of last sucessful reading
        
    end
    
    properties (Constant = true)
        
    end
    
    properties (Hidden = true)
        
        Protocol
        Com 
        ComObj 
        RetLine
        FocusStatus
        
    end
    
    
    % Constructor
    methods

        function FC=FocusController(port)
            % TempHumidityDog class constractor
            % Example: FC=obs.focuser.FocusController('/dev/tty.usbserial-OP3BCIFI')

            openLynxSerial(FC, port);

        end
        

    end

    
    % getters/setters
    methods
      
    end
    
    
    % static methods
    methods (Static)
     
    end

    
    methods 
        
        % Open connection

        function openLynxSerial(FC, port)
           if ~exist('port','var'),
              os=computer;
              if strcmp(os(1:5),'PCWIN')
                 port='COM3';
              else
                 port='/dev/ttyUSB0';
              end   
           end
           FC.ComObj=serial(port,'BaudRate',115200,'Timeout',0.5);
                       
           FC.Protocol = 'serial';

           fopen(FC.ComObj);
        end

        function openLynxTCP(FC, address)
           FC.ComObj=tcpip(address,9760);
           fopen(FC.ComObj);

           FC.Protocol = 'TCPIP';

        end

        function open(FC, port)
            % Open tcp/ip connection to WindETH
            openLynxSerial(FC, port);
        end

        function fopen(FC, port)
            % Open tcp/ip connection to WindETH
            openLynxSerial(FC, port);
        end

        
        % Close connection

        function closeLynx(FC)
           fclose(FC.ComObj);
           delete(FC.ComObj)
        end
        
        function close(FC)
            % Close tcp/ip connection to focuser
            closeLynx(FC)
        end
        
        function fclose(FC)
            % Close tcp/ip connection to focuser
            closeLynx(FC)
        end
                
        
        % Get status and information
        
        function info=lynxFocuserStatus(FC,focuser)
           if ~exist('focuser','var'),
              focuser=1;
           end
           info={};
           fprintf(FC.ComObj,sprintf('<F%1dGETSTATUS>',focuser));
           while isempty(info) || (~strcmp(info{end},'END') && ~isempty(info{end}))
              info={info{:},fgetl(FC.ComObj)};
           end
        end
        
        function info=lynxHubInfo(FC)
           info={};
           fprintf(FC.ComObj,'<FHGETHUBINFO>');
           while isempty(info) || (~strcmp(info{end},'END') && ~isempty(info{end}))
              info={info{:},fgetl(FC.ComObj)};
           end
        end
        
        
        % Move focuser

        function lynxMoveAbs(FC,pos,focuser)
            if ~exist('focuser','var'),
               focuser=1;
            end
            fprintf(FC.ComObj,sprintf('<F%1dMA%06d>',focuser,pos));
            if ~(strcmp(fgetl(FC.ComObj),'!') && strcmp(fgetl(FC.ComObj),'M'))
               error('focuser not responding!')
            end
        end

        
        function lynxMoveRel(FC,DeltaPos,focuser)
           if ~exist('focuser','var'),
              focuser=1;
           end

           % Get current location
           info=lynxFocuserStatus(FC,focuser);
           CurrPosCell = info(4);
           CurrPosStr = CurrPosCell{1};
           StrPos = strfind(CurrPosStr, ' = ');
           CurrPos = str2num(CurrPosStr(StrPos+3:end));

           % Move to new absolute location
           lynxMoveAbs(FC,CurrPos+DeltaPos,focuser)
        end
        
    end
    
end
