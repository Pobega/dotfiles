set fish_greeting # Quiet!
set fish_prompt_pwd_dir_length 4 # Longer directory

function fish_prompt
  set last_status $status

  set_color green
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  set_color normal
end
