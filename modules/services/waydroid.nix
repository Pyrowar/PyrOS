{
  flake.nixosModules.waydroid =
    { ... }:
    {
      virtualisation.waydroid.enable = true;
      # IP forwarding is required for Waydroid networking.
      # waydroid0 is Waydroid's bridge — local-only.
      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
      networking.firewall.trustedInterfaces = [ "waydroid0" ];
    };
}
