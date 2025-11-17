# Balikar Repository

Official package repository for Balikar Package Manager.

## Repository Structure

```
balikar-repository/
├── repodata.json              # Generated metadata (DO NOT EDIT MANUALLY)
├── generate_repodata.sh       # Script to regenerate repodata.json
├── README.md                  # This file
└── [a-z]/                     # Package directories organized by first letter
    └── <package-name>/
        └── <package-name-version>/
            ├── index.json     # Package metadata
            ├── .build         # Build script
            └── extras/        # Patches, additional files
```

## Adding or Updating Packages

### 1. Edit Package Metadata

Edit the `index.json` file for your package:

```bash
# Example: Update gzip
nano g/gzip/gzip-1.14/index.json
```

Example `index.json`:
```json
{
  "name": "gzip",
  "version": "1.14",
  "build": "0",
  "arch": "noarch",
  "depends": ["glibc"],
  "source": [{
    "url": "https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.xz",
    "sha256": "4bf5a10f287501ee8e8ebe00ef62b2c2ab1852b0bb3c5fa888f4e4e05e7f4b4e"
  }],
  "extras": [],
  "is_group": false,
  "no_package": false
}
```

### 2. Regenerate repodata.json

After editing any `index.json` files:

```bash
./generate_repodata.sh
```

This will:
- ✓ Scan all package directories
- ✓ Collect metadata from `index.json` files
- ✓ Generate updated `repodata.json`
- ✓ Validate JSON syntax

### 3. Commit and Push Changes

```bash
git add .
git commit -m "Update gzip package metadata"
git push origin main
```

### 4. Update Local Cache (For Users)

After pushing changes to GitHub, users need to refresh their cache:

```bash
rm /var/cache/balikar/downloads/repodata.json
balikar repo-update
```

Or simply:
```bash
balikar repo-update   # Will download fresh repodata.json
```

## Testing Changes Locally

Before pushing to remote, you can test locally:

### Option 1: Use local-dev repository

Edit `~/.config/balikar/repos.conf` or `/etc/balikar/repos.conf`:

```ini
[local-dev]
url = /home/your-user/Balikar/balikar-repository
priority = 200              # Higher than remote
enabled = true

[balikar-official]
url = https://raw.githubusercontent.com/JanPL00/balikar-repository/main
priority = 100
enabled = true
```

Then:
```bash
./generate_repodata.sh      # Generate local repodata.json
balikar repo-update         # Load from local repo
balikar build <package>     # Test
```

### Option 2: Test with absolute path

```bash
balikar --repo=/home/your-user/Balikar/balikar-repository build <package>
```

## Package Metadata Fields

Required fields in `index.json`:
- **name**: Package name (string)
- **version**: Version number (string)
- **build**: Build number (string, usually "0")
- **depends**: Array of dependency package names

Optional fields:
- **source**: Array of source URLs with sha256 hashes
- **mkdeps**: Build-time dependencies (makedeps)
- **extras**: Additional files (patches, scripts)
- **is_group**: Meta-package flag (boolean)
- **no_package**: Virtual package flag (boolean)
- **download_url**: Pre-built binary URL (future use)

## Workflow Summary

```
1. Edit index.json        → Make changes to package metadata
2. ./generate_repodata.sh → Regenerate repodata.json
3. git commit & push      → Publish to GitHub
4. balikar repo-update    → Users refresh cache
5. balikar build <pkg>    → Users install updated package
```

## Troubleshooting

### Problem: Cache not updating

**Solution:**
```bash
rm /var/cache/balikar/downloads/repodata.json
balikar repo-update
```

### Problem: Invalid JSON in repodata.json

**Solution:**
```bash
./generate_repodata.sh   # Will validate and show errors
jq '.' repodata.json     # Manual validation
```

### Problem: Package not found after update

**Solution:**
```bash
# Check if package is in repodata.json
jq '.packages | keys | .[]' repodata.json | grep <package-name>

# Verify index.json exists
ls -la */*/package-name-*/index.json
```

## Remote Repository URL

This repository is published at:
```
https://raw.githubusercontent.com/JanPL00/balikar-repository/main
```

Users configure this in `repos.conf`:
```ini
[balikar-official]
url = https://raw.githubusercontent.com/JanPL00/balikar-repository/main
priority = 100
enabled = true
```

## Development Tips

- **Always regenerate** `repodata.json` after editing `index.json`
- **Test locally** before pushing to remote
- **Validate JSON** syntax with `jq`
- **Keep backups** of working `repodata.json`
- **Use semantic versioning** for package versions

## License

Same as Balikar Package Manager (see main project).
