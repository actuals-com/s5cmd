{ pkgs
, rev
, srcHash
, vendorHash
, expectedBinarySha256 ? null
, pname ? "s5cmd"
, repoOwner ? "peak"
, repoName ? "s5cmd"
, version ? rev
}:

pkgs.buildGoModule {
  inherit pname version vendorHash;

  src = pkgs.fetchFromGitHub {
    owner = repoOwner;
    repo = repoName;
    inherit rev;
    hash = srcHash;
  };

  # s5cmd lives at repository root.
  subPackages = [ "." ];

  # Keep the binary statically linked for portable image imports.
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/peak/s5cmd/v2/version.Version=${version}"
    "-X=github.com/peak/s5cmd/v2/version.GitCommit=${rev}"
  ];

  nativeBuildInputs = [ pkgs.coreutils ];

  doInstallCheck = expectedBinarySha256 != null;
  installCheckPhase = pkgs.lib.optionalString (expectedBinarySha256 != null) ''
    echo "${expectedBinarySha256}  $out/bin/s5cmd" | sha256sum -c -
  '';

  meta = with pkgs.lib; {
    description = "Very fast S3 and local filesystem execution tool";
    homepage = "https://github.com/peak/s5cmd";
    license = licenses.mit;
    mainProgram = "s5cmd";
  };
}
