#!/bin/bash

# Increment build number
current_version=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d '+' -f1)
current_build_number=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d '+' -f2)
new_build_number=$((current_build_number + 1))

# Update the version in pubspec.yaml
sed -i '' "s/version: .*+$current_build_number/version: $current_version+$new_build_number/" pubspec.yaml

# Export environment variables
export VERSION=$current_version
export BUILD_NUMBER=$new_build_number

# Generate Release Notes
echo "Version: $VERSION" > release_notes.txt
echo "Build: $BUILD_NUMBER" >> release_notes.txt
echo "" >> release_notes.txt
echo "Changes in this build:" >> release_notes.txt
