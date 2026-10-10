{ inputs, config, ... }: {

  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    
    gnupg.sshKeyPaths = [ ]; 
  };
}
