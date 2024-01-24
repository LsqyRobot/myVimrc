function! MyCompletionFunction(lead, cmdline, cursorpos)
  let completions = ['reprintf', 'lsqyRobot']
  let matches = filter(completions, 'v:val =~ "^" . a:lead')
  return matches
endfunction
