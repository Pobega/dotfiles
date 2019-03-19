# Source fish git prompt functions if it exists
for f in $fish_function_path/__fish_git_prompt.fish
    test -e $f; and source $f; and break
end

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1

set -g __fish_git_prompt_color_dirtystate red
set -g __fish_git_prompt_color_stagedstate purple
set -g __fish_git_prompt_color_stashstate blue
set -g __fish_git_prompt_color_untrackedfiles yellow

set -g __fish_git_prompt_char_dirtystate "?"
set -g __fish_git_prompt_char_untrackedfiles "!"

function in_git_prompt -d "Check if argv[1] is in the git_prompt"
  if string match -q -- "*$argv[1]*" $git_prompt
    return 0
  end
  return 1
end

function is_clean_upstream -d "True if we match upstream"
  if string match -q -- "=" (__fish_git_prompt_show_upstream)
    return 0
  end
  return 1
end

# https://github.com/oh-my-fish/oh-my-fish/blob/master/lib/git/git_is_repo.fish
function is_git_repo -d "Check if directory is a repository"
  test -d .git; or command git rev-parse --git-dir >/dev/null 2> /dev/null
end

function set_git_color
  if is_git_repo
    set -g git_prompt (__fish_git_prompt)
    # Branch colors ordered by priority
    if in_git_prompt "\?"
      set -g __fish_git_prompt_color_branch $__fish_git_prompt_color_dirtystate
    else if in_git_prompt "!"
      set -g __fish_git_prompt_color_branch $__fish_git_prompt_color_untrackedfiles
    else if in_git_prompt "+"
      set -g __fish_git_prompt_color_branch $__fish_git_prompt_color_stagedstate
    else if is_clean_upstream
      set -g __fish_git_prompt_color_branch green --bold
    else
      set -g __fish_git_prompt_color_branch green
    end
  end
end
