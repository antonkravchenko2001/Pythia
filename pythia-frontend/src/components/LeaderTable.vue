<template>
    <div class="leader-board">
        <h3 class="leader-board-title">
            Leaderboard
        </h3>
        <table>
            <tr>
                <th>
                    <i class="fa-solid fa-hashtag"></i>
                </th>
                <th>Player's address</th>
                <th>Expert score</th>
                <th>Reward received</th>
                <th>Total Money waged</th>
                <th>
                    # markets that user waged money in
                </th>
            </tr>
            <tr v-for="(player, index) in ranking" :key="player">
                <td>
                    <div class="colored-num" :style="{'background': backgroundNum(index + 1)}">
                        {{index + 1}}
                    </div>
                </td>
                <td style="font-size:13px">{{player.player}}</td>
                <td>{{round(player.expertScore)}}</td>
                <td>{{round(player.reward)}} DAI</td>
                <td>{{round(player.totalMoneyWaged)}} DAI</td>
                <td>{{round(player.numMarkets)}}</td>
            </tr>
        </table>
    </div>
</template>

<script>
    import Moralis from "../main.js";
    import { roundNum } from "@/utils.js";
    
    export default {
        data(){
            return {
                ranking: [],
                colors: ['#dcba04', '#c0c0c0', '#cd7f32', '#124978']
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
                console.log(results);
                this.ranking = results;
            },
            backgroundNum(idx){
                if(idx == 1){
                    return '#dcba04';
                }else if(idx == 2){
                    return '#c0c0c0';
                }else if(idx == 3){
                    return '#cd7f32';
                }else{
                    return '#124978';
                }
            }
        },
    
        async created(){
            await this.getRanking();
        }

    }
</script>

<style scoped>
    .leader-board {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .leader-board-title {
        display:flex;
        justify-content:flex-start;
        width:85%;
        color:#ffffff;
        font-size: 24px;
        font-family: 'Montserrat';
        font-weight: 500;

    }

    td {
        text-align: left;
        color: white;
        font-size: 13px;
        font-weight: 350;
        padding-top: 10px;
        padding-bottom: 10px;
        padding-right: 7px;
    }
    th {
        text-align: left;
        color: #8f8d8d;
        font-size: 13px;
        font-weight: 400;
    }
    
    tr {
        padding: 15px;
    }

    table {
        width: 85%;
        padding: 5px;
        background: #0d2537;
        border: none;
        border-radius: 5px;
        box-shadow: 1px 1px 8px #121212;
        align-items: center;
        font-family: 'Montserrat';
    }

    .colored-num {
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 14px;
        border-radius: 50%;
        width: 18px;
        height: 17px;
        font-family: monospace;
    }
</style>