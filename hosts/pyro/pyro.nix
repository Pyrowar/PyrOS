{
  flake.nixosModules.pyro =
    { ... }:
    {
      flake.hosts.snowdrift = "pyro";
      system.user = "pyro";
    };
}
