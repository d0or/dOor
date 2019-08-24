<template>

  <div class="columns ">
    <div v-for="(item, key) of items" :key="key" class="column">

      <nuxt-link
        :to="item.to"
        exact-active-class="is-active"
        class="is-large button is-rounded is-fullwidth"
      >

        {{ item.title }}
      </nuxt-link>
    </div>
  </div>
</template>

<script>

export default {
  components: {

  },
  data () {
    return {
      items: [
        {
          title: 'Event organizer',
          icon: 'home',
          to: { name: 'index' }
        },
        {
          title: 'User',
          icon: 'account',
          to: { name: 'user' }
        },
        {
          title: 'Bouncer',
          icon: 'account',
          to: { name: 'bouncer' }
        }
      ]
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
