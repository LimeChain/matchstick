# Subtest 🧪⚙️
👋 Welcome to **Subtest** - a unit testing framework for The Graph protocol. Try out your mapping logic in a sandboxed environment and ensure your handlers run correctly when deploying your awesome subgraph!

![miro2](https://user-images.githubusercontent.com/32264020/123761690-bcf37f80-d8ca-11eb-9950-6452d7e972cd.jpeg)

## Quick Start 🚀
To download **Subtest**, simply run the following command in you terminal:

`curl -OL https://github.com/LimeChain/subtest/releases/download/0.0.2/subtest`

It will download the **subtest** binary, after that you just need to make it executable with this:

`chmod a+x subtest`

### Run
To run the framework, you just have to provide a path to a valid WASM instance where you have written and compiled your mappings along with your tests. To learn how to do that, proceed to the next section with user stories and practical examples. 

In order to run the framework with your compiled WASM binary, simply run:

`./subtest <PATH_TO_WASM>`

**NOTE:** We've included an [example WASM binary](https://github.com/LimeChain/subtest/blob/main/Gravity.wasm "generated WASM file"), generated from our [demo subgraph](https://github.com/LimeChain/demo-subgraph "demo subgraph"), you can run that with:

`./subtest "Gravity.wasm"`

Now you can jump straight to the [test examples](https://github.com/LimeChain/demo-subgraph/blob/main/src/tests.ts "examples of tests") we have in our [demo subgraph](https://github.com/LimeChain/demo-subgraph "demo subgraph") and start your journey in Subgraph unit testing!

## Setting up locally 📍
If you want to get **Subtest** up and running on your system with the minimal amount of hassle, this section is for you. This guide is aimed at both **macOS** and **Linux** systems.

### Prerequisites
To build and run **Subtest**  you need to have the following installed on your system:

- Rust - [How to install Rust](https://www.rust-lang.org/en-US/install.html "How to install Rust")

### Setup
Clone this repository and run `cargo build`. If that executes successfully congratulations 🎉 you're all set.

**NOTE:** *You may encounter an error, related to missing `libpq` dependencies on your system. In that case - install the missing dependencies (listed in the error log) with your package manager.*

### Run
To run the framework, you just have to provide a path to a valid WASM instance where you have written and compiled your mappings along with your tests. To learn how to do that, proceed to the next section with user stories and practical examples. 

`cargo run <PATH_TO_WASM>`

**NOTE:** We've included an [example WASM binary](https://github.com/LimeChain/subtest/blob/main/Gravity.wasm "generated WASM file"), generated from our [demo subgraph](https://github.com/LimeChain/demo-subgraph "demo subgraph"), you can run that with:

`cargo run "Gravity.wasm"`

## Example Usage 📖
To use **Subtest** you also need to have a generated WASM binary, which includes your mappings and your unit tests. To get that file simply run `graph build` the same way you would normally build your subgraph. The generated WASM file will be located in the `/build` folder of your subgraph project.

Let's explore a few common scenarios where we'd want to test our handler functions. We've created a [**demo subgraph repo**](https://github.com/LimeChain/demo-subgraph "demo subgraph") ❗to fully demonstrate how to use the framework and all its functionality using the [Example Subgraph](https://thegraph.com/docs/developer/create-subgraph-hosted "Example Subgraph"), provided by [The Graph Docs](https://thegraph.com/docs "The Graph Docs"), which you most likely will be familiar with. For the full examples, feel free to check it out in depth. Let's dive in straight to the code on there! We've got the following simple generated event:
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
Along with the following simple generated entity:
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
And finally, we have a handler function (that we've written in our `mapping.ts` file) that deals with the events. As well as two little helper functions - one for multiple events of the same type and another for creating new events of that type (You could of course consturct event objects manually each time, but it's a lot more hassle):
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

What we need to do is create a test file, we can name it however we want - let's say `tests.ts`, somewhere in our project. In our test file we need to define a function named `runTests()`, it's important that the function has that exact name (for now). This is an example of how our tests might look like:

```typescript
import { store } from "subtest-as/assembly/store";
import { test } from "subtest-as/assembly/index";
import { Gravatar } from "../generated/schema";
import { NewGravatar } from "../generated/Gravity/Gravity";
import { handleNewGravatars, createNewGravatarEvent } from "./mapping";

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
        store.assertFieldEq(GRAVATAR_ENTITY_TYPE, "gravatarId0", "id", "gravatarId0");
        store.assertFieldEq(GRAVATAR_ENTITY_TYPE, "12345", "id", "12345");
        store.assertFieldEq(GRAVATAR_ENTITY_TYPE, "3546", "id", "3546");

        store.clear();
    });
  
  test("Next test", () => {
    //...
  });
}
```

**DISCLAIMER:** *In order for that to work, we need to import the `runTests()` function in our mappings file. It won't be used there, but it has to be imported there so that it can get picked up by Rust later when running the tests.*

That's a lot to unpack! First off, an important thing to notice is that we're importing things from `subtest-as`, that's our AssemblyScript helper library (distributed as an npm module), which you can check out [here](https://github.com/LimeChain/subtest-as "here"). It provides us with useful testing methods and also defines the `test()` function which we will use to build our test blocks. It also gives us a mock implementation of the `store` and all of its functions. The rest of it is pretty straightforward - here's what happens:
- We're setting up our initial state and adding one custom Gravatar entity;
- We define two `NewGravatar` event objects along with their data;
- We're calling out handler methods for those events - `handleNewGravatars()` and passing in the list of our custom events;
- We assert the state of the store. How does that work? - We're passing a unique combination of Entity type and id. Then we check a specific field on that Entity and assert that it has the value we expect it to have. We're doing this both for the initial burger Entity we added and for the one that gets added when the handler function is called;
- And lastly - we're cleaning the store using `store.clean()` so that our next test can start with a fresh and empty store object. We can define as many test blocks as we want.

There we go - we've tested our first event handler! 👏

Now let's recap and take a look at some **User Stories**, which include what we already covered plus more useful things we can use **Subtest** for.

## User Stories 📝
### As a user I want to hydrate the store with a certain state
Users are able to hydrate the store with a known set of entities. Here's an example to initialise the store with a Gravatar entity:
```typescript
let gravatar = new Gravatar("entryId");
gravatar.save();
```

### As a user I want to call a mapping function with an event
A user can create a custom event Entity and pass it to a mapping function that is bound to the store:
```typescript
import { store } from "subtest-as/assembly/store";
import { handleNewGravatars, createNewGravatarEvent } from "./mapping";

let newGravatarEvent = createNewGravatarEvent(12345, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");

handleNewGravatar(newGravatarEvent);
```

### As a user I want to call all of the mappings with event fixtures
Users can call the mappings with test fixtures.
```typescript
import { store } from "subtest-as/assembly/store";
import { handleNewGravatars, createNewGravatarEvent } from "./mapping";

let newGravatarEvent = createNewGravatarEvent(12345, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");

let anotherGravatarEvent = createNewGravatarEvent(3546, "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7", "cap", "pac");

handleNewGravatars([newGravatarEvent, anotherGravatarEvent]);
```

### As a user I want to mock contract calls
Users can mock contract calls:
```typescript
import { test, mockFunction, callFunction } from "subtest-as/assembly/index";

mockFunction("0x000001234123", "exampleFuncName", ["param1", "param2"], "returnVal");
let returnValue = callFunction("0x000001234123", "exampleFuncName", ["param1", "param2"]);
```
In order to mock a contract call and hardcore a return value (string), the user must provide a contract address, function name, an array of parameters, and finally - a return value.

After that, calling `callFunction()` with the same address, name and parameters will return the specified value in `mockFunction()`.

### As a user I want to assert the state of the store
Users are able to assert the final (or midway) state of the store through asserting entities. In order to do this, the user has to supply an Entity type, the specific ID of an Entity, a name of a field on that Entity, and the expected value of the field. Here's a quick example:
```typescript
import { store } from "subtest-as/assembly/store";
import { Gravatar } from "../generated/schema";

let GRAVATAR_ENTITY_TYPE = "Gravatar";

let gravatar = new Gravatar("gravatarId0");
gravatar.save();

store.assertFieldEq(GRAVATAR_ENTITY_TYPE, "gravatarId0", "id", "gravatarId0");

```
Running the assertFieldEq() function will check for equality of the given field against the given expected value. The test will fail and an error message will be outputted if the values are **NOT** equal. Otherwise the test will pass successfully.

### As a user I want be able to interact with Event metadata
Users can *inject* default transaction data into any event object, as long as it inherits the base `ethereum.Event`. The following example shows how you can wrap any event with default metadata:
```typescript
import { store } from "subtest-as/assembly/store";
import { addMetadata } from "subtest-as/assembly/index";
import { Address, BigInt, Bytes, ethereum } from "@graphprotocol/graph-ts";
import { NewGravatar } from "../generated/Gravity/Gravity";

let base: ethereum.Event = new NewGravatar();
let newGravatarEvent = addMetadata(base);
```

Then you can read/write to those fiels like this:
```tyepscript
let logType = newGravatarEvent.logType;

let UPDATED_ADDRESS = "0xB16081F360e3847006dB660bae1c6d1b2e17eC2A";
newGravatarEvent.address = Address.fromString(UPDATED_ADDRESS);
```

### As a user I want to see test run time durations
The log output includes the test run duration. Here's an example:

`Jul 09 14:54:42.420 INFO Program execution time: 10.06022ms`

## Next steps 🎯
The **Subtest** framework is currently live for beta testing. There is a lot of room for improvements to everything we've talked about above. We're trying to gather as much feedback from subgraph developers as we can, to understand how we can solve the problems they face when building subgraphs, as well as how we can make the overall testing process as smooth and streamlined as possible.

There's a GitHub project board where we keep track of day to day work which you can check out [here](https://github.com/LimeChain/subtest/projects/1 "here").

Here are some of the areas we're set to focus on from here on out: 
- Unit tests;
- Style terminal output;
- Integrate framework in graph-cli.

## Technologies used 💻

The **Subtest** framework is built in **Rust** and acts as a wrapper for the generated WebAssembly module that contains the mappings and the unit tests. It passes the host function implementations down to the module, to be used in the tests (and in the mappings if needed). The framework also acts as a proxy for structs defined in the [graph-node repo](https://github.com/graphprotocol/graph-node/tree/master/graph "graph-node repo"), because it needs to pass down all the usual imports, as well as a few bonus/mocked ones glued on top.

**Subtest** also relies on a helper library - [subtest-as](https://github.com/LimeChain/subtest-as "subtest-as"), written in **AssemblyScript** and used as an import in the unit tests.
