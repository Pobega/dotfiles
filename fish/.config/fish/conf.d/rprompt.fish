if not set -q __fish_prompt_hosname
  set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
end

function fish_right_prompt
  printf '%s' (git_prompt)
end
