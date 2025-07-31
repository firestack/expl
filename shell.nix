let
	# nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
	nixpkgs = <nixpkgs>;
	pkgs = import nixpkgs { config = {}; overlays = []; };
	inherit (pkgs) stdenv lib;
in

pkgs.mkShell {
	packages = [
		# Elixir Dependencies
		pkgs.beam.packages.erlang_28.elixir_1_18
		pkgs.beam.packages.erlang_28.erlang
		# Elixir LSP Server
		pkgs.elixir-ls

		# Ecto DB
		pkgs.sqlite
	]
	# Phoenix live-reload requirements
	++ lib.optionals stdenv.hostPlatform.isLinux [ pkgs.inotify-tools ];

	LANG="C.UTF-8";

	# keep your shell history in iex
	ERL_AFLAGS="-kernel shell_history enabled";

	EXQLITE_USE_SYSTEM = 1;

	shellHook = ''
		# this allows mix to work on the local directory
		mkdir -p .cache/nix/mix .cache/nix/hex
		export MIX_HOME=$PWD/.cache/nix/mix
		export HEX_HOME=$PWD/.cache/nix/hex
		export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH

		# make hex from Nixpkgs available
		# `mix local.hex` will install hex into MIX_HOME and should take precedence
		export MIX_PATH="${pkgs.beam.packages.erlang.hex}/lib/erlang/lib/hex/ebin"
	'';
}
