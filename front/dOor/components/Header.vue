<template>
  <div class="hero-body">
    <div class="container">
      <ul class="grid">
        <li v-for="(letter, index) in letters" :key="index" class="ot-letter-left">
          <span :data-letter="letter.letter">{{ letter.letter }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      letters: [
        { letter: 'Đ', open: false },
        { letter: 'O', open: false },
        { letter: 'o', open: false },
        { letter: 'r', open: false }
      ]
    }
  },
  methods: {
    raise () {

    }
  },
  mount () {
    /* setInterval(() => {
      const randIdx = Math.floor((Math.random() * this.letters.length) + 1)
      this.letters = this.letters.map((l) => { l.open = false; return l })
      this.letters
    }, 1000)
    */
  }
}
</script>

<style lang="scss" scoped>
@import "../assets/scss/variables.scss";

.hero-body {
    .grid li {
      position: relative;
      float: left;
      font-size: 12em;
      line-height: 1.5;
      max-height: 290px;
      text-align: center;
      width: -webkit-calc(100% / 4);
      width: calc(100% / 4);
    }
    .grid li span {
      display: inline-block;
      font-weight: 900;
      line-height: 1;
      position: relative;
      color: hsla(0, 0%, 0%, 0.6);
      transform-style: preserve-3d;
      perspective: 550px;
      z-index: 1;

      &:before {
        text-shadow: none;
        color: hsla(0, 0%, 0%, 0.12);
      }

      &:before, &:after {
        position: absolute;
        content: attr(data-letter);
        line-height: inherit;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        z-index: 2;
        transition: all 0.3s;
      }
    }

    .ot-letter-left {
      span:before,  span:after {
         transform-origin: 0 50%;
      }
      span:before {
        transform: scale(1.08, 1) skew(0deg, 1deg);
      }
      span:after {
        text-shadow:
          -1px 0px 0px hsla(360, 100%, 100%, 0.1),
          3px 0px 1px hsla(0, 0%, 0%, 0.4);
        transform: rotateY(-15deg);
      }

      &:hover span:after, &.is-open span:after {
        transform: rotateY(-40deg);
      }
      &:hover span:before, &.is-open span:before {
        transform: scale(0.85,1) skew(0deg,20deg);
      }

      background: $primary;
      color: $primary;

      span {
        text-shadow:
          1px 4px 6px $primary,
          0 0 0 hsla(0, 0%, 0%, 0.3),
          1px 4px 6px $primary;
        &:after {
          color: lighten($primary, 10%);
        }
      }

      :hover span:after, &.is-open span:after {
        //color: $primary;
        color: lighten($primary, 10%);
      }

    }
  }
</style>
