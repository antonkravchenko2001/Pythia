<template>
    <span :style="{'color': color, 'background': background}" class="alert">
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
    .alert {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px;
        border-radius: 5px;
    }

    .alert-text {
        display: flex;
        align-items: center;
        font-family: 'Montserrat';
        font-size: 14px;
        color: white;
    }
</style>