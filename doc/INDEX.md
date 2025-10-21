# Hem

Ryan Tomayko \<r@tomayko.com\>  
v{hem_version}, March 2008

`hem` manages multiple background SSH connections.
It is most often used to setup reliable, long-running port forwards, control masters, or VPN tunnels.
`hem` monitors SSH connection status and automatically bounces downed connections (repeatedly, if necessary).

`hem` is *Free Software* covered by the
http://opensource.org/licenses/bsd-license.php[New and Simplified BSD License].
It was written originally, and is currently maintained, by
http://tomayko.com[Ryan Tomayko].

## Installation

`hem` should run on most flavors of Unix/GNU that include a
http://www.opengroup.org/onlinepubs/009695399/utilities/sh.html[POSIX compatible `sh(1)`].
In order to be useful, `hem` requires a fairly recent version of
http://www.openssh.com/[OpenSSH] as well as
http://www.harding.motd.ca/autossh/[Carson Harding's `autossh`]
(included with distribution).

* Current Release/Source Distribution:  
	http://tomayko.com/dist/hem/hem-{hem_version}.tar.gz[hem-{hem_version}.tar.gz]
	(http://tomayko.com/dist/hem/hem-{hem_version}.cksums[MD5/SHA1/SHA256])

* Previous Releases:  
	http://tomayko.com/dist/hem/

Please read the link:install.html[INSTALL] file included with the distribution for
installation and hacking instructions.

## Documentation

A comprehensive set of manual pages are installed with `hem` and available here for ease of viewing:

* The manlocal:hem[1] manpage is a good starting point.

* Each of `hem`'s sub-commands have manual pages of their own:
  manlocal:hem-init[1], manlocal:hem-manage[1], manlocal:hem-status[1],
  manlocal:hem-info[1], manlocal:hem-up[1], manlocal:hem-down[1],
  and manlocal:hem-bounce[1].

* Finally, `hem`'s global and connection profile configuration files are
  documented in `manlocal:hem_config[5]` and `manlocal:hem_profile[5]`,
  respectively.

### See Also

* http://github.com/rtomayko/hem/[The Hem Project Page] on GitHub
* http://www.openssh.com/[OpenSSH]
* http://www.harding.motd.ca/autossh/[autossh] - Carson Harding's SSH connection monitor.
* http://sourceforge.net/projects/rstunnel/[RSTunnel] - Reliable SSH Tunnel.
* http://www.linux.com/feature/54498?theme=print[Accelerating OpenSSH connections with ControlMaster]

