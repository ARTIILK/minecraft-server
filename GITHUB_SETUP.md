# GitHub SSH Setup Guide

This guide will help you set up SSH authentication with GitHub and push your Minecraft server configuration.

## Step 1: Generate SSH Key (if you don't have one)

```bash
# Generate a new SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# When prompted:
# - Press Enter to accept default file location (~/.ssh/id_ed25519)
# - Enter a passphrase (optional but recommended)

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your SSH key to the agent
ssh-add ~/.ssh/id_ed25519

# Display your public key (copy this)
cat ~/.ssh/id_ed25519.pub
```

## Step 2: Add SSH Key to GitHub

1. Go to GitHub.com and sign in
2. Click your profile photo → **Settings**
3. In the sidebar, click **SSH and GPG keys**
4. Click **New SSH key**
5. Give it a title (e.g., "Minecraft Server")
6. Paste your public key (from `cat ~/.ssh/id_ed25519.pub`)
7. Click **Add SSH key**

## Step 3: Test SSH Connection

```bash
ssh -T git@github.com
```

You should see:
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

## Step 4: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `minecraft-server` (or your choice)
3. Description: "Optimized Minecraft Server with Crossplay Support"
4. Choose **Private** (recommended) or Public
5. **DO NOT** initialize with README (we already have one)
6. Click **Create repository**

## Step 5: Push to GitHub

```bash
# Navigate to the backup directory
cd /root/minecraft-server-backup

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Optimized Minecraft server with crossplay support"

# Add GitHub as remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin git@github.com:YOUR_USERNAME/minecraft-server.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 6: Verify Upload

Go to your GitHub repository URL:
```
https://github.com/YOUR_USERNAME/minecraft-server
```

You should see all your configuration files!

## Cloning on Another Server

To download and use this configuration on another server:

```bash
# Clone the repository
git clone git@github.com:YOUR_USERNAME/minecraft-server.git
cd minecraft-server

# Run setup script
chmod +x setup.sh
sudo ./setup.sh
```

## Updating the Repository

When you make changes to your server configuration:

```bash
cd /root/minecraft-server-backup

# Copy updated configs
cp /opt/minecraft/server.properties config/
cp /opt/minecraft/config/*.yml config/
# ... copy other changed files

# Commit and push changes
git add .
git commit -m "Updated server configuration"
git push
```

## Troubleshooting

### Permission denied (publickey)

If you get this error:
```bash
# Check if SSH key is loaded
ssh-add -l

# If not, add it
ssh-add ~/.ssh/id_ed25519

# Test connection again
ssh -T git@github.com
```

### Repository already exists

If the repository already exists on GitHub:
```bash
# Just add remote and push
git remote add origin git@github.com:YOUR_USERNAME/minecraft-server.git
git push -u origin main
```

### Large files error

If you get errors about large files:
```bash
# Make sure .gitignore is working
git rm --cached -r world/
git rm --cached *.jar
git commit -m "Remove large files"
git push
```

## Security Notes

⚠️ **IMPORTANT**: This repository does NOT include:
- World data (too large)
- Player data (privacy)
- Banned/ops lists (security)
- Plugin databases (privacy)
- Server JAR files (licensing)

These are excluded via `.gitignore` for security and size reasons.

## Next Steps

After pushing to GitHub:
1. Add a description to your repository
2. Add topics/tags (minecraft, paper, geyser, crossplay)
3. Consider making it public to help others
4. Star the repository for easy access

---

**Need Help?**
- GitHub SSH Docs: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- Git Basics: https://git-scm.com/book/en/v2/Getting-Started-Git-Basics
