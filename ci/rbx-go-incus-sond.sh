#!/bin/sh
# incus-sond, inside golang:1.25
set -e
export GOFLAGS=-mod=mod
export GOTOOLCHAIN=auto
apt-get update -qq && apt-get install -y -qq gcc make pkg-config git autoconf automake libtool \
	lxc-dev libacl1-dev libcap-dev libdbus-1-dev liblz4-dev libseccomp-dev libselinux1-dev \
	libsqlite3-dev libudev-dev libuv1-dev
# Debian bookworm ships no libcowsql: incus's tests need cowsql.h, so build raft and
# cowsql from their own sources (both are small autotools projects).
if [ ! -f /usr/local/lib/pkgconfig/cowsql.pc ]; then
	git clone --quiet --depth 1 --branch v0.22.1 https://github.com/cowsql/raft.git /tmp/raft
	sh -c 'cd /tmp/raft && autoreconf -i && ./configure --prefix=/usr/local && make -j"$(nproc)" && make install' >/dev/null
	git clone --quiet --depth 1 --branch v1.15.9 https://github.com/cowsql/cowsql.git /tmp/cowsql
	sh -c 'cd /tmp/cowsql && autoreconf -i && ./configure --prefix=/usr/local && make -j"$(nproc)" && make install' >/dev/null
	ldconfig
fi
go version
go test ./internal/server/instance/drivers/... "$@"
