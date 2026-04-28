{ ... }:

{
  # ------------------------------------------------------------------ #
  # Secure boot
  #
  # 1. Create keys:
  #      nix run nixpkgs#sbctl -- create-keys
  # 2. Disable factory keys in BIOS, then enroll:
  #      sudo sbctl enroll-keys --microsoft --firmware-builtin
  # 3. Set secureBoot.enable = true above and re-enable in BIOS.
  # 4. Verify:
  #      sudo bootctl status
  # ------------------------------------------------------------------ #
  boot.loader.limine = {
    secureBoot.enable = false; # set to false if you don't care about secure boot
  };

}
