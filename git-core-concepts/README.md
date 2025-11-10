# Git Refresher Class Notes

## Introduction: The Story of Git and GitHub

### The Chaos Before Version Control

In the early days of software development, teams faced significant challenges:
- Files shared via email with confusing names like "app_final_v3_really_final_final.py"
- No way to track which version was the latest
- One developer's fixes overwriting another's features
- Complete chaos and confusion

### What is SCM?

**SCM stands for Source Code Management** - it helps teams collaborate on code safely.

There are three types of SCM:

| Type | Where the Code Lives | Example |
|------|---------------------|---------|
| **Local SCM** | Only on your computer | Old-school tools like RCS |
| **Remote SCM** | Central server everyone connects to | Subversion (SVN) |
| **Distributed SCM** | Each developer has the full copy of history | Git |

**Git is distributed** - everyone has a full history of the project. You can work even offline.

## Comparison of Repository Types

| Aspect | Local Repositories | Remote Repositories | Distributed Repositories |
|--------|-------------------|---------------------|-------------------------|
| **Collaboration** | No collaboration - only accessible to one user or machine | Enables team collaboration via a central server | Full collaboration - every user has a complete copy of the repo |
| **Community & Ecosystem Support** | Lacks ecosystem integration and third-party tools | Integrated with platforms like GitHub, GitLab, Bitbucket | Same ecosystem benefits as remote, plus offline flexibility |
| **Storage Requirements** | High disk space usage (full history on one system) | Centralized storage - less local usage | Optimized across nodes - each user stores full but manageable copies |
| **Dependency Management** | Hard to manage or share dependencies | Easier with centralized dependency control | Easier - distributed package managers and sync mechanisms |
| **Availability & Reliability** | Reduced - data loss if local machine fails | Dependent on remote server uptime | Highly available - each copy acts as a backup |
| **Scalability** | Difficult to scale for large teams or projects | Scales but needs powerful central infrastructure | Scales naturally - peer-to-peer replication |
| **Maintenance Overhead** | High - manual backups, versioning, and cleanup | Centralized maintenance, but needs monitoring | Low - self-healing through distributed nodes |
| **Performance** | Very fast (local operations) | Slower - every operation involves network latency | Fast for local operations; syncs asynchronously |
| **Network Dependency** | None - fully offline | Network trips required for all operations | Works offline; syncs only when needed |
| **Backup & Recovery** | Manual backups required | Centralized backups needed | Built-in redundancy (every clone is a backup) |
| **Blocking Operations** | None (everything local) | Possible during network or server delays | Non-blocking - local commits independent of network |

**Overall Summary:**
- **Local:** Simple but isolated and hard to manage
- **Remote:** Centralized, collaborative but network-dependent
- **Distributed:** Best of both worlds - collaboration + offline capability

## Installing Git

### For RHEL/CentOS:
```bash
sudo su
yum update
yum install git
```

### For Ubuntu/Debian:
```bash
apt update -y
apt install git
```

### Verify Installation:
```bash
git --version
```

## Configuring Git

