# https://github.com/fish-shell/fish-shell/issues/602#issuecomment-470805514
function reverse_history_search
  history | fzf --no-sort | read -l command
  if test $command
    commandline -rb $command
  end
end

function fish_user_key_bindings
  bind \cr reverse_history_search
end
