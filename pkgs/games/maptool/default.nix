{ callPackage, gradleGen, makeWrapper, fetchgit, lib, pkgs, ... }:
let
  buildGradle = callPackage ./gradle-env.nix {
    gradleGen = gradleGen.override {
      java = pkgs.jdk11;
    };
  };
in
buildGradle {
  version = "1.7.0";
  envSpec = ./gradle-env.json;

  # Patched version from my github so this all works
  src = fetchgit {
    url = "https://github.com/euank/maptool.git";
    rev = "697e9549cf42ac84fe03d74b30ae2f761868f974";
    sha256 = "1n1hzh6mmsls1bgjmr924fk15zg25l81q9f75sjr4fgjqc8bl59j";
    # Used for versioning, TODO mock this out somehow
    leaveDotGit = true;
  };

  gradleFlags = [ "distTar" ];

  buildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/realroot $out/bin
    tar -C "$out/realroot" --strip-components=1 -xf build/distributions/MapTool.tar

    patchShebangs $out/realroot/bin/MapTool

    makeWrapper $out/realroot/bin/MapTool $out/bin/MapTool --prefix PATH : ${lib.makeBinPath [ pkgs.jdk11 ]}

  '';
}
