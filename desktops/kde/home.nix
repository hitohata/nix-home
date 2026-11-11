{ config, pkgs, lib, ... }:

{
  imports = [ ./shortcuts.nix ];

  # IBus's candidate surface can appear as a normal Wayland window and
  # steal focus from the editor. Merge this rule without replacing GUI rules.
  home.activation.ibusCandidateFocus = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.python3}/bin/python3 - <<'PY'
    import configparser
    from pathlib import Path

    path = Path(${builtins.toJSON "${config.xdg.configHome}/kwinrulesrc"})
    rules = configparser.ConfigParser(interpolation=None, strict=False)
    rules.optionxform = str
    rules.read(path)
    if not rules.has_section('General'):
        rules.add_section('General')
    rule_id = 'codex-ibus-candidate'
    ids = [item for item in rules.get('General', 'rules', fallback="").split(',') if item]
    if rule_id not in ids:
        ids.append(rule_id)
    rules['General']['rules'] = ','.join(ids)
    rules['General']['count'] = str(len(ids))
    rules[rule_id] = {
        'Description': 'Keep IBus candidate window from stealing keyboard focus',
        'wmclass': 'ibus-ui-gtk3',
        'wmclassmatch': '1',
        'wmclasscomplete': 'false',
        'acceptfocus': 'false',
        'acceptfocusrule': '2',
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w') as output:
        rules.write(output, space_around_delimiters=False)
    PY
  '';

  # Make the Plasma IBus Wayland session start in Mozc's Hiragana mode.
  # `mozc-on` is the Mozc engine whose composition mode is explicitly
  # Hiragana; retaining XKB as the other engine keeps English available.
  dconf.settings."desktop/ibus/general" = {
    engines-order = [ "mozc-on" "xkb:us::eng" ];
    preload-engines = [ "mozc-on" "xkb:us::eng" ];
  };

  gtk = {
    enable = true;
    theme = lib.mkDefault {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };
  };
}
