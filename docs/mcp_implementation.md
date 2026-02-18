# Implementing Model Context Protocol (MCP)

To implement MCP, you typically build an "MCP Server" that exposes tools and resources to an AI client.

## Quick Start (Python)

The easiest way is using the `mcp` Python SDK with `FastMCP`.

### 1. Install dependencies
```bash
pip install "mcp[cli]"
```

### 2. Create your server script (`server.py`)

This example defines a simple calculator tool.

```python
from mcp.server.fastmcp import FastMCP

# Create an MCP server
mcp = FastMCP("My Demo Server")

# Define a tool
@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b

# Define a resource (read-only data)
@mcp.resource("greeting://{name}")
def get_greeting(name: str) -> str:
    """Get a personalized greeting"""
    return f"Hello, {name}!"

if __name__ == "__main__":
    # Run the server
    mcp.run()
```

### 3. Run and Debug

Use the inspector to test your server without configuring a client:
```bash
mcp dev server.py
```

### 4. Configuration

To use this server with your AI client (e.g., Claude Desktop), add it to your configuration file:

```json
{
  "mcpServers": {
    "my-demo": {
      "command": "python",
      "args": ["/absolute/path/to/server.py"]
    }
  }
}
```

## Core Concepts
- **Tools**: Functions the AI can execute (e.g., calculate, search_web).
- **Resources**: Data the AI can read (e.g., file contents, API responses).
- **Prompts**: Reusable prompt templates for specific tasks.
