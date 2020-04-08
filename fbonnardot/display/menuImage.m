function menuImage (fig,callback,param)
% Create a menu for figure of type image.
%
% menuImage ([fig])
%
% Input :
%   fig      : handle on the figure
%              optional, gcf by default

% menuImage (fig,callback,param)
%
% Callback funtion for the image menu.
%
% Input :
%   fig      : handle on the image figure
%   callback : name of the asking function
%   param    : extra parameters

% Author                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Mercredi 17 Juillet 2002
% Modification          : Wednesday 8 April 2020, adjustements
% Version               : 1.1 i
% Matlab                : MatLab 6.1

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
%                                                     initial after the name)

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
        if isfield (propchild,'CData')
            % L'element est une image
            nbdonnees=nbdonnees+1;
        end;
    end;       
    % Creation du menu
    figid=gcf;
    appelCallBack=['menuImage (' (num2str (figid.Number)) ','];
    mpmenu=uimenu ('Label','menuImage');
        seuilmenu=uimenu (mpmenu,'Label','Threshold [a% max->infinite]');
        for seuil=10:10:90
            uimenu (seuilmenu,'Label',sprintf ('%d %%',seuil),'Callback',[appelCallBack '''seuillage'',' (num2str(seuil)) ')']);
        end;
        seuilmenu=uimenu (mpmenu,'Label','Threshold [0->a% max]');
        for seuil=10:10:90
            uimenu (seuilmenu,'Label',sprintf ('%d %%',seuil),'Callback',[appelCallBack '''seuillage2'',' (num2str(seuil)) ')']);
        end;        
        uimenu (mpmenu,'Label','Log scale','Callback',[appelCallBack '''echelleLog'')']);        
        uimenu (mpmenu,'Label','Mesh','Callback',[appelCallBack '''mesh'')']);        
        fftmenu=uimenu (mpmenu,'Label','|FFT| (lin)','Separator','on');
            uimenu (fftmenu,'Label','2D' ,'Callback',[appelCallBack '''fftlin'',1)']);
            uimenu (fftmenu,'Label','/X' ,'Callback',[appelCallBack '''fftlin'',2)']);
            uimenu (fftmenu,'Label','/Y' ,'Callback',[appelCallBack '''fftlin'',3)']);
        coupemenu=uimenu (mpmenu,'Label','Extract');
            uimenu (coupemenu,'Label','/X' ,'Callback',[appelCallBack '''coupe'',1)']);
            uimenu (coupemenu,'Label','/Y' ,'Callback',[appelCallBack '''coupe'',2)']);
        projmenu=uimenu (mpmenu,'Label','Projection by mean');
            uimenu (projmenu,'Label','sur X' ,'Callback',[appelCallBack '''projection'',1)']);
            uimenu (projmenu,'Label','sur Y' ,'Callback',[appelCallBack '''projection'',2)']);
        cmapmenu=uimenu (mpmenu,'Label','Color map','Separator','on');
            uimenu (cmapmenu,'Label','hsv' ,'Callback',[appelCallBack '''cmap'',''hsv'')']);
            uimenu (cmapmenu,'Label','1-hsv' ,'Callback',[appelCallBack '''cmap'',''nhsv'')']);
            uimenu (cmapmenu,'Label','jet' ,'Callback',[appelCallBack '''cmap'',''jet'')']);
            uimenu (cmapmenu,'Label','1-jet' ,'Callback',[appelCallBack '''cmap'',''njet'')']);
            uimenu (cmapmenu,'Label','gray' ,'Callback',[appelCallBack '''cmap'',''gray'')']);
            uimenu (cmapmenu,'Label','1-gray' ,'Callback',[appelCallBack '''cmap'',''ngray'')']);
        grillemenu=uimenu (mpmenu,'Label','Grid','Callback',[appelCallBack '''grille'')']);  
        uimenu (mpmenu,'Label','Reverse Y axis','Callback',[appelCallBack '''renverserY'')']);        
        uimenu (mpmenu,'Label','fft shift 2D','Callback',[appelCallBack '''fftshift2D'')']);                
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
        if isfield (propchild,'CData')
            % L'element est une image => recupere les donnees
            nbdonnees=nbdonnees+1;
            abscisses {nbdonnees}=propchild.XData;
            ordonnees {nbdonnees}=propchild.YData;
            donnees   {nbdonnees}=propchild.CData;
        end;
    end;
    donnees=donnees {1};
    abscisses=abscisses {1};
    ordonnees=ordonnees {1};
    
    if length (abscisses)==2
        abscisses=linspace (abscisses (1),abscisses (2),size (donnees,2));
    end;
    if length (ordonnees)==2
        ordonnees=linspace (ordonnees (1),ordonnees (2),size (donnees,1));
    end;
    
    % Choix selon la fonction
    switch (callback)
    case 'seuillage'
        figure        
        maxi=max(max(donnees));
        mini=min(min(donnees));        
        seuil=(maxi-mini)*param/100+mini;
        donnees (find (donnees<=seuil))=seuil;
        imagesc (abscisses,ordonnees,donnees);
        menuImage;
    case 'seuillage2'
        figure        
        maxi=max(max(donnees));
        mini=min(min(donnees));        
        seuil=(maxi-mini)*param/100+mini;
        donnees (find (donnees>=seuil))=seuil;
        imagesc (abscisses,ordonnees,donnees);
        menuImage;        
    case 'echelleLog'
        figure       
        donnees=donnees-min(min(donnees));
        donnees=donnees./(max(max(donnees)));
                
        imagesc (abscisses,ordonnees,log(0.1.*donnees+0.0001));
        menuImage;
    case 'mesh'
        figure       
        mesh (abscisses,ordonnees,donnees);
    case 'fftlin'
        figure        
        donnees=donnees-mean(mean (donnees));
        if param==1
            % fft 2D
            donnees=abs(fft2(donnees));
            Te=abscisses(2)-abscisses(1);
            N=length (abscisses);
            abscisses=(1:N)./(N*Te);            
            Te=ordonnees(2)-ordonnees(1);
            N=length (ordonnees);
            ordonnees=(1:N)./(N*Te);                        
        elseif param==2
            % fft /X
            donnees=abs(fft(donnees.').');
            Te=abscisses(2)-abscisses(1);
            N=length (abscisses);
            abscisses=(1:N)./(N*Te);            
        else
            % fft /Y
            donnees=abs(fft(donnees));
            Te=ordonnees(2)-ordonnees(1);
            N=length (ordonnees);
            ordonnees=(1:N)./(N*Te);                        
        end;        
        imagesc (abscisses,ordonnees,donnees);
        menuImage;
    case 'coupe'
        [xe,ye]=ginput (1);  
        t=1:(length (abscisses)-1);
        x=find (abscisses(t)<=xe & abscisses (t+1)>xe);
        if isempty(x)
            x=abscisses(1);
        end;
        t=1:(length (ordonnees)-1);
        y=find (ordonnees(t)<=ye & ordonnees (t+1)>ye);
        if isempty(y)
            y=ordonnees(1);
        end;
        if param==1
            % coupe /X            
            donnees=donnees (y,:);
            titre=sprintf ('Coupe /X - y=%g',ye);
            t=abscisses;
        else
            % coupe /Y
            donnees=donnees (:,x);
            titre=sprintf ('Coupe /Y - x=%g',xe);            
            t=ordonnees;
        end;    
        figure         
        plot (t,donnees);
        title (titre);
        menuPlot;
    case 'projection'
        if param==1
            % projection /X            
            donnees=mean(donnees);
            titre='Projection sur X';
            t=abscisses;
        else
            % projection /Y
            donnees=mean(donnees.').';
            titre='Projection sur Y';            
            t=ordonnees;
        end;    
        figure         
        plot (t,donnees);
        title (titre);
        menuPlot;
    case 'cmap'
        if param(1)=='n'
            colormap (1-feval (param (2:end)));
        else
            colormap (feval (param));    
        end;
    case 'grille'
        if strcmp (grille,'on')
            grille='off';
            grid off;
        else
            grille='on';
        end;
    case 'renverserY'
        handle=get (gca);
        if strcmp (handle.YDir,'reverse')
            set(gca,'YDir','normal');
        else
            set(gca,'YDir','reverse');
        end;
    case 'fftshift2D'
        imagesc(abscisses,ordonnees,fftshift(donnees));
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