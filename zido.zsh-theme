# Characters
GEARS='\uf085'
GIT_BRANCH='\uf418'
GIT_BRANCH_CHECK='\Uf14cf'
GIT_BRANCH_PLUS='\Uf14ca'
GIT_BRANCH_MINUS='\Uf14cb'
GIT_BRANCH_CROSS='\Uf14cc'
GIT_BRANCH_REFRESH='\Uf14cd'
GIT_BRANCH_SYNC='\Uf14ce'
GIT_STASH='\Uf003c'
ROOT_USER='\uedc8'

RET_INDICATOR='\uf060'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_THEME_GIT_PROMPT_DIRTY='\Uf14cc'
ZSH_THEME_GIT_PROMPT_CLEAN='\uf418'

# ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE='\Uf01fc'                   # Equal
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE='\Uf005d'                     # Ahead
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE='\Uf0045'                    # Behind
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE='\Uf0e79'                  # Diverged

ZSH_THEME_GIT_PROMPT_UNTRACKED='\Uf086f'  # file question       # Untracked
ZSH_THEME_GIT_PROMPT_ADDED='\Uf0752'      # file plus           # Unstaged (Added)
ZSH_THEME_GIT_PROMPT_MODIFIED='\Uf11e7'   # file pencil         # Unstaged (Modified)
ZSH_THEME_GIT_PROMPT_RENAMED='\Uf0ab9'    # file arrow (moved)  # Unstaged (Renamed)
ZSH_THEME_GIT_PROMPT_DELETED='\Uf0b98'    # file cross          # Unstaged (Deleted)
ZSH_THEME_GIT_PROMPT_STASHED='\Uf003c'    # archive box         # Stashed
ZSH_THEME_GIT_PROMPT_UNMERGED='u'
# ZSH_THEME_GIT_PROMPT_AHEAD='a'
# ZSH_THEME_GIT_PROMPT_BEHIND='b'
# ZSH_THEME_GIT_PROMPT_DIVERGED='d'

ZSH_THEME_GIT_PROMPT_REMOTE_MISSING='\Uf048f'                  # Remote missing

# Uncommitted ?? (dirty)
# Conflicts
# Stashed
# Clean/Dirty
# Detached ???
# Merge / Rebase / Cherrypick

git_status_icons() {
  echo "$(_omz_git_prompt_status)$(git_prompt_remote)" | sed 's/./ &/g'
}

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local current_branch=$(git_current_branch)
  [[ -n "$current_branch" ]] || return 0
  echo "${ZSH_THEME_GIT_PROMPT_PREFIX} $(git_remote_status) ${GIT_BRANCH} ${current_branch}$(git_status_icons)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}
autoload -U colors && colors

jobs_status() {
  echo "%(1j.%{$fg[cyan]%}$GEARS %b.)"
}

user_status() {
    echo "%(#.$ROOT_USER .)"
}

venv_status() {
  if [ "$VIRTUAL_ENV" != "" ]; then
    echo "%{$fg[blue]%}(venv: $(basename $(dirname $VIRTUAL_ENV)))%b  "
  fi
}

proc_status() {
  echo "%(?..%{$fg[red]%}%B%? $RET_INDICATOR%b) "
}

host_status() {
  echo "%{$fg[magenta]%}($(hostname)) "
}

pwd_status() {
  echo "%B%{$fg[cyan]%}%5~% "
}

lang_status() {
  typeset -A PROJECTS=(
    [Cargo.toml]='\ue68b'
    [Makefile.txt]='\ue673'
    [Makefile]='\ue673'
    [makefile]='\ue673'
    [requirements.txt]='\ue73c'
    [requirement.txt]='\ue73c'
    [package.json]='\uf2ef'
    [tsconfig.json]='\ue69d'
    [CMakeLists.txt]='\ue794'
    [build.sbt]='\ue68e'
    [pubspec.yaml]='\ue7dd'
    [build.gradle]='\ue660'
  )
  local total=""

  for key value in ${(kv)PROJECTS}; do
    if [[ -f "$key" ]]; then
      total+="$value "
    fi
  done

  echo "%B%{$fg[magenta]%}$total%b"
}

setopt PROMPT_SUBST

precmd() {
  PROMPT="$(host_status)$(user_status)$(pwd_status)$(git_custom_status) >%b "
  RPROMPT="$(proc_status)$(lang_status)$(venv_status)$(jobs_status)"
}
