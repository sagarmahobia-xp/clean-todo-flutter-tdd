#!/bin/bash

# Script to run Flutter tests with coverage, generate HTML report, and open it

echo "Running Flutter tests with coverage..."

# Run Flutter tests with coverage
flutter test --coverage

if [ $? -ne 0 ]; then
    echo "Flutter tests failed. Exiting."
    exit 1
fi

echo "Tests completed successfully. Generating HTML coverage report..."

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

if [ $? -ne 0 ]; then
    echo "Failed to generate HTML coverage report. Make sure lcov is installed."
    echo "You can install it with: brew install lcov (on macOS)"
    exit 1
fi

echo "HTML coverage report generated successfully."

# Open the HTML report in the default browser
open coverage/html/index.html

if [ $? -ne 0 ]; then
    echo "Failed to open the coverage report. Opening manually..."
    open coverage/html/
fi

echo "Coverage report is now open in your browser."