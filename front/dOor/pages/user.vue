<template>
  <section class="section">
    <b-button @click="getAccount2">{{ test }}</b-button>
  </section>
</template>
<script>
/* eslint-disable no-console */
export default {
  data () {
    return {
      test: 'RSVP'
    }
  },
  methods: {
    getAccount2 () {
      window.$web3.eth.getAccounts().then((accounts) => {
        if (accounts.length && accounts[0]) {
          // just get the account address and balance
          window.$web3.eth.getBalance(accounts[0]).then((balance) => {
            const data = {
              account: accounts[0],
              balance: Number(window.$web3.utils.fromWei(balance)).toFixed(3).toLocaleString()
            }

            console.log(data)

            this.$store.state.account.address = data.account
          })
        } else if (window.ethereum) {
        // privacy mode on
          window.ethereum.enable().then((accounts) => {
            window.$web3.eth.getBalance(accounts[0]).then((balance) => {
              const data = {
                account: accounts[0],
                balance: Number(window.$web3.utils.fromWei(balance)).toFixed(3).toLocaleString()
              }

              console.log(data)

              this.$store.state.account.address = data.account
            })
          })
        }
      })
    },
    getAccount () {
      return new Promise((resolve) => {
        window.$web3.eth.getAccounts().then((res) => {
          if (!res.length) {
            alert('Please login to MetaMask!')
            return
          }
          return resolve(res[0])
        })
      })
    }
  }
}
</script>
