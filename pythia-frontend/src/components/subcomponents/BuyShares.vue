<template>
    <div v-if='$store.state.user' class="buy-shares-outer">
        <div class="buy-withdraw-buttons">
            <button class="buy-button" ref='buy' name='buy'  @click="click('buy')" :class="{'buy-button-active': buttons.buy}">Wage Money</button>
            <button v-if='withDrawInfo.resolved' class="withdraw-button" ref='withdraw' name='withdraw'  @click="click('withdraw')"  :class="{'withdraw-button-active': buttons.withdraw}">Withdraw</button>
        </div>
        <div v-if='buttons.buy' class="buy-shares-inner">
            <div class="share-type">No</div>
            <div class="share-type">Yes</div>
            <div class="market-stats no-annot">
                <span>10%</span>
            </div><div class="market-stats yes-annot">
                <span>90%</span>
            </div>
            <input type='number' class='buy-shares-input' v-model='buyInfo.moneyToWage[0]'/>
            <input type='number' class='buy-shares-input' v-model='buyInfo.moneyToWage[1]'/>
            <div class="grid-spec dynamic-stats">
                <div class="dynamic-stats-title">Shares bought</div>
                <div class="dynamic-stats-group">
                    <div class="dynamic-stats-element">0.001</div>
                    <div class="dynamic-stats-element">0.002</div>
                </div>
            </div>
            <div class="grid-spec submit-button-div">
                <button class="submit-button" @click="wageMoney">Submit</button>
            </div>
        </div>

        <div  v-if='buttons.withdraw' class="withdraw-money-inner">
            <div class="withdraw-money-stats">
                <div>% of winning shares</div><div class="withdraw-money-stat-values">{{withDrawInfo.winMoneyPercent}}%</div>
                <div>% of winning money</div><div class="withdraw-money-stat-values">{{withDrawInfo.winSharesPercent}}%</div>
                <div>Money won</div><div class="withdraw-money-stat-values">{{withDrawInfo.moneyWon}}</div>
                <div>Expert score</div><div class="withdraw-money-stat-values">{{withDrawInfo.expertScore}}</div>
            </div>
            <div class="withdraw-button-div">
                <button class="withdraw-button-submit" @click="withDrawWinnings()">Withdraw</button>
            </div>
        </div>
    </div>
</template>

<script>
import { 
    _wageMoney,
    _getExpertScore,
    _getMarketInfo,
    _getPlayerInfo,
    _getReward,
    _withdrawWinnings
} from '../../contract-functions/ContractFunctions';
    export default {
        data(){
            return {
                buyInfo: {
                    odds: [0, 0],
                    moneyToWage: [0, 0],
                    sharesToBuy: [0, 0],
                },
                withDrawInfo: {
                    resolved: false,
                    withdrawed: false,
                    winSharesPercent: 0,
                    winMoneyPercent: 0,
                    moneyWon: 0,
                    expertScore: 0
                },
                buttons :{
                    buy: true,
                    withdraw: false
                }
            }
        },
        methods: {
            click(btn) {
                const buttonName = this.$refs[btn].name;
                if(!this.buttons[buttonName]){
                    this.buttons[buttonName] = true;
                    if(buttonName === 'buy'){
                        this.buttons.withdraw = false;
                    } else if(buttonName === 'withdraw') {
                        this.buttons.buy = false;
                    }
                }
            },
            async  wageMoney(){
                const _marketId = this
                    .$route
                    .params
                    .marketId
                    .toString();

                //wage Money
                await _wageMoney(
                    {
                        _marketId,
                        _moneyToWage: this.buyInfo.moneyToWage
                    }
                )
           },
           async withDrawWinnings(){
                if(!this.withDrawInfo.withdrawed){
                    const _marketId = this
                    .$route
                    .params
                    .marketId
                    .toString();
                    _withdrawWinnings(_marketId);
                    this.withDrawInfo.moneyWon = 0;
                    this.withDrawInfo.withdrawed = true;
                }
           }
        },
        async created(){
            const marketId = this
                            .$route
                            .params
                            .marketId
                            .toString();
            const playerAddress = this
                                  .$store
                                  .state
                                  .user
                                  .get('ethAddress');
            const marketInfo = await _getMarketInfo(marketId);
            const playerInfo = await _getPlayerInfo(playerAddress, marketId);

            if(marketInfo.resolved){

                const winningOutcome = parseInt(marketInfo.winningOutcome);

                const playerWinMoney = playerInfo.moneyWaged[winningOutcome];
                const winMoney = marketInfo.moneyWaged[winningOutcome];

                const playerWinShares = playerInfo.sharesOwned[winningOutcome];
                const winShares = marketInfo.sharesOwned[winningOutcome];

                this.withDrawInfo.expertScore = await _getExpertScore(playerAddress, marketId);
                this.withDrawInfo.moneyWon = await _getReward(playerAddress, marketId);

                this.withDrawInfo.winMoneyPercent = Math.round(1000 * playerWinMoney / winMoney) / 10
                this.withDrawInfo.winSharesPercent = Math.round(1000 * playerWinShares / winShares) / 10

                this.withDrawInfo.resolved = marketInfo.resolved

                this.withDrawInfo.withdrawed = playerInfo.withdrawed

            }
        }
    }
