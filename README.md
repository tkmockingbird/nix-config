This nixos system configuration was created for my wife, Queen, and myself, King.

It uses the following: Flakes, Home Manager, Overlays, Plasma (though there is gnome setup I was testing), Hosts, and the Systemd Bootloader.

Important notes to anyone trying to use this to learn and adapt from, as I did in this creation:

The foundation of this nixos config was taken and adapted from the far more intelligent, Sioodmy, credit: https://github.com/sioodmy/dotfiles. Below I will break-down each of the main directories, what they are, what they do, and how they're generally structured (or should be if I wasn't dumb). Also, should you wish to adopt and use this configuration immediately, clone to this git to ~/nix-config. Change ownership of the files to your user via sudo chown your_username:users -R ~/nix-config . Then you'll almost certainly need to change the hardware configuration. That, among other additions, is found at /hosts/king/default.nix and /hosts/queen/default.nix. I am attempting to go through and make everything specifically use whoami or hostname as opposed to hardcoded user and hostnames. I'm rather out of my depth here.

1. /desktop-environments ~ Located within here are gnome and plasma. These are the necessary system-wide settings needed to properly import and run Gnome OR Plasma. Never both. Both king and queen hosts use plasma.

2. /home-manager ~ Located here is a common, the main section of home-manager, then king, for my personal computer and packages unique to myself, then queen, with packages unique to my wife. Hosts will import their own home-manager based on the hostname, king or queen, which subsequently import the common section.

3. /hosts ~ This is the heart and soul of the configuration. The flake calls the hosts and the hosts calls EVERYTHING else, either directly or indirectly. Each host has their own unique hardware configuration found within /hosts/hostname/default.nix and their own boot found at /hostname/boot/default.nix.

4. /modules ~ These are my own personal nixos modules that I've attempted to creat. Appflowy and thorium are functional. Other items may or may not be depending on the time of this writing.

5. /overlays ~ These are the nixos overlays that are then imported via flake.nix. Overlays overwrite or makes changes to already existing nixos packages, in my case, or in others add entirely new functionality. They can do anything as nix is exceedingly multi-faceted. I rarely use overlays and the contents will frequently change. I only use them when something a nixpkg breaks and I have to overwrite it.

6. /system ~ This is the primary system configuration. Things like audio, networking, printer, and system-wide packages are here. Also my nix settings are here. System is called by both hosts though it probably shouldn't. Currently my wife and I have roughly the same computer so it works out well for me. May not for you.

7. /user ~ This contains more system configuration however it offers some things that are unique to specific hosts. I prefer to tests things out fully before pushing anything to my wife's computer. I have the free-time to sit and work through stuff should it break, she doesn't. 

8. /flake.nix ~ This was, until recently, 100% based off sioodmy's flake.nix but I've finally read enough source code that I felt comfortable updating / changing things. Is it better or worse? You decide.

9. /gitupdate.sh and /update.sh : Gitupdate.sh Backs up your existing /etc/nixos, then takes your nix-config (Which it is hardcoded to presume it is located at /home/username/nix-config), requests what build command type you wish to run [switch, boot, or any other valid command as listed at the top], then removes /etc/nixos/*, copies nix-config into it and attempts the rebuild. Should it be successful, it will then prompt for a commit message, push the git, and other things. Skim it quickly, I hope it is well commented.

And that's it. I hope this config can be useful as many others were useful to me. If I can be of any assistance to your nixos journey, please reach out to me on discord @KingSK. git 