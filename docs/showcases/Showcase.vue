<script setup>
defineProps({
  image: { type: String, required: false },
  videoUrl: { type: String, required: false },
  title: { type: String, default: "" },
  index: { type: Number, required: true }
})

const isMp4 = (url) => {
  return url && url.endsWith('.mp4')
}
</script>

<template>
  <figure
    class="showcase"
    :class="`from-${index % 2 === 0 ? 'left' : 'right'}`"
  >
    <div class="image-wrapper">
      <template v-if="videoUrl">
        <video
          v-if="isMp4(videoUrl)"
          controls
          muted
          loop
          :src="videoUrl"
          :title="title"
          width="100%"
          height="400"
          class="rounded-video"
        />

        <div v-else class="youtube-wrapper">
          <iframe
            :src="videoUrl"
            :title="title"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
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

img, video {
  width: 100%;
  height: auto;
  object-fit: contain;
  display: block;
  border-radius: 1rem;
  transition: transform 0.3s ease;
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

.youtube-wrapper {
  position: relative;
  width: 100%;
  padding-top: 56.25%;
  border-radius: 1rem;
  overflow: hidden;
}

.youtube-wrapper iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: none;
  border-radius: 1rem;
}

</style>