</script>

<style scoped>
    .buy-shares-outer {
        display: grid;
        grid-template-rows: 1fr 8fr;
        color:#cecece;
    }

    .buy-shares-inner {
        display: grid;
        gap: 10px;
        grid-template-rows: 0.5fr 1.4fr 1fr 1.5fr 1fr;
        grid-template-columns: repeat(2,1fr);
        background-color: #0e2438;
        padding:10px;
        border: #79e2f2 1.2px solid;
        border-radius: 5px;
    }
    .buy-withdraw-buttons {
        display: flex;
        justify-content: space-between;
    }

    .withdraw-button {
        background-color: #0b1723;
        margin-bottom: 5px;
        border: none;
        color: #cecece;
        font-size: 13px;
        padding-left: 15px;
        padding-right: 15px;
    }

    .withdraw-button-active {
        color: #79e2f2;
        margin-bottom: 0px;
    }

    .buy-button {
        background-color: #0b1723;
        margin-bottom: 5px;
        border: none;
        color: #cecece;
        font-size: 13px;
        padding-left: 10px;
        padding-right: 10px;

    }

    .buy-button-active {
        color: #79e2f2;
        margin-bottom: 0px;
    }

    .buy-info-container {
        display: flex;
        justify-content: space-between;
    }

    .grid-spec {
        grid-column-start: 1;
        grid-column-end: 3;
        /* background-color: #243b53; */
    }

    .buy-info {
        font-weight: 300;
        font-size: 11px;
        border: 1.2px solid;
        border-color: #79e2f2;
    }

    .share-type{
        font-size: 13px;
    }

    .market-stats{
        border-radius: 5px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 13px;
        font-weight: 300;
        font-family: 'Montserrat';
    }
    .buy-shares-input {
        max-width: 80px;
        max-height: 40px;
        box-shadow: none;
        font-size: 12px;
        background: #243b53;
        color:#cecece;
        font-weight: 200;
        font-family: 'Montserrat';
        border: none;
    }

    .submit-button-div {
        display: flex;
        justify-content: flex-end;
    }

    .submit-button {
        background: #3a9770;
        border: #358262 1.5px solid;
        box-shadow: 1px 1px 8px #121212;
        border-radius: 5px;
        color:#cecece;
    }

    .submit-button:active{
        background: #358262;
        box-shadow: none;
    }

    .dynamic-stats {
        font-family: 'Montserrat';
        grid-template-rows:  repeat(2, 1fr);
        grid-template-columns: repeat(2, 1fr);
    }

    .dynamic-stats-group {
        display: flex;
        justify-content: space-between;
    }

    .dynamic-stats-title {
        font-size: 11px
    }

    .dynamic-stats-element {
        font-size:10px;
        font-weight: 200;
        margin-top: 5px;
    }

    .yes-annot {
       border: #4decc9c2 1.5px solid;
       color: #4decc9c2;
   }

   .no-annot {
       border: #ec4d4dc2 1.5px solid;
       color: #ec4d4dc2 ;
   }

   .withdraw-money-inner {
        border:#79e2f2 1.2px solid;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background-color: #0e2438;
        padding:10px;
        border-radius: 5px;
   }

   .withdraw-money-stats {
        display: grid;
        grid-template-columns: 3fr 1fr;
        grid-template-rows: repeat(5,1fr);
        row-gap: 5px;
        column-gap: 10px;
        font-size: 10px;
   }

   .withdraw-money-stat-values {
        font-weight: 200;
   }

   .withdraw-button-div {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 70px;
   }

   .withdraw-button-submit {
        background-color:#7c3ec2;
        color:#cecece;
        border: none;
        padding-top: 3px;
        padding-bottom: 3px;
        border-radius: 5px;
        box-shadow: 1px 1px 8px #121212;
   }

    .withdraw-button-submit:active {
        box-shadow: none;
        background-color: #542c83;

    }


</style>