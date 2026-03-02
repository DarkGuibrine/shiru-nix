# shiru Nix Flake

This repository packages the upstream [Shiru](https://github.com/RockinChaos/Shiru) AppImage for use with Nix. The flake exports a `Shiru` package and an overlay that you can import into other flakes.

## Installation

Add the flake as an input in your configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    shiru = {
      url = "github:DarkGuibrine/shiru-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, shiru, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ shiru.overlays.default ];
      };
    in {
      packages.${system}.default = pkgs.shiru;
    };
}
```

### Home Manager / NixOS usage

Once the overlay is imported, reference `pkgs.shiru` anywhere you would normally list packages:

```nix
{
  home.packages = [ pkgs.shiru ];
  # or
  environment.systemPackages = [ pkgs.shiru ];
}
```

Alternatively, you can pin the exported package directly without the overlay:

```nix
home.packages = [ shiru.packages.${pkgs.system}.default ];
```

### Ad-hoc use

Build or run the packaged AppImage directly from the command line:

```bash
nix build github:DarkGuibrine/shiru-nix#default
nix run github:DarkGuibrine/shiru-nix#default
```

## Automation

The workflow in `.github/workflows/update.yml` listens for a `repository_dispatch` event named `shiru_release`, re-fetches the latest upstream AppImage, updates `package.nix`, builds the package, and opens a pull request.

Builds are pushed to the `cloudglides` Cachix cache when the `CACHIX_AUTH_TOKEN` secret is present. Local developers can run `cachix use cloudglides` to read from the cache or `cachix watch-store cloudglides` to upload local builds.

## Development

```bash
nix fmt
nix build .#default
```

Commit the generated `flake.lock` when inputs change to keep builds reproducible.
# shiru-Nix
# shiru-Nix
