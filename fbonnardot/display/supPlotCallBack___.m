function SupPlotCallBack___ (fig,callback,param)
% Callback funtion for the SupPlot menu.
%
% SupPlotCallBack___ (fig,callback)
%
% Input :
%   fig      : handle on the supplot's figure
%   callback : name of the asking function
%   param    : extra parameters

% Auteur                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Lundi 22 Avril 2002
% Modification          : Vendredi 18 Novembre 2016 (vers Matlab 9.1)
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
%                                                     initial after the name)


% Retrouve les donnees sauvegardees dans la figure
minimum  =getappdata (fig,'mini'    );
maximum  =getappdata (fig,'maxi'    );
Te       =getappdata (fig,'Te'      );    
noms     =getappdata (fig,'noms'    );            
sensNoms =getappdata (fig,'sensNoms');        
echelle  =getappdata (fig,'echelle' );        

% Recupere les donnees affichees
propfig=get(fig);
propaxes=get(propfig.CurrentAxes);
% Parcours tous les elements de la figure
nbdonnees=0;
for index=1:length (propaxes.Children)    
    propchild=get(propaxes.Children (index));    
    if isfield (propchild,'YData')
        % L'element est un courbe => recupere les donnees
        nbdonnees=nbdonnees+1;
        donnees (nbdonnees,:)=propchild.YData;
    end;
end;

% Remet les donnees dans l'ordre
data(1,:)=donnees(nbdonnees,:);
if nbdonnees>1
    data(nbdonnees,:)=donnees(nbdonnees-1,:);
end;
for index=2:nbdonnees-1
    data(index,:)=donnees(nbdonnees-index,:);
end;

% Corrige les donnees (moyenne,amplitude)
[li,col]=size (data);
data=data-repmat ((1:nbdonnees).',1,col);
data=data.*repmat ((maximum-minimum)',1,col);
data=data+repmat ((minimum).',1,col);

% Choix selon la fonction
switch (callback)
case 'centre'
    figure
    data=data-repmat (mean (data.').',1,col);
    supPlot (data,col,0,Te,noms,sensNoms,0,echelle);
case 'fftlin'
    figure;
    if length (Te)~=1
        Te=diff (Te);
        Te=mean (Te);
    end;
    supPlot (abs(fft(data.')).',col,0,1/(Te*col),noms,sensNoms,0,echelle);
case 'fftdB'
    figure;
    if length (Te)~=1
        Te=diff (Te);
        Te=mean (Te);
    end;
    supPlot (20*log10(abs(fft(data.'))).',col,0,1/(Te*col),noms,sensNoms,0,echelle);
case 'psdlin'
    figure;
    if length (Te)~=1
        Te=diff (Te);
        Te=mean (Te);
    end;
    for index=1:li
        param=min(param,size(data,2));
        psddata(index,:)=pwelch(data(index,:),param,0).';
        %psddata(index,:)=psd (data(index,:),param).';
    end;
    supPlot (psddata,size (psddata,2),0,1/(Te*param),noms,sensNoms,0,echelle);
case 'psddB'
    figure;
    if length (Te)~=1
        Te=diff (Te);
        Te=mean (Te);
    end;
    for index=1:li
        param=min(param,size(data,2));
        psddata(index,:)=10*log10(pwelch(data(index,:),param,0).');
        %psddata(index,:)=10*log10(psd (data(index,:),param).');
    end;
    supPlot (psddata,size (psddata,2),0,1/(Te*param),noms,sensNoms,0,echelle);
case 'tmpfreq'
    figure
    if length (Te)==1
        Te=(0:(col-1))./Te;
    end;
    if param<2
        spcol=round (sqrt(1.5*li));
        spli=ceil (li/spcol);
        for index=1:li
            subplot (spli,spcol,index);
            [tfr,t,f]=tfrwv(hilbert(data (index,:).'));
            if param
                tfr=seuil0(tfr);
            end;
            imagesc (Te,f,tfr);
            axis xy;
            xlabel ('time');
            ylabel ('frequency');   
            colorbar;              
            if length (noms)~=0
                title (noms {index});
            end;
        end;
    else
        [tfrcum,t,f]=tfrwv(hilbert(data (1,:).'));
        for index=2:li
            [tfr,t,f]=tfrwv(hilbert(data (index,:).'));
            tfrcum=tfrcum+tfr;
        end;
        tfrcum=tfrcum./li;
        imagesc (Te,f,tfr);
        axis xy;
        xlabel ('time');
        ylabel ('frequency');   
        colorbar;         
        menuImage;
    end;
case 'rceps'
    if length (Te)~=1
        Te=diff (Te);
        Te=mean (Te);
    end;
    data=rcepsnonper (data.').';
    figure
    supPlot (data,size (data,2),0,Te,noms,sensNoms,0,echelle);
case 'isoler'
    figure
    if length (Te)==1
        Te=(0:(col-1))./Te;
    end;
    plot (Te,data (param,:));
    grid;
    if isempty (noms)
        title (num2str (param));
    else
        title (noms {param});
    end;
    a4;    
    axis tight;
    grid on;
    menuPlot;
case 'superposer'
    figure
    if length (Te)==1
        Te=(0:(col-1))./Te;
    end;
    plot (Te,data.');    
    grid;
    if ~isempty (noms) & li<20
        legend (noms);
    end;    
    a4;    
    axis tight;
    grid on;
    menuPlot;
case 'recouvrir'
    figure;
    if length (Te)==1
        Te=(0:(col-1))./Te;
    end;
    supPlot (data,col,0,Te,noms,sensNoms,param,echelle);
case 'memeechelle'
    figure;
    if length (Te)==1
        Te=(0:(col-1))./Te;
    end;
    if param==0
        supPlot (data,col,0,Te,noms,sensNoms,0,'ind');
    else
        supPlot (data,col,0,Te,noms,sensNoms,0,'glo');
    end;
case 'enlever'
    figure;
    if length (Te)==1
        Te=(0:(col-1))./Te;
    end;
    data=data([(1:(param-1)) ((param+1):li)],:);
    supPlot (data,col,0,Te,noms,sensNoms,0,echelle);
otherwise
    error ([callback ' : Unknown callback function.']);
end;
