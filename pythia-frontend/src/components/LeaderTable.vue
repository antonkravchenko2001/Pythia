<template>
    <div class="leader-board">
        <div class="player-info table-title">
            <i class="fa-solid fa-hashtag"></i>
            <div>Player's address</div>
            <div>Expert points</div>
            <div>Reward received</div>
        </div>
        <div v-for="(player, index) in ranking" :key="player" class="player-info table-content">
            <div>{{index + 1}}</div>
            <div>{{player.objectId}}</div>
            <div>{{round(player.expertScore)}}</div>
            <div>{{round(player.reward)}} Dai</div>
        </div>
    </div>
</template>

<script>
    import Moralis from "../main.js";
    import { roundNum } from "@/utils.js";
    
    export default {
        data(){
            return {
                ranking: []
            }
        },
        methods:{
            round(num){
                return roundNum(num);
            },
            async getRanking(){
                const results = await Moralis.Cloud.run(
                    'getTopPerformers',
                )
                this.ranking = results;
            }
        },
    
        async created(){
            await this.getRanking();
        }

    }
</script>

<style scoped>
    .leader-board {
        display: grid;
        grid-template-rows: repeat(auto-fill, 1fr);
        gap: 3px;
        width: 60%;
        position: relative;
        left: 20%;
        top: 100px;
        z-index: 2;
        color: #ffffff;
        font-family: 'Montserrat';
        font-size: 13px;
        padding-bottom: 10px;
        
    }

    .player-info {
        display: grid;
        grid-template-columns: 0.5fr 4fr 1fr 1fr;
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