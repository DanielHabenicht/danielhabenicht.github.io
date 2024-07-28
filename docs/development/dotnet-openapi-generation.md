> New kid on the block:
> https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis/aspnetcore-openapi?view=aspnetcore-9.0&tabs=net-cli#lint-generated-openapi-documents-with-spectral

```bash
dotnet new tool-manifest
dotnet tool install Swashbuckle.AspNetCore.Cli

```

```xml name=project.csproj
  <PropertyGroup>
    <GenerateDocumentationFile>true</GenerateDocumentationFile>
  </PropertyGroup>
  ...
  <Target Name="PostBuild" AfterTargets="PostBuildEvent">
    <Exec Command="dotnet tool restore" />
    <Exec Command="dotnet swagger tofile --output swagger.json $(OutputPath)$(AssemblyName).dll 1.0" EnvironmentVariables="ASPNETCORE_ENVIRONMENT=Development" />
  </Target>
```
