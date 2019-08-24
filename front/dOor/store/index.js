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
  data: null,
  error: null
})

export const mutations = {
  UPDATE_ACCOUNT (state, data) {
    state.account = {
      address: data.address,
      balance: data.balance
    }
  }
}

export const actions = {
  setAccount ({ commit }, data) {
    commit('UPDATE_ACCOUNT', data)
  }
  // nuxtServerInit({commit}, {req}) {
  //     let auth = null;
  //     if (req.headers.cookie) {
  //         const parsed = cookieparser.parse(req.headers.cookie);
  //         try {
  //             auth = JSON.parse(parsed.auth);
  //         } catch (err) {
  //             // No valid cookie found
  //         }
  //     }
  //     this.state.account.auth = auth;
  // }
}

export const getters = {}
