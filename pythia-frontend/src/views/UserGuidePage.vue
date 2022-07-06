<template>
    <NavBar/>
    <UserGuide/>
</template>

<script>
    import UserGuide from '@/components/UserGuide.vue'
    import NavBar from '@/components/NavBar/NavBar.vue'
    export default {
        components: {
            UserGuide,
            NavBar
        }
    }
</script>