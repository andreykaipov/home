set autowrite

" in milliseconds
set updatetime=10000

" TODO - opt in to autosaving specific filetypes rather than opting out. don't
" really want to edit something in /etc/, step away from the computer, and bork
" everything.
"
" TODO - look into disabling history and swp files since we're autosaving
"
" We manually issue a BufWritePost event for any autocmds that would listen for
" that to actually mimic a manual `:w`. For example, ALE listens for it to run
" fixers on save.
function! s:AutoSave()
    if &filetype == 'help'
        return
    endif
    silent write
    doautocmd BufWritePost
    echo "autosaved at " . strftime("%H:%M:%S")
endfunction

function! s:ToggleAutoSave()
    if exists('#AutoSave#CursorHold')
        echo 'Disabed autosave'
        augroup AutoSave
            autocmd!
        augroup END
    else
        echo 'Enabled autosave'
        augroup AutoSave
            autocmd!
            autocmd CursorHold,CursorHoldI * :call s:AutoSave()
        augroup END
    endif
endfunction

command! ToggleAutoSave :call s:ToggleAutoSave()
nmap <leader>s :ToggleAutoSave<cr>