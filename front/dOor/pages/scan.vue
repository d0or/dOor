<template>
  <section class="section">
    <div class="columns is-mobile">
      <card title="Read a qr code" icon="github-circle">
        <qrcode-stream @decode="onDecode" @init="logErrors" />
        <p>Result: {{ result }}</p>
      </card>
    </div>
  </section>
</template>

<script>
import { QrcodeStream } from 'vue-qrcode-reader'
import Card from '~/components/Card'

export default {
  name: 'Scanner',
  components: {
    QrcodeStream,
    Card
  },

  data () {
    return {
      result: null
    }
  },

  methods: {
    onDecode (result) {
      this.result = result
    },

    logErrors (promise) {
      promise.catch(console.error)
    }
  }
}
</script>
