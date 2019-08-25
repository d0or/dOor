<template>
  <section class="section">
    <span>Web3 version: {{ this.$store.state.web3.version }}</span>
    <div class="columns is-multiline">
      <!-- <div v-for="event in events" :key="event.address" class="column"> -->
      <div v-for="event in events" :key="event.address" class="column is-half">

        <event-card :event="event">
          <b-field grouped>
            <p v-if="event.hasTicket">you're registered</p>
            <b-button v-else size="is-medium" type="is-primary" @click="buyTicket(event)">Buy ticket ({{ event.price }}) </b-button>
          </b-field>

          <b-field grouped>
            <b-input v-model="challenge" placeholder="challenge (1234)" />
            <b-button :disabled="challengeValid" @click="showQr(event)">Start challenge</b-button>
          </b-field>
        </event-card>

      </div>
    </div>
  </section>
</template>
<script>
/* eslint-disable no-console */
import DoorAbi from '../abis/Door.abi.json'
import EventCard from '~/components/EventCard'
import QrProof from '~/components/QrProof'
import doors from '~/lib/doors'

export default {
  components: {
    EventCard
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
      events: [],
      account: {},
      challenge: ''
    }
  },
  computed: {
    challengeValid () {
      return this.challenge.length !== 4
    }
    /* events () {
      return this.$store.getters.events
    }
*/
  },
  async mounted () {
    // if (!this.$store.state.account.address) { }
    // TODO: uncomment
    // await this.$store.dispatch('getEvents')
    this.account = await this.getAccount()
    this.events = await doors(window.$web3, this.account)
  },
  methods: {
    async callEventAction (action, eventAddress) {
      // make sure account is available
      if (!this.$store.state.account.address) { this.getAccount() }
      console.log('callEventAction', action, eventAddress)
      await this.$store.dispatch(action, eventAddress)
      console.log('after')
    },
    async sign (message) {
      try {
        const signature = await window.$web3.eth.personal.sign(message, this.account)
        return signature
      } catch (e) {
        console.error(e)
      }
    },

    async showQr (event) {
      console.log('event:', event)
      const msg = this.challenge
      const signature = await this.sign(msg)

      this.$buefy.modal.open({
        parent: this,
        component: QrProof,
        hasModalCard: true,
        customClass: 'custom-class custom-class-2',
        props: {
          address: this.account,
          signature
        }
      })
    },

    buyTicket (event) {
      const doorContract = new window.$web3.eth.Contract(DoorAbi, event.address, {
        from: this.account,
        gasPrice: '200000000'
      })

      doorContract.methods.buyEventTicket().send({
        value: event.price
      })
    },
    // 0x3EeD37643788B70328d12e132A69E5A922B2c5c9

    async getBalance () {
      const balance = await window.$web3.eth.getBalance(this.account)
      const data = {
        address: this.account,
        balance: Number(window.$web3.utils.fromWei(balance)).toFixed(3).toLocaleString()
      }
      console.log(data)
    },

    async getAccount () {
      let accounts = window.$web3.eth.getAccounts()

      if (accounts.length && accounts[0]) {
        this.getBalance()
      } else if (window.ethereum) {
        // privacy mode on
        accounts = await window.ethereum.enable()
      }
      return accounts[0]
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

/*
<div v-if="event.state === 0">
            <b-button @click="callEventAction('RSVPEvent', event.address)">RSVP</b-button>
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
          */
</script>
