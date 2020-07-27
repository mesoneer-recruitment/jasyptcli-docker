#!/bin/bash

set -e

usage() {
  cat <<'__USAGE__' | fold -s -w 70
Usage is exactly the same when you use Jasypt encrypt.sh or decrypt.sh (http://www.jasypt.org/cli.html).

By default, only the OUTPUT section are outputted to prevent leaking sensitive data.
Override this default behaviour by setting verbose=true (also supported by Jasypt).

$ encrypt [ARGUMENTS]

or

$ decrypt [ARGUMENTS]
__USAGE__

}

if [ "$#" == 0 ]
then
  usage
  exit 0
fi

main() {
  command="${1}"
  shift

  case "$command" in

    "encrypt" | "en")
      local verbose=$(echo "$@" | grep --count 'verbose=true' || true)
      if [[ "$verbose" == "1" ]]
      then
        bin/encrypt.sh "$@" 
      else
        bin/encrypt.sh "$@" | grep 'OUTPUT' -A 100
      fi
      ;;

    "decrypt" | "de")
      local verbose=$(echo "$@" | grep --count 'verbose=true' || true)
      if [[ "$verbose" == "1" ]]
      then
        bin/decrypt.sh "$@"
      else
        bin/decrypt.sh "$@" | grep 'OUTPUT' -A 100
      fi
        ;;

    *)
      usage
      ;;
  esac
}

main "$@"
