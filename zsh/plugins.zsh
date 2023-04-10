#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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 zplug
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 非同期処理できるようになる
zplug "mafredri/zsh-async"

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "agkozak/zsh-z"
# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zplug "zsh-users/zsh-autosuggestions"
# 補完強化
zplug "zsh-users/zsh-completions"
# 256色表示にする
zplug "chrissicool/zsh-256color"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "BurntSushi/ripgrep"

zplug "junegunn/fzf"

zplug "Aloxaf/fzf-tab"

zplug "zdharma-continuum/fast-syntax-highlighting", as:theme



# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load
