#!/usr/bin/env bash
# Detect container runtime and print icon + name for tmux status bar.
# Called by tmux via #() every status-interval seconds.
# Keep it fast — no external commands beyond basic POSIX + /proc checks.

if [ -f /.dockerenv ]; then
    printf '🐳 docker'
elif [ -f /run/.containerenv ]; then
    printf '🦭 podman'
elif grep -qE 'lxc' /proc/1/cgroup 2>/dev/null; then
    printf '📦 lxc'
elif [ -n "$container" ]; then
    printf '🧊 oci'
fi
