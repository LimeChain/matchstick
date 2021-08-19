![GitHub Bannet-1](https://user-images.githubusercontent.com/32264020/128688825-29841c79-976a-428d-b5f0-0743739fc075.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

👋 Welcome to **Matchstick** - a unit testing framework for The Graph protocol. Try out your mapping logic in a sandboxed environment and ensure your handlers run correctly when deploying your awesome subgraph!

## Quick Start 🚀
The release binary comes in three flavours - for **MacOS**, **Linux** and **Windows**. To add **Matchstick** to your subgraph project just open up a terminal, navigate to the root folder of your project and simply follow these steps (depending on your OS):

### MacOS 

```
curl -OL https://github.com/LimeChain/matchstick/releases/download/0.1.0/binary-macos &&
mv binary-macos matchstick &&
chmod a+x matchstick
```

❗ If you don't have Postgres installed, you will need to install it with:
```
brew install postgresql
```

### Linux 🐧

```
curl -OL https://github.com/LimeChain/matchstick/releases/download/0.1.0/binary-linux &&
mv binary-linux matchstick &&
chmod a+x matchstick
```

❗ If you don't have Postgres installed, you will need to install it with (depending on your distro):
```
sudo apt install postgresql
```

### Windows

```
curl -OL https://github.com/LimeChain/matchstick/releases/download/0.1.0/binary-windows &&
move binary-windows matchstick
```

❗ If you don't have Postgres installed, you will need to install it with (depending on your distro):
```
choco install postgresql12
```

### Install dependencies
In order to use the test helper methods and run the tests, you will need to install the following dependencies:

```
yarn add matchstick-as
```

### Run
To run the framework, you simply need to provide a datasource name (after you've compiled your subgraph using `graph build`).

Just run the following in the root folder of your project:

`./matchstick <DATASOURCE NAME>`

For instance, in our [demo subgraph example](https://github.com/LimeChain/demo-subgraph "demo subgraph"), the command look like this:

`./matchstick Gravity`

**Tip:** You can build your subgraph (along with your tests) and run the framework in one step using:
`graph build && ./matchstick Gravity`

**Tip:** Add this commant to your `package.json` file to run the tests with `yarn test` and possibly on CI:
```js
// package.json
{
  // ...
  "scripts:" {
    // ...
    "test": "graph build && ./matchstick Gravity"
  }
}
```

Now you can jump straight to the [test examples](https://github.com/LimeChain/demo-subgraph/blob/main/src/tests.ts "examples of tests") we have in our [demo subgraph](https://github.com/LimeChain/demo-subgraph "demo subgraph") and start your journey in Subgraph unit testing!

## Setting up locally 📍
If you want to get the **Matchstick** project up and running on your system, follow these simple steps. This guide is aimed at both **MacOS** and **Linux** systems.

### Prerequisites
To build and run **Matchstick**  you need to have the following installed on your system:

- Rust - [How to install Rust](https://www.rust-lang.org/en-US/install.html "How to install Rust")
- PostgreSQL – [PostgreSQL Downloads](https://www.postgresql.org/download/)

### Setup
Clone this repository and run `cargo build`. If that executes successfully congratulations 🎉 you're all set.

**NOTE:** *You may encounter an error, related to missing `libpq` dependencies on your system. In that case - install the missing dependencies (listed in the error log) with your package manager.*

## Example Usage 📖
Let's explore a few common scenarios where we'd want to test our handler functions. We've created a [**demo subgraph repo**](https://github.com/LimeChain/demo-subgraph "demo subgraph") ❗to fully demonstrate how to use the framework and all its functionality. It uses the [Example Subgraph](https://thegraph.com/docs/developer/create-subgraph-hosted "Example Subgraph"), provided by [The Graph Docs](https://thegraph.com/docs "The Graph Docs"), which you most likely will be familiar with. For the full examples, feel free to check it out in depth. Let's dive in straight to the code on there! We've got the following simple **generated** event:
```typescript
export class NewGravatar extends ethereum.Event {
  get params(): NewGravatar__Params {
    return new NewGravatar__Params(this);
  }
}

export class NewGravatar__Params {
  _event: NewGravatar;

  constructor(event: NewGravatar) {
    this._event = event;
  }

  get id(): BigInt {
    return this._event.parameters[0].value.toBigInt();
  }

  get owner(): Address {
    return this._event.parameters[1].value.toAddress();
  }

  get displayName(): string {
    return this._event.parameters[2].value.toString();
  }

  get imageUrl(): string {
    return this._event.parameters[3].value.toString();
  }
}
```
Along with the following simple **generated** entity:
```typescript
export class Gravatar extends Entity {
  constructor(id: string) {
    super();
    this.set("id", Value.fromString(id));
  }

  save(): void {
    let id = this.get("id");
    assert(id !== null, "Cannot save Gravatar entity without an ID");
    assert(
      id.kind == ValueKind.STRING,
      "Cannot save Gravatar entity with non-string ID. " +
        'Considering using .toHex() to convert the "id" to a string.'
    );
    store.set("Gravatar", id.toString(), this);
  }

  static load(id: string): Gravatar | null {
    return store.get("Gravatar", id) as Gravatar | null;
  }

  get id(): string {
    let value = this.get("id");
    return value.toString();
  }

  set id(value: string) {
    this.set("id", Value.fromString(value));
  }

  get owner(): Bytes {
    let value = this.get("owner");
    return value.toBytes();
  }

  set owner(value: Bytes) {
    this.set("owner", Value.fromBytes(value));
  }

  get displayName(): string {
    let value = this.get("displayName");
    return value.toString();
  }

  set displayName(value: string) {
    this.set("displayName", Value.fromString(value));
  }

  get imageUrl(): string {
    let value = this.get("imageUrl");
    return value.toString();
  }

  set imageUrl(value: string) {
    this.set("imageUrl", Value.fromString(value));
  }
}
```
And finally, we have a handler function (**that we've written in our** `mapping.ts` **file**) that deals with the events. As well as two little helper functions - one for multiple events of the same type and another for creating new events of that type (You could of course consturct event objects manually each time, but it's a lot more hassle):
```typescript
export function handleNewGravatar(event: NewGravatar): void {
    let gravatar = new Gravatar(event.params.id.toHex())
    gravatar.owner = event.params.owner
    gravatar.displayName = event.params.displayName
    gravatar.imageUrl = event.params.imageUrl
    gravatar.save()
}

export function handleNewGravatars(events: NewGravatar[]): void {
    events.forEach(event => {
        handleNewGravatar(event);
    });
}

export function createNewGravatarEvent(id: i32, ownerAddress: string, displayName: string, imageUrl: string): NewGravatar {
    let newGravatarEvent = new NewGravatar();
    newGravatarEvent.parameters = new Array();
    let idParam = new ethereum.EventParam();
    idParam.value = ethereum.Value.fromI32(id);
    let addressParam = new ethereum.EventParam();
    addressParam.value = ethereum.Value.fromAddress(Address.fromString(ownerAddress));
    let displayNameParam = new ethereum.EventParam();
    displayNameParam.value = ethereum.Value.fromString(displayName);
    let imageUrlParam = new ethereum.EventParam();
    imageUrlParam.value = ethereum.Value.fromString(imageUrl);

    newGravatarEvent.parameters.push(idParam);
    newGravatarEvent.parameters.push(addressParam);
    newGravatarEvent.parameters.push(displayNameParam);
    newGravatarEvent.parameters.push(imageUrlParam);

    return newGravatarEvent;
}
```
That's all well and good, but what if we had more complex logic in the handler function? We would want to check that the event that gets saved in the store looks the way we want it to look like.

What we need to do is create a test file, we can name it however we want - let's say `gravity.test.ts`, in our project. In our test file we need to define a function named `runTests()`, it's important that the function has that exact name (for now). This is an example of how our tests might look like:

```typescript
import { clearStore, test, assert } from "matchstick-as/assembly/index";
import { Gravatar } from "../../generated/schema";
import { createNewGravatarEvent, handleNewGravatars } from "../mappings/gravity";

export function runTests(): void {
  test("Can call mappings with custom events", () => {
        // Initialise
        let gravatar = new Gravatar("gravatarId0");
        gravatar.save();

        // Call mappings
        let newGravatarEvent = createNewGravatarEvent(12345, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");
        let anotherGravatarEvent = createNewGravatarEvent(3546, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");
        
        handleNewGravatars([newGravatarEvent, anotherGravatarEvent]);

	// Assert the state of the store
	assert.fieldEquals("Gravatar", "gravatarId0", "id", "gravatarId0");
      	assert.fieldEquals("Gravatar", "12345", "id", "12345");
        assert.fieldEquals("Gravatar", "3546", "id", "3546");

        clearStore();
    });
  
  test("Next test", () => {
    //...
  });
}
```

❗ **IMPORTANT:** *In order for that to work, we need to import the `runTests()` function in our mappings file. It won't be used there, but it has to be imported there so that it can get picked up by Rust later when running the tests.*

You can import the tests wrapper function in your mappings file like this:

```
export { runTests } from "../tests/gravity.test.ts";
```

❗ **IMPORTANT:** *Currently there's an issue with using matchstick when deploying your subgraph. Please only use Matchstick for local testing, and remove/comment out this line (`export { runTests } from "../tests/gravity.test.ts"`) once you're done. We expect to resolve this issue shortly, sorry for the inconvenience!*

*If you don't remove that line, you will get the following error message when attempting to deploy your subgraph:*
```
/...
Mapping terminated before handling trigger: oneshot canceled
.../
```

That's a lot to unpack! First off, an important thing to notice is that we're importing things from `matchstick-as`, that's our AssemblyScript helper library (distributed as an npm module), which you can check out [here](https://github.com/LimeChain/matchstick-as "here"). It provides us with useful testing methods and also defines the `test()` function which we will use to build our test blocks. The rest of it is pretty straightforward - here's what happens:
- We're setting up our initial state and adding one custom Gravatar entity;
- We define two `NewGravatar` event objects along with their data;
- We're calling out handler methods for those events - `handleNewGravatars()` and passing in the list of our custom events;
- We assert the state of the store. How does that work? - We're passing a unique combination of Entity type and id. Then we check a specific field on that Entity and assert that it has the value we expect it to have. We're doing this both for the initial burger Entity we added and for the one that gets added when the handler function is called;
- And lastly - we're cleaning the store using `clearStore()` so that our next test can start with a fresh and empty store object. We can define as many test blocks as we want.

There we go - we've tested our first event handler! 👏

Now let's recap and take a look at some **User Stories**, which include what we already covered plus more useful things we can use **Matchstick** for.

## User Stories 📝
### As a user I want to hydrate the store with a certain state
Users are able to hydrate the store with a known set of entities. Here's an example to initialise the store with a Gravatar entity:
```typescript
let gravatar = new Gravatar("entryId");
gravatar.save();
```

### As a user I want to call a mapping function with an event
A user can create a custom event and pass it to a mapping function that is bound to the store:
```typescript
import { store } from "matchstick-as/assembly/store";
import { handleNewGravatars, createNewGravatarEvent } from "./mapping";

let newGravatarEvent = createNewGravatarEvent(12345, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");

handleNewGravatar(newGravatarEvent);
```

### As a user I want to call all of the mappings with event fixtures
Users can call the mappings with test fixtures.
```typescript
import { store } from "matchstick-as/assembly/store";
import { handleNewGravatars, createNewGravatarEvent } from "./mapping";

let newGravatarEvent = createNewGravatarEvent(12345, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");

let anotherGravatarEvent = createNewGravatarEvent(3546, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");

handleNewGravatars([newGravatarEvent, anotherGravatarEvent]);
```

### As a user I want to mock contract calls
Users can mock contract calls:
```typescript
import { addMetadata, assert, createMockedFunction, clearStore, test } from "matchstick-as/assembly/index";
import { Gravity } from "../../generated/Gravity/Gravity";
import { Address, BigInt, ethereum } from "@graphprotocol/graph-ts";

let contractAddress = Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7");
let expectedResult = Address.fromString("0x90cBa2Bbb19ecc291A12066Fd8329D65FA1f1947");
let bigIntParam = BigInt.fromString("1234");
createMockedFunction(contractAddress, "gravatarToOwner", "gravatarToOwner(uint256):(address)")
    .withArgs([ethereum.Value.fromSignedBigInt(bigIntParam)])
    .returns([ethereum.Value.fromAddress(Address.fromString("0x90cBa2Bbb19ecc291A12066Fd8329D65FA1f1947"))]);

let gravity = Gravity.bind(contractAddress);
let result = gravity.gravatarToOwner(bigIntParam);

assert.equals(ethereum.Value.fromAddress(expectedResult), ethereum.Value.fromAddress(result));
```
As demonstrated, in order to mock a contract call and hardcore a return value, the user must provide a contract address, function name, function signature, an array of arguments, and of course - the return value.

Users can also mock function reverts:
```typescript
let contractAddress = Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7");
createMockedFunction(contractAddress, "getGravatar", "getGravatar(address):(string,string)")
    .withArgs([ethereum.Value.fromAddress(contractAddress)])
    .reverts();
```

### As a user I want to assert the state of the store
Users are able to assert the final (or midway) state of the store through asserting entities. In order to do this, the user has to supply an Entity type, the specific ID of an Entity, a name of a field on that Entity, and the expected value of the field. Here's a quick example:
```typescript
import { assert } from "matchstick-as/assembly/index";
import { Gravatar } from "../generated/schema";

let gravatar = new Gravatar("gravatarId0");
gravatar.save();

assert.fieldEquals("Gravatar", "gravatarId0", "id", "gravatarId0");

```
Running the assert.fieldEquals() function will check for equality of the given field against the given expected value. The test will fail and an error message will be outputted if the values are **NOT** equal. Otherwise the test will pass successfully.

### As a user I want be able to interact with Event metadata
Users can *inject* default transaction data into any event object, as long as it inherits the base `ethereum.Event`. The following example shows how you can wrap any event with default metadata:
```typescript
import { addMetadata } from "matchstick-as/assembly/index";
import { Address, BigInt, Bytes, ethereum } from "@graphprotocol/graph-ts";
import { NewGravatar } from "../generated/Gravity/Gravity";

let base: ethereum.Event = new NewGravatar();
let newGravatarEvent: NewGravatar = addMetadata(base);
```

Then you can read/write to those fields like this:
```typescript
let logType = newGravatarEvent.logType;

let UPDATED_ADDRESS = "0xB16081F360e3847006dB660bae1c6d1b2e17eC2A";
newGravatarEvent.address = Address.fromString(UPDATED_ADDRESS);
```

### As a user I want be able to assert if variables are equal
```typescript
assert.equals(ethereum.Value.fromString("hello"), ethereum.Value.fromString("hello"));
```

### As a user I want to see test run time durations
The log output includes the test run duration. Here's an example:

`Jul 09 14:54:42.420 INFO Program execution time: 10.06022ms`

## Next steps 🎯
The **Matchstick** framework is currently live for beta testing. There is a lot of room for improvements to everything we've talked about above. We're trying to gather as much feedback from subgraph developers as we can, to understand how we can solve the problems they face when building subgraphs, as well as how we can make the overall testing process as smooth and streamlined as possible.

There's a GitHub project board where we keep track of day to day work which you can check out [here](https://github.com/LimeChain/matchstick/projects/1 "here").

Here are some of the areas we're set to focus on from here on out:
- Integration to in graph-cli.
- Improvements and feature requests.

Known issues:
- When `runTests()` is imported in the mappings file the deployment to the hosted service will break. For now, it's required to remove/comment out the import.

You can check out the full list of tasks [here](https://github.com/LimeChain/matchstick/projects/2).

## Technologies used 💻

![diagram-resized](https://user-images.githubusercontent.com/32264020/128724602-81699397-1bb9-4e54-94f5-bb0f40c2a38b.jpg)

The **Matchstick** framework is built in **Rust** and acts as a wrapper for the generated WebAssembly module that contains the mappings and the unit tests. It passes the host function implementations down to the module, to be used in the tests (and in the mappings if needed). The framework also acts as a proxy for structs defined in the [graph-node repo](https://github.com/graphprotocol/graph-node/tree/master/graph "graph-node repo"), because it needs to pass down all the usual imports, as well as a few bonus/mocked ones glued on top.

**Matchstick** also relies on a helper library - [matchstick-as](https://github.com/LimeChain/matchstick-as "matchstick-as"), written in **AssemblyScript** and used as an import in the unit tests.
