# Subtest 🧪⚙️
👋 Welcome to **Subtest** - a unit testing framework for The Graph protocol. Try out your mapping logic in a sandboxed environment and ensure your handlers run correctly when deploying your awesome subgraph!

## Quickstart 🚀
If you want to get **Subtest** up and running on your system with the minimal amount of hassle, this section is for you. This guide is aimed at both **macOS** and **Linux** systems.

### Prerequisites 📝
To build and run **Subtest**  you need to have the following installed on your system (you should already have them set up if you have used the [graph-node](https://github.com/graphprotocol/graph-node "graph-node") repository locally):

- Rust - [How to install Rust](https://www.rust-lang.org/en-US/install.html "How to install Rust")
- PostgreSQL - [PostgreSQL Downloads](https://www.postgresql.org/download/ "PostgreSQL Downloads")

### Setup 🔧
Now that you have those installed you need to get a few things set up before we can run **Subtest**. First off, run this in the terminal:

`export THEGRAPH_STORE_POSTGRES_DIESEL_URL=postgresql://<your_username>:@localhost:5432/thegraph`

Then you need to start up postgres with the following command:

`pg_ctl -D /usr/local/var/postgres start`

**NOTE:** This step will not be needed in the future are we are not actually spinning up and using a DB anywhere within **Subtest**.

Clone this repository and run `cargo build`. If that executes successfully congratulations 🎉 you're all set. 
