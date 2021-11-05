import { assert, createMockedFunction, clearStore, test, newMockEvent, newMockCall } from "matchstick-as/assembly/index"
import { Address, BigInt, Bytes, ethereum, store, Value } from "@graphprotocol/graph-ts"

import { createNewGravatarEvent } from "./utils"
import { Gravatar } from "../../generated/schema"
import { Gravity, NewGravatar, CreateGravatarCall } from "../../generated/Gravity/Gravity"
import { handleNewGravatars, saveGravatarFromContract, trySaveGravatarFromContract, handleCreateGravatar } from "../../src/gravity"

let GRAVATAR_ENTITY_TYPE = "Gravatar"
let TRANSACTION_ENTITY_TYPE = "Transaction"

test("Can mock and call function with different argument types", () => {
  let numValue = ethereum.Value.fromI32(152)
  let stringValue = ethereum.Value.fromString("example string value")
  let arrayValue = ethereum.Value.fromI32Array([156666, 123412])
  let booleanValue = ethereum.Value.fromBoolean(true)
  let objectValue = ethereum.Value.fromAddress(Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7"))

  let argsArray: Array<ethereum.Value> = [numValue, stringValue, arrayValue, booleanValue, objectValue]
  createMockedFunction(Address.fromString("0x90cBa2Bbb19ecc291A12066Fd8329D65FA1f1947"), "funcName", "funcName():(void)")
    .withArgs(argsArray)
    .returns([ethereum.Value.fromString("result")])
  let val = ethereum.call(new ethereum.SmartContractCall("conName", Address.fromString("0x90cBa2Bbb19ecc291A12066Fd8329D65FA1f1947"), "funcName", "funcName():(void)", argsArray))![0]

  assert.equals(ethereum.Value.fromString("result"), val)
})

test("Can test if mocked function reverts", () => {
  createMockedFunction(Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7"), "revert", "").reverts()
  let val = ethereum.call(new ethereum.SmartContractCall("conName", Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7"), "revert", "", []))

  assert.equals(ethereum.Value.fromBoolean(true), ethereum.Value.fromBoolean(val == null))
})

test("Can mock gravity function correctly", () => {
  let contractAddress = Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
  let expectedResult = Address.fromString("0x90cBa2Bbb19ecc291A12066Fd8329D65FA1f1947")
  let bigIntParam = BigInt.fromString("1234")
  createMockedFunction(contractAddress, "gravatarToOwner", "gravatarToOwner(uint256):(address)")
    .withArgs([ethereum.Value.fromSignedBigInt(bigIntParam)])
    .returns([ethereum.Value.fromAddress(Address.fromString("0x90cBa2Bbb19ecc291A12066Fd8329D65FA1f1947"))])

  let gravity = Gravity.bind(contractAddress)
  let result = gravity.gravatarToOwner(bigIntParam)

  assert.equals(ethereum.Value.fromAddress(expectedResult), ethereum.Value.fromAddress(result))
})

test("Should throw an error", () => {
  throw new Error()
}, true)

test("Can initialise store with an array of Entity objects", () => {
  let gravatar = new Gravatar("entryId")
  gravatar.save()

  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "entryId", "id", "entryId")

  clearStore()
})

test("Can call mappings with custom events", () => {
  // Initialise
  let gravatar = new Gravatar("gravatarId0")
  gravatar.save()

  // Call mappings
  let newGravatarEvent = createNewGravatarEvent(
      12345,
      "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7",
      "cap",
      "pac",
  )

  let anotherGravatarEvent = createNewGravatarEvent(
      3546,
      "0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7",
      "cap",
      "pac",
  )

  handleNewGravatars([newGravatarEvent, anotherGravatarEvent])

  assert.fieldEquals(
      GRAVATAR_ENTITY_TYPE,
      "gravatarId0",
      "id",
      "gravatarId0",
  )
  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "12345", "id", "12345")
  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "3546", "id", "3546")
  clearStore()
})

test("Can use entity.load() to retrieve entity from store", () => {
  let gravatar = new Gravatar("gravatarId0")
  gravatar.save()

  let retrievedGravatar = Gravatar.load("gravatarId0")
  assert.equals(ethereum.Value.fromString("gravatarId0"), ethereum.Value.fromString(retrievedGravatar!.get("id")!.toString()))
})

test("Returns null when calling entity.load() if an entity doesn't exist", () => {
  let retrievedGravatar = Gravatar.load("IDoNotExist")
  assert.equals(ethereum.Value.fromBoolean(true), ethereum.Value.fromBoolean(retrievedGravatar == null))
})

test("Can update entity that already exists using Entity.save()", () => {
  let gravatar = new Gravatar("23")
  gravatar.imageUrl = "https://wow.zamimg.com/uploads/screenshots/small/659866.jpg"
  gravatar.save()

  // Retrieve same entity from the store
  gravatar = Gravatar.load("23") as Gravatar
  gravatar.set("imageUrl", Value.fromString("https://i.ytimg.com/vi/MELP46s8Cic/maxresdefault.jpg"))
  gravatar.save()

  assert.fieldEquals(
      GRAVATAR_ENTITY_TYPE,
      "23",
      "imageUrl",
      "https://i.ytimg.com/vi/MELP46s8Cic/maxresdefault.jpg",
  )
})

test("Can add, get, assert and remove from store", () => {
  let gravatar = new Gravatar("23")
  gravatar.save()

  assert.fieldEquals(
      GRAVATAR_ENTITY_TYPE,
      "23",
      "id",
      "23",
  )

  store.remove(GRAVATAR_ENTITY_TYPE, "23")
  
  assert.notInStore(GRAVATAR_ENTITY_TYPE, "23")
  clearStore()
})

test("Can initialise event with default metadata", () => {
  let newGravatarEvent = changetype<NewGravatar>(newMockEvent())

  let DEFAULT_LOG_TYPE = "default_log_type"
  let DEFAULT_ADDRESS = "0xA16081F360e3847006dB660bae1c6d1b2e17eC2A"
  let DEFAULT_BLOCK_HASH = "0xA16081F360e3847006dB660bae1c6d1b2e17eC2A"
  let DEFAULT_LOG_INDEX = 1

  // String
  assert.equals(ethereum.Value.fromString(DEFAULT_LOG_TYPE), ethereum.Value.fromString(newGravatarEvent.logType!))
  // Address
  assert.equals(ethereum.Value.fromAddress(Address.fromString(DEFAULT_ADDRESS)), ethereum.Value.fromAddress(newGravatarEvent.address))
  // BigInt
  assert.equals(ethereum.Value.fromSignedBigInt(BigInt.fromI32(DEFAULT_LOG_INDEX)), ethereum.Value.fromSignedBigInt(newGravatarEvent.logIndex))
  // Bytes & nested objects
  assert.equals(ethereum.Value.fromBytes(Bytes.fromHexString(DEFAULT_BLOCK_HASH) as Bytes), ethereum.Value.fromBytes(newGravatarEvent.block.hash))
})

test("Can update event metadata", () => {
  let newGravatarEvent = changetype<NewGravatar>(newMockEvent())

  let UPDATED_LOG_TYPE = "updated_log_type"
  let UPDATED_ADDRESS = "0xB16081F360e3847006dB660bae1c6d1b2e17eC2A"
  let UPDATED_BLOCK_HASH = "0xC16081F360e3847006dB660bae1c6d1b2e17eC2A"
  let UPDATED_LOG_INDEX = 42

  newGravatarEvent.logType = UPDATED_LOG_TYPE
  newGravatarEvent.address = Address.fromString(UPDATED_ADDRESS)
  newGravatarEvent.block.hash = Bytes.fromHexString(
      UPDATED_BLOCK_HASH,
  ) as Bytes
  newGravatarEvent.logIndex = BigInt.fromI32(UPDATED_LOG_INDEX)

  // String
  assert.equals(ethereum.Value.fromString(UPDATED_LOG_TYPE), ethereum.Value.fromString(newGravatarEvent.logType!))
  // Address
  assert.equals(ethereum.Value.fromAddress(Address.fromString(UPDATED_ADDRESS)), ethereum.Value.fromAddress(newGravatarEvent.address))
  // BigInts
  assert.equals(ethereum.Value.fromSignedBigInt(BigInt.fromI32(UPDATED_LOG_INDEX)), ethereum.Value.fromSignedBigInt(newGravatarEvent.logIndex))
  // Bytes & nested objects
  assert.equals(ethereum.Value.fromBytes(Bytes.fromHexString(UPDATED_BLOCK_HASH) as Bytes), ethereum.Value.fromBytes(newGravatarEvent.block.hash))
})

test("Can save gravatar from contract", () => {
  let contractAddress = Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
  createMockedFunction(contractAddress, "getGravatar", "getGravatar(address):(string,string)")
    .withArgs([ethereum.Value.fromAddress(contractAddress)])
    .returns([ethereum.Value.fromString("1st val"), ethereum.Value.fromString("2nd val")])
  saveGravatarFromContract("48")

  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "48", "value0", "1st val")
  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "48", "value1", "2nd val")
})

test("Can fail gracefully when saving gravatar from contract with try_getGravatar", () => {
  let contractAddress = Address.fromString("0x89205A3A3b2A69De6Dbf7f01ED13B2108B2c43e7")
  createMockedFunction(contractAddress, "getGravatar", "getGravatar(address):(string,string)")
    .withArgs([ethereum.Value.fromAddress(contractAddress)])
    .reverts()
  trySaveGravatarFromContract("48")

  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "48", "value0", "1st val")
  assert.fieldEquals(GRAVATAR_ENTITY_TYPE, "48", "value1", "2nd val")
})

test("Can save transaction from call handler", () => {
  let call = changetype<CreateGravatarCall>(newMockCall())
  call.inputValues = [new ethereum.EventParam("displayName", ethereum.Value.fromString("name")), new ethereum.EventParam("imageUrl", ethereum.Value.fromString("example.com"))]
  handleCreateGravatar(call)

  assert.fieldEquals(TRANSACTION_ENTITY_TYPE, "0xa16081f360e3847006db660bae1c6d1b2e17ec2a", "displayName", "name")
  assert.fieldEquals(TRANSACTION_ENTITY_TYPE, "0xa16081f360e3847006db660bae1c6d1b2e17ec2a", "imageUrl", "example.com")
})
