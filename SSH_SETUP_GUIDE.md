# Step-by-Step Guide: SSH Connection & User Setup on Google Cloud

This guide will help you connect to your Google Cloud VM using your existing SSH key and set up a dedicated user.

## 1. Get Your Public Key
Since you already have a key on your PC, you need to find the **Public Key** file (usually ending in `.pub`) to share with Google Cloud.

**To view your public key content:**

Option 1: **PowerShell**
```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

Option 2: **Git Bash (MINGW64)**
```bash
cat ~/.ssh/id_ed25519.pub
```

**Copy the entire output** (it starts with `ssh-ed25519` and ends with your computer name/email).

## 2. Add Key to Google Cloud
1.  Go to **Google Cloud Console** > **Compute Engine**.
2.  In the left menu, assume **Settings** > **Metadata**.
3.  Click **"SSH Keys"** tab > **Edit** > **Add Item**.
4.  Paste the public key you copied.
5.  Click **Save**.
    *(Google will show you the `username` it created next to the key. Note this down!)*

## 3. Connect to the Server
Open **PowerShell** or **Git Bash** and run:

```bash
# Syntax: ssh -i <path_to_private_key> <gcp_username>@<vm_external_ip>
ssh -i ~/.ssh/id_ed25519 username@YOUR_VM_EXTERNAL_IP
```

*Note: `<gcp_username>` is usually the username associated with the key (e.g., `ubuntu` or your google account name).*

## 3. Create "pommauser" (On Server)
Once logged in, perform these steps to create the user for the application deployment.

1.  **Create the user**:
    ```bash
    sudo adduser dayon
    # Enter a strong password when prompted (e.g., 'pommapass')
    # Press Enter for other details
    ```

2.  **Grant Sudo Access** (Optional, but recommended for Setup):
    ```bash
    sudo usermod -aG sudo pommauser
    ```

3.  **Setup SSH for New User** (Optional):
    If you want to log in directly as `pommauser` later:
    ```bash
    sudo mkdir -p /home/dayon/.ssh
    sudo cp ~/.ssh/authorized_keys /home/pommauser/.ssh/
    sudo chown -R pommauser:pommauser /home/pommauser/.ssh
    sudo chmod 700 /home/pommauser/.ssh
    sudo chmod 600 /home/pommauser/.ssh/authorized_keys
    ```

## 5. Deployment Preparation
Now that you are connected, follow the earlier deployment instructions:

```bash
# Switch to the new user
su - pommauser

# Clone Repository
git clone https://github.com/teqmatessolutions-gif/pomma-latest.git /opt/pomma
# (You might need sudo for /opt permissions first)
```
