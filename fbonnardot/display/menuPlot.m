function menuPlot (fig,callback,param)
% Create a menu for figure of type plot.
%
% menuPlot ([fig])
%
% Input :
%   fig      : handle on the plot's figure
%              optional, gcf by default

% menuPlot (fig,callback,param)
%
% Callback funtion for the plot menu.
%
% Input :
%   fig      : handle on the plot figure
%   callback : name of the asking function
%   param    : extra parameters

% Author                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Mardi 23 Avril 2002
%                         Mercredi 29 Mai 2002 (remplacement diff(Te)~=0 par >=eps)
% Modification          : Vendredi 18 Novembre 2016 (Matlab 9.1)
%                         Wednesday 8 April 2020, adjustements
% Version               : 1.2 i
% Matlab                : MatLab 9.1

% (c) Frederic BONNARDOT, 2002-2020
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Affero General Public License for more details.
% 
% You should have received a copy of the GNU Affero General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
% 
% This code is given as is without warranty of any kind.
% In no event shall the authors or copyright holder be liable for any claim
%                                                    damages or other liability.
% 
% If you change or adapt this function, change its name (for example add your
%  

if nargin<2
    % Pas d'argument => cree le menu
    % Compte le nombre de courbes
    if ~nargin
        fig=gcf;
    end;
    supprMenu ('menuImage',fig);
    supprMenu ('SupPlot',fig);
    supprMenu ('menuPlot',fig);
    propfig=get(fig);    
    propaxes=get(propfig.CurrentAxes);
    grille=propaxes.XGrid;
    % Parcours tous les elements de la figure
    nbdonnees=0;
    for index=1:length (propaxes.Children)    
        propchild=get(propaxes.Children (index));    
        if isfield (propchild,'YData')
            % L'element est un courbe
            nbdonnees=nbdonnees+1;
        end;
    end;       
    % Creation du menu
    figid=gcf;
    appelCallBack=['menuPlot (' (num2str (figid.Number)) ','];
    mpmenu=uimenu ('Label','menuPlot');
        uimenu (mpmenu,'Label','Center','Callback',[appelCallBack '''centre'')']);
        uimenu (mpmenu,'Label','|FFT| (lin)','Callback',[appelCallBack '''fftlin'')'],'Separator','on');
        uimenu (mpmenu,'Label','|FFT| (dB)','Callback',[appelCallBack '''fftdB'')']);
        permenu=uimenu (mpmenu,'Label','Periodogram (lin)');
            uimenu (permenu,'Label','256' ,'Callback',[appelCallBack '''psdlin'',256)' ]);
            uimenu (permenu,'Label','512' ,'Callback',[appelCallBack '''psdlin'',512)' ]);
            uimenu (permenu,'Label','1024','Callback',[appelCallBack '''psdlin'',1024)']);
            uimenu (permenu,'Label','2048','Callback',[appelCallBack '''psdlin'',2048)']);        
            uimenu (permenu,'Label','4096','Callback',[appelCallBack '''psdlin'',4096)']);                
        permenudB=uimenu (mpmenu,'Label','Periodogram (dB)');
            uimenu (permenudB,'Label','256' ,'Callback',[appelCallBack '''psddB'',256)' ]);
            uimenu (permenudB,'Label','512' ,'Callback',[appelCallBack '''psddB'',512)' ]);
            uimenu (permenudB,'Label','1024','Callback',[appelCallBack '''psddB'',1024)']);
            uimenu (permenudB,'Label','2048','Callback',[appelCallBack '''psddB'',2048)']);        
            uimenu (permenudB,'Label','4096','Callback',[appelCallBack '''psddB'',4096)']);  
        if exist('tfrwv')       
            tfmenu=uimenu (mpmenu,'Label','Time Frequency','Separator','on');
                uimenu (tfmenu,'Label','Wigner Ville Distribution','Callback',[appelCallBack '''tmpfreq'',0)']);        
                uimenu (tfmenu,'Label','Wigner Ville Distribution + threshold [0,Inf]','Callback',[appelCallBack '''tmpfreq'',1)']);                    
        end;
        if exist('rcepsnonper')
            uimenu (mpmenu,'Label',[('Real cepstrum') ' (-10%,+77%x0,zero padding)'],'Callback',[appelCallBack '''rceps'')'],'Separator','on');
        end;
        isolermenu=uimenu (mpmenu,'Label','Isolate','Separator','on');        
            for index=1:nbdonnees
                nom=num2str (index);
                uimenu (isolermenu,'Label',nom,'Callback',[appelCallBack '''isoler'',' (num2str (index)) ')']);                
            end;
        grillemenu=uimenu (mpmenu,'Label','Grid','Callback',[appelCallBack '''grille'')']);  
        transferer=uimenu (mpmenu,'Label','To workspace','Callback',[appelCallBack '''transferer'')']);  
else
    % Retrouve les donnees sauvegardees dans la figure

    % Recupere les donnees affichees
    propfig=get(fig);
    propaxes=get(propfig.CurrentAxes);
    grille=propaxes.XGrid;
    % Parcours tous les elements de la figure
    nbdonnees=0;
    for index=1:length (propaxes.Children)    
        propchild=get(propaxes.Children (index));    
        if isfield (propchild,'YData')
            % L'element est un courbe => recupere les donnees
            nbdonnees=nbdonnees+1;
            abscisses {nbdonnees}=propchild.XData;
            donnees   {nbdonnees}=propchild.YData;
            couleur   {nbdonnees}=propchild.Color;
            style     {nbdonnees}=propchild.LineStyle; 
            marqueur  {nbdonnees}=propchild.Marker; 
        end;
    end;   
    
    % Choix selon la fonction
    switch (callback)
    case 'centre'
        figure
        hold on
        for index=nbdonnees:-1:1
            plot (abscisses {index},donnees {index}-mean (donnees{index}), ...
                  'Color',couleur {index},'LineStyle',style {index}, ...
                  'Marker',marqueur {index});
        end;
        hold off
        menuPlot;
    case 'fftlin'
        figure
        hold on
        for index=nbdonnees:-1:1
            N=length (abscisses {index});            
            Te=diff (abscisses {index});
            if find (diff (Te)>eps)
                warning ('FFT work only on uniform sampled data.');
            end;
            plot ((0:N-1)/(N*Te(1)),abs(fft(donnees {index})), ...
                  'Color',couleur {index},'LineStyle',style {index}, ...
                  'Marker',marqueur {index});
        end;
        hold off
        menuPlot;
    case 'fftdB'
        figure
        hold on
        for index=nbdonnees:-1:1
            N=length (abscisses {index});
            Te=diff (abscisses {index});            
            if find (abs(diff (Te))>eps)
                warning ('FFT work only on uniform sampled data.');
            end;
            plot ((0:N-1)/(N*Te(1)),20*log10(abs(fft(donnees {index}))), ...
                  'Color',couleur {index},'LineStyle',style {index}, ...
                  'Marker',marqueur {index});
        end;
        hold off
        menuPlot;
    case 'psdlin'
        figure
        hold on
        for index=nbdonnees:-1:1
            N=length (abscisses {index});            
            Te=diff (abscisses {index});            
            if find (abs(diff (Te))>eps)
                warning ('psd work only on uniform sampled data.');
            end;            
            param=min(param,length(donnees {index}));
            %[Pxx,F]=psd(donnees {index},param,1/Te(1));
            [Pxx,F]=pwelch(donnees {index},param,0,[],1/Te(1));
            plot (F,Pxx, ...
                  'Color',couleur {index},'LineStyle',style {index}, ...
                  'Marker',marqueur {index});
        end;
        hold off
        menuPlot;
    case 'psddB'
        figure
        hold on
        for index=nbdonnees:-1:1
            N=length (abscisses {index});            
            Te=diff (abscisses {index});            
            if find (abs(diff (Te))>eps)
                warning ('psd work only on uniform sampled data.');
            end;   
            param=min(param,length(donnees {index}));
            %[Pxx,F]=psd(donnees {index},param,1/Te(1));
            [Pxx,F]=pwelch(donnees {index},param,0,[],1/Te(1));
            plot (F,10*log10(Pxx), ...
                  'Color',couleur {index},'LineStyle',style {index}, ...
                  'Marker',marqueur {index});
        end;
        hold off
        menuPlot;
    case 'tmpfreq'
        if nbdonnees==1
            figure
            [tfr,t,f]=tfrwv(hilbert(donnees {index}.'));
            if param
                tfr=seuil0(tfr);
            end;
            imagesc (t,f,tfr);
            axis xy;
            xlabel ('time');
            ylabel ('frequency');   
            colorbar;
            menuImage();
        else
            warning ('You must use only one curve in order to use time frequency.');
        end;
    case 'rceps'
        figure
        hold on
        for index=nbdonnees:-1:1
            Te=diff (abscisses {index});            
            col=length (abscisses {index});                        
            if find (abs(diff (Te))>eps)
                warning ('rceps work only on uniform sampled data.');
            end;            
            data=rcepsnonper (donnees {index});
            N=length (data);                        
            plot ((0:N-1).*Te(1),data, ...
                  'Color',couleur {index},'LineStyle',style {index}, ...
                  'Marker',marqueur {index});
        end;
        hold off
        menuPlot;
    case 'isoler'
        figure
        hold on
        param=nbdonnees-param+1;
        plot (abscisses {param},donnees {param}, ...
                  'Color',couleur {param},'LineStyle',style {param}, ...
                  'Marker',marqueur {param});
        hold off
        menuPlot;
    case 'grille'
        if strcmp (grille,'on')
            grille='off';
            grid off;
        else
            grille='on';
        end;
    case 'transferer'
        assignin('base','mp',donnees);
        disp ('Plot in variable mp.');
    otherwise
        error ([callback ' : Unknown callback function.']);
    end;
    if strcmp (grille,'on')
        grid;
    end;
    axis tight
    a4;
end;