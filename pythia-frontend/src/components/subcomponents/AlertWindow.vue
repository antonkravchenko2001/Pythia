<template>
    <span :style="{'color': color, 'background': background}" class="alert-container">
        <i v-if="status==='fail'" class="fa-solid fa-triangle-exclamation"></i>
        <i v-if="status==='success'" class="fa-solid fa-circle-check"></i>
        <i v-if="status==='pending'" class="fa-solid fa-clock"></i>
        <span class="alert-text">{{message}}</span>
        <span class="alert-text">
            {{text}}
        </span>
    </span>
</template>

<script>
    export default {
        props: ['message', 'background', 'text', 'color', 'status'],
    }
</script>

<style scoped>
    .alert-container {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .alert-text {
        display: flex;
        align-items: center;
        font-family: monospace;
        font-size: 16px;
    }
</style>