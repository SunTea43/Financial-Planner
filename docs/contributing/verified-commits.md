# Verified Commits

This project supports commit signing with SSH or GPG. We recommend SSH signing for simplicity.

## Why a commit is marked Unverified

A commit can appear as Unverified when one of these conditions is not met:

- The commit is not signed.
- The signing key is not registered in GitHub as a signing key.
- The commit email is not verified in the same GitHub account that owns the signing key.

## Recommended setup (SSH)

### 1. Configure Git signing

For all repositories:

```bash
git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
```

For this repository only:

```bash
git config --local commit.gpgsign true
git config --local gpg.format ssh
git config --local user.signingkey ~/.ssh/id_ed25519.pub
```

### 2. Register your key in GitHub

In GitHub, go to Settings > SSH and GPG keys and add `~/.ssh/id_ed25519.pub` as:

- Key type: Signing key

### 3. Verify the commit email used by this repository

Set the repository email to one verified on your GitHub account:

```bash
git config --local user.email "your_verified_email@example.com"
```

## Quick validation

Create an explicitly signed commit:

```bash
git commit --allow-empty -S -m "chore: signed commit check"
```

Inspect the latest commit signature state:

```bash
git show --pretty=format:'%h %ae %G? %GS' -s HEAD
```

Expected `G` status means the commit is signed and valid locally.

## Local SSH verification note

If `git log --show-signature` complains about `gpg.ssh.allowedSignersFile`, configure it:

```bash
mkdir -p ~/.config/git
printf "your_verified_email@example.com %s\n" "$(cat ~/.ssh/id_ed25519.pub)" > ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

This setting affects local verification output; GitHub verification still depends on your registered signing key and verified email.
