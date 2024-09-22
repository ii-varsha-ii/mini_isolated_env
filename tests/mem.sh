#!/bin/sh

echo "Test memory: Transferring < 20MB"
dd if=/dev/zero of=/tmp/file1 bs=18M count=10
echo "Works!"

echo "Test memory: Transferring >= 20MB"
dd if=/dev/zero of=/tmp/file1 bs=20M count=10