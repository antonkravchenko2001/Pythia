<template>
    <div class="create-market-div">
        <button  v-if="!clicked & isLoggedIn" @click="click" class="create-market-button">
            CREATE MARKET
            <i class="fas fa-plus"></i>
        </button>
        <div v-if="clicked & isLoggedIn" class="create-market-window">
            <div class="title">Create Market form</div>
            <div class="info-container">
                <div class="info-container">
                    <div class="item-name">Asset</div>
                    <input type='text' placeholder="eth/usd" class="item-val features-input" v-model='marketParams.asset'/>
                </div>
                <div class="info-container">
                    <div class="item-name">Strike Price</div>
                    <input type='number' class="item-val features-input" placeholder='1200' v-model='marketParams.strikePrice'/>
                </div>
            </div>
            <div class="info-container">
                <div class="info-container">
                    <div class="item-name">Wage Deadline</div>
                    <input type='text' class="item-val features-input" placeholder='Enter wage deadline' v-model='marketParams.wageDeadline'/>
                </div>
                <div class="info-container">
                    <div class="item-name">Resolve Date</div>
                    <input type='text' class="item-val features-input" placeholder='Enter resolution date' v-model='marketParams.resolveDate' required/>
                </div>
            </div>
            <div >
                <div class="item-name">Description</div>
                <textarea type='text' class='item-val description-area' placeholder='Enter the discription' v-model='marketParams.description' required></textarea>
            </div>
            <div class="item-val market-stats">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>
                <div class="market-info-text">Initial Money Waged</div>
                <input type='number' class="market-stats-component no-annot" placeholder='10' v-model='marketParams.moneyWaged[0]'>
                <input type='number' class="market-stats-component yes-annot" placeholder='10' v-model='marketParams.moneyWaged[1]'/>
                <div class="market-info-text">Initial Shares Owned</div>
                <input type='number' class="market-stats-component no-annot" placeholder='10' v-model='marketParams.sharesOwned[0]'/>
                <input type='number' class="market-stats-component yes-annot" placeholder='10' v-model='marketParams.sharesOwned[1]'/>
            </div>
            <div class="button-group">
                <button class='cancel-button' @click="cancel()">Cancel</button>
                <button class="submit-button" @click="createMarket">Submit</button>
            </div>
        </div>
    </div>
</template>

<script>

import {_numMarkets } from '../../contract-functions/ContractFunctions.js'
import {dateToUnix, checkMoney, ethToWei, checkShares} from '../../helperFunctions.js'
import {_createMarket} from '../../contract-functions/ContractFunctions.js'
import Moralis from '../../main.js'
export default {
    data() {
        return {
            marketParams: {
                asset: "0",
                strikePrice: 0,
                wageDeadline: 0,
                resolveDate: 0,
                description: "",
                moneyWaged: [0, 0],
                sharesOwned: [0, 0]
            },
            clicked: false
        };
    },
    methods: {
        click(){
            this.$store.state.showForm = true;
            this.clicked = true;
        },
        cancel(){
            this.clicked=false;
            this.$store.state.showForm=false;
        },
        async createMarket(){
            const asset = await Moralis.Cloud.run(
                'getAsset', {asset: this.marketParams.asset}
            );
            const assetFeed = asset.get('priceFeed');
            const assetName =  asset.get('asset');
            const marketId = await _numMarkets();

            if(
                checkMoney(this.marketParams.moneyWaged) &&
                checkShares(this.marketParams.sharesOwned)){
                const createOptions = {
                    _sharesOwned: ethToWei(this.marketParams.sharesOwned),
                    _moneyWaged: ethToWei(this.marketParams.moneyWaged),
                    _priceFeedAddress: assetFeed,
                    _strikePrice: ethToWei([this.marketParams.strikePrice])[0],
                    _resolutionDate: dateToUnix(this.marketParams.resolveDate),
                    _wageDeadline: dateToUnix(this.marketParams.wageDeadline)
                }
    
                try{
                    console.log(createOptions);
                    await _createMarket(createOptions);
                } catch(error){
                    console.error(error)
                    return false;
                }
                const volume = this
                            .marketParams
                            .moneyWaged
                            .reduce(
                                    (acc, curr) => { return acc + curr; }
                            );
                const volumeShares = this
                                    .marketParams
                                    .sharesOwned
                                    .reduce(
                                        (acc, curr) => { return acc + curr; }
                                    );
                const _wageDeadline = new Date(dateToUnix(this.marketParams.wageDeadline) * 1000);
                const _resolveDate = new Date(dateToUnix(this.marketParams.wageDeadline) * 1000);

                //save market
                const marketValues = {
                    marketId,
                    asset: assetName,
                    strikePrice: this.marketParams.strikePrice,
                    resolvePrice: 0,
                    wageDeadline: _wageDeadline,
                    resolveDate: _resolveDate,
                    description: this.marketParams.description,
                    volume,
                    volumeShares,
                    resolved: false,
                    winningOutcome: 0
                }

                await Moralis.Cloud.run(
                    'saveMarket', {
                        values: marketValues
                    }
                );
                console.log('market saved!')

                //save player
                const playerValues = {
                    marketId,
                    player: this.$store.state.user.get('ethAddress'),
                    strikePrice: this.marketParams.strikePrice,
                    withdrawed: false,
                    expertScore: 0,
                    reward: 0,
                    sharesOwned: this.marketParams.sharesOwned,
                    moneyWaged: this.marketParams.moneyWaged
                }

                await Moralis.Cloud.run(
                    'savePlayer', {
                        values: playerValues
                    }
                );
                console.log('player saved!')
            }
        },


    
    },
    computed: {
        isLoggedIn(){
            if(this.$store.state.user){
                return true;
            }
            return false;
        }
    },
}
</script>

