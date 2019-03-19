if not set -q __fish_prompt_hosname
  set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
end

function fish_right_prompt
  set_color blue
  echo $__fish_prompt_hostname
  set_color normal
end
