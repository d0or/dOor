<template>
  <section class="section">
    <span>Web3 version: {{ this.$store.state.web3.version }}</span>
    <div class="columns is-multiline">
      <!-- <div v-for="event in events" :key="event.address" class="column"> -->
      <div v-for="event in events" :key="event.address" class="column is-half">

        <event-card :event="event">
          <div v-if="event.state === 0">
            <b-button @click="callEventAction('rsvp', event.address)">RSVP</b-button>
          </div>
          <div v-if="event.state === 1">
            <b-button @click="callEventAction('cancel', event.address)">Cancel attendence</b-button>
            <b-button @click="showQr(event)">Present challange</b-button>
          </div>
          <div v-if="event.state === 2">
            <b-button @click="callEventAction('withdraw', event.address)">Withdraw</b-button>
          </div>
          <div v-if="event.state === 3">
            <b-button disabled>Funds withdrew</b-button>
          </div>
          <div v-if="event.state === 4">
            <b-button disabled>Missed event</b-button>
          </div>
        </event-card>

      </div>
    </div>
  </section>
</template>
<script>
/* eslint-disable no-console */
import EventCard from '~/components/EventCard'
import QrProof from '~/components/QrProof'
import events from '~/data/events'

export default {
  components: {
    EventCard,
    QrProof
  },
  data () {
    const userStateMapping = {
      0: 'RSVP', // potential event
      1: 'Attending', // bought ticket
      2: 'Attended', // event ended
      3: 'Withdrew', // collected stakes
      4: 'Missed' // User didn't attend
    }

    return {
      userStateMapping,
      qrSize: 150,
      events
    }
  },
  mounted () {
    if (!this.$store.state.account.address) { this.getAccount() }
  },
  methods: {
    callEventAction (eventAddress, action) {
      // make sure account is available
      if (!this.$store.state.account.address) { this.getAccount() }
      console.log('callEventAction', eventAddress, action)
      this.$store.dispatch(action, eventAddress)
    },
    showQr (event) {
      console.log('event:', event)
      this.$buefy.modal.open({
        parent: this,
        component: QrProof,
        hasModalCard: true,
        customClass: 'custom-class custom-class-2',
        props: {
          'qrValue': event.qrValue,
          'qrGifBgSrc': event.qrGifBgSrc
        }
      })
    },
    getAccount () {
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
          })
        } else if (window.ethereum) {
        // privacy mode on
          window.ethereum.enable().then((accounts) => {
            window.$web3.eth.getBalance(accounts[0]).then((balance) => {
              const data = {
                address: accounts[0],
                balance: Number(window.$web3.utils.fromWei(balance)).toFixed(3).toLocaleString()
              }
              console.log(data)
              this.$store.dispatch('setAccount', data)
            })
          })
        }
      })
    }
    // ,
    // getAccount () {
    //   return new Promise((resolve) => {
    //     window.$web3.eth.getAccounts().then((res) => {
    //       if (!res.length) {
    //         alert('Please login to MetaMask!')
    //         return
    //       }
    //       return resolve(res[0])
    //     })
    //   })
    // }
  }
}
</script>
