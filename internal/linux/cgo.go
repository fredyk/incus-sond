//go:build linux && cgo

package linux

// Modified by the Sond project, 2026-11-22: no -fexceptions. musl does not unwind on thread
// cancellation, so the flag only pulled in libgcc_eh's unwinder, which is built for glibc.

// #cgo CFLAGS: -std=gnu11 -Wvla -Werror -fvisibility=hidden -Winit-self
// #cgo CFLAGS: -Wformat=2 -Wshadow -Wendif-labels -fasynchronous-unwind-tables
// #cgo CFLAGS: -pipe --param=ssp-buffer-size=4 -g -Wunused
// #cgo CFLAGS: -Werror=implicit-function-declaration
// #cgo CFLAGS: -Werror=return-type -Wendif-labels -Werror=overflow
// #cgo CFLAGS: -Wnested-externs
// #cgo LDFLAGS: -lutil -lpthread
import "C"
