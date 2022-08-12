<template>
    <div class="leader-board">
        <h3 class="leader-board-title">
            Leaderboard
        </h3>
        <table>
            <thead>
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
            </thead>
            <tbody>
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
            </tbody>
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

    table {
        min-width: 85%;
        max-width: 97%;
        padding: 5px;
        border: none;
        font-family: 'Montserrat';
        border-collapse: collapse;

    }

    thead {
        background: transparent;
    }

    tbody {
        background: #123148;
    }

    td {
        text-align: left;
        color: white;
        font-size: 13px;
        font-weight: 350;
        padding: 10px;
    }
    th {
        text-align: left;
        color: #90a2ba;
        padding: 10px;
        font-size: 13px;
        font-weight: 400;
    }
    
    tr {
        padding: 15px;
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