<template>
  <section class="section">
    <span>Web3 version: {{ this.$store.state.web3.version }}</span>
    <div class="columns is-mobile">
      <!-- <div v-for="event in events" :key="event.address" class="column"> -->
      <div v-for="event in events" :key="event.state" class="column">
        <card
          :title="event.name"
          icon="calendar-check"
        >
          <div v-if="event.state === 0">
            <b-button @click="callEvent('rsvp', event.address)">RSVP</b-button>
          </div>
          <div v-if="event.state === 1">
            <b-button @click="callEvent('cancel', event.address)">Cancel attendence</b-button>
            <b-button @click="showQr(event)">Present challange</b-button>
            <QrProof :qr-value="events[1].qrValue" :qr-gif-bg-src="events[1].qrGifBgSrc" />
          </div>
          <div v-if="event.state === 2">
            <b-button @click="callEvent('withdraw', event.address)">Withdraw</b-button>
          </div>
          <div v-if="event.state === 3">
            <b-button disabled>Funds withdrew</b-button>
          </div>
          <div v-if="event.state === 4">
            <b-button disabled>Missed event</b-button>
          </div>
          <!-- <vue-qr :gif-bg-src="event.qrGifBgSrc" :text="event.qrValue" :size="qrSize" /> -->
        </card>
      </div>
      <!-- <div class="column">
        <b-collapse class="card" aria-id="contentIdForA11y3">
          <div
            slot="trigger"
            slot-scope="props"
            class="card-header"
            role="button"
            aria-controls="contentIdForA11y3"
          >
            <p class="card-header-title">
              Component
            </p>
            <a class="card-header-icon">
              <b-icon
                :icon="props.open ? 'menu-down' : 'menu-up'"
              />
            </a>
          </div>
          <div class="card-content">
            <div class="content">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec iaculis mauris.
              <a>#buefy</a>.
            </div>
          </div>
          <footer class="card-footer">
            <a class="card-footer-item">Save</a>
            <a class="card-footer-item">Edit</a>
            <a class="card-footer-item">Delete</a>
          </footer>
        </b-collapse>
      </div> -->
    </div>
  </section>
</template>
<script>
/* eslint-disable no-console */
import Card from '~/components/Card'
import QrProof from '~/components/QrProof'
export default {
  components: {
    Card,
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
    }
  },
  methods: {
    callEvent (eventAddress, action) {
      // make sure account is available
      if (!this.$store.state.account.address) { this.getAccount() }
      this.$store.dispatch(action, eventAddress)
    },
    cancel (eventAddress) {
      this.$store.dispatch('cancel', eventAddress)
    },
    showQr (event) {
      console.log('event:', event)
    },
    withdraw (eventAddress) {
      this.$store.dispatch('withdraw', eventAddress)
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
            // this.$store.state.account.address = data.account
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
