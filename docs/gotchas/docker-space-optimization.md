You're Docker Images are getting bigger? This is how you save some space:

Just add this at the end of your apt-get update line:

```
RUN apt-get update && apt-get install -y your-cool packages && rm -rf /var/lib/apt/lists/*
```

It removes most of the junk installed by apt-get update
