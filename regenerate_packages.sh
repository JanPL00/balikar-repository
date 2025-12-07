#!/bin/bash
# Regenerate package tar.bz2 archives from package directories
# Usage: ./regenerate_packages.sh [directory]

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
    local output_file="$3"
    
    echo "  Creating archive: $output_file"
    
    local temp_dir=$(mktemp -d)
    local pkg_temp="$temp_dir/$pkg_name"
    
    mkdir -p "$pkg_temp"
    
    if [ -d "$pkg_dir" ]; then
        find "$pkg_dir" -mindepth 1 -maxdepth 1 ! -name "*.tar.bz2" -exec cp -r {} "$pkg_temp/" \;
    fi
    
    cd "$temp_dir"
    tar -cjf "$output_file" "$pkg_name" 2>/dev/null
    
    rm -rf "$temp_dir"
    
    if [ -f "$output_file" ] && [ -s "$output_file" ]; then
        echo "  ✓ Created: $output_file"
        return 0
    else
        echo "  ✗ Failed to create: $output_file"
        return 1
    fi
}

count=0
deleted_count=0

echo "Step 1: Removing existing tar.bz2 archives..."
echo ""

if [ -f "$TARGET_DIR" ] && [[ "$TARGET_DIR" == *.tar.bz2 ]]; then
    echo "  Removing: $TARGET_DIR"
    rm -f "$TARGET_DIR"
    deleted_count=1
else
    while IFS= read -r -d '' tar_file; do
        echo "  Removing: $tar_file"
        rm -f "$tar_file"
        ((deleted_count++))
    done < <(find "$TARGET_DIR" -name "*.tar.bz2" -type f -print0) || true
fi

echo ""
echo "✓ Removed $deleted_count archive(s)"
echo ""

echo "Step 2: Generating new package archives..."
echo ""

for letter_dir in "$REPO_ROOT"/[a-z]; do
    if [ ! -d "$letter_dir" ]; then
        continue
    fi
    
    letter=$(basename "$letter_dir")
    
    if [ "$TARGET_DIR" != "$REPO_ROOT" ] && [[ ! "$TARGET_DIR" == "$letter_dir"* ]]; then
        continue
    fi
    
    echo "Processing directory: $letter/"
    
    for pkg_dir in "$letter_dir"/*; do
        if [ ! -d "$pkg_dir" ]; then
            continue
        fi
        
        pkg_name=$(basename "$pkg_dir")
        
        if [ "$TARGET_DIR" != "$REPO_ROOT" ] && [[ ! "$TARGET_DIR" == "$pkg_dir"* ]]; then
            continue
        fi
        
        for version_dir in "$pkg_dir"/*; do
            if [ ! -d "$version_dir" ]; then
                continue
            fi
            
            if [ "$TARGET_DIR" != "$REPO_ROOT" ] && [ "$TARGET_DIR" != "$version_dir" ] && [[ ! "$TARGET_DIR" == "$version_dir"* ]]; then
                continue
            fi
            
            index_file="$version_dir/index.json"
            if [ ! -f "$index_file" ]; then
                index_file="$version_dir/info/index.json"
            fi
            
            if [ ! -f "$index_file" ]; then
                continue
            fi
            
            # Use Python for robust JSON parsing (handles trailing commas with relaxed mode)
            read -r name version <<< $(python3 -c "
import json
import sys
try:
    # Read and fix common JSON issues
    with open('$index_file', 'r') as f:
        content = f.read()
    # Remove trailing commas (simple regex approach)
    import re
    content = re.sub(r',(\s*[}\]])', r'\1', content)
    data = json.loads(content)
    print(data.get('name', 'unknown'), data.get('version', '0'))
except Exception as e:
    print('unknown', '0', file=sys.stderr)
    sys.exit(1)
" 2>/dev/null || echo "unknown 0")
            
            if [ "$name" = "unknown" ] || [ -z "$name" ]; then
                echo "  ✗ Skipping: Invalid index.json in $version_dir"
                continue
            fi
            
            output_file="$pkg_dir/$name-$version.tar.bz2"
            
            echo "  Package: $name-$version"
            
            if create_package_archive "$version_dir" "$name-$version" "$output_file"; then
                ((count++))
            fi
            
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
echo "  2. Update repodata: python3 generate_repodata.sh"
echo "  3. Commit changes: git add . && git commit -m 'Regenerate package archives'"
echo ""