Before you start using Git, you need to configure your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor "vim"
```

**Key Points:**
- `--global` sets configuration for all repositories on your system
- Without `--global`, configuration applies only to the current repository
- Every commit you make will bear your signature

### View Configuration:
```bash
git config --list                    # List all config
git config --global user.name        # View a particular config
```

## SSH Setup for GitHub

To share code with GitHub securely without entering passwords, set up SSH keys:

### Generate SSH Key:
```bash
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
```

### Add Public Key to GitHub:
1. Copy the public key: `cat ~/.ssh/id_rsa.pub`
2. Go to GitHub Settings → SSH and GPG keys
3. Click "New SSH key" and paste your public key

Your computer is now trusted by GitHub's servers - no password needed for push/pull operations.

## GitHub Account and Repository Setup

1. Create an account on [https://github.com](https://github.com)
2. Create a new repository (e.g., "demo-project")
3. Choose whether to initialize with README, .gitignore, or license

## The Four Key Areas in Git

Git operates through four distinct areas:

| Area | Also Called | Description | Example Command |
|------|-------------|-------------|-----------------|
| **Working Tree** | "Workspace" | The actual files and folders you're editing on your machine. These are not yet tracked until staged. | `git status` shows modified/untracked files |
| **Staging Area** | "Index" or "Cache" | A middle area where you prepare files for the next commit (a preview of what will be committed). | `git add file.txt` moves it here |
| **Local Repository** | ".git directory" | The database on your local machine storing commits, branches, and history. | `git commit` saves changes here |
| **Remote Repository** | "Origin" (commonly) | A server-hosted copy (e.g., GitHub, GitLab) for collaboration and backups. | `git push` / `git pull` sync changes |

### The Git Workflow:
```
Working Tree → git add → Staging Area → git commit → Local Repo → git push → Remote Repo
```

## Starting a Git Project

### Initialize a Local Repository:
```bash
mkdir demo
cd demo
git init
```

This creates a hidden `.git` folder - your local repository database.

### Check Status:
```bash
git status
```

Shows the state of your working tree and staging area.

## Basic Git Operations

### Creating and Tracking Files:
```bash
touch Abc.txt
touch Xyz.txt
git status                    # Shows untracked files
```

### Staging Files:
```bash
git add Abc.txt               # Stage a single file
git add .                     # Stage all files in current directory
git add -A                    # Stage all changes (including deletions)
git add -p                    # Interactively stage hunks
```

**What happens:** When you stage a file, Git creates a hash object in `.git/objects/` - this is Git's way of storing file snapshots.

### Committing Changes:
```bash
git commit -m "Learn git commit"
```

**What happens:** Git creates commit objects in `.git/objects/` - each commit is a snapshot of your project at a moment in time.

### Viewing Changes:
```bash
git diff                      # Shows unstaged changes (working tree vs staging area)
git diff --cached             # Shows staged changes (staging area vs last commit)
git diff --staged             # Same as --cached
git diff <commitA> <commitB>  # Show diffs between commits, branches, or tags
```

## Connecting to Remote Repository

### Add Remote:
```bash
git remote add origin git@github.com:username/repo-name.git
```

### View Remotes:
```bash
git remote -v                 # Show configured remotes and URLs
```

### Push to Remote:
```bash
git push origin main          # Push to remote (first time)
git push -u origin main       # Push and set upstream (for future pulls)
```

**Note:** Until you push, everything happens locally - no internet needed for init, add, commit operations.

## Cloning a Repository

To get a copy of an existing repository:

```bash
git clone git@github.com:username/repo-name.git
```

This creates an exact copy with all commits, branches, and history.

## Viewing Status & Differences

### Status:
```bash
git status                    # Show changed files and state of working tree and index
```

### Differences:
```bash
git diff                      # Show unstaged changes (working tree vs index)
git diff --staged             # Show staged changes (index vs last commit)
git diff <commitA> <commitB>  # Show diffs between commits, branches, or tags
```

### Commit History:
```bash
git log                       # Show commit history (linear)
git log --oneline --graph --decorate --all    # Compact visual commit graph
git show <commit>             # Show details and patch for a commit
git blame <file>              # Annotate file lines with commit info
git shortlog -s -n            # Summarize commits by author
```

## Staging & Committing

### Staging:
```bash
git add file.txt              # Stage a file (working tree → index)
git add -p                    # Interactively stage hunks
git add .                     # Stage all changed files in current directory
git add -A                    # Stage all changes (including deletions)
git restore --staged file.txt # Unstage a file (move from index back to working tree)
```

### Committing:
```bash
git commit -m "Short message"              # Create a commit from staged changes
git commit --amend                         # Amend the last commit
git commit -v                              # Show diff in editor when composing commit message
git commit --allow-empty -m "empty commit" # Create an empty commit (useful for triggers)
```

## Branching & Switching

### Branch Operations:
```bash
git branch                    # List local branches
git branch -a                 # List all branches (local + remote)
git branch feature/x          # Create a branch (does not switch)
git checkout feature/x        # Switch to branch (legacy)
git switch feature/x          # Switch to branch (modern recommended)
git switch -c feature/y       # Create and switch to a new branch
git branch -d feature/old     # Delete a branch (only if fully merged)
git branch -D feature/old      # Force-delete branch (use carefully)
```

### Merging:
```bash
git merge feature/x           # Merge named branch into current branch
git merge --no-ff feature/x   # Force merge commit even if fast-forward possible
```

### Rebasing:
```bash
git rebase master             # Rebase current branch onto master
git rebase -i HEAD~5          # Interactive rebase to squash, reorder, or edit last 5 commits
git rebase --abort            # Abort an interrupted rebase
git rebase --continue         # Continue an interrupted rebase
```

## Remote Repositories

### Remote Operations:
```bash
git remote -v                 # Show configured remotes and URLs
git remote add origin <url>   # Add a remote named origin
git fetch origin              # Fetch updates from remote (no merge)
git pull                      # Fetch + merge (equivalent to git fetch + merge)
git pull --rebase             # Fetch and rebase local commits onto fetched branch
git push origin feature/x     # Push a branch to remote
git push -u origin feature/x  # Push and set upstream
git push --force-with-lease origin feature/x    # Force-push safely
git push --tags               # Push tags to remote
git remote set-url origin <url>    # Change remote URL
git ls-remote origin          # Show remote refs without fetching
```

## Tags & Releases

```bash
git tag v1.0.0                # Create lightweight tag
git tag -a v1.0.0 -m "release 1.0.0"    # Create an annotated tag (recommended)
git show v1.0.0              # Show tag details and commit
git push origin v1.0.0       # Push a tag to remote
git push origin --tags       # Push all tags
```

## Stashing

Stashing allows you to temporarily save uncommitted changes:

```bash
git stash                     # Stash uncommitted changes
git stash push -m "WIP: experiment"    # Push stash with a message
git stash list                # List stashes
git stash show -p stash@{0}   # Show diff of a stash
git stash apply stash@{0}     # Reapply stash but keep it in stash list
git stash pop                 # Reapply stash and remove it from stash list
git stash drop stash@{0}      # Remove one stash
git stash clear               # Clear all stashes
```

## Undoing & History Rewriting

**Use these commands carefully:**

```bash
git revert <commit>           # Create a new commit that undoes <commit> (safe)
git reset --soft HEAD~1      # Move HEAD back but keep changes staged
git reset --mixed HEAD~1     # Default: move HEAD back and unstage changes
git reset --hard HEAD~1      # Move HEAD back and discard all changes (destructive)
git reflog                    # Show history of HEAD movement (useful to recover lost commits)
git cherry-pick <commit>      # Apply the changes from <commit> onto current branch
```

## Searching & Selecting Commits/Files

```bash
git grep "TODO"               # Search working tree for text
git log --grep="fix memory leak"    # Search commit messages
git log -S"functionName"      # Find commits that added/removed specific string
git log --pretty=format:"%h %an %ad %s" --date=short    # Custom commit log format
git bisect start              # Binary search to find bad commit
git bisect bad HEAD
git bisect good v1.0
```

## Git Hooks

Hooks are scripts inside `.git/hooks/` executed on events.

### Common Hooks:
- `pre-commit` - Run before commit
- `pre-push` - Run before push
- `commit-msg` - Validate commit message
- `post-receive` - Server-side hook after receiving push

### Example:
```bash
chmod +x .git/hooks/pre-commit
# Edit .git/hooks/pre-commit to add linting, tests, etc.
```

## Ignore Files & Attributes

### .gitignore:
```bash
echo "node_modules/" >> .gitignore
echo "*.log" >> .gitignore
git status --ignored          # Show ignored files
git check-ignore -v path/to/file    # Show which .gitignore rule matches
```

### .gitattributes:
```bash
echo "*.bak filter=clean" > .gitattributes
# Use for EOL handling, filters, or export settings
```

## Git LFS (Large File Storage)

For large binary files:

```bash
git lfs install
git lfs track "*.psd"
git add .gitattributes
```

## Safety & Best Practices

```bash
git fetch --all --prune       # Fetch all remotes and prune deleted remote branches
git branch --merged           # See merged branches
git branch --no-merged        # See unmerged branches
git remote show origin        # Get useful info about tracking branches
git config pull.rebase false  # Configure pull behavior
git config pull.rebase true
git config pull.ff only
```

## Example Workflows

### Typical Feature Branch Workflow:
```bash
git checkout -b feature/awesome
# make changes
git add .
git commit -m "Implement awesome feature"
git push -u origin feature/awesome
# open pull request on remote
```

### Rebase Workflow Before Merging:
```bash
git checkout feature/awesome
git fetch origin
git rebase origin/main
# resolve conflicts, if any, then
git push --force-with-lease origin feature/awesome
```

### Merge via Fast-Forward or Merge Commit:
```bash
git checkout main
git pull origin main
git merge --no-ff feature/awesome
git push origin main
```

### Squash Commits Before Merging:
```bash
git checkout feature/awesome
git rebase -i origin/main
# in editor: squash commits into one
git push --force-with-lease
```

## Getting Help

### Detailed Help:
```bash
man git                       # Full manual
```

### Concise Help:
```bash
git add -h                    # Quick summary of command syntax
git <command> --help          # Help for specific command
```

## The Circle of Git Life

Here's the complete cycle:

1. **Working Tree:** Edit files locally
2. **Staging Area:** `git add` to prepare changes
3. **Local Repository:** `git commit` to save snapshot
4. **Remote Repository:** `git push` to share with others
5. **Pull Updates:** `git pull` to get others' changes

This cycle repeats endlessly - code evolves, commits grow, and collaboration thrives.

## Summary

Git is a distributed version control system that:
- Tracks every change to your code
- Enables collaboration without conflicts
- Works offline
- Provides complete project history
- Integrates with platforms like GitHub for sharing

**Key Commands Recap:**
- `git init` - Start a new repository
- `git add` - Stage changes
- `git commit` - Save snapshot
- `git push` - Upload to remote
- `git pull` - Download from remote
- `git clone` - Copy existing repository
- `git status` - Check current state
- `git diff` - View changes
- `git log` - View history
- `git branch` - Manage branches
- `git merge` - Combine branches

Mastering Git enables efficient collaboration, safe experimentation, and reliable code management.
