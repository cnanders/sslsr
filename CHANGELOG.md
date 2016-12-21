# 1.0.0-alpha.6

- Migrated Sslsr.m into sins.main.Main()
- Built sins.sins.SinsTest() class that builds maskT and filterY and connects to Carl's test jar
- refactored pkg directory so it can support multiple package root folders

# 1.0.0-alpha.5

- Migrating to mic.v1.0.0-alpha.33.  This required changing instances of Utils.\*() to MicUtils.\*()
- Building scoped package for project classes (outside of MIC library)

# 1.0.0-alpha.4

- Added Sample -> LL button on Stages panel and implemented a state scan to move the system to the LL state.  Currently the state is temporary.  Need to update with true LL state.
- Migrating to mic v1.0.0-alpha.26 (there was a bug in v1.0.0-alpha.25 due to names of API wrappers being ambiguous)

# 1.0.0-alpha.3

- Migrating to mic v1.0.0-alpha.25
- Using CamelCase consistent with mic v1.0.0-alpha.25.  E.g., API -> Api; APIV -> Apiv; HIOTX -> Hiotx


## Requirements

- https://github.com/cnanders/mic v1.0.0-alpha.25

# 1.0.0-alpha.2

- Moving to latest MIC release that includes complete Keithley6482

## Requirements

- https://github.com/cnanders/mic v1.0.0-alpha.20

# 1.0.0-alpha.1

## Requirements

- https://github.com/cnanders/mic v1.0.0-alpha.4