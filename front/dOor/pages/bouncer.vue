<template>
  <section class="section">
    <div class="columns is-mobile">

      <card title="Read a qr code" icon="door-closed-lock">
        <b-button @click="toggleScan">Scan!</b-button>
        <b-button @click="fakeResult">Fake!</b-button>
        <div v-if="scanning">
          <qrcode-stream @decode="onDecode" @init="logErrors" />
          <p>Result: {{ result }}</p>
        </div>

        <VerifyAttendee v-if="result" :scan-result="result" />

      </card>

    </div>
  </section>
</template>

<script>
import { QrcodeStream } from 'vue-qrcode-reader'
import Card from '~/components/Card'
import VerifyAttendee from '~/components/VerifyAttendee'

export default {
  name: 'Bouncer',
  components: {
    QrcodeStream,
    Card,
    VerifyAttendee
  },

  data () {
    return {
      result: null,
      scanning: false
    }
  },

  methods: {
    onDecode (result) {
      this.result = result
      this.scanning = false
    },
    fakeResult () {
      this.result = {
        'm': '97ADB1477B6B2f48384023211832Dfa5031f44e7',
        'a': '0x467aa7e0addf094e140bf2bd4be706bd2e34e8d9',
        's': '0x525ab3b015165fcef73dc634bdce749afd9762465d938d730f9334ef6b93dcc908fe6d84ade6064d16b3d971bc44626070f93a222ad7e67ba7262d375116ae031b'
      }
    },

    toggleScan () {
      this.scanning = !this.scanning
    }
  }
}
</script>
