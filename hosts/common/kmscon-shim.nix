# Dummy option — Stylix na NixOS 26.05 ustawia services.kmscon.config,
# która już nie istnieje. Szim dla wszystkich hostów (osobny plik, bo moduł
# z zadeklarowanym `options` nie może mieć obok top-levelowego configu).
{ lib, ... }:
{
  options.services.kmscon.config = lib.mkOption {
    type = lib.types.anything;
    default = { };
    description = "Dummy option to fix Stylix compatibility with NixOS 26.05";
  };
}
