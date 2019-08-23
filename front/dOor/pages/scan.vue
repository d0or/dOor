<template>
  <section class="section">
    <div class="columns is-mobile">
      <card
        title="Read a qr code"
        icon="github-circle"
      >
      <qrcode-stream></qrcode-stream>
<qrcode-drop-zone></qrcode-drop-zone>
<qrcode-capture></qrcode-capture>
      </card>
    </div>
  </section>
</template>

<script>
import { QrcodeStream, QrcodeDropZone, QrcodeCapture } from 'vue-qrcode-reader'
import Card from '~/components/Card'

export default {
  name: 'Scanner',

  components: {
    QrcodeStream,
    QrcodeDropZone,
    QrcodeCapture,
    Card
  }
}
</script>
