" Dated Backup Plugin
" =========================================================================
" Author:     LiosK <contact@mail.liosk.net>
" Version:    v1.0.3 (20151212)
" Licence:    The MIT Licence
" Copyright:  Copyright (c) 2009-2015 LiosK.
" =========================================================================

" include guard
if !&backup || exists('loaded_ddbackup')
  finish
endif
let loaded_ddbackup = 1

" prepare root backupdir
let s:bdir = '~/.vim_backup'
if &backupdir != ''
  let s:pos  = stridx(&backupdir, ',')
  let s:bdir = (s:pos < 0) ? &backupdir : strpart(&backupdir, 0, s:pos)
endif
if !isdirectory(s:bdir) && !(exists('*mkdir') && mkdir(s:bdir, 'p', 0700))
  echoerr 'ddbackup.vim: error: cannot make the backup directory'
  finish  " do nothing when the root backupdir is not available
endif

" define handler
let s:original_bex = &backupext
function s:BackupHandler()
  if exists('b:ddbackup_bex')
    let &backupext = s:original_bex
  else
    let b:ddbackup_bex = strftime('-%Y%m%dT%H%M%S.bak')
    let &backupext     = b:ddbackup_bex

    " use monthly backupdir if possible
    let l:bdir = s:bdir . strftime('/%Y%m')
    if isdirectory(l:bdir) || (exists('*mkdir') && mkdir(l:bdir, 'p'))
      let &backupdir = l:bdir
    else
      let &backupdir = s:bdir
    endif
  endif
endfunction

" register handler
autocmd BufWritePre * call s:BackupHandler()

" vim: tabstop=2 shiftwidth=2
