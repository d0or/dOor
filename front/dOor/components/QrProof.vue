<template>
  <div>
    <vue-qr :gif-bg-src="qrGifBgSrc" :text="qrValue" :size="qrSize" />
  </div>
</template>
<script>
import VueQr from 'vue-qr'
export default {
  components: {
    VueQr
  },
  props: {
    qrValue: {
      type: String,
      default: ''
    },
    qrGifBgSrc: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      qrSize: 150
    }
  }
}
</script>
