<template>
  <section class="section">
    <div class="columns is-mobile">
      <card
        title="Setup an event"
        icon="home"
      >
        Functions and inputs here
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
  }
}
</script>
