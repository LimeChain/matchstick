# Subtest 🧪⚙️
👋 Welcome to **Subtest** - a unit testing framework for The Graph protocol. Try out your mapping logic in a sandboxed environment and ensure your handlers run correctly when deploying your awesome subgraph!

![miro2](https://user-images.githubusercontent.com/32264020/123761690-bcf37f80-d8ca-11eb-9950-6452d7e972cd.jpeg)

## Quick Start 🚀
To use **Subtest**, simply go to the [Releases page](https://github.com/LimeChain/subtest/releases "Releases page") on this repository and download the latest binary.

### Prerequisites
- PostgreSQL - [PostgreSQL Downloads](https://www.postgresql.org/download/ "PostgreSQL Downloads")

### Setup
Now that you have Postgres installed and you've downloaded the binary you need to get a few things set up before we can run **Subtest**. First off, run this in the terminal:

`export THEGRAPH_STORE_POSTGRES_DIESEL_URL=postgresql://<your_username>:@localhost:5432/thegraph`

Then you need to start up postgres with the following command:

`pg_ctl -D /usr/local/var/postgres start`

**NOTE:** *This step will not be needed in the future are we are not actually spinning up and using a DB anywhere within **Subtest**.*

### Run
To run the framework, you just have to provide a path to a valid WASM instance where you have written and compiled your mappings along with your tests. To learn how to do that, proceed to the next section with user stories and practical examples. 

`./subtest "MyWasmFile.wasm"`

## Setting up locally 📍
If you want to get **Subtest** up and running on your system with the minimal amount of hassle, this section is for you. This guide is aimed at both **macOS** and **Linux** systems.

### Prerequisites
To build and run **Subtest**  you need to have the following installed on your system (you should already have them set up if you have used the [graph-node](https://github.com/graphprotocol/graph-node "graph-node") repository locally):

- Rust - [How to install Rust](https://www.rust-lang.org/en-US/install.html "How to install Rust")
- PostgreSQL - [PostgreSQL Downloads](https://www.postgresql.org/download/ "PostgreSQL Downloads")

### Setup
Now that you have those installed you need to get a few things set up before we can run **Subtest**. First off, run this in the terminal:

`export THEGRAPH_STORE_POSTGRES_DIESEL_URL=postgresql://<your_username>:@localhost:5432/thegraph`

Then you need to start up postgres with the following command:

`pg_ctl -D /usr/local/var/postgres start`

**NOTE:** *This step will not be needed in the future are we are not actually spinning up and using a DB anywhere within **Subtest**.*

Clone this repository and run `cargo build`. If that executes successfully congratulations 🎉 you're all set.

### Run
To run the framework, you just have to provide a path to a valid WASM instance where you have written and compiled your mappings along with your tests. To learn how to do that, proceed to the next section with user stories and practical examples. 

`cargo run "MyWasmFile.wasm"`

## Example Usage 📖
Let's explore a few common scenarios where we'd want to test our handler functions. Imagine you're building a subgraph for some burger joint dApp. Occasionally the chefs will introduce new types of burgers to the menu, each burger will have a unique id and a name that describes its contents Let's assume we have the following simple event:
```typescript
export class NewBurgerEvent {
  id: string;
  name: string;
  
    constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }
}
```
Along with the following simple entity:
```typescript
import { Entity, TypedMapEntry, Value, ValueKind } from "@graphprotocol/graph-ts";

export class Burger extends Entity {
  id: string;

  constructor(id: string, name: string) {
    super();
    let value = new Value();
    value.kind = ValueKind.STRING;
    value.data = name as u64;
    this.entries.push(new TypedMapEntry("name", value));
    this.id = id;
  }
}
```
And finally, we have a handler function that deals with the events:
```typescript
export function handleNewBurger(event: NewBurgerEvent): void {
  let burgeEntity = new Burger(event.id, event.name);
  store.set(EntityTypes.BURGER, burgeEntity.id, burgeEntity);
}
```
That's all well and good, but what if we had more complex login in the handler function? We would want to check that the event that gets saved in the store looks the way we want it to look like.

What we need to do is create a test file, we can name it however we want - let's say `tests.ts`, somewhere in our project. In our test file we need to define a function named `runTests()`, it's important that the function has that exact name (for now). This is an example of how our tests might look like:

```typescript
import { store } from "subtest-as/assembly/store";
import {
  handleNewBurger,
  NewBurgerEvent,
  Burger,
  EntityTypes,
} from "../mappings/burger";

export function runTests(): void {
  test("Populates the store as expected", () => {
  
    // Initialise store
    let burger = new Burger("burgerId", "Pulled pork burger");
    store.set(EntityTypes.BURGER, burger.id, burger);

    // Defining and handling events
    let newBurgerEvent = new NewBurgerEvent("burgerId1", "Veggie");
    handleNewBurger(newBurgerEvent);

    // Asserting the end state of the store
    store.assertFieldEq(EntityTypes.BURGER, "burgerId", "name", "Pulled pork burger");
    store.assertFieldEq(EntityTypes.BURGER, "burgerId1", "name", "Veggie");

    store.clear();
  });
  
  test("Next test", () => {
    //...
  });
}
```

**DISCLAIMER:** *In order for that to work, we need to import the `runTests()` function in our mappings file. It won't be used there, but it has to be imported there so that it can get picked up by Rust later when running the tests.*

That's a lot to unpack! First off, an important thing to notice is that we're importing things from `subtest-as`, that's our AssemblyScript helper library (distributed as an npm module), which you can check out [here](https://github.com/LimeChain/subtest-as "here"). It provides us with useful testing methods and also defines the `test()` function which we will use to build our test blocks. It also gives us a mock implementation of the `store` and all of its functions. The rest of it is pretty straightforward - here's what happens:
- We're setting up our initial state and adding one custom Burger entity;
- We define our `NewBurgerEvent` along with its information for the burger id and burger name;
- We're calling out handler method for that event - `handleNewBurger()` and passing in our custom event;
- We assert the state of the store. How does that work? - We're passing a unique combination of Entity type and id. Then we check a specific field on that Entity and assert that it has the value we expect it to have. We're doing this both for the initial burger Entity we added and for the one that gets added when the handler function is called;
- And lastly - we're cleaning the store using `store.clean()` so that our next test can start with a fresh and empty store object. We can define as many test blocks as we want.

There we go - we've tested our first event handler! 👏

Now let's recap and take a look at some **User Stories**, which include what we already covered plus more useful things we can use **Subtest** for.

## User Stories 📝
### As a user I want to hydrate the store with a certain state
Users are able to hydrate the store with a known set of entities. Here's an example to initialise the store with a single burger entity:
```typescript
let burger = new Burger("burgerId", "Pulled pork burger");
store.set(EntityTypes.BURGER, burger.id, burger);
```
We can also do that with multiple entities:
```typescript
import {
  handleTestEvent,
  handleNewBurger,
  TestEvent,
  NewBurgerEvent,
  TestEntity,
  Burger,
  EntityTypes,
} from "../mappings/burger";

let porkBurger = new Burger("burgerId", "Pulled pork burger");
let veganBurger = new Burger("burgerId1", "Vegan burger");

let burgerEntities: Array<Burger> = [porkBurger, veganBurger];

burgerEntities.forEach(burger => {
  store.set(EntityTypes.BURGER, burger.id, burger)
})
```

### As a user I want to call a mapping function with an event
A user can create a custom event Entity and pass it to a mapping function that is bound to the store:
```typescript
import {
  handleNewBurger,
  NewBurgerEvent,
  Burger,
} from "../mappings/burger";

let newBurgerEvent = new NewBurgerEvent("burgerId1", "Veggie");
handleNewBurger(newBurgerEvent);

let anotherNewBurgerEvent = new NewBurgerEvent("burgerId2", "Chiken teriyaki burger");
handleNewBurger(anotherNewBurgerEvent);
```

### As a user I want to call all of the mappings with event fixtures
Users can call the mappings with test fixtures.
In the mapping file:
```typescript
export function handleNewBurgers(events: NewBurgerEvent[]): void {
  events.forEach(event => {
    handleNewBurger(event);
  });
}
```

In the test file:
```typescript
import {
  handleNewBurgers,
  NewBurgerEvent,
  Burger,
} from "../mappings/burger";

let newBurgerEvent = new NewBurgerEvent("burgerId1", "Veggie");
let anotherNewBurgerEvent = new NewBurgerEvent("burgerId2", "Chiken teriyaki burger");

handleNewBurgers([newBurgerEvent, anotherNewBurgerEvent]);
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
import {
  handleNewBurger,
  NewBurgerEvent,
  Burger,
  EntityTypes,
} from "../mappings/burger";

let burger = new Burger("burgerId", "Pulled pork burger")
store.set(EntityTypes.BURGER, burger.id, burger);

store.assertFieldEq(EntityTypes.BURGER, "burgerId", "name", "Pulled pork burger");
```
Running the assertFieldEq() function will check for equality of the given field against the given expected value and return the following log message if the fields are equal:

`Jun 28 17:00:42.019 INFO Success! Field 'name' on entity with type 'Burger' and id 'burgerId' equals 'Pulled pork burger'.`

And if they're not equal, the test block will fail and a relevant error message will be shown.

### As a user I want to see test run time durations
The log output includes the test run duration. Here's an example:

`Jun 28 17:24:46.312 INFO Program execution time: 775.439512ms`

## Next steps 🎯
The **Subtest** framework is still very much a work in progress. There is a lot of room for improvements to everything we've talked about above. We're trying to gather as much feedback from subgraph developers as we can, to understand how we can solve the problems they face when building subgraphs, as well as how we can make the overall testing process as smooth and streamlined as possible.

There's a GitHub project board where we keep track of day to day work which you can check out [here](https://github.com/LimeChain/subtest/projects/1 "here").

Here are some of the areas we're set to focus on from here on out: 
- Hold transaction information in Event object;
- Mock contract function reverts;
- Create a demo subgraph for showcasing the framework;
- Set up CI/CD;
- Refactor Rust code to remove as much hardcoded structs and functions as possible (import them from graph-node instead);
- Add detailed error messages and test failure information;
- Unit tests;
- Style terminal output;
- Remove need for using PostgreSQL;
- Integrate framework in graph-cli.

Estimated time for those tasks: ~ 7.5 weeks

## Technologies used 💻

The **Subtest** framework is built in **Rust** and acts as a wrapper for the generated WebAssembly module that contains the mappings and the unit tests. It passes the host function implementations down to the module, to be used in the tests (and in the mappings if needed). The framework also acts as a proxy for structs defined in the [graph-node repo](https://github.com/graphprotocol/graph-node/tree/master/graph "graph-node repo"), because it needs to pass down all the usual imports, as well as a few bonus/mocked ones glued on top.

**Subtest** also relies on a helper library - [subtest-as](https://github.com/LimeChain/subtest-as "subtest-as"), written in **AssemblyScript** and used as an import in the unit tests.
