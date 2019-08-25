<template>
  <section class="section">
    <h1 class="is-size-1">Create a new event</h1>
    <create-event @createEvent="createEvent" />
    <h1 class="is-size-1 mt-20">Your events</h1>
    <div class="container">
      <div class="columns is-multiline">
        <div
          v-for="event in events"
          :key="event.address"
          class="column is-half"
        >
          <event-card :event="event">
            <div>
              <b-button @click="start(event)">Start</b-button>
              <b-button @click="finish(event)">finish</b-button>
              <b-button @click="remaining(event)">remaining</b-button>
            </div>
          </event-card>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import DoorFactoryAbi from '../abis/DoorFactory.abi.json'

import CreateEvent from '~/components/CreateEvent'
import EventCard from '~/components/EventCard'
import doors from '~/lib/doors'

export default {
  name: 'HomePage',
  components: {
    CreateEvent,
    EventCard
  },
  data () {
    return {
      events: [],
      account: {}
    }
  },
  async mounted () {
    this.account = await this.getAccount()
    this.events = await doors(window.$web3, this.account)
  },
  methods: {
    start (evt) {
      console.log(evt)
    },
    finish (evt) {
      console.log(evt)
    },
    remaining (evt) {
      console.log(evt)
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
    },
    async createEvent (evt) {
      console.log(`Creating event ${evt.name} with ticket price ${evt.price} and distribution = ${evt.isDistributing}`)
      const doorContract = new window.$web3.eth.Contract(DoorFactoryAbi, '0x5D1aca1FD0f16d930030AeCf4FA68698A0Ce9112', {
        from: this.account,
        gasPrice: '200000000'
      })
      const newDoorAddress = await doorContract.methods.createNewDoor(evt.price, evt.name, evt.isDistributing === 'Yes').send()
      console.log('created ' + newDoorAddress)
    }
  }
}
</script>
<style lang="scss" scoped>
  section h1 {
    font-family: 'Poppins';
    font-weight: 900;
  }
</style>
