{ lib
, stdenv
, fetchgit
, writeScriptBin
, coreutils
, gawk
, gnused
, netcat
, nettools
, unixtools
, makeWrapper
, openssl
}:

stdenv.mkDerivation rec {
  pname = "ircsink";
  version = "1.0.1";

  src = fetchgit {
    url = "https://cgit.krebsco.de/ircaids";
    rev = version;
    sha256 = "sha256-cGOPZmRHQODEQIOckBhFygKD6Q5xSNRrFoeh8tQN4HI=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    runHook preInstall
    install -D -m755 bin/ircsink $out/bin/ircsink
    wrapProgram $out/bin/ircsink \
      --prefix PATH : ${lib.makeBinPath [
        coreutils
        unixtools.getopt
        gawk
        gnused
        netcat
        openssl
        nettools
      ]}
    runHook postInstall
  '';
  meta = with lib; {
    description = "IRC notifications implemented as a shell script";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}