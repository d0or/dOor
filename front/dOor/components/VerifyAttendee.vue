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
      const web3 = window.$web3

      const secretMessage = 'BatMan!'
      // this.balance = await web3.eth.getBalance(this.scanResult.publicAddress)

      const accounts = await web3.eth.getAccounts()
      const fstAccount = accounts[0]
      // const msgHex = web3.utils.utf8ToHex(secretMessage)
      // console.log(msgHex)
      try {
        const signature = await web3.eth.personal.sign(secretMessage, fstAccount)
        console.log(signature)
      } catch (e) {
        console.error(e)
      }
    }
  }
}
</script>
