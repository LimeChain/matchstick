![GitHub Banner-1](https://user-images.githubusercontent.com/32264020/128688825-29841c79-976a-428d-b5f0-0743739fc075.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

👋 Welcome to **Matchstick** - a unit testing framework for The Graph protocol. Try out your mapping logic in a sandboxed environment and ensure your handlers run correctly when deploying your awesome subgraph!

## Quick Start 🚀
### Docker 🐳
The quickest way to use **Matchstick** "out of the box" is to build and run an ubuntu-based Docker container with a **Matchstick** image. Steps:

- Install [Docker](https://docs.docker.com/get-docker/) if you don't have it already.

- Create a file named `Dockerfile` in the root folder of your subgraph project, and paste [the contents of this file](https://github.com/LimeChain/demo-subgraph/blob/main/Dockerfile) there.

- Build a **Matchstick** image using the following command:
```
docker build -t matchstick .
```

 - The build step might take a while, but once that's done we can quickly run our tests like this:
```
docker run --rm matchstick
```

or

```
docker run -it --rm --mount type=bind,source=<absolute/path/to/project>,target=/matchstick  matchstick
```

❗ If you want to pass arguments to **Matchstick** (for instance to test only a specific datasource or to generate a test coverage report) you can do so like this:
```
docker run -e ARGS="gravity" --rm matchstick
```

or

```
docker run -e ARGS="gravity" -it --rm --mount type=bind,source=<absolute/path/to/project>,target=/matchstick  matchstick
```

❗ **Note:** The second command will mount the project folder in the container, so you don't need to rebuild the image after every change to your code. Also any changes that happen to files during the run will persist on the host machine as well. [More info about docker bind mounts](https://docs.docker.com/storage/bind-mounts/)

After that you can go straight to [the final setup step](https://github.com/LimeChain/matchstick/tree/dockerize#install-dependencies) and you'll be all set to start writing your first unit test.

❗ Although using the Docker approach is easy, we highly recommend using **Matchstick** via OS-specific binary (which is downloaded automatically when you run `graph test`). The Docker approach should only be considered if for some reason you cannot get `graph test` to work, or if you just want to quickly try something out.

### OS-specific release binaries ⚙️
The release binary comes in two flavours - for **МacOS** and **Linux**. To add **Matchstick** to your subgraph project just open up a terminal, navigate to the root folder of your project and simply run `graph test` - it downloads the latest **Matchstick** binary and runs the specified test or all tests in a test folder (or all existing tests if no datasource flag is specified). Example usage: `graph test gravity`.

❗ If you don't have Postgres installed, you will need to install it. Instructions for that below:

#### MacOS 
❗ Postgres installation command:
```
brew install postgresql
```

#### Linux 🐧
❗ Postgres installation command (depends on your distro):
```
sudo apt install postgresql
```

### Install dependencies
In order to use the test helper methods and run the tests, you will need to install the following dependencies:

```
yarn add --dev matchstick-as
```

Now you can jump straight to the [examples](https://github.com/LimeChain/demo-subgraph#readme "examples of tests") in our [demo-subgraph](https://github.com/LimeChain/demo-subgraph "demo-subgraph") and start your journey in Subgraph unit testing!

## Building from source
### Prerequisites
To build and run **Matchstick** you need to have the following installed on your system:

- Rust - [How to install Rust](https://www.rust-lang.org/en-US/install.html "How to install Rust")
- PostgreSQL – [PostgreSQL Downloads](https://www.postgresql.org/download/)

### Setup
Clone this repository and run `cargo build`. If that executes successfully congratulations 🎉 you're all set.

**NOTE:** *You may encounter an error, related to missing `libpq` dependencies on your system. In that case - install the missing dependencies (listed in the error log) with your package manager.*

## Next steps 🎯
There is a lot of room for improvements to **Matchstick**. We're trying to gather as much feedback from subgraph developers as we can, to understand how we can solve the problems they face when building subgraphs, as well as how we can make the overall testing process as smooth and streamlined as possible.

There's a GitHub project board where we keep track of day to day work which you can check out [here](https://github.com/LimeChain/matchstick/projects/1 "here").

You can check out the full list of tasks [here](https://github.com/LimeChain/matchstick/projects/2).

## Technologies used 💻
![diagram-resized](https://user-images.githubusercontent.com/32264020/128724602-81699397-1bb9-4e54-94f5-bb0f40c2a38b.jpg)

The **Matchstick** framework is built in **Rust** and acts as a wrapper for the generated WebAssembly module that contains the mappings and the unit tests. It passes the host function implementations down to the module, to be used in the tests (and in the mappings if needed). The framework also acts as a proxy for structs defined in the [graph-node repo](https://github.com/graphprotocol/graph-node/tree/master/graph "graph-node repo"), because it needs to pass down all the usual imports, as well as a few bonus/mocked ones glued on top.

**Matchstick** also relies on a helper library - [matchstick-as](https://github.com/LimeChain/matchstick-as "matchstick-as"), written in **AssemblyScript** and used as an import in the unit tests.
