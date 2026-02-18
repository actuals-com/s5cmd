# Example usage:
#
#   nix-build nix/cross-build-example.nix \
#     --argstr rev 16a2aad \
#     --argstr srcHash sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= \
#     --argstr vendorHash sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB= \
#     --argstr target aarch64-unknown-linux-musl
#
# Tip: use fake hashes first (e.g. lib.fakeHash) and rerun to get the expected
# values from Nix error output.
{ nixpkgs ? <nixpkgs>
, rev
, srcHash
, vendorHash
, target ? "aarch64-unknown-linux-musl"
}:

let
  pkgs = import nixpkgs {
    crossSystem = { config = target; };
  };
in
pkgs.callPackage ./s5cmd-from-commit.nix {
  inherit pkgs rev srcHash vendorHash;
}
