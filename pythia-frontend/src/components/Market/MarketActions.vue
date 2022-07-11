<template>
    <div v-if='$store.state.user' class="buy-shares-outer">
        <div class="buy-withdraw-buttons">
            <button class="buy-button" ref='buy' name='buy'  @click="click('buy')" :class="{'buy-button-active': buttons.buy}">Wage Money</button>
            <button v-if='marketData.marketInfo.resolved' class="withdraw-button" ref='withdraw' name='withdraw'  @click="click('withdraw')"  :class="{'withdraw-button-active': buttons.withdraw}">Withdraw</button>
        </div>
        <div v-if='buttons.buy' class="buy-shares-inner">
            <div>No</div>
            <div>Yes</div>
            <div class="market-stats no-annot" :style="{background: `linear-gradient(to right, #571f1f91 ${getOdds[0]}%, transparent ${getOdds[0]}%, transparent)`}">
                <span>{{getOdds[0]}}%</span>
            </div>
            <div class="market-stats yes-annot" :style="{background: `linear-gradient(to right, #1a5447c2 ${getOdds[1]}%, transparent ${getOdds[1]}%, transparent)`}">
                <span>{{getOdds[1]}}%</span>
            </div>
            <div style="position:relative">
                <input
                    type='number'
                    class='buy-shares-input'
                    placeholder='0'
                    style="border-top-left-radius: 5px; border-bottom-left-radius:5px"
                    :class="{'incorrect-field': !formStatus.moneyToWage.correct}"
                    v-model='buyInfo.moneyToWage[0]'
                    @keyup="calcShares(0)"
                />
                <div v-if="!formStatus.moneyToWage.correct" class="error-message">
                    {{formStatus.moneyToWage.message}}
                </div>
            </div>
            <div>
                <input 
                    type='number'
                    class='buy-shares-input'
                    style="border-top-right-radius: 5px; border-bottom-right-radius:5px"
                    placeholder='0'
                    :class="{'incorrect-field': !formStatus.moneyToWage.correct}"
                    v-model='buyInfo.moneyToWage[1]'
                    @keyup="calcShares(1)"
                />
            </div>
            <div class="grid-spec dynamic-stats">
                <div class="dynamic-stats-title">Shares to receive</div>
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
import { roundNum, ethToWei} from '../../utils';
import { minMoney } from '../../config';
import Moralis from '../../main.js';
    export default {
        props: ['marketData'],
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
            getMoneyToWage(){
                let moneyToWage = []
                for(const el of this.buyInfo.moneyToWage){
                    if(!el){
                        moneyToWage.push(0)
                    }else{
                        moneyToWage.push(el)
                    }
                }
                return moneyToWage
            },
            async saveDeposit(moneyToWage, sharesToBuy){
                const saveOptions = {
                    marketId: this.marketData.marketInfo.marketId,
                    player: this.marketData.playerInfo.player,
                    moneyNo: moneyToWage[0],
                    moneyYes: moneyToWage[1],
                    sharesNo: sharesToBuy[0],
                    sharesYes: sharesToBuy[1]
                }

                await Moralis.Cloud.run(
                    'deposit',
                    saveOptions
                )
            },
            validateMoneyWaged(){
                let totalMoneyToWage = this.getMoneyToWage().reduce(
                        (acc, curr) => { return acc + curr; }
                );
                if(totalMoneyToWage < minMoney){
                    this.formStatus.moneyToWage.correct = false
                    this.formStatus.moneyToWage.message = `total wage amount must exceed ${minMoney} Dai`
                }else{
                    this.formStatus.moneyToWage.correct = true
                }
            },
            getFormStatus(){
                if(
                    this.formStatus.moneyToWage.correct &
                    this.formStatus.moneyToWage.correct
                ){
                    return true;
                } else{
                    return false;
                }
            },
            async calcShares(i){
                let shares = 0;
                let moneyToWage = this.getMoneyToWage()[i];
                if(moneyToWage > 0){
                    const options = {
                        _marketId: this.marketData.marketInfo.marketId,
                        _outcome: `${i}`,
                        _moneyToWage: ethToWei([moneyToWage])[0]
                    }
                    shares = await _numSharesForPrice(options);

                }
                this.buyInfo.sharesToBuy[i] = shares;
            },
            async wageMoney(){

                const moneyToWage = this.getMoneyToWage();
                this.validateMoneyWaged();
                let formStatus = this.getFormStatus();
                if(formStatus){
                    //wage Money

                    let shares0 = await this.calcShares(0);
                    let shares1 = await this.calcShares(1);
                    try{
                        await _wageMoney(
                            {
                                _marketId: this.marketData.marketInfo.marketId,
                                _moneyToWage: ethToWei(moneyToWage)
                            }
                        )
                    } catch(error){
                        return false;
                    }

                    //save player
                    await this.saveDeposit(
                        moneyToWage,
                        [shares0, shares1]
                    );

                    //reload the page
                    this.$router.go();
                    
                }
            },
            async saveWithdraw(reward, expertScore){
                const saveOptions = {
                    marketId: this.marketData.marketInfo.marketId,
                    player: this.marketData.playerInfo.player,
                    reward,
                    expertScore
                }
                await Moralis.Cloud.run(
                    'withdraw',
                    saveOptions
                )
            },
            async withDrawWinnings(){
                const _marketId = this
                                .$route
                                .params
                                .marketId
                                .toString();
                try{
                    await _withdrawWinnings(_marketId);
                } catch(error){
                    return false;
                }
                this.withdrawed = true;

                await this.saveWithdraw(
                    this.marketData.withDrawStats.reward,
                    this.marketData.withDrawStats.expertScore
                )
            }
        },
        data(){
            return {
                withdrawed: false,
                buyInfo: {
                    odds: [0, 0],
                    moneyToWage: [null, null],
                    sharesToBuy: [null, null],
                },
                formStatus: {
                    moneyToWage: {
                        correct: true,
                        message: ''
                    }
                },
                buttons :{
                    buy: true,
                    withdraw: false
                }
            }
        },
        computed :{
            getOdds(){
                const m0 = (
                    this.marketData.marketInfo.moneyWaged[0] +
                    this.buyInfo.moneyToWage[0]
                );
                const m1 = (
                    this.marketData.marketInfo.moneyWaged[1] +
                    this.buyInfo.moneyToWage[1]
                );
                const n0 = (
                    this.marketData.marketInfo.sharesOwned[0] + 
                    this.buyInfo.sharesToBuy[0]
                );
                const n1 = (
                    this.marketData.marketInfo.sharesOwned[1] + 
                    this.buyInfo.sharesToBuy[1]
                );
                const total = m0 / n1 + m1 / n0
                return [
                    roundNum(m0 * 100 / (total * n1)),
                    roundNum(m1 * 100 / (total * n0)),
                ]
            },
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
        color:#ffffff;
    }

    .buy-shares-inner {
        display: grid;
        row-gap: 10px;
        column-gap: 3px;
        grid-template-rows: repeat(5, max-content);
        grid-template-columns: repeat(2,1fr);
        background: #183957;
        padding:10px;
        border-radius: 5px;
    }
    .buy-withdraw-buttons {
        display: flex;
        justify-content: space-between;
    }

    .withdraw-button {
        background-color: transparent;
        margin-bottom: 5px;
        border: none;
        color: #ffffff;
        padding-left: 15px;
        padding-right: 15px;
    }

    .withdraw-button-active {
        color: #ad96ff;
        margin-bottom: 0px;
    }

    .buy-button {
        background-color: transparent;
        margin-bottom: 5px;
        border: none;
        color: #ffffff;
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

    .market-stats{
        height: 35px;
        border-radius: 5px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-weight: 300;
        font-family: 'Montserrat';
    }
    .buy-shares-input {
        max-width: 95px;
        height: 20px;
        box-shadow: inset 1px 1px 5px #0c2340;
        background: #375d84;
        color:#ffffff;
        font-weight: 200;
        font-family: 'Montserrat';
        border: none;
    }

    .submit-button-div {
        display: flex;
        height: 45px;
        flex-direction: column;
        justify-content: flex-end;
    }

    .submit-button {
        background: #0d48aa;
        border: none;
        box-shadow: 1px 1px 8px #121212;
        border-radius: 15px;
        color:#ffffff;
        width: 100%;
        height: 25px;
    }

    .submit-button:active{
        background: #1d67de;
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
        font-size: 12px
    }

    .dynamic-stats-element {
        font-size:11px;
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
        width: 210px;
        height: 200px;
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
        font-size: 12px;
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
        height:25px;
        color:#ffffff;
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

   .incorrect-field{
        border: 1.2px solid #ff0505;
        outline: none;
   }

   .incorrect-field:focus{
        outline: none;
   }


   .error-message {
      position:absolute;
      width: 200%;
      left: 0%;
      font-size: 10px;
      font-family: 'Montserrat';
      color: #ff0505;
      top: 99%;
   }



</style>