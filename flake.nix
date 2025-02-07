{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    gtk-session-lock.url = "github:Cu3PO42/gtk-session-lock";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f (import nixpkgs {
            inherit system;
            overlays = [
              (final: _: let
                gtk-session-lock = inputs.gtk-session-lock.packages.${system}.default;
              in {
                inherit gtk-session-lock;
              })
            ];
          })
      );
  in {
    devShells = eachSystem (pkgs: let
      # fabric = pkgs.python3Packages.callPackage ./nix/fabric-meson.nix {};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; with python3Packages; [
          # Custom Packages
          # fabric

          # add aditional python packages here
          # python3Packages.psutil
          # python3Packages.colorthief
          # python3Packages.requests
          # python3Packages.lxml
          # python3Packages.pam
          # python3Packages.thefuzz
          #
          # ruff # Formatter
          # vala-language-server # for vala code completions
			django
			django-crispy-bootstrap4
			django-crispy-forms
			pillow
			requests
			sqlparse
        ];
        # nativeBuildInputs = with pkgs; [
        #   vala # Vala compiler
        #   gobject-introspection
        #
        #   # non python aditional packages
        #   gtk-session-lock # For gtk lock screen
        #   playerctl # For mpirs
        #   gnome.gnome-bluetooth # For bluetooth
        #   networkmanager # For network
        #   libgweather # For weather
        #   libgudev # For uevent monitoring
        # ];
      };
    });
  };
}
