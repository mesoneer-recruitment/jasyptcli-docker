# jasyptcli-docker

A simple Docker image for running Jasypt CLI.

## Basic

Current Jasypt version: 1.9.3

## Usage

This Docker image is basically a simple wrapper for Jasypt `encrypt|descrypt.sh`.

In addition, the wrapper by default hides all sensitive information (password and message) and only print the OUTPUT (or
ERROR) sections. This can be disabled by using Jasypt verbose=true argument.


```bash
# Use `read` with password mode to ensure the sensitive data cannot be
# seen by others as well as being tracked by `history`.

$ read -s -p "Password: " password
$ read -s -p "Secret message: " message

$ docker run --rm ubitecag/jasyptcli:latest encrypt \
password=${password} \
input=${message} \
algorithm=PBEWithHMACSHA512AndAES_256 \
ivGeneratorClassName=org.jasypt.iv.RandomIvGenerator

--OUTPUT----

ABCDEFGGD...123456789
```

## Contact

Email: admins@ubitec.ch

