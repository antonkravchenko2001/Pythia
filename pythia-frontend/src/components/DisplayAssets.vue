<template>
    <div class="leader-board">
        <div class="player-info table-title">
            <div>Asset name</div>
            <div>Price Feed address</div>
        </div>
        <div v-for="asset in assets" :key="asset" class="player-info table-content">
            <div>{{asset.get('asset').toUpperCase()}}</div>
            <div>{{asset.get('priceFeed')}}</div>
        </div>
    </div>
</template>

<script>
    import Moralis from '../main.js'
    export default {
        data(){
            return {
                assets: {}
            }
        },
        methods: {
            async loadAssets(){
                const assets = await Moralis.Cloud.run('getAssets');
                this.assets = assets;
                console.log(assets);
            }
        },
        async created(){
            await this.loadAssets();
        }
    }
</script>

<style scoped>
    .leader-board {
        display: grid;
        grid-template-rows: repeat(auto-fill, 1fr);
        gap: 3px;
        width: 50%;
        position: relative;
        left: 25%;
        top: 100px;
        z-index: 2;
        color: #ffffff;
        font-family: 'Montserrat';
        font-size: 13px;
        padding-bottom: 10px;
        
    }

    .player-info {
        display: grid;
        grid-template-columns: 1fr 3fr;
        gap: 5px;
        padding: 10px;
    }

    .table-title {
        background: linear-gradient(90deg, rgba(6,35,101,1) 0%, rgba(49,40,118,1) 65%, rgba(67,48,136,1) 100%);
        color: #ffffff;
        border: none;
        box-shadow: 1px 1px 5px #081621;
        font-weight: 400;
    }

    .table-content{
        background: linear-gradient(90deg, rgba(6,35,101,1) 0%, rgba(49,40,118,1) 75%, rgba(67,48,136,1) 100%);
        box-shadow: 1px 1px 5px #081621;
        border: none;
        font-weight:300;
        color:#cecece;
    }

    .fa-solid, .fas {
        font-family: "Font Awesome 6 Free";
        font-weight: 510;
        font-size: 13px;
    }
</style>