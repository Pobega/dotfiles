# Source fish git prompt functions if it exists
for f in $fish_function_path/__fish_git_prompt.fish
    test -e $f; and source $f; and break
end

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream 1

set -g __fish_git_prompt_color_dirtystate red
set -g __fish_git_prompt_color_stagedstate purple
set -g __fish_git_prompt_color_stashstate yellow
set -g __fish_git_prompt_color_untrackedfiles red
set -g __fish_git_prompt_color_upstream green

set -g __fish_git_prompt_char_dirtystate "?"
set -g __fish_git_prompt_char_untrackedfiles "!"

function in_git_prompt
  if string match -q -- "*$argv[1]*" $git_prompt
    return 0
  end
  return 1
end

# https://github.com/oh-my-fish/oh-my-fish/blob/master/lib/git/git_is_repo.fish
function git_is_repo -d "Check if directory is a repository"
  test -d .git; or command git rev-parse --git-dir >/dev/null 2> /dev/null
end

function set_git_colors
  set -g __fish_git_prompt_color_branch $argv
end

function set_git_color
  set -l git_prompt (__fish_git_prompt)
  if git_is_repo
    # Branch colors ordered by priority
    if in_git_prompt "?"       # Dirty
      set_git_colors red
    else if in_git_prompt "!"  # Untracked
      set_git_colors blue
    else if in_git_prompt "+"  # Staged
      set_git_colors purple
    else                       # Clean
      set_git_colors green
    end
  end
end
