<template>
  <section class="section">
    <span>Web3 version: {{ this.$store.state.web3.version }}</span>
    <div class="columns is-mobile">
      <card
        title="Buy ticket"
        icon="calendar-check"
      >
        <b-button @click="getAccount2">{{ buttonText }}</b-button>
      </card>
    </div>
    <vue-qr :gif-bg-src="gifBgSrc" :text="qrValue" :size="qrSize" />
  </section>
</template>
<script>
/* eslint-disable no-console */
import VueQr from 'vue-qr'
import Card from '~/components/Card'
export default {
  components: {
    Card,
    VueQr
  },
  data () {
    return {
      buttonText: 'RSVP',
      gifBgSrc: '/img/cat.gif',
      qrSize: 300,
      qrValue: {
        publicAddress: '0xAC70DbA396847b433D3b889B3f798f21C0B024d4',
        messageSignature: 'abcder'
      }
    }
  },
  methods: {
    getAccount2 () {
      window.$web3.eth.getAccounts().then((accounts) => {
        if (accounts.length && accounts[0]) {
          // just get the account address and balance
          window.$web3.eth.getBalance(accounts[0]).then((balance) => {
            const data = {
              address: accounts[0],
              balance: Number(window.$web3.utils.fromWei(balance)).toFixed(3).toLocaleString()
            }

            console.log(data)
            this.$store.dispatch('setAccount', data)
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
