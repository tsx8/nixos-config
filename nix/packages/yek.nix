{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
,
}:

rustPlatform.buildRustPackage rec {
  pname = "yek";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "bodo-run";
    repo = "yek";
    rev = "v${version}";
    hash = "sha256-2gt/leOEhdvj5IXp0Kl3ooUk8eclsMkt6JCIvPsKhMI=";
  };

  cargoHash = "sha256-gjDcw8mMZgoy7kjXlBYHhOgYXOV+XoMgflkZoggz42Q=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doCheck = false;

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A fast Rust based tool to serialize text-based files in a repository or directory for LLM consumption";
    homepage = "https://github.com/bodo-run/yek";
    license = licenses.mit;
    mainProgram = "yek";
    maintainers = [ ];
  };
}
