<template>
  <div>

    <section class="hero is-primary">
      <d-header />
    </section>

    <b-message v-if="this.$store.state.error" title="Danger" type="is-danger">
      {{ this.$store.state.error }}
    </b-message>

    <section v-else class="main-content">

      <div class="container">
        <Roles class="mt-30" />
        <nuxt />
      </div>
    </section>
    </section></div>
</template>

<script>
import Roles from '~/components/Roles'
import Header from '~/components/Header'
export default {
  components: {
    Roles,
    dHeader: Header
  }

}
</script>

<style lang="scss" scoped>

  h1.title {
    font-family: 'Poppins';
    font-size: 4em;
  }

</style>
