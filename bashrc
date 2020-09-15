#!/bin/bash

export PATH="$HOME/bin:$HOME/.settings/bin:$HOME/local/bin:$PATH"

# kubernetes

alias k="kubectl"

alias kg="kubectl get"
alias kgp="kubectl get pod"
alias kgd="kubectl get deployment"
alias kgs="kubectl get svc"
alias kgn="kubectl get nodes"
alias kgpa="kubectl get pods --all-namespaces"

alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe svc"
alias kdn="kubectl describe nodes"

alias kp="kubectl proxy"
alias kpall="kubectl proxy --address='0.0.0.0' --accept-hosts='.*'"

alias kaf="kubectl apply -f"
alias kaff="kubectl apply -f - <<EOF"
alias kdelf="kubectl delete -f"

alias kgc="kubectl config get-contexts"
alias kuc="kubectl config use-context"
 
alias klog-alb='kubectl logs -n kube-system $(kubectl get po -n kube-system | egrep -o 'alb-ingress[a-zA-Z0-9-]+')'
alias klog-edns='kubectl logs $(kubectl get po | egrep -o 'external-dns-[a-zA-Z0-9-]+')'


alias kc=kubectx
alias kn=kubens

alias g="git"
alias gaa="git add -A"
alias gf="git fetch -n"
alias gp="git pull --ff-only"
alias gs="git status"
alias gl="git l -10"
alias gd="git diff"
alias gdh="git diff HEAD"

alias gcm="git add -A && git commit -m"
alias gacm="git add -A && git commit -m"
alias gam="git commit --amend"
alias gacgam="git add -A && git commit --amend"

alias gpus="git push --set-upstream origin \$(git rev-parse --abbrev-ref HEAD)"
alias gpul="git pull --ff-only"
alias gpull="git pull --rebase"

alias gstart="git checkout -b"

# bashrc



reload-bash() {
  if [ -f ~/.bash_profile ]; then
      source ~/.bash_profile
  elif [ -f ~/.bashrc ]; then
      source ~/.bashrc
  fi
}

alias vib="vi ~/.settings/bashrc"
alias vig="vi ~/.settings/gitconfig"

. ~/.settings/kube-ps1.sh

if [ -f "/etc/bash_completion.d/git-prompt" ]; then
  . /etc/bash_completion.d/git-prompt
fi

#_git_ps1() {
#  if [ "$(git rev-parse --is-inside-work-tree 2>&1)" = "true" ]; then
#    echo -e "(\e[34m"$(git rev-parse --abbrev-ref HEAD)"\e[0m )"
#  else
#    echo ""
#  fi
#}
ps1-kube() {
  PS1='\h $(kube_ps1) \w> '
  export _PS1_TYPE=kube
}
ps1-min() {
  PS1='\h \w> '
  export _PS1_TYPE=git
}
ps1-git() {
  PS1='\h\e[34m$(__git_ps1)\e[35m \w> \e[0m'
  export _PS1_TYPE=git
}

if [ "$_PS1_TYPE" = "git" ]; then
  ps1-git
elif [ "$_PS1_TYPE" = "kube" ]; then
  ps1-kube
elif [ "$_PS1_TYPE" = "min" ]; then
  ps1-min
else
  ps1-git 
fi


docker-tags() {
    arr=("$@")

    for item in "${arr[@]}";
    do
        tokenUri="https://auth.docker.io/token"
        data=("service=registry.docker.io" "scope=repository:$item:pull")
        token="$(curl --silent --get --data-urlencode ${data[0]} --data-urlencode ${data[1]} $tokenUri | jq --raw-output '.token')"
        listUri="https://registry-1.docker.io/v2/$item/tags/list"
        authz="Authorization: Bearer $token"
        result="$(curl --silent --get -H "Accept: application/json" -H "Authorization: Bearer $token" $listUri | jq --raw-output '.')"
        echo $result
    done
}

