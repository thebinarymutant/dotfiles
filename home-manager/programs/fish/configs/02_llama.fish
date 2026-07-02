# llama.cpp — local Qwen3.6 MTP server
set -gx LLAMA_CACHE "$HOME/llama_cache"
set -gx LLAMA_PORT 58721

function llama-start
    launchctl kickstart -k "gui/$UID/local.llama-server"
end

function llama-stop
    launchctl bootout "gui/$UID/local.llama-server" 2>/dev/null; or true
end

function llama-restart
    llama-stop; and sleep 1; and llama-start
end

function llama-status
    launchctl print "gui/$UID/local.llama-server"
end

function llama-logs
    tail -f ~/Library/Logs/llama-server.log
end

function llama-pull
    llama-cli \
        -hf unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q6_K \
        --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 \
        --presence-penalty 0.0 --repeat-penalty 1.0 \
        --spec-type draft-mtp --spec-draft-n-max 2 \
        -n 1 -p "download" >/dev/null 2>&1
    echo "Model cached in $LLAMA_CACHE"
end
