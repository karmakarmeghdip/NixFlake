{ appimageTools, lib, fetchurl, ... }:
let
  pname = "miru";
  version = "3.9.10";
  name = "${pname}-${version}";

  #TODO: remove the -rc4 from the tag in the url when possible
  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-Miru-${version}.AppImage";
    sha256 = "lOYCW8CO8vPD13ogzD4JmcWzWBJWOD8t9WmRDVkw7tk=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=miru'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Bittorrent streaming software for cats.";
    homepage = "https://github.com/ThaUnknown/miru";
    license = licenses.gpl3Only;
    # maintainers = with maintainers; [ extends ];
    platforms = [ "x86_64-linux" ];
  };
}