<style scoped>

    .create-market-window {
        display: grid;
        padding: 15px;
        gap: 15px;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 1fr 1fr 2.5fr 4.5fr 1fr;
        bottom: 50px;
        background-color: #122f4a;
        z-index: 10;
        border-radius: 10px;
        border: #8925bc 1.2px solid;
        box-shadow: 1px 1px 8px #121212;
    }

    .create-market-div {
        display: flex;
        max-height: 100vh;
        min-height: 50vh;
        width: 100%;
        margin: 15px;
        justify-content: center;
        align-items: center;
        position: absolute;
        z-index: 5;
    }

    .create-market-button{
        border: none;
        border-radius: 5px;
        border: solid 2px;
        border-color: #57c080dc;
        background-color: #0e2438;
        color: #cecece;
        font-size: 14px;
        padding: 20px;
        font-family: 'Montserrat';
    }
    .create-market-button:hover{
        background-color: #35794fdc;
    }

    .fas {
        font-family: "Font Awesome 5 Pro";
        font-weight: 400;
        left: 5px;
        position: relative;
        font-size: 15px;
    }


    .info-container {
        display: flex;
        grid-column-start: 1;
        justify-content: space-between;
    }

    .item-name {
        padding: 5px;
        border: none;
        color: #cecece;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 400;
    }

    .features-input {
        max-width: 75px;
        background-color: #0a1b2a;
    }

    .item-val {
        border: none;
        border-radius: 5px;
        padding: 5px;
        border-radius: 5px;
        color: #cecece;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 200;
    }

    .colored-border {
        border: 1.5px solid;
        border-color: #cecece
    }

    .button-container {
        display: flex;
        justify-content: flex-end;
    }

    .market-stats {
       display: grid;
       row-gap: 10px;
       column-gap: 7px;
        grid-template-columns: 3fr 2fr 2fr;
        grid-template-rows: 0.3fr 1fr 1fr;
       padding-bottom: 15px;
    }

    .market-stats-component {
        color:#cecece;
        border-radius: 5px;
        border:none;
        background-color: #0a1b2a;
        max-width: 75px;
        font-family: 'Montserrat';
        font-weight: 300;
        font-size: 13px;
    }
    .market-info-text {
        display: flex;
        align-items: center;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 400;
    }

    .title {
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 14px;
        color: #cecece;
        font-family: 'Montserrat';
    }


   .yes-annot:focus {
       outline: 1.5px;
       outline-color: #4decc9c2;
       outline-style: solid;
   }

   .no-annot:focus {
       outline: 1.5px;
       outline-color: #ec4d4dc2;
       outline-style: solid;
   }

   .description-area {
       width: 97%;
       background-color: #0a1b2a;
   }


   .button-group {
       display: flex;
       justify-content: flex-end;
   }

   .submit-button{
       background-color: #269858b3;
       color: #cecece;
       padding-left: 15px;
       padding-right: 15px;
       border-radius: 15px;
       margin-left:10px;
       border: #0e3721b3 1.5px solid;
       box-shadow: 0.1px 0.1px 5px #010b15;
   }

   .cancel-button {
       background-color: #e93939ae;
        font-size: 12px;
        padding-left: 15px;
        padding-right: 15px;
        margin-right: 10px;
        border-radius: 15px;
        border: #691d1dae 1.5px solid;
        box-shadow: 0.1px 0.1px 5px #010b15;
   }

   .cancel-button:active{
       background-color: #691d1dae;
       box-shadow: none;
   }

   .submit-button:active{
       background-color: #0e3721b3;
       box-shadow: none;
   }

   .cancel-button:hover{
       background-color: #691d1dae;
   }

   .submit-button:hover{
       background-color: #0e3721b3;
   }


</style>