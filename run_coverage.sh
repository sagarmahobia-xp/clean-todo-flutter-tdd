#!/bin/bash

# Run Flutter tests with coverage
flutter test --coverage

# Remove production data module from coverage report
lcov --remove coverage/lcov.info "lib/di/data_module.dart" -o coverage/lcov_filtered.info

# Replace original file with filtered version
mv coverage/lcov_filtered.info coverage/lcov.info

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open the HTML report
open coverage/html/index.html