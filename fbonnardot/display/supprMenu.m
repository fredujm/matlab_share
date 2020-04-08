function supprMenu (nom,fig)
% Suppress a menu in a figure.
%
% supprMenu (name[,fig])
%
% Input :
%   name     : name of the menu
%   fig      : handle on the figure
%              optional, gcf by default

% Author                : (c) Frederic BONNARDOT, AGPL-3.0-or-later license
% Creation              : Jeudi 18 Juillet 2002
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


% Controle des parametres
if nargin<1 | nargin>2
    error ('Bad number of parameters.');
end;

if nargin<2
    fig=gcf;
end;

% Suppression du menu
propfig=get (fig);
for index=length (propfig.Children):-1:1
    fils=get (propfig.Children (index));
    if strcmp (fils.Type,'uimenu')
       if strcmp (fils.Label,nom)
           delete (propfig.Children (index));
       end;
   end;
end;
