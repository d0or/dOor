<template>
  <div>
    {{ scanResult.publicAddress }}
    the balance is: {{ balance }}
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
      balance: -1
    }
  },
  methods: {
    async verify () {
      this.balance = await window.$web3.eth.getBalance(this.scanResult.publicAddress)
    }
  }
}
</script>
