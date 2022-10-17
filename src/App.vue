<script setup lang="ts">
  import { ref, onMounted } from 'vue';

  interface Question {
    name?: string;
    description?: string;
    actualQuestion?: string;
    imageUri?: string;
    videoUri?: string;
  }

  const question = ref<Question>({});
  const answer = ref("");

  const load = async (): Promise<Question> => {
    const res = await fetch('/api/quest', {
      method: 'GET',
      credentials: 'include',
    })

    return res.json();
  }

  const send = async (answer: string): Promise<Question> => {
    const res = await fetch('/api/quest', {
      method: 'POST',
      headers: {
        'Accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: `"${answer}"`
    })

    return res.json();
  }

  onMounted(async () => {
    question.value = await load();
  })

  const postAnswer = async () => {
    question.value = await send(answer.value);
    answer.value = "";
  }

  const clean = () => {
    // console.log(document.cookie);
    document.cookie = "QuestSessionId=;expires=Thu, 01 Jan 1970 00:00:01 GMT";
    document.location = "/";
  }
</script>

<template>
  <div>
    <b>{{ question.name }}</b><br />
    <b>{{ question.description }}</b><br />
    <span>{{ question.actualQuestion }}</span><br />
    <img v-if="question.imageUri" width="300" :src="question.imageUri"><br />
    <span v-if="question.videoUri"><a :href="question.videoUri" target="_blank">Видео к просмотру</a></span>
  </div>
  <input type="text" v-model="answer" autofocus @keydown.enter="postAnswer"/><br />
  <button @click="clean">CLEAN</button>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
