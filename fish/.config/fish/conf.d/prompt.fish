set fish_greeting # Quiet!
set fish_prompt_pwd_dir_length 4 # Longer directory

if not set -q hostname
  set -g hostname (command hostname)
end

set -g local_color (command echo -n $hostname | sha1sum | cut -c1-6)

for f in $fish_function_path/git.fish
    test -e $f; and source $f; and break
end

function fish_prompt
  set last_status $status

  # At sign color set based on hash of hostname
  set_color $local_color
  printf '%s' $hostname

  set_color normal
  printf ':'

  set_color green
  printf '%s ' (prompt_pwd)
  set_color normal
end
