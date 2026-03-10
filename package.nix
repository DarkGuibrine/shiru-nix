{
  lib,
  pkgs,
  ...
}:
pkgs.appimageTools.wrapType2 rec {
  pname = "shiru";
  version = "v6.5.1";

  src = pkgs.fetchurl {
    url = "https://github.com/RockinChaos/Shiru/releases/download/${version}/linux-Shiru-${version}.AppImage";
    hash = "sha256-hxg7y4xD2a3mzjF5Cqj/04HeT9RrqqR/klx8P1AJHBU=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  extraInstallCommands = let
    contents = pkgs.appimageTools.extractType2 {inherit pname version src;};
  in ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/lib/shiru"
    cp -r ${contents}/{locales,resources} "$out/share/lib/shiru"
    cp -r ${contents}/usr/share/* "$out/share"
    cp "${contents}/${pname}.desktop" "$out/share/applications/"
    wrapProgram $out/bin/shiru --add-flags "--ozone-platform=wayland"
    substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  '';

  meta = {
    description = "Shiru - Torrent streaming made simple";
    homepage = "https://github.com/RockinChaos/Shiru";
    changelog = "https://github.com/RockinChaos/Shiru/releases";
    license = lib.licenses.bsl11;
    mainProgram = "shiru";
  };
}