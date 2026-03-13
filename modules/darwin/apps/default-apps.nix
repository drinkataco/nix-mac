{
  system.activationScripts.defaultBrowser.text = ''
    # Use duti to set Firefox as the default browser via Launch Services.
    for scheme in http https; do
      /run/current-system/sw/bin/duti -s org.mozilla.firefox "$scheme" all || true
      /run/current-system/sw/bin/duti -s org.mozilla.firefox "x-scheme-handler/$scheme" all || true
    done

    for uti in public.html public.xhtml com.apple.webarchive; do
      /run/current-system/sw/bin/duti -s org.mozilla.firefox "$uti" all || true
    done
  '';
}
