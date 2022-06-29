<template>
    <div class="create-market-div">
        <button  v-if="!clicked & isLoggedIn" @click="click" class="create-market-button">
            CREATE MARKET
            <i class="fas fa-plus"></i>
        </button>
        <div v-if="clicked & isLoggedIn" class="create-market-window">
            <div>
                <i class="fa-solid fa-xmark" @click="cancel"></i>
            </div>
            <div class="info-container">
                <div>
                    <div class="item-name">Asset pair</div>
                    <input 
                        type='text'
                        placeholder="eth/usd"
                        class="item-val features-input"
                        :class="{'incorrect-field': !formStatus.asset.correct}"
                        v-model='marketParams.asset'
                    />
                    <div v-if="!formStatus.asset.correct" class="error-message">
                        {{formStatus.asset.message}}
                    </div>
                </div>
                <div>
                    <div class="item-name">Strike Price</div>
                    <input 
                        type='number'
                        class="item-val features-input"
                        placeholder='1200'
                        :class="{'incorrect-field': !formStatus.strikePrice.correct}"
                        v-model='marketParams.strikePrice'
                    />
                    <div v-if="!formStatus.strikePrice.correct" class="error-message">
                        {{formStatus.strikePrice.message}}
                    </div>
                </div>
            </div>
            <div class="info-container">
                <div>
                    <div class="item-name">Wage Deadline</div>
                    <input
                        type='text'
                        class="item-val features-input"
                        placeholder='mm/dd/yyyy'
                        :class="{'incorrect-field': !formStatus.wageDeadline.correct}"
                        v-model='marketParams.wageDeadline'
                    />
                    <div v-if="!formStatus.wageDeadline.correct" class="error-message">
                        {{formStatus.wageDeadline.message}}
                    </div>
                </div>
                <div>
                    <div class="item-name">Resolution Date</div>
                    <input
                        type='text'
                        class="item-val features-input"
                        placeholder='mm/dd/yyyy'
                        :class="{'incorrect-field': !formStatus.resolveDate.correct}"
                        v-model='marketParams.resolveDate' required
                    />
                    <div v-if="!formStatus.resolveDate.correct" class="error-message">
                        {{formStatus.resolveDate.message}}
                    </div>
                </div>
            </div>
            <div >
                <div class="item-name">Description</div>
                <textarea
                    type='text'
                    class='item-val description-area'
                    placeholder='Enter the discription'
                    :class="{'incorrect-field': !formStatus.description.correct}"
                    v-model='marketParams.description' required
                >
                </textarea>
                <div v-if="!formStatus.description.correct" class="error-message">
                    {{formStatus.description.message}}
                </div>
            </div>
            <div class="item-val market-stats">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>

                <div class="market-info-text">Initial Money Waged</div>
                <div>
                    <input 
                        type='number'
                        class="market-stats-component no-annot"
                        placeholder='10'
                        :class="{'incorrect-field': !formStatus.moneyWaged[0].correct}"
                        v-model='marketParams.moneyWaged[0]'
                    >
                    <div v-if="!formStatus.moneyWaged[0].correct" class="error-message">
                        {{formStatus.moneyWaged[0].message}}
                    </div>
                </div>
                <div>
                    <input 
                        type='number'
                        class="market-stats-component no-annot"
                        placeholder='10'
                        :class="{'incorrect-field': !formStatus.moneyWaged[1].correct}"
                        v-model='marketParams.moneyWaged[1]'
                    />
                    <div v-if="!formStatus.moneyWaged[1].correct" class="error-message">
                        {{formStatus.moneyWaged[1].message}}
                    </div>
                </div>

                <div class="market-info-text">Initial Shares Owned</div>
                <div>
                    <input 
                        type='number'
                        class="market-stats-component no-annot"
                        placeholder='10'
                        :class="{'incorrect-field': !formStatus.sharesOwned[0].correct}"
                        v-model='marketParams.sharesOwned[0]'
                    />
                    <div v-if="!formStatus.sharesOwned[0].correct" class="error-message">
                        {{formStatus.sharesOwned[0].message}}
                    </div>
                </div>
                <div>
                    <input 
                        type='number'
                        class="market-stats-component yes-annot"
                        placeholder='10'
                        :class="{'incorrect-field': !formStatus.sharesOwned[1].correct}"
                        v-model='marketParams.sharesOwned[1]'
                    />
                    <div v-if="!formStatus.sharesOwned[1].correct" class="error-message">
                        {{formStatus.sharesOwned[1].message}}
                    </div>
                </div>
            </div>
            <div class="button-group">
                <button class="submit-button" @click="createMarket">Create Market</button>
            </div>
        </div>
    </div>
