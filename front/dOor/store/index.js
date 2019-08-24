/* eslint-disable no-unused-vars */
/* eslint-disable handle-callback-err */
/* eslint-disable no-console */
import web3 from '../plugins/web3'
// const cookieparser = process.server ? require('cookieparser') : undefined;

export const strict = false

export const plugins = []

export const state = () => ({
  web3: null,
  gasLimit: 21000,
  gasPriceInWei: null,
  contractAbi: '',
  deployedContractManager: null,
  account: {
    address: null,
    balance: null
    // signature: null
  },
  error: null,
  transactionObject: null,
  events: [
    {
      state: 0,
      name: '<eventName>',
      address: '<eventAddress0>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 1,
      name: '<eventName>',
      address: '<eventAddress1>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 2,
      name: '<eventName>',
      address: '<eventAddress2>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 3,
      name: '<eventName>',
      address: '<eventAddress3>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 4,
      name: '<eventName>',
      address: '<eventAddress4>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    }
  ]
})

export const mutations = {
  UPDATE_ACCOUNT (state, data) {
    const gasPriceInWei = state.web3.utils.toWei(21000, 'ether')
    state.deployedContractManager = state.web3.eth.contract(state.contractAbi).at(state.contractAddress)
    state.account = {
      address: data.address,
      balance: data.balance
    }
    state.transactionObject = {
      from: data.address,
      gas: state.gasLimit,
      gasPrice: gasPriceInWei
    }
  },
  UPDATE_EVENTS (state, events) {
    state.events = events
  }
}

export const actions = {
  setAccount ({ commit }, data) {
    commit('UPDATE_ACCOUNT', data)
  },
  async getEvents ({ commit, state }) {
    const events = []
    await state.deployedContractManager.events.call({ from: state.account.address }, async function (err, result) {
      console.log('getEvents', result)
      const eventCount = result.length
      for (let i = 0; i < eventCount; i++) {
        const temp = await state.deployedContractManager.getEventAtAddress(result[i])
        // TODO: How to get the toString() of the child event contract without knowing its ABI?
        // events.push(await window.$web3.contract.at(`${temp}`).toString())
      }
      commit('UPDATE_EVENTS', events)
    })
  },
  async startEvent ({ state }, eventAddress) {
    await state.deployedContractManager.sendTransaction('startEvent', state.transactionObject, (err, result) => { // do something with error checking/result here });
      console.log('startEvent', result)
    })
  },
  async RSVPEvent ({ state }, eventAddress) {
    await state.deployedContractManager.sendTransaction('RSVPEvent', state.transactionObject, (err, result) => { // do something with error checking/result here });
      console.log('RSVPEvent', result)
    })
  },
  async endEvent ({ commit }, eventAddress) {
    await state.deployedContractManager.sendTransaction('endEvent', state.transactionObject, (err, result) => { // do something with error checking/result here });
      console.log('endEvent', result)
    })
  },
  async withdrawStakes ({ commit }, eventAddress) {
    await state.deployedContractManager.sendTransaction('withdrawStakes', state.transactionObject, (err, result) => { // do something with error checking/result here });
      console.log('withdrawStakes', result)
    })
  },
  async cancelRSVP ({ commit }, eventAddress) {
    await state.deployedContractManager.sendTransaction('cancelRSVP', state.transactionObject, (err, result) => { // do something with error checking/result here });
      console.log('cancelRSVP', result)
    })
  }
}

export const getters = {
  events: state => state.events
}
