" vim-plug list
call plug#begin('~/.vim/plugged')

Plug 'jnurmine/Zenburn' " color theme
Plug 'tpope/vim-sensible' " common settings
Plug 'scrooloose/syntastic' " syntax checking
Plug 'jpalardy/vim-slime' " REPL
" Python specific
Plug 'tmhedberg/SimpylFold' " better folding for Python
Plug 'vim-scripts/indentpython.vim' " indentation for Python
" OCaml specific
" Plug 'OCamlPro/ocp-indent' " indentation for OCaml
" Plug 'ocaml/merlin' " autocompletion for OCaml

call plug#end()

" apply color scheme
colorscheme zenburn

" line numbers
set nu

" make new lines and stay in normal mode
nmap <CR> o<Esc>

" syntastic settings
let g:syntastic_ocaml_checkers = ['merlin']

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## ddd405160dfd33f5e80e75bbb993f69b ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/home/sytrus/.opam/system/share/vim/syntax/ocp-indent.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
