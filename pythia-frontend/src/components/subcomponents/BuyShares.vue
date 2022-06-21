<template>
    <div v-if='$store.state.user' class="buy-shares-outer">
        <div class="buy-withdraw-buttons">
            <button class="buy-button" ref='buy' name='buy'  @click="click('buy')" :class="{'buy-button-active': buttons.buy}">Wage Money</button>
            <button v-if='marketData.marketInfo.resolved' class="withdraw-button" ref='withdraw' name='withdraw'  @click="click('withdraw')"  :class="{'withdraw-button-active': buttons.withdraw}">Withdraw</button>
        </div>
        <div v-if='buttons.buy' class="buy-shares-inner">
            <div class="share-type">No</div>
            <div class="share-type">Yes</div>
            <div class="market-stats no-annot">
                <span>10%</span>
            </div><div class="market-stats yes-annot">
                <span>90%</span>
            </div>
            <input type='number' class='buy-shares-input' v-model='buyInfo.moneyToWage[0]' @keyup="calcShares(0)"/>
            <input type='number' class='buy-shares-input' v-model='buyInfo.moneyToWage[1]' @keyup="calcShares(1)"/>
            <div class="grid-spec dynamic-stats">
                <div class="dynamic-stats-title">Shares bought</div>
                <div class="dynamic-stats-group">
                    <div class="dynamic-stats-element">{{round(buyInfo.sharesToBuy[0])}}</div>
                    <div class="dynamic-stats-element">{{round(buyInfo.sharesToBuy[1])}}</div>
                </div>
            </div>
            <div class="grid-spec submit-button-div">
                <button class="submit-button" @click="wageMoney" :class="{unclickable: marketData.marketInfo.resolved}">Buy</button>
            </div>
        </div>

        <div  v-if='buttons.withdraw' class="withdraw-money-inner">
            <div class="withdraw-money-stats">
                <div>% of winning shares</div><div class="withdraw-money-stat-values">{{round(winMoneyPercent)}}%</div>
                <div>% of winning money</div><div class="withdraw-money-stat-values">{{round(winSharesPercent)}}%</div>
                <div>Money won</div><div class="withdraw-money-stat-values">{{round(marketData.withDrawInfo.reward)}} Dai</div>
                <div>Expert score</div><div class="withdraw-money-stat-values">{{round(marketData.withDrawInfo.expertScore)}}</div>
            </div>
            <div class="withdraw-button-div">
                <button class="withdraw-button-submit" @click="withDrawWinnings()" :class="{unclickable: isWithdrawed || withdrawed}">Withdraw</button>
            </div>
        </div>
    </div>
</template>

<script>
import { 
    _wageMoney,
    _withdrawWinnings,
    _numSharesForPrice
} from '../../contract-functions/ContractFunctions';
import { roundNum } from '../../helperFunctions';
    export default {
        props: ['marketData'],
        data(){
            return {
                withdrawed: false,
                buyInfo: {
                    odds: [0, 0],
                    moneyToWage: [0, 0],
                    sharesToBuy: [0, 0],
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
            round(num){
                return roundNum(num)
            },
            async calcShares(i){
                let shares = 0;
                if(this.buyInfo.moneyToWage[i] > 0){
                    const options = {
                        _marketId: this.marketData.marketInfo.marketId,
                        _outcome: `${i}`,
                        _moneyToWage: this.buyInfo.moneyToWage[i].toString()
                    }
                    shares = await _numSharesForPrice(options);
                    console.log(options);

                }
                this.buyInfo.sharesToBuy[i] = shares;
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
                const _marketId = this
                                .$route
                                .params
                                .marketId
                                .toString();
                await _withdrawWinnings(_marketId);
                this.withdrawed = true;
           }
        },

        computed :{
            winMoneyPercent(){
                console.log(this.marketData);
                const winningOutcome = this.marketData.marketInfo.winningOutcome;
                if(this.marketData.playerInfo !== null){
                    return (
                        this.marketData.playerInfo.moneyWaged[winningOutcome] * 100/
                        this.marketData.marketInfo.moneyWaged[winningOutcome]
                    )
                } return 0
            },
            winSharesPercent(){
                const winningOutcome = this.marketData.marketInfo.winningOutcome;
                if(this.marketData.playerInfo !== null){
                    return (
                        this.marketData.playerInfo.sharesOwned[winningOutcome] * 100/
                        this.marketData.marketInfo.sharesOwned[winningOutcome]
                    )
                } return 0
            },
            isWithdrawed(){
                console.log(this.marketData.playerInfo.withdrawed)
                return this.marketData.playerInfo.withdrawed
            }
        },
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
        border: #ad96ff 1.2px solid;
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
        color: #ad96ff;
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
        color: #ad96ff;
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
        border-color: #ad96ff;
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
        justify-content: center;
    }

    .submit-button {
        background: #0d48aa;
        border: none;
        box-shadow: 1px 1px 8px #121212;
        border-radius: 5px;
        color:#cecece;
        width: 100%;
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
        border:#ad96ff 1.2px solid;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
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
        align-items: flex-end;
        height: 70px;

   }

   .withdraw-button-submit {
        background-color:#0d48aa;
        color:#cecece;
        border: none;
        padding-top: 3px;
        padding-bottom: 3px;
        border-radius: 5px;
        box-shadow: 1px 1px 8px #121212;
        width: 100%;
   }

    .withdraw-button-submit:active {
        box-shadow: none;
        background-color: #0d48aa;

    }

    .unclickable {
        pointer-events: none;
        cursor: not-allowed;
        opacity: 0.65;
        filter: alpha(opacity=65);
        -webkit-box-shadow: none;
        box-shadow: none;
    }


</style>