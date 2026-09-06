# gpg-agent configuration.
#
# Replaces the guarded grep-and-append into ~/.gnupg/gpg-agent.conf that both
# install_scripts/*/setup.sh used to do. The pinentry binary is per-OS, so
# linux.nix/darwin.nix set `dotfiles.gpg.pinentry`; the rest is shared.
#
# Pinning a store path rather than whatever `command -v pinentry-curses`
# resolved to is the same reasoning git.nix applies to gpg.program: the old
# lookup only worked because the nix profile happened to already be on PATH.
#
# Not services.gpg-agent: that module drives a systemd user unit, and this has
# to work in containers with no systemd, and on darwin.
#
# A box set up before this existed has a hand-written gpg-agent.conf, which
# activation refuses to overwrite. Move it aside before the first switch.
{
  config,
  lib,
  ...
}:

{
  options.dotfiles.gpg.pinentry = lib.mkOption {
    type = lib.types.str;
    description = ''
      Absolute path to the pinentry binary gpg-agent should use. No default:
      an unset one means a platform module forgot to pick a pinentry, and
      an empty pinentry-program line breaks gpg-agent outright.
    '';
  };

  config = {
    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${config.dotfiles.gpg.pinentry}
    '';

    # home-manager creates the parent 0755, but gpg refuses to trust a homedir
    # that is not 0700 -- every invocation warns about unsafe permissions.
    # A running agent keeps its old config: `gpgconf --kill gpg-agent` after a
    # switch that changes this file. Not done here, since that would drop
    # cached passphrases on every unrelated switch.
    home.activation.gnupgHomedirPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run chmod 700 "${config.home.homeDirectory}/.gnupg"
    '';
  };
}
