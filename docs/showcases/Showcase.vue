<script setup>
defineProps({
  image: { type: String, required: false },
  videoUrl: { type: String, required: false },
  title: { type: String, default: "" },
  index: { type: Number, required: true }
})
</script>

<template>
  <figure
    class="showcase"
    :class="`from-${index % 2 === 0 ? 'left' : 'right'}`"
  >
    <div class="image-wrapper">
      <template v-if="videoUrl">
        <iframe
          width="100%"
          height="400"
          :src="videoUrl"
          :title="title"
          frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowfullscreen
        ></iframe>
      </template>
      <template v-else>
        <img :src="image" :alt="title" loading="lazy" />
      </template>

      <span v-if="title" class="title-pill">{{ title }}</span>
    </div>
  </figure>
</template>

<style scoped>
.showcase {
  opacity: 0;
  transform: translateX(0);
  transition:
    opacity 0.8s ease-out,
    transform 0.8s ease-out;
  will-change: transform, opacity;
}

.from-left {
  transform: translateX(-30px);
}

.from-right {
  transform: translateX(30px);
}

.showcase.visible {
  opacity: 1;
  transform: translateX(0);
}

.image-wrapper {
  width: 100%;
  position: relative;
}

img {
  width: 100%;
  height: auto;
  object-fit: contain;
  border-radius: 1rem;
  display: block;
}

.title-pill {
  position: absolute;
  bottom: 1rem;
  left: 1rem;
  background-color: rgba(0, 0, 0, 0.6);
  color: white;
  font-size: 0.85rem;
  padding: 0.4rem 0.8rem;
  border-radius: 999px;
  backdrop-filter: blur(5px);
}

.image-wrapper {
  width: 100%;
  position: relative;
  overflow: hidden;
  border-radius: 1rem;
  cursor: pointer;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  background: linear-gradient(135deg, rgba(0,255,255,0.05), rgba(0,150,255,0.08));
}

.image-wrapper:hover {
  transform: scale(1.02) translateY(-6px);
  box-shadow: 0 12px 24px rgba(0, 255, 255, 0.2);
}


img {
  width: 100%;
  height: auto;
  object-fit: contain;
  display: block;
  transition: transform 0.3s ease;
}

</style>
