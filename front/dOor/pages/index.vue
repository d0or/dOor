<template>
  <section class="section">
    <h1 class="is-size-1">Create a new event</h1>
    <create-event />
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

import CreateEvent from '~/components/CreateEvent'
import EventCard from '~/components/EventCard'
import events from '~/data/events'

export default {
  name: 'HomePage',
  components: {
    CreateEvent,
    EventCard
  },
  data () {
    return {
      events
    }
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
