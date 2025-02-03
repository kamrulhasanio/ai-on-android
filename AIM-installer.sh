#!/data/data/com.termux/files/usr/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

is_ollama_running() {
    pgrep -x ollama >/dev/null
}

install_ollama() {
    echo "Installing Ollama..."
    wget https://github.com/kamrulhasanio/ai-on-android/blob/main/ollama-installer.sh
    bash ollama-installer.sh
    rm ollama-installer.sh

    if command_exists ollama; then
        echo "✅ Ollama installed successfully."
    else
        echo "❌ Error: Ollama installation failed. Exiting..."
        exit 1
    fi
}

is_model_installed() {
    ollama list | grep -q "$1"
}

install_model() {
    local model_name=$1
    echo "Installing model: $model_name..."
    if ollama pull "$model_name"; then
        echo "✅ Model $model_name installed successfully."
    else
        echo "❌ Error: Failed to install $model_name. Exiting..."
        exit 1
    fi
}

setup_aliases() {
    echo "Setting up aliases..."
    ALIAS_FILE="$HOME/.bashrc"
    sed -i '/alias start_ollama=/d' "$ALIAS_FILE"
    sed -i '/alias qwen=/d' "$ALIAS_FILE"
    sed -i '/alias deepseek=/d' "$ALIAS_FILE"

    {
        echo "alias start_ollama='nohup ollama serve > ollama.log 2>&1 &'"
        if [[ "$selected_model" == "qwen2.5:0.5b" ]]; then
            echo "alias qwen='ollama run qwen2.5:0.5b'"
        elif [[ "$selected_model" == "deepseek-r1:1.5b" ]]; then
            echo "alias deepseek='ollama run deepseek-r1:1.5b'"
        fi
    } >> "$ALIAS_FILE"

    source "$ALIAS_FILE"
    echo "✅ Aliases set up successfully and applied."
}

if command_exists ollama; then
    echo "✅ Ollama is already installed."
else
    install_ollama
fi

if is_ollama_running; then
    echo "✅ Ollama is already running."
else
    echo "Starting Ollama..."
    nohup ollama serve > ollama.log 2>&1 &
    sleep 2
    if is_ollama_running; then
        echo "✅ Ollama started successfully."
    else
        echo "❌ Error: Failed to start Ollama. Exiting..."
        exit 1
    fi
fi

model_installed=""
if is_model_installed "deepseek-r1:1.5b"; then
    model_installed="deepseek-r1:1.5b"
elif is_model_installed "qwen2.5:0.5b"; then
    model_installed="qwen2.5:0.5b"
fi

if [[ -n "$model_installed" ]]; then
    echo "A model ($model_installed) is already installed."
    echo "1) Use existing model"
    echo "2) Install a new model"
    read -p "Enter your choice (1/2): " choice
    if [[ "$choice" == "1" ]]; then
        selected_model="$model_installed"
    else
        model_installed=""
    fi
fi

if [[ -z "$model_installed" ]]; then
    echo "Select a model to install:"
    echo "1) deepseek-r1:1.5b"
    echo "2) qwen2.5:0.5b"
    read -p "Enter your choice (1/2): " model_choice

    if [[ "$model_choice" == "1" ]]; then
        selected_model="deepseek-r1:1.5b"
    elif [[ "$model_choice" == "2" ]]; then
        selected_model="qwen2.5:0.5b"
    else
        echo "❌ Invalid option. Exiting..."
        exit 1
    fi

    install_model "$selected_model"
fi

setup_aliases

echo "✅ Installation complete! Here’s how to use it:"
echo ""
echo "1️⃣ Start Ollama:   start_ollama"
echo "2️⃣ Run AI Model:"

if [[ "$selected_model" == "qwen2.5:0.5b" ]]; then
    echo "   - Use 'qwen' to start the Qwen model."
elif [[ "$selected_model" == "deepseek-r1:1.5b" ]]; then
    echo "   - Use 'deepseek' to start the DeepSeek model."
fi

echo "🎉 Enjoy your AI experience!"
