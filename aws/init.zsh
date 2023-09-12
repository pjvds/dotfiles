if ! type "aws_completer" &> /dev/null; 
then
    warn "aws_completer could not be found"
    return
fi
