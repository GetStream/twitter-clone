# Node backend
The `server` directory contains a small Node backend that is required to run this app.

Take your terminal into the `server` directory and run:
```shell
npm start
```

# iOS Frontend

The folder TwitterClone contains the iOS codebase.

To get started with it, you need to install Tuist and run `tuist generate` in the directory `TwitterClone`. Then open the `TwitterClone.xcworkspace` file.

[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)


## To install Tuist on your system:

Run:
```shell
curl -Ls https://install.tuist.io | bash
```

## Generate and open project files
To generate the Xcode project files and open the project in Xcode, run:
```shell
tuist generate
```

# iOS package graph
We work towards a µFramework based packaging system.

![](TwitterClone/graph.png)


