{
  getIPRangePrefix = ipRange: 
    builtins.head (
      builtins.match 
        "([0-9][0-9]?[0-9]?\\.[0-9][0-9]?[0-9]?\\.[0-9][0-9]?[0-9]?\\.).*"
        ipRange
    );

  testIpRange = ipRange:
    builtins.isList (
      builtins.match
        "([0-9]{1,3}\\.){3}[0-9]{1,3}/24"
        ipRange
    );
}
