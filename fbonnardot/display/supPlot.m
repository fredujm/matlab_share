function li=supPlot (donnees,N,offset,Te,noms,sensNoms,recouvr,echelle)
% Display all signals in one plot.
%
% li=supplot (datas[,N,offset,Ts,names,NameOrientation,overlap,scale])
%
%   the ith signal is between i and i+1 (1st signal i=1).
%
% Input :
%   datas    : data to plot (matrix)
%              1 signal = 1 row
%   N        : last sample to plot (optional)
%   offset   : offset (optional, 0 by default)
%              according to its sign offset is interpreted differently
%                offset > 0 : Display the data beginning at the offset+1
%                               sample
%                offset < 0 : Tell the sample no corresponding to
%                               0 in the x axis
%              if offset is a vector, it will be like
%                [display sample0] (with no sign interpretation)
%   Ts       : Sampling period (optional, 1 by default)
%              or vector corresponding to the abscissas
%   names    : names of the datas (optional, [] by default)
%              if names<>[], the name of the signals is displayed on the left
%              names are cells (1 element=name of the signal)
%                ex. : {'voie A' 'voie B'}
%              if there is more the 20 signals, some name will not be displayed
%   NameOrientation : Orientation of the signals name (optional)
%              'horiz' : horizontal
%              'vert'  : vertical (by default)
%   overlap  : Overlapping between signals (optional)
%                0   by default
%                -1  to superpose the signals
%   scale    : Scale of signals
%              'ind' : each signal have its own scale to fit in the n, n+1 box
%              'glo' : same scale for each signal
%              optionnal, 'ind' by default
%
%   NB : If overlap<>0, the min, max, the grid aren't displayed.
%
% Output :
%   number of signals

% Author                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Jeudi 12 Juillet 2001
% Modifications         : Lundi 23 Juillet 2001
%                         Mardi  5 Fevrier 2002 (recouvrement)
%                         Jeudi 14 Mars    2002 (cellules pour nom)
%                         Lundi 22 Avril   2002 (menu)
%                         Jeudi 25 Avril   2002 (vecteur Te => abscisse)
%                         Mercredi 12 Juin 2002 (offset<0 & offset vecteur)
%                         Lundi 1er Decembre 2003 (limitation du nombre de l?gendes - echelle)
%                         Lundi  6 Fevrier 2006 (recouvrement=-1 => superposition)
%                         Vendredi 18 Novembre 2016 (vers Matlab 9.1)
%                         Wednesday 8 April 2020, adjustements
% Version               : 1.9 i
% Matlab                : MatLab 9.1

% (c) Frederic BONNARDOT, 2001-2020
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


% Verification du nombre de parametres
if nargin==0
   error ('Bad number of parameters, read the help.');
end

[li,col]=size (donnees);

if li>col
    warning ('The number of signals should be inferior to their length, press Ctrl-C to stop.');
    pause(5);
end;

% Parametres optionnel
if nargin<2
   N=col;
elseif N==inf
    N=col;
elseif N>col
   error ('Number of sample per signal to high.');
end;

if nargin<3
   premierechant=1; % Premier echantillon affiche
   position0=1;     % Position du 0 sur l'axe des abscisses
else
   if max(abs(floor (offset)-offset))~=0
      error ('Offset must be an integer.');
   end;
   if length (offset)==2
       premierechant=offset(1)+1;
       position0=offset (2);
   elseif length (offset)==1
       if offset>=0
           premierechant=offset+1;
           position0=1;
       else
           premierechant=1;
           position0=abs(offset);
       end;
   else
       error ('Offset can''t have more than 2 elements.');
   end;
end;

if nargin<4
   Te=1;
elseif length (Te)>1
    % Te est un vecteur, on verifie qu'il a la bonne taille
    if length (Te)~=col
        error ('Ts must have the same size as each signals.');
    end;
elseif (Te<=0)
    error ('Ts must be stricly positive.');
end;

if nargin<5
   noms=[];
else
   if length (noms)<li & isempty (noms)==0
      error ('The last signals don''t have names.');
   end;
end;

if nargin<6
   sensNoms='vert';
end;

if nargin<7
    recouvr=0;
else
    if (abs(recouvr)>=1 | abs(recouvr)<0) & recouvr~=-1
        error ('Overlap must be in [0;1[.');
    end;
