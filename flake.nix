{
  description = "Meghdip's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:karmakarmeghdip/nixpkgs/patch-1";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, aagl }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true; 
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      meghdip = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit hyprland;
            };
            home-manager.users.meghdip = import ./home.nix;
          }
          {
            imports = [ aagl.nixosModules.default ];
            nix.settings = aagl.nixConfig; # Set up Cachix
            # programs.an-anime-game-launcher.enable = true;
            programs.the-honkers-railway-launcher.enable = true; # Adds launcher and /etc/hosts rules
          }
        ];
      };
    };
  };
}
