#!/bin/bash
# Simple chat server testing script

echo "=== Chat Server Testing Script ==="
echo ""
echo "This script will test the chat server with multiple clients"
echo "Make sure the server is running: ./zig-out/bin/chat-server"
echo ""
read -p "Press Enter to start testing..."

echo ""
echo "Test 1: Single client connection"
echo "--------------------------------"
(sleep 1; echo "Test message 1") | nc localhost 8888 &
CLIENT1_PID=$!
sleep 2
echo "✓ Test 1 complete"

echo ""
echo "Test 2: Multiple concurrent clients"
echo "------------------------------------"
for i in {1..3}; do
    (sleep 1; echo "Message from client $i"; sleep 2) | nc localhost 8888 &
    echo "Started client $i"
done

sleep 4
echo "✓ Test 2 complete"

echo ""
echo "Test 3: Rapid connect/disconnect"
echo "---------------------------------"
for i in {1..5}; do
    echo "Quick message $i" | nc localhost 8888 &
done

sleep 2
echo "✓ Test 3 complete"

echo ""
echo "=== All tests completed ==="
echo "Check the server output to verify message broadcasting"