end;

if nargin<8
    echelle='ind';
end;

if strcmp (echelle,'glo')
    memeechelle=1;
else
    memeechelle=0;
end;

if recouvr==-1
    memeechelle=1;
end;

% Preleve les signaux a afficher et transpose pour utiliser min et max
temp=donnees(:,premierechant:N)';

% Ajuste les signaux pour qu'il soient dans index*(1-recouvr)+[-0.5;0.5]
maximum=max (temp);
minimum=min (temp);

if memeechelle==1
    % Si on veut la meme echelle pour les signaux
    minimum(:)=min(minimum);
    maximum(:)=max(maximum);
end;

if recouvr~=-1
  for index=1:li;
    if maximum(index)==minimum(index)
       msg='The signal no';
       msg=strcat (msg,int2str(index));
       msg=strcat (msg,' is constant !!!');
       warning (msg);
       temp(:,index)=index*(1-recouvr)+0.5;
     else      
       temp(:,index)=index*(1-recouvr)+0.5+(temp(:,index)-(maximum(index)+minimum(index))/2)/(maximum(index)-minimum(index));
     end  
  end
end;

if length (Te)==1
    % t=(premierechant-1)*Te:1*Te:(N-1)*Te;
    t=(premierechant-position0)*Te:1*Te:(N-position0)*Te;        
else
    t=Te(premierechant:N);
end;

if recouvr~=-1
  % Affiche les 1er et les dernier signaux (pour echelle)
  hold off;
  cla;
  plot (t,temp (:,1),'b',t,temp (:,li),'b')
  % Verrouille la courbe ...
  hold on
  for index=2:li-1
     % ... Pour supperposer les autres signaux
     plot (t,temp(:,index));
  end
  % Deverouille la courbe
  hold off
else
    % On veut supperposer les signaux
    plot (t,temp);
end;

% Affichage grille si pas de recouvrement
%axis ([offset*Te (N-1)*Te 1-recouvr li*(1-recouvr)+1]);
gauche=min (t);
droite=max (t);
borddroit=droite+mean (diff (t));
if recouvr~=-1
    axis ([gauche droite 1-recouvr li*(1-recouvr)+1]);
else
    axis tight;
    noms=[];
end;

handle=gca;
if recouvr==0
    if li>20
        pastick=ceil (li/20);
    else
        pastick=1;
    end;
    set (handle,'YTick',2:pastick:li);
    grid;
end;

% Noms
if ~isempty(noms)
   set (handle,'YTickLabel',[]);
   % Limitation du nombre de legendes a 20
   if li>20
       pasnoms=ceil (li/20);
   else
       pasnoms=1;
   end;
   for index=1:pasnoms:li
         % Cellules 
         nom=noms {index};        
      if strcmp (sensNoms,'vert')
         % handle=text (offset*Te,index*(1-recouvr)+0.5,nom);
         handle=text (gauche,index*(1-recouvr)+0.5,nom);
         set (handle,'Rotation',90,'HorizontalAlignment','Center','VerticalAlignment','Bottom');
      else
         % handle=text (offset*Te,index*(1-recouvr)+0.5,nom);
         handle=text (gauche,index*(1-recouvr)+0.5,nom);
         set (handle,'Rotation',00,'HorizontalAlignment','Right','VerticalAlignment','Middle');       
      end;      
   end;
end;

% Valeur min et max si pas de recouvrement
if recouvr==0 & memeechelle==0 & li<20
    for index=1:li
        texte=num2str (min(donnees(index,premierechant:N)),'%1.2e');
        text (borddroit,index,texte,'Rotation',00,'HorizontalAlignment','Left','VerticalAlignment','Bottom');            
        texte=num2str (max(donnees(index,premierechant:N)),'%1.2e');
        text (borddroit,index+1,texte,'Rotation',00,'HorizontalAlignment','Left','VerticalAlignment','Top');                
    end;
end;

% Options pour impression : a4 paysage
%a4;

figid=gcf;

