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

  commaSeparated = list:
    let
      head = builtins.head list;
      tail = builtins.tail list;
    in
      builtins.foldl' (x: y: x + ", " + y) head tail;

}
