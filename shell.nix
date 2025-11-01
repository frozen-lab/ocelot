{ pkgs ? import <nixpkgs> { } }:

let
  system = pkgs.system;
  isDarwin = builtins.match ".*-darwin" system != null;
  isLinux  = builtins.match ".*-linux" system != null;
in
pkgs.mkShell {
  name = "dev";
  buildInputs = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-show-asm
  ]
  ++ (if isLinux then [ pkgs.gcc pkgs.linuxPackages.perf pkgs.gdb ] else [])
  ++ (if isDarwin then [ pkgs.clang pkgs.lldb pkgs.gdb ] else []);

  nativeBuildInputs = [ pkgs.pkg-config pkgs.cmake ];

  shellHook = ''
    export RUST_BACKTRACE=1
    export CARGO_TERM_COLOR=always
  '';
}
