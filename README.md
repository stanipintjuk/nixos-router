# NixOS Router

NixOS expression for creating a simple router from your ethernet ports.

## Why?
I am not networking a expert. I don't even know the true meaning of "a router" or a lot of details around NATs, 
I just wanted to enable internet access on my Raspberry Pi by connecting it to one of my ethernet ports on my PC. And guess what? It worked!
So I might as well share my stuff :)

## How do I use it?
1. Have NixOS
2. Clone this repo
3. Add this to your imports:
```
  (import /path/the/cloned/repo/mkRouter.nix {
    internalInterface = "enp4s0"; # or w/e ethernet interface you want to connect your raspberry pi to
    externalInterface = "wlp0s20f0u8"; # or w/e interface you get your internet connection to your pc
  })
```
Now just run `nixos-rebuild switch`, plugin in your Raspberry Pi (or any other device you want) 
into the ethernet port, and BOOM! Magic! (You might have to reboot your PC though)

## What is the IP of my connected device?
It will probably be 192.168.2.10

If it isn't then you can run a ping sweep using `nmap`

`nmap -sn 192.168.2.0-255`

this will list all the pingable devices that you route your internet connection to.

If you don't want the ip address range to be 192.168.2.XXX then look at the next section

## What configurations are available

I have added a few parameters that you can add along side `internalInterface` and `externalInterface`.
All of these parameters have default values.
There are some parameters 

| Parameter  | Explanation  | Default Value | Type  |
| ---------- | ------------ | ------------- | ----- |
| ipRange    | The ip range of your subnet. Your interface (your "router") will be automatically assigned to XXX.XXX.XXX.1 | 192.168.2.0/24 | String in the form `XXX.XXX.XXX.0/24`
| maxLeaseTime | maps to max-lease-time in dhcpd config | 604800 | String or Int
| defaultLeaseTime | maps to default-lease-time in dhcpd config | 86400 | String or Int
| dnsServers | A list of DNS Server IPs that you want your connected devices to use | [ "8.8.8.8" "8.8.4.4" ] | List of Strings

## Wan't to yell?
You're welcome to make an issue or write to stanislav.pintjuk@gmail.com, or contact me on telegram https://t.me/StaniBanani

I am always open to yelling!

## Creds
This NixOS expression was inspired .. _by my need for having my Raspberry Pi close to my PC at all times_ ...

AND /u/poo\_22 on reddit https://www.reddit.com/r/NixOS/comments/3unzet/help_i_am_having_trouble_setting_up_networking/
