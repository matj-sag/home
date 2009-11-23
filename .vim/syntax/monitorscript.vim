" Vim syntax file
" Language:	MonitorScript
" Maintainer:	Mark Raynes (mraynes@progress.com)
" Last Change:	30/07/2007

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" Keywords:
syn keyword msExternal  	package
syn keyword msBoolean  		false true
syn keyword msStatement		as on all action wait return monitor event import returns route emit to wildcard call spawn die enqueue print log at in within unmatched completed currentTime from select in using retain batch within partition by join in where group having istream rstream into generates aggregate every
syn keyword msOpertaor  	new not and xor equals
syn keyword msRepeat		while for do break continue
syn keyword msConditional	if then else
syn keyword msType		integer string boolean float sequence dictionary stream

" Strings and characters:
syn region msString		start=+"+  skip=+\\\\\|\\"+  end=+"+
syn region msString		start=+'+  skip=+\\\\\|\\'+  end=+'+

" Numbers:
syn match msNumber		"-\=\<\d*\.\=[0-9_]\>"

" Comments:
syn match msCommentCharacter contained "'\\[^']\{1,6\}'"
syn match msCommentCharacter contained "'\\''"
syn match msCommentCharacter contained "'[^\\]'"
syn region msComment start="/\*"  end="\*/" contains=msCommentCharacter,msNumber
syn region msComment start="//" skip="\\$" end="$" contains=msCommentCharacter,msNumber

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ms_syn_inits")
  if version < 508
    let did_ms_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink msExternal 	Include
  HiLink msBoolean 	Boolean
  HiLink msStatement 	Statement
  HiLink msOpertaor 	Operator
  HiLink msRepeat 	Repeat
  HiLink msConditional 	Conditional
  HiLink msType 	Type
  HiLink msString 	String
  HiLink msNumber 	Number
  HiLink msComment 	Comment

  delcommand HiLink
endif

let b:current_syntax = "monitorscript"

" vim: ts=8
