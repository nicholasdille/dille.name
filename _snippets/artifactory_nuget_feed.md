---
title: 'Docker lessons learned'
layout: snippet
tags:
- Docker
---
1. Create NuGet repo in Artifactory
2. Install NuGet on build agent
3. Register new repository:

    ```powershell
    Register-PSRepository -Name Artifactory -SourceLocation http://10.12.12.157:8081/artifactory/api/nuget/dillen-nuget -PublishLocation http://10.12.12.157:8081/artifactory/api/nuget/dillen-nuget -InstallationPolicy Trusted
    ```

4. Publish module:

    ```powershell
    Publish-Module -Name Foobar -Repository Artifactory -NuGetApiKey 'dillen:XXX'
    ```

The NuGetApiKey is retrieved from Artifactory using the "Set Me Up" button of the repository.
