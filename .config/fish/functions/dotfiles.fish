

# push an existing repository from the command line
# git remote add origin https://github.com/kzha0/dotfiles.git
# git branch -M main
# git push -u origin main

function dotfiles -w git -d "Manages dotfiles"
    set -xa DOTFILES_ID dotfiles
    set -xa DOTFILES_LOCAL_PATH $HOME/Desktop/$DOTFILES_ID
    set subcommand $argv[1]
    set rest_args $argv[2..-1]
    switch $subcommand
        case 'add'
            git --git-dir=$DOTFILES_LOCAL_PATH --work-tree=$HOME add -f $rest_args
        case 'untrack'
            git --git-dir=$DOTFILES_LOCAL_PATH --work-tree=$HOME rm --cached $rest_args
        case 'push'
            git --git-dir=$DOTFILES_LOCAL_PATH --work-tree=$HOME push -u origin main $rest_args
        case '*'
            git --git-dir=$DOTFILES_LOCAL_PATH --work-tree=$HOME $rest_args
    end
end