{pkgs, ...}:
let
  port = 3000;
  dejimaHost = "dejima.local";
  n100Host = "n100.local";
  piNasHost = "pi-nas.local";
  homeassistantHost = "homeassistant.local";
in {

  networking.firewall.allowedTCPPorts = [ port ]; 

  services.homepage-dashboard = {
    enable = true;
    listenPort = port;

    allowedHosts = ''n100.local:${builtins.toString port},localhost,127.0.0.1,homepage.sv'';

    settings = {
      title = "Home Lab Gateway";
      favicon = "homepage.png";
      layout = {
        "Infrastructure" = {style = "grid"; columns = 3; };
        "Services" = { style = "grid"; columns = 3; };
      };
    };

    widgets = [
      {
        datetime = {
          text_size = "xl";
          format = {
            dateStyle = "short";
            timeStyle = "short";
            hour12 = true;
          };
        };
      }
      {
        resources = {
          label = "System";
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
    ];

    bookmarks = [
      {
        "Tech & Dev" = [
          { GitHub = [{ abbr = "GH"; href = "https://github.com/"; }]; }
          { NixOS  = [{ abbr = "NX"; href = "https://search.nixos.org/"; }]; }
        ];
      }
    ];

    services = [
      {
        "Infrastructure" = [
          {
            "AdGuard Home" = {
              icon = "adguard-home.png";
              href = "http://dns.sv";
              description = "Network-wide DNS Protector";
              ping = dejimaHost;
            };
          }
          {
            "Pi NAS" = {
              icon = "openmediavault.png";
              href = "http://pi-nas.sv";
              description = "Pi NAS dashboard";
              ping = piNasHost;
            };
          }
        ];
      }
      {
        "Services" = [
          {
            "Homepage" = {
              icon = "homepage.png";
              href = "http://homepage.sv";
              description = "This Dashboard";
              ping = n100Host;
            };
          }
          {
            "Immich" = {
              icon = "immich.png";
              href = "http://immich.sv";
              description = "Immich media server";
              ping = n100Host;
            };
          }
          {
            "Homeassistnat" = {
              icon = "home-assistant.png";
              href = "http://homeassistant.sv";
              description = "Homeassistant smart home server";
              ping = n100Host;
            };
          }
        ];
      }
    ];
  }; 
}