</template>

<script>

import {_numMarkets } from '../../contract-functions/ContractFunctions.js'
import {dateToUnix, ethToWei} from '../../helperFunctions.js'
import {_createMarket} from '../../contract-functions/ContractFunctions.js'
import {minMoneyCreate, minSharesCreate} from '../../config.js';
import Moralis from '../../main.js'
export default {
    data() {
        return {
            marketParams: {
                asset: '',
                strikePrice: null,
                wageDeadline: '',
                resolveDate: '',
                description: "",
                moneyWaged: [null, null],
                sharesOwned: [null, null]
            },
            formStatus: {
                asset: {correct: true, message: ''},
                strikePrice: {correct: true, message: ''},
                wageDeadline: {correct: true, message: ''},
                resolveDate: {correct: true, message: ''},
                description: {correct: true, message: ''},
                moneyWaged: {
                    0: {correct: true, message: ''},
                    1: {correct: true, message: ''},
                },
                sharesOwned: {
                    0: {correct: true, message: ''},
                    1: {correct: true, message: ''},
                }
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

        validateAsset(asset){
            if(!asset){
                this.formStatus.asset.correct = false;
                this.formStatus.asset.message = 'asset not found'
            }else{
                this.formStatus.asset.correct = true;
            }
        },
        validateStrikePrice(){
            const strikePrice = this.marketParams.strikePrice;
            if(strikePrice <= 0){
                this.formStatus.strikePrice.correct = false;
                this.formStatus.strikePrice.message = 'strike price should be > 0';
            }else{
                this.formStatus.strikePrice.correct = true;
            }
        },
        validateWageDeadline(){
            const today = dateToUnix();
            const wageDeadline = dateToUnix(this.marketParams.wageDeadline);
            console.log(wageDeadline, today);
            if(wageDeadline < today){
                this.formStatus.wageDeadline.correct = false;
                this.formStatus.wageDeadline.message = 'wage deadline has passed'
            }else{
                this.formStatus.wageDeadline.correct = true;
            }
        },
        validateResolveDate(){
            const resolveDate = dateToUnix(this.marketParams.resolveDate);
            const wageDeadline = dateToUnix(this.marketParams.wageDeadline);
            
            if(
                (resolveDate < wageDeadline) || (!resolveDate)
            ){
                this.formStatus.resolveDate.correct = false;
                this.formStatus.resolveDate.message = 'resolution < wage deadline';
            }else{
                this.formStatus.resolveDate.correct = true;
            }
        },

        validateDesciption(){
            if(this.marketParams.description === ''){
                this.formStatus.description.correct = false;
                this.formStatus.description.message = 'description is empty'
            }else{
                this.formStatus.description.correct = true;
            }
        },
        validateMoneyWaged(){
            for(let outcome=0; outcome < 2; outcome++){
                if(this.marketParams.moneyWaged[outcome] < minMoneyCreate){
                    this.formStatus.moneyWaged[outcome].correct = false
                    this.formStatus.moneyWaged[outcome].message = 'insufficient money'
                } else {
                    this.formStatus.moneyWaged[outcome].correct = true
                }
            }
        },
        validateSharesOwned(){
            for(let outcome=0; outcome < 2; outcome++){
                if(this.marketParams.sharesOwned[outcome] < minSharesCreate){
                    this.formStatus.sharesOwned[outcome].correct = false
                    this.formStatus.sharesOwned[outcome].message = 'insufficient shares'
                } else {
                    this.formStatus.sharesOwned[outcome].correct = true
                }
            }
        },
        getFormStatus(){
            if(
                this.formStatus.asset.correct &
                this.formStatus.strikePrice.correct &
                this.formStatus.wageDeadline.correct &
                this.formStatus.resolveDate.correct &
                this.formStatus.description.correct &
                this.formStatus.moneyWaged[0].correct &
                this.formStatus.moneyWaged[1].correct &
                this.formStatus.sharesOwned[0].correct &
                this.formStatus.sharesOwned[1].correct
            ){
                return true;
            }else{
                return false;
            }
        },
        async createMarket(){

            //get asset
            const asset = await Moralis.Cloud.run(
                'getAsset',
                {asset: this.marketParams.asset}
            );

            this.validateAsset(asset);

            //get marketId
            const marketId = await _numMarkets();

            //get strike price
            const _strikePrice = this.marketParams.strikePrice;

            this.validateStrikePrice();

            //get money waged
            const _moneyWaged = this.marketParams.moneyWaged;

            this.validateMoneyWaged();

            //get shares owned
            const _sharesOwned = this.marketParams.sharesOwned;

            this.validateSharesOwned();

            //get wage deadline
            const _wageDeadline = this.marketParams.wageDeadline;

            this.validateWageDeadline();

            //get resolve date
            const _resolutionDate= this.marketParams.resolveDate;
            this.validateResolveDate();

            //get description
            const description = this.marketParams.description;
            this.validateDesciption();

            const formStatus = this.getFormStatus();
            console.log(this.formStatus)
            if(formStatus){

                //create market
                const createOptions = {
                    _sharesOwned: ethToWei(_sharesOwned),
                    _moneyWaged: ethToWei(_moneyWaged),
                    _priceFeedAddress: asset.get('priceFeed'),
                    _strikePrice: ethToWei([_strikePrice])[0],
                    _resolutionDate: dateToUnix(_resolutionDate),
                    _wageDeadline: dateToUnix(_wageDeadline)
                }
    
                try{
                    console.log(createOptions);
                    await _createMarket(createOptions);
                } catch(error){
                    console.error(error)
                    return false;
                }

                //save results for player and market to the database
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
                const wageDeadline = new Date(
                    dateToUnix(_wageDeadline) *
                    1000
                );
                const resolveDate = new Date(
                    dateToUnix(_resolutionDate) *
                    1000
                );

                //save market
                const marketValues = {
                    marketId,
                    asset: asset.get('asset'),
                    strikePrice: this.marketParams.strikePrice,
                    resolvePrice: 0,
                    wageDeadline: wageDeadline,
                    resolveDate: resolveDate,
                    description: description,
                    volume,
                    volumeShares,
                    resolved: false,
                    winningOutcome: 0
                }

                //save market
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
                    sharesOwned: _sharesOwned,
                    moneyWaged: _moneyWaged
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
        },
    }
}
</script>

<style scoped>

    .create-market-window {
        display: grid;
        padding: 20px;
        width: 350px;
        gap: 10px;
        bottom: 50px;
        background-color: #122f4a;
        grid-template-rows: repeat(6, max-content);
        z-index: 10;
        border-radius: 10px;
        border: #8925bc 1.2px solid;
        box-shadow: 1px 1px 8px #121212;
    }

    .create-market-div {
        display: flex;
        max-height: 50vh;
        min-height: 20vh;
        width: 100%;
        justify-content: center;
        align-items: center;
        position: absolute;
        z-index: 5;
    }

    .create-market-button{
        border-radius: 5px;
        border: solid 2px #57c080dc;
        background-color: #0b1f2e;
        color: #ffffff;
        font-size: 14px;
        padding: 20px;
        font-family: 'Montserrat';
    }
    .create-market-button:hover{
        background-color: #35794fdc;
    }

    .fas {
        font-family: "Font Awesome 5 Pro";
        font-weight: 1000;
        left: 5px;
        top: 1px;
        position: relative;
        font-size: 20px;
    }


    .info-container {
        display: flex;
        grid-column-start: 1;
        justify-content: space-between;
    }

    .item-name {
        padding: 5px;
        border: none;
        color: #ffffff;
        font-size: 13px;
        font-family: 'Montserrat';
        font-weight: 400;
    }

    .features-input {
        height: 20px;
        width: 110px;
        background-color: #0c2235;
    }

    .item-val {
        border: none;
        border-radius: 5px;
        border-radius: 5px;
        color: #cecece;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 250;
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
       color: #ffffff;
        grid-template-columns: 3fr 2fr 2fr;
        grid-template-rows: 0.3fr 1fr 1fr;
       padding-bottom: 15px;
    }

    .market-stats-component {
        color:#cecece;
        border-radius: 5px;
        border:none;
        background-color: #0c2235;
        height: 25px;
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
       background-color: #0c2235;
   }


   .button-group {
       display: flex;
       justify-content: space-between;
       margin: 0px;
       padding: 0px;
   }

   .submit-button{
       background-color: #154ab8;
       color: #cecece;
       padding-left: 15px;
       padding-right: 15px;
       border-radius: 15px;
       height: 25px;
       border: none;
       box-shadow: 0.1px 0.1px 5px #010b15;
       width: 100%;
   }

   
   .submit-button:active{
       box-shadow: none;
   }


   .submit-button:hover{
       box-shadow: none;
   }

   .fa-solid {
      cursor: pointer;
      color: #ffffff;
      font-size: 18px;
      position: relative;
   }

   .incorrect-field{
        border: 1.2px solid #ff0505;
        outline: none;
   }

   .incorrect-field:focus{
        outline: none;
   }


   .error-message {
      font-size: 10px;
      font-family: 'Montserrat';
      color: #ff0505;
   }



</style>