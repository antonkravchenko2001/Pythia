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
            <div class="market-description">
                <div class="description-component">Will</div>
                <div style="display: flex;flex-direction: column;justify-content: center;">
                    <DropDown :objects="assetNames" height="100px" background="#0c2235" ref="dropdown"/>
                </div>
                <div class="description-component">exceed</div>
                <div class="description-component" style="position:relative">
                    <input 
                        type="number"
                        class='description-input'
                        placeholder='2000'
                        v-model='marketParams.strikePrice'
                        :class="{'incorrect-field': !formStatus.strikePrice.correct}"
                    />
                    <div v-if="!formStatus.strikePrice.correct" class="error-message">
                        {{formStatus.strikePrice.message}}
                    </div>
                </div>
                <div class="description-component">by</div>
                <div class="description-component" style="position: relative">
                    <input 
                    type='date'
                    class='description-input'
                    :class="{'incorrect-field': !formStatus.resolveDate.correct}"
                    v-model="marketParams.resolveDate"
                    />
                    <div v-if="!formStatus.resolveDate.correct" class="error-message">
                        {{formStatus.resolveDate.message}}
                    </div>  
                    <i class="fa-solid fa-calendar" style="position: absolute"></i>
                </div>
                <div class="description-component">?</div>
            </div>
            <div class="wage-deadline-container" style="position: relative">
                <div class="description-component" >Wage deadline</div>
                <div class="description-component" style="position: relative">
                    <input 
                        type='date'
                        class='description-input'
                        :class="{'incorrect-field': !formStatus.wageDeadline.correct}"
                        v-model="marketParams.wageDeadline"
                    />
                    <div v-if="!formStatus.wageDeadline.correct" class="error-message">
                        {{formStatus.wageDeadline.message}}
                    </div>  
                    <i class="fa-solid fa-calendar" style="position: absolute"></i>
                </div>
                <PopUpWindow 
                    text='Deadline for waging money in this market' 
                    background="#134876"
                    width="120px"
                    height="90px"
                />
            </div>
            <div class="item-val market-stats">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>

                <div class="market-info-text">
                    Initial money waged
                </div>
                <div style="position:relative">
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
                <div style="position:relative">
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

                <div class="market-info-text">
                    Initial shares created
                </div>
                <div style="position:relative">
                    <input 
                        type='number'
                        class="market-stats-component no-annot"
                        placeholder='10'
                        :class="{'incorrect-field': !formStatus.sharesOwned[0].correct}"
                        v-model='marketParams.sharesOwned[0]'
                    />
                    <div 
                        v-if="!formStatus.sharesOwned[0].correct"
                        class="error-message"
                    >
                        {{formStatus.sharesOwned[0].message}}
                    </div>
                </div>
                <div style="position:relative">
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
import {dateToUnix, ethToWei, unixToDate} from '../../helperFunctions.js'
import {_createMarket} from '../../contract-functions/ContractFunctions.js'
import {minMoneyCreate, minSharesCreate} from '../../config.js';
import DropDown from './DropDown.vue';
import PopUpWindow from './PopUpWindow.vue';
import Moralis from '../../main.js'
export default {
    components: {
        DropDown,
        PopUpWindow
    },
    props: ['assetNames'],
    data() {
        return {
            marketParams: {
                asset: '',
                strikePrice: null,
                wageDeadline: '',
                resolveDate: '',
                moneyWaged: [null, null],
                sharesOwned: [null, null]
            },
            formStatus: {
                strikePrice: {correct: true, message: ''},
                wageDeadline: {correct: true, message: ''},
                resolveDate: {correct: true, message: ''},
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
        async getAsset(){
            const assetName = this.$refs.dropdown.input;
            const res = await Moralis.Cloud.run(
                'getAssets', 
                {asset: assetName}
            )
            let asset = res[0];
            return asset;
        },
        validateStrikePrice(){
            const strikePrice = this.marketParams.strikePrice;
            if(strikePrice < 0){
                this.formStatus.strikePrice.correct = false;
                this.formStatus.strikePrice.message = 'strike price < 0';
            }else{
                this.formStatus.strikePrice.correct = true;
            }
        },
        validateWageDeadline(){
            const today = dateToUnix();
            const wageDeadline = dateToUnix(this.marketParams.wageDeadline);
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
                (resolveDate < wageDeadline)
            ){
                this.formStatus.resolveDate.correct = false;
                this.formStatus.resolveDate.message = 'resolution < wage deadline';
            }else{
                this.formStatus.resolveDate.correct = true;
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
                this.formStatus.strikePrice.correct &
                this.formStatus.wageDeadline.correct &
                this.formStatus.resolveDate.correct &
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
            const asset =  await this.getAsset();
            const assetName = asset.get('asset');
            const priceFeed = asset.get('priceFeed');

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
            const _wageDeadline = dateToUnix(this.marketParams.wageDeadline);
            this.validateWageDeadline();

            //get resolve date
            const _resolutionDate= dateToUnix(this.marketParams.resolveDate);
            this.validateResolveDate();

            //get form status
            const formStatus = this.getFormStatus();
            if(formStatus){

                //create market
                const createOptions = {
                    _sharesOwned: ethToWei(_sharesOwned),
                    _moneyWaged: ethToWei(_moneyWaged),
                    _priceFeedAddress: priceFeed,
                    _strikePrice: ethToWei([_strikePrice])[0],
                    _resolutionDate,
                    _wageDeadline
                }
                const marketId = await _numMarkets();
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


                //save market
                const marketValues = {
                    marketId,
                    asset: assetName,
                    strikePrice: _strikePrice,
                    resolvePrice: 0,
                    wageDeadline: unixToDate(_wageDeadline),
                    resolveDate: unixToDate(_resolutionDate),
                    volume,
                    volumeShares,
                    resolved: false,
                    winningOutcome: 0
                }

                console.log(marketValues);

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
                    strikePrice: _strikePrice,
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
    },


}
</script>

<style scoped>

    .create-market-window {
        display: grid;
        padding: 20px;
        width: 450px;
        gap: 25px;
        bottom: 50px;
        background: linear-gradient(90deg, rgb(25 31 74) 0%, rgba(18,47,74,1) 75%, rgba(18,47,74,1) 100%);
        grid-template-rows: repeat(5, max-content);
        z-index: 10;
        border-radius: 10px;
        border: #3a98e1 1.5px solid;
        box-shadow: 1px 1px 8px #121212;
        color: #ffffff;
        font-family: 'Montserrat';
        font-size: 12px;
        position: relative;
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

    .market-description {
        display: grid;
        grid-template-columns: max-content 1.5fr max-content 1.2fr max-content 1.7fr max-content;
        gap: 7px;
    }

    .description-component {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        position:relative;
    }

    .description-input {
        width: 90%;
        background: #0c2235;
        color:#ffffff;
        font-family: 'Montserrat';
        border: none;
        border-radius: 5px;
        box-shadow: 1px 1px 5px #121212;
    }

    .description-component .fa-solid {
        right: 5px;
        font-size: 13px;
    }

    .wage-deadline-container {
        display: grid;
        gap: 10px;
        grid-template-columns: repeat(3, max-content);
        width: 200px;
    }

    .market-stats {
       display: grid;
       row-gap: 20px;
       column-gap: 7px;
       color: #ffffff;
        grid-template-columns: 3fr 2fr 2fr;
        grid-template-rows: 0.3fr 1fr 1fr;
       padding-bottom: 15px;
    }

    .market-stats-component {
        color:#ffffff;
        border-radius: 5px;
        border:none;
        background-color: #0c2235;
        height: 25px;
        max-width: 75px;
        font-family: 'Montserrat';
        font-weight: 400;
        font-size: 13px;
    }
    .market-info-text {
        display: flex;
        align-items: center;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 400;
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


   .button-group {
       display: flex;
       justify-content: space-between;
       margin: 0px;
       padding: 0px;
   }

   .submit-button{
       background-color: #2060e6;
       color: #ffffff;
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
      position:absolute;
      width: 120%;
      left: 0%;
      font-size: 10px;
      font-family: 'Montserrat';
      color: #ff0505;
      top: 105%;
   }



</style>