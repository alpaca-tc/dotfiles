# This checks if the current branch is ahead of or behind the remote branch with which it is tracked.

# Source lib to get the function get_tmux_pwd
source "${TMUX_POWERLINE_DIR_HOME}/lib/tmux_adapter.sh"

other_symbol="⋯ "

run_segment() {
  tmux_path=$(get_tmux_cwd)

  cd "$tmux_path"
  stats=""
  if [ -n "${git_stats=$(__parse_git_stats)}" ]; then
    stats="$git_stats"
  elif [ -n "${svn_stats=$(__parse_svn_stats)}" ]; then
    stats="$svn_stats"
  elif [ -n "${hg_stats=$(__parse_hg_stats)}" ]; then
    stats="$hg_stats"
  fi
  echo "${git_stats}aaa"
  return 1

  if [[ -n "$stats" && $stats -gt 0 ]]; then
      echo "${other_symbol}${stats}"
  else
      git_dir=$(git rev-parse --git-dir 2> /dev/null)
      if [ $git_dir != 0 ]; then
          echo "${other_symbol}"
      else
          echo ""
      fi
  fi
  return 0
}

__parse_git_stats(){
  # check if git
  # [[ -z $(git rev-parse --git-dir 2> /dev/null) ]] && return

  # return the number of staged items
  other=$(git ls-files --others --exclude-standard | wc -l)
  return $other
  # echo $other
}
__parse_hg_stats(){
  type svn >/dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    return
  fi
  # not yet implemented
}
__parse_svn_stats(){
  type hg >/dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    return
  fi
  # not yet implemented
}
