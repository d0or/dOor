<template>
  <section class="section">
    <h1 class="is-size-1">Check in</h1>

    <h1 v-if="random !== null" class="random-message has-text-center">{{ random }}</h1>

    <b-button v-if="!scanning" size="is-large" type="is-primary" @click="start">Start</b-button>

    <div v-if="scanning">
      <qrcode-stream @decode="onDecode" />
      <p v-if="result">Result: {{ result }}</p>
    </div>

    <VerifyAttendee v-if="result" :scan-result="result" :challenge="random" @dismissed="reset" />
    <b-button size="is-large" type="is-secondary" @click="reset">Reset</b-button>
  </section>
</template>

<script>
import { QrcodeStream } from 'vue-qrcode-reader'
import VerifyAttendee from '~/components/VerifyAttendee'

export default {
  name: 'Bouncer',
  components: {
    QrcodeStream,
    VerifyAttendee
  },

  data () {
    return {
      result: null,
      scanning: false,
      random: null
    }
  },

  methods: {
    onDecode (result) {
      this.result = JSON.parse(result)
      this.scanning = false
    },
    start () {
      this.result = null
      this.scanning = true
      this.random = '' + (1000 + Math.floor(900 * Math.random()))
    },
    reset () {
      this.result = null
      this.random = null
      this.scanning = false
    }
  }
}
</script>

<style lang="scss" scoped>
  section h1 {
    font-family: 'Poppins';
    font-weight: 900;
  }
  h1.random-message {
    font-size: 12em;
    text-align: center;
  }
</style>
