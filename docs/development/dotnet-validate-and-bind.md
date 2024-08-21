rehackt.extensions.options.validation

```
builder.Services.ConfigureAndValidate<AppSettingsRootConfiguration>(options =>
{
    builder.Configuration.Bind(options);
});

builder.Services.AddSingleton(provider => Options.Create(provider
    .GetRequiredService<IOptions<AppSettingsRootConfiguration>>().Value
    .MacToolConfiguration));

builder.Services.AddSingleton(provider => provider
    .GetRequiredService<IOptions<AppSettingsRootConfiguration>>().Value.MacToolConfiguration
);
builder.Services.AddSingleton(provider => provider
    .GetRequiredService<IOptions<AppSettingsRootConfiguration>>().Value.Authentication
);
builder.Services.AddSingleton(provider => provider
    .GetRequiredService<IOptions<AppSettingsRootConfiguration>>().Value.MacToolConfiguration.LdapServerConfiguration
);
builder.Services.AddSingleton(provider => provider
    .GetRequiredService<IOptions<AppSettingsRootConfiguration>>().Value.MacToolConfiguration.ValidationConfiguration
);
```
