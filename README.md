# About
Matlab UI for the Singapore Synchrotron Light Source Reflectomer

# Installation

1. Clone the repos of all [dependencies](#dependencies) into your MATLAB project, preferably in a “vendor” directory.  See [Recommended Project Structure](#project-structure)

2. Add all dependencies to the MATLAB path, e.g., 

```matlab
addpath(genpath('pkg'));
addpath(genpath('vendor/github/cnanders/mic'));
```
<a name="dependencies"></a>
# Dependencies

- [github/cnanders/mic](https://github.com/cnanders/mic) > v1.0.0-alpha.44


<a name="project-structure"></a>
# Recommended Project Structure

- project/
  - vendor/
    - github/
      - cnanders/
        - mic/ **(dependency)**
  - pkg/
  - launch.m