{ 
  internalInterface, 
  externalInterface, 
  ipRange ? "192.168.2.0/24",
  maxLeaseTime ? "604800",
  defaultLeaseTime ? "86400",
  dnsServers ? [ "8.8.8.8" "8.8.4.4" ]
}:
with import ./helpers.nix;
if !testIpRange ipRange 
then
  throw ''ipRange '${ipRange}' is invalid. Here is a valid example: 192.168.2.0/24''
else
let
  ipRangePrefix = getIPRangePrefix ipRange;
  gatewayIP = ipRangePrefix + "1";

in
{ ... }:
{
  networking.nat.enable = true;
  networking.nat.internalIPs = [ ipRange ];
  networking.nat.externalInterface = externalInterface;
  networking.interfaces."${internalInterface}" = { 
    ipv4.addresses = [{
      address = gatewayIP;
      prefixLength = 24;
    }];
  };

  services.dhcpd4 = let
    subnet = ipRangePrefix + "0";
    netMask = "255.255.255.0";
    ipRangeFrom = ipRangePrefix + "10";
    ipRangeTo = ipRangePrefix + "254";
    broadcastAddress = ipRangePrefix + "255";
    commaSepDNSServers = commaSeparated dnsServers;
  in
  {
    enable = true;
    interfaces = [ internalInterface ]; 
    extraConfig = ''
      ddns-update-style none;
      #option subnet-mask         ${netMask};
      one-lease-per-client true;

      subnet ${ipRangePrefix}0 netmask ${netMask} {
        range ${ipRangeFrom} ${ipRangeTo};
        authoritative;

        # Allows clients to request up to a week (although they won't)
        max-lease-time              ${maxLeaseTime};
        # By default a lease will expire in 24 hours.
        default-lease-time          ${defaultLeaseTime};

        option subnet-mask          ${netMask};
        option broadcast-address    ${broadcastAddress};
        option routers              ${gatewayIP};
        option domain-name-servers  ${commaSepDNSServers};
      }
    '';
  };
}
