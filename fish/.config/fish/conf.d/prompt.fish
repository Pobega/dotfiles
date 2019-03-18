set fish_greeting # Quiet!
set fish_prompt_pwd_dir_length 4 # Longer directory

for f in $fish_function_path/git.fish
    test -e $f; and source $f; and break
end                   

function fish_prompt
  set last_status $status

  set_color green
  printf '%s' (prompt_pwd)
  set_color normal

  set_git_color
  printf '%s ' (__fish_git_prompt)

  set_color normal
end
