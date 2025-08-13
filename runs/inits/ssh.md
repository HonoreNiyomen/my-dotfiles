1. Check for existing SSH keys
$ ls -al ~/.ssh

2. Generate a new SSH key (if needed) - Ed25519 (modern and secure)
$ ssh-keygen -t ed25519 -C "your_email@example.com"

3. Start the SSH agent
$ eval "$(ssh-agent -s)"

4. Add your SSH key to the agent (or ~/.ssh/id_rsa if you used RSA)
$ ssh-add ~/.ssh/id_ed25519

5. Copy the public key
$ cat ~/.ssh/id_ed25519.pub

6. To test the connection
$ ssh -T git@github.com
