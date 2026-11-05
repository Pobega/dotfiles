.PHONY: stow
stow:
	stow aider bash git mutt nvim nanocoder tmux vim
	stow --no-folding agy

.PHONY: quadlets
quadlets:
	stow quadlets
