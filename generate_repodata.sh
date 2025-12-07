#!/usr/bin/env python3
# Generate repodata.json from index.json files in balikar-repository
# This script scans all package directories and creates a unified repodata.json

import os
import sys
import json
from pathlib import Path

def main():
    # Get repository root (directory containing this script)
    repo_root = Path(__file__).parent.resolve()
    output_file = repo_root / "repodata.json"
    
    print("=== Balikar Repository - Generate repodata.json ===")
    print(f"Repository root: {repo_root}")
    print(f"Output file: {output_file}")
    print()
    
    # Initialize repodata structure
    repodata = {
        "info": {
            "subdir": "noarch",
            "platform": "linux",
            "arch": "x86_64"
        },
        "packages": {},
        "packages.conda": {}
    }
    
    package_count = 0
    error_count = 0
    
    # Iterate through all directories (a-z)
    for letter_dir in sorted(repo_root.iterdir()):
        # Skip non-directories
        if not letter_dir.is_dir():
            continue
        
        letter = letter_dir.name
        
        # Skip if not a single letter directory
        if len(letter) != 1 or not letter.isalpha():
            continue
        
        print(f"Scanning directory: {letter}/")
        
        # Iterate through package directories in this letter directory
        for pkg_dir in sorted(letter_dir.iterdir()):
            if not pkg_dir.is_dir():
                continue
            
            pkg_name = pkg_dir.name
            
            # Iterate through version directories
            for version_dir in sorted(pkg_dir.iterdir()):
                if not version_dir.is_dir():
                    continue
                
                # Look for index.json in version_dir or version_dir/info/
                index_json_path = None
                if (version_dir / "index.json").exists():
                    index_json_path = version_dir / "index.json"
                elif (version_dir / "info" / "index.json").exists():
                    index_json_path = version_dir / "info" / "index.json"
                
                if not index_json_path:
                    continue
                
                print(f"  Found: {index_json_path}")
                
                # Load and parse index.json
                try:
                    with open(index_json_path, 'r') as f:
                        index_data = json.load(f)
                    
                    # Extract package metadata
                    name = index_data.get('name', 'unknown')
                    version = index_data.get('version', '0')
                    build = index_data.get('build', '0')
                    
                    # Generate package key: name-version-build.tar.bz2
                    pkg_key = f"{name}-{version}-{build}.tar.bz2"
                    
                    # Add to repodata
                    repodata['packages'][pkg_key] = index_data
                    package_count += 1
                    
                except json.JSONDecodeError as e:
                    print(f"  ✗ ERROR: Invalid JSON in {index_json_path}: {e}", file=sys.stderr)
                    error_count += 1
                    continue
                except Exception as e:
                    print(f"  ✗ ERROR processing {index_json_path}: {e}", file=sys.stderr)
                    error_count += 1
                    continue
    
    # Check if there were any errors
    if error_count > 0:
        print()
        print(f"✗ FAILED: Found {error_count} error(s) during processing", file=sys.stderr)
        print(f"✗ Processed {package_count} packages successfully", file=sys.stderr)
        print("✗ Please fix the errors above and try again", file=sys.stderr)
        return 1
    
    # Write repodata.json
    try:
        with open(output_file, 'w') as f:
            json.dump(repodata, f, indent=4, sort_keys=False)
        
        print()
        print("✓ Successfully generated repodata.json")
        print(f"✓ File: {output_file}")
        print(f"✓ Packages: {package_count}")
        print()
        print("Next steps:")
        print("  1. Review changes: git diff repodata.json")
        print("  2. Commit: git add repodata.json && git commit -m 'Update repodata.json'")
        print("  3. Push: git push origin main")
        print("  4. Update cache: rm /var/cache/balikar/downloads/repodata.json")
        print("  5. Install: balikar repo-update && balikar build <package>")
        
        return 0
        
    except Exception as e:
        print(f"✗ ERROR: Failed to write {output_file}: {e}", file=sys.stderr)
        return 1

if __name__ == '__main__':
    sys.exit(main())
