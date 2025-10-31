#!/bin/bash

# Run Flutter integration tests
echo "Running integration tests..."
flutter test integration_test/add_todo_e2e_test.dart

# Check if the test passed
if [ $? -eq 0 ]; then
    echo "✅ Integration tests passed successfully!"
else
    echo "❌ Integration tests failed!"
    exit 1
fi
