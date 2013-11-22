let s:PM = vital#of('.vim').import('ProcessManager')

function! alpaca#system#new(command) "{{{
  return s:Watch.new(a:command)
endfunction"}}}

let s:Watch = {
      \ 'instances' : {}
      \ }
function! s:Watch.new(command) "{{{
  let instance = copy(self)
  call remove(instance, 'new')
  call instance.constructor(a:command)

  return instance
endfunction"}}}

function! s:Watch.do_callback(callback_name) "{{{
  " do something
endfunction"}}}

function! s:Watch.constructor(command) "{{{
  let self.pid        = s:PM.new(a:command)
  let s:Watch.instances[self.pid] = self
  let self.command    = a:command
endfunction"}}}

function! s:Watch.read() "{{{
  try
    call s:PM.status(self.pid)
  catch "^ProcessManager doesn't know about.*"
    return [
          \ get(self, 'stdout_all', ''),
          \ get(self, 'stderr_all', ''),
          \ get(self, 'status', 'not_exists')]
  endtry

  let [self.stdout, self.stderr, self.status] = s:PM.read(self.pid, [''])
  let self.stdout_all .= self.stdout
  let self.stderr_all .= self.stderr

  return [self.stdout_all, self.stderr_all, self.status]
endfunction"}}}

function! s:Watch.done() "{{{
  call alpaca#print_message('Done!!! ' . self.command)
  call remove(s:Watch.instances, self.pid)
  call self.do_callback('done')
  call s:PM.stop(self.pid)
endfunction"}}}

function! s:Watch.in_process() "{{{
  call alpaca#print_message(self.command . '...')
endfunction"}}}

function! s:Watch.destroy() "{{{
  call alpaca#print_error('Timeout: ' . self.command)
  call remove(s:Watch.instances, self.pid)
  call s:PM.stop(self.pid)
endfunction"}}}

" Watching process for sync
function! s:check_status() "{{{
  if empty(s:Watch.instances)
    return 0
  endif

  for pid in keys(s:Watch.instances)
    let instance = s:Watch.instances[pid]
    let status = s:PM.status(pid)

    if status == 'active'
      call instance.in_process()
    elseif status == 'inactive'
      call instance.done()
    elseif status == 'timeout'
      call instance.destroy()
    endif
  endfor
endfunction"}}}

function! s:start_watching() "{{{
  if exists('s:loaded_start_watching')
    return
  endif
  let s:loaded_start_watching = 1

  augroup AlpacaSystem
    autocmd!
    autocmd CursorHold,CursorHoldI * call s:check_status()
    autocmd VimLeavePre * call alpaca#system#killall()
  augroup END
endfunction"}}}
call s:start_watching()

function! alpaca#system#killall() "{{{
  let pids = keys(s:Watch.instances)
  let s:Watch.instances = {}
  for pid in pids
    call s:PM.stop(pid, 2)
  endfor

  echomsg '[AlpacaSystem] Kill process: ' . join(pids, ', ')
endfunction"}}}
