# Azure MCP Docker

A Docker image for [Azure Model Context Protocol (MCP)](https://github.com/Azure/azure-mcp) that fixes authentication issues with mounted Azure CLI credentials.

## Problem

The official Azure MCP Docker image cannot properly authenticate using Azure CLI credentials mounted into the container. This image resolves that issue by including Azure CLI within the container and properly configuring credential authentication.

## Features

- ✅ Azure CLI installed and configured
- ✅ Supports `AzureCliCredential` authentication
- ✅ Node.js v24 with NVM
- ✅ Azure MCP server pre-installed
- ✅ Optimized image size with cache cleanup

## Usage

### Prerequisites

Before running the container, ensure you're logged in to Azure CLI on your host machine:

```bash
az login
```

### Using with MCP Client

To use this Docker image with an MCP client, update your MCP client configuration to use `--volume` to map the host machine's `.azure` folder to the corresponding `.azure` directory in the container.

**Configuration for Linux/Mac:**

```json
{
   "mcpServers": {
      "Azure MCP Server": {
         "command": "docker",
         "args": [
            "run",
            "-i",
            "--rm",
            "--volume",
            "~/.azure:/root/.azure",
            "ghcr.io/lonegunmanb/azure-mcp:latest"
         ]
      }
   }
}
```

#### For Windows Users

On Windows, Azure CLI stores credentials in an encrypted format that cannot be accessed from within Docker containers. On Linux and Mac, credentials are stored as plain JSON files that can be shared with containers. Consequently, mapping the `.azure` directory from the user profile to the container will not work on Windows. 

A workaround is to use WSL to log into the Azure CLI and then map that to the Docker container:

1. In a WSL console:
   ```bash
   mkdir /mnt/c/users/<username>/.azure-wsl
   AZURE_CONFIG_DIR=/mnt/c/users/<username>/.azure-wsl
   az login
   ```

2. Update MCP client configuration to point to that folder:
   ```json
   {
      "mcpServers": {
         "Azure MCP Server": {
            "command": "docker",
            "args": [
               "run",
               "-i",
               "--rm",
               "--volume",
               "C:\\users\\<username>\\.azure-wsl:/root/.azure",
               "ghcr.io/lonegunmanb/azure-mcp:latest"
            ]
         }
      }
   }
   ```

> **Note:** There is an [open issue](https://github.com/Azure/azure-sdk-for-net/issues/19167) tracking Windows credential access from containers.

### Building Locally

If you prefer to build the image locally:

```bash
git clone https://github.com/lonegunmanb/azure-mcp-docker.git
cd azure-mcp-docker
docker build -t azure-mcp .
```

Then update the image reference in your MCP client configuration to use your local image tag instead of `ghcr.io/lonegunmanb/azure-mcp:latest`.

## How It Works

This image addresses the authentication issue by:

1. **Installing Azure CLI** directly in the container
2. **Setting `AZURE_TOKEN_CREDENTIALS=AzureCliCredential`** to enable Azure CLI credential provider
3. **Mounting host Azure credentials** from `~/.azure` directory (read-only)

When you mount your local `~/.azure` directory into the container, the Azure MCP server can authenticate using your existing Azure CLI session.

## Environment Variables

- `AZURE_TOKEN_CREDENTIALS=AzureCliCredential` - Configured to use Azure CLI credentials
- `NVM_DIR=/usr/local/.nvm` - Node Version Manager directory
- `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1` - .NET globalization setting

## Related Projects

- [Azure MCP](https://github.com/Azure/azure-mcp) - Official Azure Model Context Protocol implementation

## License

See [LICENSE](LICENSE) file for details.

## Contributing

Issues and pull requests are welcome!
