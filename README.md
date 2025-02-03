# AI on Android
**Use AI models locally on your Android device using Ollama.**

## Description
This project provides a script to install AI models (Deepseek-R1:1.5B & Qwen2.5:0.5B) locally on Android devices using Ollama. It sets up the necessary environment through Termux, allowing users to install and run AI models independently, without relying on cloud services.

## Installation

### 1. Install Termux from F-Droid
Follow these steps to install Termux on your Android device:
1. Open [F-Droid](https://f-droid.org/packages/com.termux/) on your Android device.
2. Download the Termux APK.
3. Install the APK on your device.
4. Open Termux.

### 2. Run Installation Script
Execute the following command to download and run the installation script, which automates the setup process for running AI models on your device:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/kamrulhasanio/ai-on-android/main/AIM-installer.sh)
```

## Usage

Once the installation is complete, you can run AI models directly from your Android device using Ollama in Termux. Here's how to use your AI model:

1. Start Ollama by running the command:

    ```bash
    start_ollama
    ```

2. Once Ollama is running, you can execute your installed AI models:
    - For Qwen:

        ```bash
        ollama run qwen2.5:0.5b
        ```

    - For DeepSeek:

        ```bash
        ollama run deepseek-r1:1.5b
        ```

## Credits
- The Ollama installation script is sourced from the [ollama-termux](https://github.com/ollama-termux) repository.
- ChatGPT was used to assist in creating the Redme file and for some logic within the scripts.