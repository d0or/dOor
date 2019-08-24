// import web3 from '../plugins/web3';
// const cookieparser = process.server ? require('cookieparser') : undefined;

export const strict = false

export const plugins = []

export const state = () => ({
  account: {
    address: null,
    balance: null
    // signature: null
  },
  error: null,
  events: [
    {
      state: 0,
      name: '<eventName>',
      address: '<eventAddress>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 1,
      name: '<eventName>',
      address: '<eventAddress>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 2,
      name: '<eventName>',
      address: '<eventAddress>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 3,
      name: '<eventName>',
      address: '<eventAddress>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    },
    {
      state: 4,
      name: '<eventName>',
      address: '<eventAddress>',
      qrValue: 'https://ipsum.serveo.net/challange?address=X&signature=Y',
      qrGifBgSrc: '/img/cat.gif'
    }
  ]
})

export const mutations = {
  UPDATE_ACCOUNT (state, data) {
    state.account = {
      address: data.address,
      balance: data.balance
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
  async getEvents ({ commit }) {
    const events = []
    const eventCount = await window.$web3.contract.at('').getEventCount()
    for (let i = 0; i < eventCount; i++) {
      const temp = await window.$web3.contract.at('').getEventAtIndex(i)
      events.push(await window.$web3.contract.at(`${temp}`).toString())
    }
    commit('UPDATE_EVENTS', events)
  },
  async startEvent (eventAddress) {
    await window.$web3.contract.at('').startEvent(eventAddress)
  },
  async endEvent (eventAddress) {
    await window.$web3.contract.at('').endEvent(eventAddress)
  },
  async withdrawStakes (eventAddress) {
    await window.$web3.contract.at('').withdrawStakes(eventAddress)
  },
  async cancelRSVP (eventAddress) {
    await window.$web3.contract.at('').cancelRSVP(eventAddress)
  }
}

export const getters = {
  events: state => state.events
}
