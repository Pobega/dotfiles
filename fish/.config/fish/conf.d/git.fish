# Source fish git prompt functions if it exists
for f in $fish_function_path/__fish_git_prompt.fish
    test -e $f; and source $f; and break
end

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream 1

set -g __fish_git_prompt_char_dirtystate "?"
set -g __fish_git_prompt_char_untrackedfiles "!"

# https://github.com/oh-my-fish/oh-my-fish/blob/master/lib/git/git_is_repo.fish
function git_is_repo -d "Check if directory is a repository"
  test -d .git; or command git rev-parse --git-dir >/dev/null 2> /dev/null
end

#function set_git_color --on-event fish_prompt
#  if git_is_repo
#    # Branch colors ordered by priority
#    if (__fish_git_prompt_dirty)           # Dirty
#      set -g __fish_git_prompt_color_branch red --bold
#    else if (__fish_git_prompt_untracked)  # Untracked
#      set -g __fish_git_prompt_color_branch red
#    else if (__fish_git_prompt_staged)     # Staged
#      set -g __fish_git_prompt_color_branch purple
#    else                                   # Clean
#      set -g __fish_git_prompt_color_branch green --bold
#    end
#  end
#end
