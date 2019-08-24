<template>
  <section class="section">
    <div class="columns is-mobile">
      <card
        title="Setup an event"
        icon="home"
      >
        <b-field label="Event name">
          <b-input v-model="eventName" />
        </b-field>
        <b-field label="Ticket price">
          <b-input v-model="price" type="number" />
        </b-field>
        <b-field label="Distribute leftover">
          <div class="field">
            <b-checkbox
              v-model="isDistributing"
              true-value="Yes"
              false-value="No"
            >
              {{ isDistributing }}
            </b-checkbox>
          </div>
        </b-field>
        <b-button type="is-primary" outlined :disabled="eventName && !price" @click="createEvent">Submit</b-button>
      </card>

      <card
        title="Mark event as started"
        icon="reload"
      >
        <b-button>Start event</b-button>
      </card>

      <card
        title="Mark event as finished"
        icon="check-outline"
      >
        <b-button>End event</b-button>
      </card>

      <card
        title="Send remaining funds"
        icon="send"
      >
        <b-button>Send leftover money</b-button>
      </card>
    </div>
  </section>
</template>

<script>
import Card from '~/components/Card'

export default {
  name: 'HomePage',
  components: {
    Card
  },
  data () {
    return {
      eventName: '',
      price: null,
      isDistributing: 'Yes'
    }
  },
  methods: {
    createEvent () {
      console.log(`Creating event ${this.eventName} with ticket price ${this.price} and distribution = ${this.isDistributing}`)
    }
  }
}
</script>
