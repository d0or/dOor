<template>
  <div>

    <section class="hero is-primary">
      <d-header />
    </section>

    <section v-if="this.$store.state.error" class="main-content">
      <b-message title="Danger" type="is-danger">
        {{ this.$store.state.error }}
      </b-message>
    </section>

    <section v-else class="main-content">

      <div class="container">
        <Roles class="mt-30" />
        <nuxt />
      </div>
    </section>
  </div>
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
