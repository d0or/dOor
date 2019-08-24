<template>
  <div class="card">
    <header class="card-header">
      <p class="card-header-title has-text-grey">
        {{ event.name }}
      </p>
    </header>

    <div class="card-content">
      <div class="content has-text-centered">
        {{ event.address }}
      </div>
    </div>
    <footer class="card-footer">
      <div class="card-footer-item">
        <span>
          <slot />
        </span>
      </div>
    </footer>
  </div>

</template>

<script>

export default {
  props: {
    'event': {
      type: Object,
      default () { return {} }
    }
  },
  methods: {

  }
}
</script>
