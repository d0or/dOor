<template>
  <div>
    <b-field label="Event name">
      <b-input v-model="eventName" />
    </b-field>
    <b-field label="Ticket price">
      <b-input v-model="price" type="number" />
    </b-field>
    <b-field label="Distribute leftovers">
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
    <b-button type="is-primary is-medium" :disabled="eventName && !price" @click="createEvent">Create</b-button>
  </div>
</template>

<script>

export default {
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
