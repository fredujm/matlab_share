function h=verticalLabel(x,texte,couleur,style,epaisseur,position,taillep,orient)
% Put a vertical line on the figure (under existing elements).
%
% verticalLabel(x,text,color[,style,width,position,sizef,orient])
%
% Input parameters :
%   x        : abcissa (scalar or vector for more marks).
%   text     : text to display (use %i for display mark number).
%   color    : color, optionnal 'b' by default
%   style    : style '-' ou '--' ou ..., optionnal '-' by default
%   width    : width, optionnal 0.5 by default
%   position : position 'top', 'bottom', optionnal 'top' by default
%   sizef    : font size, optionnal, 10 by default.
%   orient   : orientation 'vert', 'horiz' - vert by default.
%
% Output parameter :
%   h        : handle(s) of lines

% Author                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Mardi 12 Decembre 2017
% Modifications         : Vendredi 19 Janvier 2018 (ajout style epaisseur)
%                         Mercredi 28 Fevrier 2018 (place les lignes sous les elements deja presents)
% Version               : 1.2 i
% Matlab                : MatLab 9.1 (R2016b)

% (c) Frederic BONNARDOT, 2017-2020
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

if nargin>8 || nargin<2
    error('verticalLabel : Too much parameters');
end;

if nargin<8
    orient='vert';
end;

if nargin<7
    taillep=10;
end;

if nargin<6
    position='top';
end;

if nargin<5
    epaisseur=0.5;
end;

if nargin<4
    style='-';
end;

if nargin<3
    couleur='b';
end;

YLim=get(gca,'YLim');
for index=1:length(x)
    h(index)=line(x(index)*[1 1],YLim,'Color',couleur,'LineStyle',style,'LineWidth',epaisseur);
    % Insert the line under the other elements
    chH = get(gca,'Children');
    set(gca,'Children',[chH(2:end);chH(1)]);
    if strcmp(position,'haut') || strcmp(position,'top')
        if strcmp(orient,'vert')
            text(x(index),YLim(2),sprintf(texte,index),'Color',couleur,'HorizontalAlignment','right','VerticalAlignment','Bottom','Rotation',90,'FontSize',taillep);
        else
            text(x(index),YLim(2),sprintf(texte,index),'Color',couleur,'HorizontalAlignment','center','VerticalAlignment','Bottom','Rotation',0,'FontSize',taillep);
        end;
    else
        if strcmp(orient,'vert')
            text(x(index),YLim(1),sprintf(texte,index),'Color',couleur,'HorizontalAlignment','left','VerticalAlignment','Bottom','Rotation',90,'FontSize',taillep);
        else
            text(x(index),YLim(1),sprintf(texte,index),'Color',couleur,'HorizontalAlignment','center','VerticalAlignment','Bottom','Rotation',0,'FontSize',taillep);
        end;
    end;
end;