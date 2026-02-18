# Example usage:
#
#   nix-build nix/cross-build-example.nix \
#     --argstr rev 16a2aad \
#     --argstr srcHash sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= \
#     --argstr vendorHash sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB= \
#     --argstr target aarch64-unknown-linux-musl \
#     --argstr repoOwner actuals
#
# Tip: use fake hashes first (e.g. lib.fakeHash) and rerun to get the expected
# values from Nix error output.

# To compute the expected binary hash once:
#
#   nix-build nix/cross-build-example.nix \
#     --argstr rev <rev> \
#     --argstr srcHash <srcHash> \
#     --argstr vendorHash <vendorHash>
#   sha256sum ./result/bin/s5cmd
#
# Then pass that value via `expectedBinarySha256` to enforce binary integrity
# verification during builds.
{ nixpkgs ? <nixpkgs>
, rev
, srcHash
, vendorHash
, target ? "aarch64-unknown-linux-musl"
, expectedBinarySha256 ? null
, repoOwner ? "actuals"
}:

let
  pkgs = import nixpkgs {
    crossSystem = { config = target; };
  };
in
pkgs.callPackage ./s5cmd-from-commit.nix {
  inherit pkgs rev srcHash vendorHash expectedBinarySha256 repoOwner;
}
