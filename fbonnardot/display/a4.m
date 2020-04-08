function a4 (orientation,handle)
% Set the printing parameter of a figure.
%
% a4 ([orientation,handle])
%
% Input :
%   orientation : 'portrait' or 'landscape'
%                 (optionnal landscape by defaut)
%   handle      : handle of the figure (cf. gcf)
%                 (optionnal, current figure by default)

% Author                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Lundi 23 Juillet 2001
% Modification          : Samedi 6 Avril   2002
%                         Wednesday 8 April 2020, adjustements
% Version               : 1.2 i
% Matlab                : MatLab 5

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


% Verification parametres
if nargin<1
   orientation='paysage';
else
   if ~strcmp (orientation,'paysage') & ~strcmp (orientation,'portrait') & ~strcmp (orientation,'landscape')
      error ('Bad value for orientation.');
   end;
end;

if nargin<2
   handle=gcf;
end;

if strcmp (orientation,'paysage') | strcmp (orientation,'landscape')
   set (handle,'PaperOrientation','landscape','PaperPosition',[0.25 0.25 11.1929 7.76772],'PaperPositionMode','manual','PaperType','a4letter','PaperUnits','inches');
   set (handle,'PaperOrientation','landscape','PaperPosition',[0.25 0.25 11.1929 7.76772],'PaperPositionMode','manual','PaperType','a4letter','PaperUnits','inches');   
else
   set (handle,'PaperOrientation','portrait','PaperPosition',[0.25 0.25 7.76772 11.1929],'PaperPositionMode','manual','PaperType','a4letter','PaperUnits','inches');
   set (handle,'PaperOrientation','portrait','PaperPosition',[0.25 0.25 7.76772 11.1929],'PaperPositionMode','manual','PaperType','a4letter','PaperUnits','inches');   
end;