% Cree le menu SupPlot si pas de recouvrement
if recouvr==0
    supprMenu ('SupPlot');
    supprMenu ('menuPlot');
    supprMenu ('menuImage');
    appelCallBack=['supPlotCallBack___ (' (num2str (figid.Number)) ','];
    spmenu=uimenu ('Label','SupPlot');
        uimenu (spmenu,'Label','Center','Callback',[appelCallBack '''centre'')']);
        uimenu (spmenu,'Label','|FFT| (lin)','Callback',[appelCallBack '''fftlin'')'],'Separator','on');
        uimenu (spmenu,'Label','|FFT| (dB)','Callback',[appelCallBack '''fftdB'')']);
        permenu=uimenu (spmenu,'Label','Periodogram (lin)');
            uimenu (permenu,'Label','256' ,'Callback',[appelCallBack '''psdlin'',256)' ]);
            uimenu (permenu,'Label','512' ,'Callback',[appelCallBack '''psdlin'',512)' ]);
            uimenu (permenu,'Label','1024','Callback',[appelCallBack '''psdlin'',1024)']);
            uimenu (permenu,'Label','2048','Callback',[appelCallBack '''psdlin'',2048)']);        
            uimenu (permenu,'Label','4096','Callback',[appelCallBack '''psdlin'',4096)']);                
        permenudB=uimenu (spmenu,'Label','Periodogram (dB)');
            uimenu (permenudB,'Label','256' ,'Callback',[appelCallBack '''psddB'',256)' ]);
            uimenu (permenudB,'Label','512' ,'Callback',[appelCallBack '''psddB'',512)' ]);
            uimenu (permenudB,'Label','1024','Callback',[appelCallBack '''psddB'',1024)']);
            uimenu (permenudB,'Label','2048','Callback',[appelCallBack '''psddB'',2048)']);        
            uimenu (permenudB,'Label','4096','Callback',[appelCallBack '''psddB'',4096)']);
        if exist('tfrwv')
            tfmenu=uimenu (spmenu,'Label','Time Frequency','Separator','on');
                uimenu (tfmenu,'Label','Wigner Ville Distribution','Callback',[appelCallBack '''tmpfreq'',0)']);        
                uimenu (tfmenu,'Label','Wigner Ville Distribution + threshold [0,Inf]','Callback',[appelCallBack '''tmpfreq'',1)']);
                uimenu (tfmenu,'Label','Wigner Ville Spectrum','Callback',[appelCallBack '''tmpfreq'',2)']);  
        end
        if exist('rcepsnonper')
            uimenu (spmenu,'Label',[('Real cepstrum') ' (-10%,+77%x0,zero padding)'],'Callback',[appelCallBack '''rceps'')'],'Separator','on');
        end
        isolermenu=uimenu (spmenu,'Label','Isolate','Separator','on');        
            for index=li:-1:1
                if isempty (noms)
                    nom=num2str (index);
                else
                    nom=noms {index};
                end;
                uimenu (isolermenu,'Label',nom,'Callback',[appelCallBack '''isoler'',' (num2str (index)) ')']);                
            end;
        enlevermenu=uimenu (spmenu,'Label','Remove','Separator','on');        
            for index=li:-1:1
                if isempty (noms)
                    nom=num2str (index);
                else
                    nom=noms {index};
                end;
                uimenu (enlevermenu,'Label',nom,'Callback',[appelCallBack '''enlever'',' (num2str (index)) ')']);                
            end;
        uimenu (spmenu,'Label','Superpose','Callback',[appelCallBack '''superposer'')']);
        remenu=uimenu (spmenu,'Label','Overlapping');
            for index=1:19
                rec=num2str (index*5);
                uimenu (remenu,'Label',[rec ' %'],'Callback',[appelCallBack '''recouvrir'',0.' rec ')']);                        
            end;
        if memeechelle==0
            uimenu (spmenu,'Label','Same Y scale','Callback',[appelCallBack '''memeechelle'',1)']);
        else
            uimenu (spmenu,'Label','Stretch each signal','Callback',[appelCallBack '''memeechelle'',0)']);            
        end;

    % Enregistre les min et max des courbes
    setappdata (gcf,'mini'    ,minimum);
    setappdata (gcf,'maxi'    ,maximum);
    setappdata (gcf,'Te'      ,Te);
    setappdata (gcf,'noms'    ,noms);
    setappdata (gcf,'sensNoms',sensNoms);
    setappdata (gcf,'echelle' ,echelle);    
end;