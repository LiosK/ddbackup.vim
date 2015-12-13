" Dated Backup Plugin
" =========================================================================
" Author:     LiosK <contact@mail.liosk.net>
" Version:    v2.0.0
" Licence:    The MIT Licence
" Copyright:  Copyright (c) 2009-2015 LiosK.
" =========================================================================

" include guard
if !&backup || exists('loaded_ddbackup')
  finish
endif
let loaded_ddbackup = 1

" create directory if not exists
function s:UseDir(name, perm)
  if isdirectory(a:name)
    return 1
  elseif !exists('*mkdir') || !mkdir(a:name, 'p', a:perm)
    return 0
  endif
  if has('unix')
    " workaround for sudo
    call system('chown `logname` ' . shellescape(a:name))
  endif
  return 1
endfunction

" prepare root backupdir
let s:bdir = '~/.vim_backup'
if &backupdir != ''
  let s:pos  = stridx(&backupdir, ',')
  let s:bdir = (s:pos < 0) ? &backupdir : strpart(&backupdir, 0, s:pos)
endif
if !s:UseDir(s:bdir, 0700)
  echoerr 'ddbackup.vim: error: cannot make the backup directory'
  finish  " do nothing when the root backupdir is not available
endif

" define handler
function s:BackupHandler()
  " use per-directory backupdir if possible
  let l:bdir = s:bdir . '/' . expand('%:p:h:gs?[/\\]?%?')
  let &backupdir = s:UseDir(l:bdir, 0700) ? l:bdir : s:bdir

  " keep original and minutely backups
  let &backupext = strftime('-%Y%m%dT%H%M~')
  if !exists('b:ddbackup_original_saved')
    let &backupext = strftime('-%Y%m%dT%H%M%S~')
    let b:ddbackup_original_saved = 1
  endif
endfunction

" register handler
autocmd BufWritePre * call s:BackupHandler()

" vim: tabstop=2 shiftwidth=2
