# Note this whole file needs a rework if I want it to be
# reusable on other hosts. Currently the value of ashyn.local is
# hardcoded
{
  ...
}:
{
  # Caddy
  services.caddy = {
    enable =true;
    virtualHosts."ashyn.local" = {
      serverAliases = [
        "ashyn.local"
        "ashyn"
        "localhost"
      ];
      extraConfig = ''
        tls internal
        reverse_proxy to localhost:8000 {
          header_down X-Read-IP {http.request.remote}
          header_down X-Forwarded-For {http.request.remote}
        }
      '';
    };
  };
}
