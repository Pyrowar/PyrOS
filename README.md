# PyrOS
Work in progress, but slowly getting better!

## System administration
### Standard
```nix
sudo nixos-rebuild switch --flake /etc/nixos
sudo nixos-rebuild boot --flake /etc/nixos
sudo nixos-rebuild dry-activate --flake /etc/nixos
sudo nix flake update --flake /etc/nixos
sudo nix-collect-garbage -d
sudo nix store optimise
nix run path:/etc/nixos#write-flake
nixos-rebuild list-generations
```
### While using nh
```nix
nh os switch --ask
nh os boot --ask
nh os --help
nh clean all
```
### Help
#### Manual is located here:
```sh
/run/current-system/sw/share/doc/nixos
```
#### In terminal:
```sh
nixos-help
```

---

## Sops
### General info
> Sops is essentially a declarative password manager for your system.

- One encrypted file in your repo holds all your secrets.
- Each machine has its own private key to decrypt it.
- The repo is safe to make public since everything is encrypted.
- Secrets are deployed automatically on rebuild, no manual copying.
### Managing secrets
- ~/.config/sops
- ~/.ssh
### Adding new device keys

#### Option 1:
Copy your age key to the new device.
Copy `~/.config/sops/age/keys.txt` from your current machine to the same path on the new one. You could do this over SSH:
```sh
bashscp ~/.config/sops/age/keys.txt user@newdevice:~/.config/sops/age/keys.txt
```
#### Option 2:
Add the new device's age key to sops. Generate a new age key on the new device:
```sh
bashmkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt  # print the public key
```
Then add it to .sops.yaml alongside your existing key:
```yaml
yamlkeys:
  - &laptop age1abc...
  - &desktop age1xyz...  # new device's public key

creation_rules:
  - path_regex: secrets/*.yaml$
    key_groups:
      - age:
        - *laptop
        - *desktop
```
Then re-encrypt your secrets file, so it's encrypted for both keys:
```sh
bashsops updatekeys /etc/nixos/secrets/secrets.yaml
```

---

## General tips
### Pinning your generation
#### List your generations

```bash
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
```
#### Find the generation number you want to pin, then create a GC root for it

```bash
sudo nix-store --add-root /nix/var/nix/gcroots/pinned-backup --indirect -r /nix/var/nix/profiles/system-N-link
```
#### Replace N with your generation number. This prevents GC from ever collecting it.

### Fixing nix-flatpak out of sync
#### Reset the state:
```sh
sudo rm /nix/var/nix/gcroots/flatpak-state.json
```
#### Then rebuild.

### Fixing GSConnect/Valent
#### "This location could not be displayed":
append `/storage/emulated/0/` or `/sdcard` to the sftp path.
