<template>
  <div class="modal-card" style="width: auto">
    <header class="modal-card-head">
      <p class="modal-card-title">Event {{ event.title }} Challenge</p>
    </header>
    <section class="modal-card-body">
      <div class="columns">
        <div class="column">
          <vue-qr :text="payload" qid="testid" :size="qrSize" :dot-scale="dotSize" />
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
    event: {
      type: Object,
      default () { return {} }
    },
    message: {
      type: String,
      default: ''
    },
    address: {
      type: String,
      default: ''
    },
    signature: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      qrSize: 600,
      dotSize: 1
    }
  },
  computed: {
    payload () {
      const pl = {
        a: this.address,
        s: this.signature
      }

      const str = JSON.stringify(pl)
      console.log(str)
      return str
    }
  }
}
</script>
