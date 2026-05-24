{
  flake.nixosModules.networking =
    { config, lib, ... }:
    {
      options.system.wifi.sops = lib.mkEnableOption "wifi uses sops passwd";

      config = {
        users.users.${config.system.user}.extraGroups = [ "networkmanager" ];
        networking.nftables.enable = true;
        networking.firewall = rec {
          enable = true;
          # allowedTCPPorts = [ ];
          # allowedUDPPorts = [ ];
          
          # KDE Connect
          allowedTCPPortRanges = [
            {
              from = 1714;
              to = 1764;
            }
          ];
          allowedUDPPortRanges = allowedTCPPortRanges;
        };

        networking.networkmanager = {
          enable = true;
          ensureProfiles = lib.mkIf config.system.wifi.sops {
            environmentFiles = [ config.sops.secrets.wifi_passwords.path ];
            profiles = {
              "Kamadan" = {
                connection = {
                  id = "Kamadan";
                  type = "wifi";
                };
                wifi = {
                  mode = "infrastructure";
                  ssid = "Kamadan";
                };
                wifi-security = {
                  key-mgmt = "wpa-psk";
                  psk = "$wifi_kamadan";
                };
                ipv4.method = "auto";
                ipv6.method = "auto";
              };
              "Nika" = {
                connection = {
                  id = "Nika";
                  type = "wifi";
                };
                wifi = {
                  mode = "infrastructure";
                  ssid = "Nika";
                };
                wifi-security = {
                  key-mgmt = "wpa-psk";
                  psk = "$wifi_nika";
                };
                ipv4.method = "auto";
                ipv6.method = "auto";
              };
            };
          };

        };

      };

    };

}
