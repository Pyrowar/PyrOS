{ ... }:

{
  # ------------------------------------------------------------------ #
  # Dual booting
  #
  # After committing changes to the bootloader, run:
  #   sudo nixos-rebuild boot --flake /etc/nixos --install-bootloader
  # To find the Windows EFI partition UUID:
  #   sudo blkid | grep -i efi
  # ------------------------------------------------------------------ #
  boot.loader.limine = {
    extraEntries = ''
      /Windows 10
        protocol: efi
        image_path: uuid(d4e98ad0-f84f-4e67-a722-7c19900b75de):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

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
    secureBoot.enable = true; # set to false if you don't care about secure boot
  };

}
