import { assert, test, newMockEvent, dataSourceMock } from "matchstick-as/assembly/index"
import { BigInt, DataSourceContext, Value } from "@graphprotocol/graph-ts"

import { handleApproveTokenDestinations } from "../../src/token-lock-wallet"
import { ApproveTokenDestinations } from "../../generated/templates/GraphTokenLockWallet/GraphTokenLockWallet"
import { NameSignalTransaction, TokenLockWallet, GraphAccount } from "../../generated/schema"

test("Data source simple mocking example", () => {
    let addressString = "0xA16081F360e3847006dB660bae1c6d1b2e17eC2A"
    let wallet = new TokenLockWallet(addressString)
    wallet.save()
    let context = new DataSourceContext()
    context.set("contextVal", Value.fromI32(325))
    dataSourceMock.setReturnValues(addressString, "rinkeby", context)
    let event = changetype<ApproveTokenDestinations>(newMockEvent())

    assert.assertTrue(!wallet.tokenDestinationsApproved)
    
    handleApproveTokenDestinations(event)

    wallet = TokenLockWallet.load(addressString)!
    assert.assertTrue(wallet.tokenDestinationsApproved)
    assert.bigIntEquals(wallet.tokensReleased, BigInt.fromI32(325))

    dataSourceMock.resetValues()
})

test("Derived fields example test", () => {
    let mainAccount = new GraphAccount("12")
    mainAccount.save()
    let operatedAccount = new GraphAccount("1")
    operatedAccount.operators = ["12"]
    operatedAccount.save()
    let nst = new NameSignalTransaction("1234")
    nst.signer = "12";
    nst.save()

    assert.assertNull(mainAccount.get("nameSignalTransactions"))
    assert.assertNull(mainAccount.get("operatorOf"))

    mainAccount = GraphAccount.load("12")!

    assert.i32Equals(1, mainAccount.nameSignalTransactions.length)
    assert.stringEquals("1", mainAccount.operatorOf[0])
})
