<template>
  <div>
    {{ scanResult.a }}
    <div v-if="verification == 0">
      unverified
    </div>
    <div v-else-if="verification == -1">
      verification challenge failed!
    </div>
    <div v-else-if="verification == 1">
      verification succeeded! Let her in!
      <b-button>void ticket</b-button>
    </div>
    <div v-else-if="verification == 2">
      void ticket
    </div>

    <b-button @click="verify">verify!</b-button>
  </div>
</template>

<script>
export default {
  name: 'VerifyAttendee',
  components: {

  },
  props: {
    'scanResult': {
      type: Object,
      default: null
    }
  },
  data () {
    return {
      verification: 0
    }
  },
  methods: {

    async verify () {
      const web3 = window.$web3
      const address = await web3.eth.personal.ecRecover(this.scanResult.m, this.scanResult.s)
      this.verification = (address === this.scanResult.a) ? 1 : -1
    }

  }
}
</script>
