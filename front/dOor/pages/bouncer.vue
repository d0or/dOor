<template>
  <section class="section">
    <div class="columns is-mobile">

      <card title="Read a qr code">
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
    },
    fakeResult () {
      this.result = {
        publicAddress: '0xAC70DbA396847b433D3b889B3f798f21C0B024d4',
        messageSignature: 'abcder'
      }
    },
    logErrors (promise) {
      promise.catch(console.error)
    },
    toggleScan () {
      this.scanning = !this.scanning
    }
  }
}
</script>
