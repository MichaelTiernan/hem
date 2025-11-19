# Hem

<center>
<h2>
Persistent ssh connection and tunnel manager
</h2>
</center>
--

`hem` manages multiple background SSH connections using an ifconfig/rc style interface.
It is most often used to setup persistent/long-running port tunnels and control master connections.
`hem` monitors connection status and can automatically bounce downed connection.

`hem` is Free Software covered by the "New and Simplified BSD License".
It was originally written by [Ryan Tomayko <r@tomayko.com>](mailto://r@tomayko.com)

Please read the file `INSTALL` for installation and hacking instructions.
`hem` should run on most flavors of Unix/Gnu that include a posix compatible sh interpreter.
`hem` currently requires fairly recent version of OpenSSH's `ssh(1)` as well as Carson Harding's `autossh(1)` (included with distribution).

More information on `hem` is accessible from
~~[http://tomayko.com/src/hem/](http://tomayko.com/src/hem/)~~
including full documentation, examples, and distributable.
There is also project tracking resources at
[http://github.com/rtomayko/hem/](http://github.com/rtomayko/hem/)

### See Also:

* OpenSSH: http://www.openssh.com/
* autossh: http://www.harding.motd.ca/autossh/
