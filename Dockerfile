FROM ubuntu:22.04

WORKDIR /usr/mcp
ENV NVM_DIR=/usr/local/.nvm
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
ENV PATH=$PATH:/usr/local/.nvm/versions/node/v24.12.0/bin
ENV AZURE_TOKEN_CREDENTIALS=AzureCliCredential

RUN mkdir /usr/local/.nvm && apt update && apt install -y libx11-6  curl && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    \. "/usr/local/.nvm/nvm.sh" && \
    nvm install 24 && \
    npm install @azure/mcp-linux-x64@latest && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["npx", "-y", "@azure/mcp@latest", "server", "start"]