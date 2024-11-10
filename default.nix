{
  lib,
  stdenv,
  fetchurl,
  cpio,
  xar,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karabiner-dk-virtial-hid";
  version = "3.2.0";

  src = fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${finalAttrs.version}/Karabiner-DriverKit-VirtualHIDDevice-${finalAttrs.version}.pkg";
    hash = "sha256-1mjsk98iy90y0qcjbzdls8qr0kfmhpy8vgc6bscr3858pxa5iwq7=";
  };

  outputs = [
    "out"
  ];

  nativeBuildInputs = [
    cpio
    xar
  ];

  unpackPhase = ''
    xar -xf $src
    zcat Payload | cpio -i
  '';

  sourceRoot = ".";

  postPatch = ''
    shopt -s globstar
    for f in /Library/**/LaunchDaemons/*.plist; do
      substituteInPlace "$f" \
        --replace-fail "/Library/" "$out/Library/"
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp -R Applications Library $out
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/v${finalAttrs.version}";
    description = "Karabiner-DriverKit-VirtualHIDDevice implements a virtual keyboard and virtual mouse using DriverKit on macOS.";
    homepage = "https://karabiner-elements.pqrs.org/";
    license = lib.licenses.unlicense;
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
})
