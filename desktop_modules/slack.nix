{ pkgs-unstable, ... }:
{
  home.packages = [
    # Slack 4.51.180 fixes huddle screen-sharing crashes on Wayland.
    # https://slack.com/release-notes/linux
    pkgs-unstable.slack
  ];
}
