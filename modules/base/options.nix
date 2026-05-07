{ lib, ... }:
{
  options.system.user = lib.mkOption {
    type = lib.types.str;
    description = "Primary user account name.";
  };

  options.system.description = lib.mkOption {
    type = lib.types.str;
    description = "Displayed name and surname.";
  };
}
