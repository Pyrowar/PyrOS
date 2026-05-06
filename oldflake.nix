{
  description = "PyrOS flake";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url   = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url   = "github:NixOS/nixos-hardware";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    };

    import-tree.url = "github:vic/import-tree";
    # flake-file.url = "github:vic/flake-file"; # auto-generates flake.nix from a spec file

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      # Host output declarations — one file per channel/hostname pair.
      # These are explicit since they declare flake outputs, not NixOS modules.
      ./snowdrift.nix
      ./permafrost.nix
    ];

    # flake-parts requires systems to be declared even if we only use
    # nixosConfigurations which are not per-system outputs.
    systems = [ "x86_64-linux" ];
  };

}
