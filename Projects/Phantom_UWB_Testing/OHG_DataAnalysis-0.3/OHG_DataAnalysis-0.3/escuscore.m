function newstr = escuscore( str)
% newstr = escuscore( str) - escape underscore chars with backslashes.
%   This is useful to keep the underscores from causing subscripting in
%   e.g. plot titles.
%   If 'str' is a cell array, returns a cell array of processed strings.
% Input:
%   str: a string (or cell array) in which to look for underscores.
% Output:
%   newstr: the input string (or cell array) with underscores prepended
%   with backslashes
  
% Revision History
% 07apr03 bpw: added handling of cell arrays of strings
% 03feb03 bpw: Initial version
  
  % Check for cell array
  if iscell( str)
    newstr = {};
    for k = 1:prod( size( str))
      newstr{k} = escuscore( str{k});
    end
    return
  end

  % Find the relevant spots
  uaddr = findstr( str, '_');
  la = length( uaddr);
  
  if ( la > 0)
    for k = 1:la
      m = la - k + 1;			% work from the back forward
      ta = uaddr(m);			% this address
      str = [str(1:(ta-1)), '\_', str( (ta+1):end)];
    end
  end
  
  newstr = str;
  
  return
end