import DoorFactoryAbi from '../abis/DoorFactory.abi.json'
import DoorAbi from '../abis/Door.abi.json'

export default async function getDoors (web3, account) {
  const doorFactory = new web3.eth.Contract(DoorFactoryAbi, '0x5D1aca1FD0f16d930030AeCf4FA68698A0Ce9112', {
    from: account,
    gasPrice: '200000000'
  })

  const doorAdresses = await doorFactory.methods.getAllDoors().call()

  const doorsPromises = doorAdresses.map((doorAddress) => {
    const doorContract = new web3.eth.Contract(DoorAbi, doorAddress, {
      from: account,
      gasPrice: '200000000'
    })

    return new Promise(async (resolve, reject) => {
      const price = await doorContract.methods.getEventPrice().call()
      const title = await doorContract.methods.getEventName().call()
      const hasTicket = await doorContract.methods.userHasEventTicket().call()

      resolve({
        address: doorAddress,
        title,
        price,
        hasTicket
      })
    }) // wwwwwaaaaah
  })
  const events = await Promise.all(doorsPromises)
  return events
}
