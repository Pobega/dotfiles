set fish_greeting

function fish_prompt
  set last_status $status

  set_color green
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  set_color normal
end
