/* eslint-disable no-console */
import Web3 from 'web3'

export default ({ store }) => {
  if (process.client) {
    let instance
    try {
      instance = new Web3(window.web3.currentProvider)
    } catch (e) {
      console.log('No Metamask detected!')
      store.state.error = 'Please open this application using metamask supported browser'
    }
    window.$web3 = instance
    store.state.web3 = instance
    return instance
  }
}
