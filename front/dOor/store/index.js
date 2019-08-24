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
  events: []
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
  async startEvent ({ commit }, eventAddress) {
    await window.$web3.contract.at('').startEvent(eventAddress)
  },
  async endEvent ({ commit }, eventAddress) {
    await window.$web3.contract.at('').endEvent(eventAddress)
  },
  async sendLeftovers ({ commit }, eventAddress) {
    await window.$web3.contract.at('').sendLeftovers(eventAddress)
  }
}

export const getters = {}
