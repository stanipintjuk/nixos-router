{ 
  internalInterface, 
  externalInterface, 
  ipRange
}:
with import ./helpers.nix;
if !testIpRange ipRange 
then
  throw ''ipRange '${ipRange}' is invalid. Here is a valid example: 192.168.2.0/24''
else
let
  ipRangePrefix = getIPRangePrefix ipRange;
  gatewayIP = ipRangePrefix + "1";

  ipRangeFrom = ipRangePrefix + "10";
  ipRangeTo = ipRangePrefix + "254";
  broadcastAddress = ipRangePrefix + "255";
in
{ ... }:
{
  networking.nat.enable = true;
  networking.nat.internalIPs = [ ipRange ];
  networking.nat.externalInterface = externalInterface;
  networking.interfaces."${internalInterface}" = { 
    ipAddress = gatewayIP;
    prefixLength = 24;
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ internalInterface ]; 
    extraConfig = ''
      ddns-update-style none;
      #option subnet-mask         255.255.255.0;
      one-lease-per-client true;

      subnet ${ipRangePrefix}0 netmask 255.255.255.0 {
        range ${ipRangeFrom} ${ipRangeTo};
        authoritative;

        # Allows clients to request up to a week (although they won't)
        max-lease-time              604800;
        # By default a lease will expire in 24 hours.
        default-lease-time          86400;

        option subnet-mask          255.255.255.0;
        option broadcast-address    ${broadcastAddress};
        option routers              ${gatewayIP};
        option domain-name-servers  8.8.8.8, 8.8.4.4;
      }
    '';
  };
}
