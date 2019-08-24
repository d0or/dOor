<template>
  <div class="modal-card" style="width: auto">
    <header class="modal-card-head">
      <p class="modal-card-title">Event {{ eventName }} Challange</p>
    </header>
    <section class="modal-card-body">
      <div class="columns">
        <div class="column">
          <vue-qr :gif-bg-src="qrGifBgSrc" :text="qrValue" :size="qrSize" />
        </div>
      </div>
    </section>
    <footer class="modal-card-foot">
      <button class="button" type="button" @click="$parent.close()">Close</button>
    </footer>
  </div>
</template>
<script>
import VueQr from 'vue-qr'
export default {
  components: {
    VueQr
  },
  props: {
    eventName: {
      type: String,
      default: ''
    },
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
      qrSize: 300
    }
  }
}
</script>
