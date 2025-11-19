#!/bin/false

# hem-* scripts source this file to bring in some useful helper functions.

####>--------------------------------------------------------------------------------

_projName='hem'

# List of variables used in the profiles.
_profVars="host port user remote pidfile statefile"
_profVars="${_profVars} monitor_port tunnels extra_args disabled"

_profVars="${_profVars} _configFile"

# A list of commands now available
# hem-sh-setup # This file
# 
# The one time 'set it up' script...
# hem-init
#
# The individual commands....
#     hem-bounce  hem-list       hem-status
#     hem-down    hem-manage     hem-up
#     hem-info    hem-push-keys

# hem

####>--------------------------------------------------------------------------------

# setup some common variables.
# If called as hem-foo-bar, the next line returns the fullpath

# /usr/local/bin/hem-foo-bar
_fullPath=$(realpath ${0})

# hem-foo-bar
_progName=$(basename ${_fullPath})

# foo-bar
_commandName=$(echo "${_progName}" | sed 's/-/ /')

####>--------------------------------------------------------------------------------

workdir=$(pwd)

PS4=${PS4:-"+ "}

####>--------------------------------------------------------------------------------

# die [<message>]
#
# Exit with a status of 1. If <message> is provided, write it to stderr before
# exiting.
die() {
	test ${#} -gt 0 && {
		echo >&2 "${_commandName}:" "${@}"
		log "${@}"
	}
	exit 1
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# usage
#
# Write program usage to stdout. This function does not exit.
usage() {
	echo "Usage: ${_commandName} ${USAGE}"
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# see_usage [<message>]
#
# Show basic program usage and exit with status 1.
# If <message> is provided, write that message to stderr before anything else.
see_usage() {
	test ${#} -gt 0 && echo >&2 "${_commandName}:" "${@}"
	echo "Usage: ${_commandName} ${USAGE}" | head -1
	echo "See: ${_commandName} --help"
	exit 1
}

if [ ${#} -gt 0 ] && ( [ "${1}" = '--help' ] || [ "${1}" = '-h' ] ) ; then
	usage
	exit 0
fi

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# log <message>
#
# Log a message to the configured log destination. When log_to is empty,
# messages are logged using logger(1); otherwise, messages are written to the
# file specified.
#
# If verbose is set, the message is also written to stderr with a PS4 prefix.
log() {
	[ ${verbose} ] && echo >&2 "${PS4}${_progName}:" "${@}"
	if [ -n "${log_to}" ] ; then
		echo "$(date +'%Y-%m-%d_%H:%M:%S') ${_progName}[${$}]" "${@}" >> "${log_to}"
	else
		logger "${@}"
	fi
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# info <message>
#
# Write non-critical informational message to stdout unless the
#  quiet environment variable is set.
# The message is also written to the log.
info() {
	[ ${quiet} ]   || echo "${@}"
	[ ${verbose} ] || log "${@}"
	return 0
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# editor [<args>] <file>
#
# Open an editor with the arguments provided. Use VISUAL, EDITOR, and then vi;
# in that order.
editor() {
	VISUAL=${VISUAL:-}
	if [ -n "${VISUAL}" ]; then
		${VISUAL} "${@}"
	else
		${EDITOR:-'vi'} "${@}"
	fi
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# tildize <path>
#
# Convert $HOMEs to tildes ("~") at the beginning of <path>.
tildize() {
	echo "${1:-}" | sed "s@^$HOME@~@"
	return 0
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# untildize <path>
#
# Convert tildes ("~") to $HOMEs at the beginning of <path>.
untildize() {
	echo "${1:-}" | sed "s@^~@${HOME}@"
	return 0
	# "s@^$HOME@~@"
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# remote_part [<user>@]<host>[:<port>]
#
# Convert a <remote> spec like 'foo@bar.com:75' into its parts,
# setting the following variables:
#
#   remote_user     the user portion of the remote spec (or $USER)
#   remote_host     the host portion of the remote spec
#   remote_port     the port portion of the remote spec (or 22)
#
# TODO: this is pretty much insane. there's gotta be a better way of
# pulling these pieces apart.
remote_part() {
	if [ $(expr -- "$1" : '.*@') -gt 0 ]; then
		remote_user=$(echo "$1" | sed 's/\(.*\)@.*/\1/')
		remote_host=$(echo "$1" | sed 's/.*@\(.*\)/\1/')
	else
		remote_user="$USER"
		remote_host="$1"
	fi
	if [ $(expr -- "$remote_host" : '.*:') -gt 0 ]; then
		remote_port=$(echo "$remote_host" | sed 's/.*:\(.*\)/\1/')
		remote_host=$(echo "$remote_host" | sed 's/\(.*\):.*/\1/')
	else
		remote_port=22
	fi
	return 0
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---------------------------------------------------------------------
# Profile Specific Functions
# ---------------------------------------------------------------------

# profile_path <name>|<path>
#
# Outputs the path to a profile file given a profile name or profile path.
# No attempt is made to check that the profile exists or is syntactally valid.
#
# Most profile_XXX functions call this when they indicate a <profile> argument.
#
profile_path() {
	# Check to see if the name "1" includes a "/" path separator.
	if [ "$(expr -- "${1}" : '\/')" = 1 ] ; then
		# If it includes a "/" then its probably a full path.
		echo "$1"
	else
		# If it DOESN'T includes a "/" then its probably just a filename.
		# If so, look in the profile directory.
		echo "${profile_dir}"/"${1}"
	fi
	return 0
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# profile_check <profile>
#
# Check that a profile exists.
profile_exist() {
	test -f "$(profile_path $1)" &&
	return 0 ||
	return 1
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# profile_load <profile>
#
# load the profile specified and set up some intelligent variable defaults.
profile_load() {
	profile_file=$(profile_path $1)
	profile_name=$(basename "$profile_file")

	# unset all profile variables
	for i in ${_profVars} ; do
		eval "$i="
	done

	# source the profile
	import ${profile_name}

	# setup remote variables
	remote=${remote:-$profile_name}
	remote_part "$remote"
	host=${host:-$remote_host}
	port=${port:-$remote_port}
	user=${user:-$remote_user}

	# set misc/other variables
	pidfile=${pidfile:-$run_dir/$profile_name.pid}
	statefile=${statefile:-$state_dir/$profile_name}
	monitor_port=${monitor_port:-0}

	return 0
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# profile_required <profile>
#
# Useful for scripts that take a number of arguments followed by
# a single <profile>.
profile_required() {
	test $# -gt 0 ||
	see_usage "no <profile> specified."
	profile_name="$1" ; shift
	profile_load "$profile_name"
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ---------------------------------------------------------------------
# Profile Helper Function Library
# ---------------------------------------------------------------------
# The following functions are designed to be used within hem profiles
# themselves.

# import <profile>
#
# Loads the configuration from the profile specified into the current profile.
# The <profile> argument may be a name relative to <profile_dir> or
# the full path to some other file.
#
import() {
	_p=$(profile_path "$1")
	if test -r "$_p" ; then
		. "$_p"
		return 0
	else
		die "profile not found: $(tildize $_p)"
	fi
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# forward [<bind>:]<listen-port> [to] [<host>:]<forward-port> [<name>]
#
# Add a local port forward. SSH will listen on port <listen-port> on the
# interface <bind>. If no <bind> part is specified, the loopback interface
# is assumed. Connections made to the port are forwarded to <host> on
# <forward-port> on the remote side of the connection. If the <host> part
# is omitted, localhost is assumed.
forward() {
	tunnels="$tunnels -L$1"
	shift
	[ "$1" = "to" ] && shift
	[ $(expr -- "$1" : '.*:') -gt 0 ] &&
	tunnels="$tunnels:$1" ||
	tunnels="$tunnels:localhost:$1"
	return 0
}

####> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# backward [<bind>:]<listen-port> [to] [<host>:]<forward-port> [<name>]
#
# Add a remote port forward. SSH will listen on port <listen-port> on the
# interface <bind> on the remote side of the connection. If no <bind> part
# is specified, the remote loopback interface is assumed. Connections made
# to the port will be forward to <host> on <forward-port> on the local side
# of the connection. If the <host> part is omitted, localhost is assumed.
backward() {
	tunnels="$tunnels -R$1"
	shift
	[ "$1" = "to" ] && shift
	[ $(expr -- "$1" : '.*:') -gt 0 ] &&
	tunnels="$tunnels:$1" ||
	tunnels="$tunnels:localhost:$1"
	return 0
}

####>--------------------------------------------------------------------------------
