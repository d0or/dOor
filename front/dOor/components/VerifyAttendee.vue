<template>
  <div>
    <h1 v-if="verified == -1" class="invalid">
      verification challenge failed!
    </h1>
    <h1 v-if="verified == 1" class="valid">
      verification succeeded! Let her in!
    </h1>

    <b-button v-if="verified === 0" size="is-large" type="is-primary" @click="verify">verify!</b-button>
    <b-button v-if="verified !== 0" size="is-large" type="is-secondary" @click="dismiss">dismiss!</b-button>
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
    },
    challenge: {
      type: String,
      default: ''
    }

  },
  data () {
    return {
      verified: 0
    }
  },

  methods: {
    async verify () {
      const web3 = window.$web3
      const address = await web3.eth.personal.ecRecover(this.challenge, this.scanResult.s)
      this.verified = (address === this.scanResult.a.toLowerCase()) ? 1 : -1

      console.log(this.challenge)
      console.log(address)
      console.log(this.scanResult)
    },
    dismiss () {
      this.verified = 0
      this.$emit('dismissed')
    }
  }
}
</script>

<style lang="scss" scoped>
  h1 {
    font-size: 12em;
    text-align: center;
    font-family: 'Poppins';
    font-weight: 900;
     &.valid { color: green }
     &.invalid { color: red }
  }

</style>
