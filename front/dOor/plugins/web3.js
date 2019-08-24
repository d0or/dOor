/* eslint-disable no-console */
/* eslint-disable no-new */
import Web3 from 'web3'

export default async ({ store }) => {
  if (process.client) {
    let instance
    try {
      instance = new Web3(window.web3.currentProvider)
    } catch (e) {
      try {
        instance = new Web3(Web3.givenProvider)
      } catch (e) {
        try {
          await new Web3.providers.HttpProvider(`https://mainnet.infura.io/`)
        } catch (e) {
          console.log('No Metamask detected!')
        }
      }
    }

    window.$web3 = instance
    store.state.web3 = instance
    return instance
  }
}
