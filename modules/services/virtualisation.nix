{
  flake.nixosModules.virtualisation =
    { pkgs, config, ... }:
    {
      users.users.${config.system.user}.extraGroups = [ "libvirtd" ];
      # ------------------------------------------------------------------ #
      # libvirtd — QEMU/KVM virtual machines
      #
      # Before enabling, verify virtualisation is on in BIOS:
      #   grep -m1 -E 'vmx|svm' /proc/cpuinfo
      # ------------------------------------------------------------------ #
      virtualisation.libvirtd = {
        enable = true;
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ]; # virtiofs shared folder support
      };
      programs.virt-manager.enable = true;

      # IP forwarding and bridge trust are required for libvirt networking.
      # virbr0 is libvirt's default NAT bridge.
      networking.firewall.trustedInterfaces = [ "virbr0" ];
      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

      # dnsmasq provides DHCP and DNS for libvirt's virtual networks
      environment.systemPackages = with pkgs; [ dnsmasq ];

      # Autostart default network. Essentially automated:
      #  sudo virsh net-autostart default
      system.activationScripts.libvirtdDefaultNetwork = ''
        ${pkgs.libvirt}/bin/virsh net-autostart default || true
      '';
    };
}
