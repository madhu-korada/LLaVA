#!/bin/bash

# Kill previous session
tmux kill-session

# Create a new tmux session
session_name="llava_gradio_sess_$(date +%s)"
tmux new-session -d -s $session_name

tmux set -g mouse on

# Split the window into three panes
tmux selectp -t 0    # select the first (0) pane
tmux splitw -v -p 50 # split it into two halves
tmux selectp -t 0    # go back to the first pane
tmux splitw -h -p 50 # split it into two halves
tmux selectp -t 2    # go back to the first pane
tmux splitw -h -p 50 # split it into two halves

# Run the controller
tmux select-pane -t 0
tmux send-keys "llava" Enter
tmux send-keys "python -m llava.serve.controller --host 0.0.0.0 --port 10000" Enter

# Run the gradio web server.
tmux select-pane -t 1
tmux send-keys "llava" Enter
tmux send-keys 'sleep 5 && python -m llava.serve.gradio_web_server --controller http://localhost:10000 --model-list-mode reload' Enter

# Run the SGLang worker
tmux select-pane -t 2
tmux send-keys "llava" Enter
tmux send-keys "sleep 10 && CUDA_VISIBLE_DEVICES=0 python3 -m sglang.launch_server --model-path liuhaotian/llava-v1.5-7b --tokenizer-path llava-hf/llava-1.5-7b-hf --port 30000" Enter

# Run the model worker
tmux select-pane -t 3
tmux send-keys "llava" Enter
tmux send-keys "python -m llava.serve.sglang_worker --host 0.0.0.0 --controller http://localhost:10000 --port 40000 --worker http://localhost:40000 --sgl-endpoint http://127.0.0.1:30000"

# Attach to the tmux session
tmux -2 attach-session -t $session_name


