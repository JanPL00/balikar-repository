#!/bin/bash
# Regenerate package tar.bz2 archives from package directories
# Usage: ./regenerate_packages.sh [directory]
# If directory is not specified, processes all packages in the repository

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$REPO_ROOT}"

echo "=== Balikar Repository - Regenerate Package Archives ==="
echo "Repository root: $REPO_ROOT"
echo "Target directory: $TARGET_DIR"
echo ""

# Function to create tar.bz2 for a package
create_package_archive() {
    local pkg_dir="$1"
    local pkg_name="$2"
    local pkg_version="$3"
    local output_file="$4"
    
    echo "  Creating archive: $output_file"
    
    # Create temporary directory for package contents
    local temp_dir=$(mktemp -d)
    local pkg_temp="$temp_dir/$pkg_name-$pkg_version"
    
    # Copy package contents (excluding tar.bz2 files)
    mkdir -p "$pkg_temp"
    
    # Copy all contents from the version directory
    if [ -d "$pkg_dir" ]; then
        # Copy everything except existing tar.bz2 files
        find "$pkg_dir" -mindepth 1 -maxdepth 1 ! -name "*.tar.bz2" -exec cp -r {} "$pkg_temp/" \;
    fi
    
    # Create the archive
    cd "$temp_dir"
    tar -cjf "$output_file" "$pkg_name-$pkg_version"
    
    # Cleanup
    rm -rf "$temp_dir"
    
    echo "  ✓ Created: $output_file"
}

# Counter for processed packages
count=0
deleted_count=0

# Find and delete existing tar.bz2 files in target directory
echo "Step 1: Removing existing tar.bz2 archives..."
echo ""

if [ -f "$TARGET_DIR" ] && [[ "$TARGET_DIR" == *.tar.bz2 ]]; then
    # Single file specified
    echo "  Removing: $TARGET_DIR"
    rm -f "$TARGET_DIR"
    deleted_count=1
else
    # Directory specified - find all tar.bz2 files
    while IFS= read -r -d '' tar_file; do
        echo "  Removing: $tar_file"
        rm -f "$tar_file"
        ((deleted_count++))
    done < <(find "$TARGET_DIR" -name "*.tar.bz2" -type f -print0) || true
fi

echo ""
echo "✓ Removed $deleted_count archive(s)"
echo ""

# Step 2: Generate new archives
echo "Step 2: Generating new package archives..."
echo ""

# Iterate through all letter directories
for letter_dir in "$REPO_ROOT"/[a-z]; do
    if [ ! -d "$letter_dir" ]; then
        continue
    fi
    
    letter=$(basename "$letter_dir")
    
    # Skip if target is specified and doesn't match this path
    if [ "$TARGET_DIR" != "$REPO_ROOT" ] && [[ ! "$TARGET_DIR" == "$letter_dir"* ]]; then
        continue
    fi
    
    echo "Processing directory: $letter/"
    
    # Iterate through package directories
    for pkg_dir in "$letter_dir"/*; do
        if [ ! -d "$pkg_dir" ]; then
            continue
        fi
        
        pkg_name=$(basename "$pkg_dir")
        
        # Skip if target is specified and doesn't match this path
        if [ "$TARGET_DIR" != "$REPO_ROOT" ] && [[ ! "$TARGET_DIR" == "$pkg_dir"* ]]; then
            continue
        fi
        
        # Iterate through version directories
        for version_dir in "$pkg_dir"/*; do
            if [ ! -d "$version_dir" ]; then
                continue
            fi
            
            # Skip if target is specified and doesn't match this path
            if [ "$TARGET_DIR" != "$REPO_ROOT" ] && [ "$TARGET_DIR" != "$version_dir" ] && [[ ! "$TARGET_DIR" == "$version_dir"* ]]; then
                continue
            fi
            
            # Check if index.json exists
            if [ ! -f "$version_dir/index.json" ] && [ ! -f "$version_dir/info/index.json" ]; then
                continue
            fi
            
            # Read package info from index.json
            index_file="$version_dir/index.json"
            if [ ! -f "$index_file" ]; then
                index_file="$version_dir/info/index.json"
            fi
            
            # Extract name and version from index.json
            name=$(jq -r '.name // "unknown"' "$index_file")
            version=$(jq -r '.version // "0"' "$index_file")
            
            # Generate output filename (without build number)
            output_file="$pkg_dir/$name-$version.tar.bz2"
            
            echo "  Package: $name-$version"
            
            # Create the archive
            create_package_archive "$version_dir" "$name-$version" "" "$output_file"
            
            ((count++))
            echo ""
        done
    done
done

echo ""
echo "=== Summary ==="
echo "✓ Deleted archives: $deleted_count"
echo "✓ Generated archives: $count"
echo ""
echo "Next steps:"
echo "  1. Verify archives: ls -lh */*/*.tar.bz2"
echo "  2. Update repodata: ./generate_repodata.sh"
echo "  3. Commit changes: git add . && git commit -m 'Regenerate package archives'"
echo ""
