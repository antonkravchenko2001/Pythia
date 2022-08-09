<template>
    <span :style="{'color': color, 'background': background}" class="alert-container">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <span class="alert-text">{{message}}</span>
        <span class="alert-text">
            {{text}}
        </span>
    </span>
</template>

<script>
    export default {
        props: ['message', 'background', 'text', 'color'],
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
        font-size: 14px;
    }
</style>