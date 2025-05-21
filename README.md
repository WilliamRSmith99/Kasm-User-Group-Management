# Kasm Group Configuration Script

This Bash script automates the creation and configuration of user groups for a **Kasm Workspaces** environment via its Admin API. It supports defining permissions and settings for groups like Administrators, Site Administrators, All Users, and more.

## Features

- Creates standard Kasm groups if they do not exist.
- Assigns default descriptions, priorities, settings, and permissions.
- Allows force-overriding group properties using the `--force` flag.
- Supports secure interaction with the Kasm Admin API using provided credentials.

---

## Usage

\`\`\`bash
./kasm_group_config.sh -d <domain> -k <api_key> -s <api_secret> [--force]
\`\`\`

### Required Flags

- `-d`, `--domain`: The domain of the Kasm server (e.g., `kasm.example.com`)
- `-k`, `--key`: The API key for authentication
- `-s`, `--secret`: The API key secret

### Optional Flags

- `-f`, `--force`: Force update existing group configurations (overrides description and priority)
- `-h`, `--help`: Show usage information

---

## Example

\`\`\`bash
./kasm_group_config.sh --domain kasm.example.com --key abc123 --secret xyz789 --force
\`\`\`

This example will:
- Authenticate with the Kasm Admin API using the provided key/secret
- Create missing default groups
- Apply group-specific settings and permissions
- Override existing group descriptions and priorities if `--force` is used

---

## Groups Configured

1. **Administrators**  
   - Global admin access  
   - Enforced 2FA  
   - Full platform control

2. **All Users**  
   - Standard user permissions  
   - Session restrictions  
   - Usage limits

3. **Site Administrators**  
   - Broad SaaS administration permissions  
   - No global admin rights

4. **Workspace Administrators**  
   - Manage workspace-specific configurations  
   - Limited infrastructure access

5. **All Site (users)**  
   - Common default group for general access  
   - Rich user features (clipboard, downloads, webcam, etc.)

---

## Notes

- The script uses `curl` for API communication and `jq` for JSON processing. Ensure both are installed:
  
  \`\`\`bash
  sudo apt install curl jq
  \`\`\`

- The script ignores invalid SSL certs by using `--insecure` for simplicity. For production use, consider handling certs properly.

---

## Troubleshooting

- **Missing required arguments**: Make sure `-d`, `-k`, and `-s` are all set.
- **Unknown options**: Check flag spelling and formatting.
- **API errors**: Ensure the domain, key, and secret are correct and the API is accessible.

---

## License

This script is provided as-is, without warranty. Modify and use freely under the [MIT License](https://opensource.org/licenses/MIT).
