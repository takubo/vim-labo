vim9script

import autoload "./submode.vim"

call submode#enter_with('HorizScroll', 'n', '', 'zj', '<c-e>')
call submode#enter_with('HorizScroll', 'n', '', 'zk', '<c-y>')
call submode#map(       'HorizScroll', 'n', '', 'j',  '<c-e>')
call submode#map(       'HorizScroll', 'n', '', 'k',  '<c-y>')
