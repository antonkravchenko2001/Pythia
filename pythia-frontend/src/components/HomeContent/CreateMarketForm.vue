<template>
    <div class="create-market-window" style="z-index:100">
        <i class="fa-solid fa-xmark" @click="cancel"></i>
        <div class="market-description">
            Will
            <div style="display: flex;flex-direction: column;justify-content: center;">
                <DropDown defaultValue='ETH/USD' :objects="assetNames" height="100px" background="#16446c" ref="dropdown"/>
            </div>
            exceed
            <div style="position:relative">
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
            by
            <div class="description-component">
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
            ?
        </div>
        <div class="wage-deadline-container">
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
                background="#121f2a"
                color="#afafaf"
                width="120px"
                height="70px"
            />
        </div>
        <div>
            <div class="market-options">
                <span>No</span>
                <span>Yes</span>
            </div>
            <div class="market-stats">
                <div class="market-info-text">
                    Initial money waged
                </div>
                <div style="position:relative">
                    <input 
                        type='number'
                        class="market-stats-component"
                        placeholder='10'
                        style="border-top-left-radius: 5px; border-bottom-left-radius: 5px;"
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
                        class="market-stats-component"
                        placeholder='10'
                        style="border-top-right-radius: 5px; border-bottom-right-radius: 5px;"
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
                        class="market-stats-component"
                        placeholder='10'
                        style="border-top-left-radius: 5px; border-bottom-left-radius: 5px;"
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
                        class="market-stats-component"
                        style="border-top-right-radius: 5px; border-bottom-right-radius: 5px;"
                        placeholder='10'
                        :class="{'incorrect-field': !formStatus.sharesOwned[1].correct}"
                        v-model='marketParams.sharesOwned[1]'
                    />
                    <div v-if="!formStatus.sharesOwned[1].correct" class="error-message">
                        {{formStatus.sharesOwned[1].message}}
                    </div>
                </div>
            </div>
        </div>
        <div class="button-group">
            <button class="submit-button" @click="createMarket">Create Market</button>
        </div>
    </div>
</template>

<script>
    import {_numMarkets } from '../../contract-functions/ContractFunctions.js'
    import {dateToUnix, ethToWei, unixToDate} from '../../utils.js'
    import {_createMarket} from '../../contract-functions/ContractFunctions.js'
    import {minMoneyCreate, minSharesCreate} from '../../config.js';
    import DropDown from '../subcomponents/DropDown.vue';
    import Moralis from '../../main.js'
    import { defineAsyncComponent } from 'vue';
    export default {
        components: {
            DropDown,
            PopUpWindow: defineAsyncComponent(() =>
                import('../subcomponents/PopUpWindow.vue')
            )
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
                minMoney: minMoneyCreate,
                minShares: minSharesCreate
            };
        },
        methods: {
            cancel(){
                this.$store.state.showForm=false;
            },
            async getAsset(){
                const assetName = this.$refs.dropdown.input;
                console.log(assetName);
                const res = await Moralis.Cloud.run(
                    'getAssets', 
                    {asset: assetName.toLowerCase()}
                )
                let asset = res[0];
                return asset;
            },
            validateStrikePrice(){
                const strikePrice = this.marketParams.strikePrice;
                if(strikePrice == null){
                    this.formStatus.strikePrice.correct = false;
                    this.formStatus.strikePrice.message = 'select strike price';
                }else if(strikePrice < 0){
                    this.formStatus.strikePrice.correct = false;
                    this.formStatus.strikePrice.message = 'strike price < 0';
                }else{
                    this.formStatus.strikePrice.correct = true;
                }
            },
            validateWageDeadline(){
                const today = dateToUnix();
                const wageDeadline = dateToUnix(this.marketParams.wageDeadline);
                if(!this.marketParams.wageDeadline){
                    this.formStatus.wageDeadline.correct = false;
                    this.formStatus.wageDeadline.message = 'select wage deadline'
                }else if(wageDeadline < today){
                    this.formStatus.wageDeadline.correct = false;
                    this.formStatus.wageDeadline.message = 'wage deadline has passed'
                }else{
                    this.formStatus.wageDeadline.correct = true;
                }
            },
            validateResolveDate(){
                const resolveDate = dateToUnix(this.marketParams.resolveDate);
                const wageDeadline = dateToUnix(this.marketParams.wageDeadline);
                if(!this.marketParams.resolveDate){
                    this.formStatus.resolveDate.correct = false;
                    this.formStatus.resolveDate.message = 'select resolution date';
                }else if(resolveDate < wageDeadline){
                    this.formStatus.resolveDate.correct = false;
                    this.formStatus.resolveDate.message = 'resolution must be >= wage deadline';
                }else{
                    this.formStatus.resolveDate.correct = true;
                }
            },
            validateMoneyWaged(){
                for(let outcome=0; outcome < 2; outcome++){
                    if(this.marketParams.moneyWaged[outcome] < minMoneyCreate){
                        this.formStatus.moneyWaged[outcome].correct = false
                        this.formStatus.moneyWaged[outcome].message = `money to wage must be >= ${this.minMoney}`
                    } else {
                        this.formStatus.moneyWaged[outcome].correct = true
                    }
                }
            },
            validateSharesOwned(){
                for(let outcome=0; outcome < 2; outcome++){
                    if(this.marketParams.sharesOwned[outcome] < minSharesCreate){
                        this.formStatus.sharesOwned[outcome].correct = false
                        this.formStatus.sharesOwned[outcome].message = `shares to initialize must be >= ${this.minMoney}`
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
                    console.log('market_id', marketId);
                    try{
                        await _createMarket(createOptions);
                    } catch(error){
                        console.error(error)
                        return false;
                    }

                    //save market
                    await Moralis.Cloud.run(
                        'saveMarket', {
                            marketId,
                            values: {
                                marketId,
                                asset: assetName,
                                strikePrice: _strikePrice,
                                wageDeadline: unixToDate(_wageDeadline),
                                resolutionDate: unixToDate(_resolutionDate),
                            }
                        }
                    );
                    console.log('market saved!')

                    //save deposit transaction
                    await Moralis.Cloud.run(
                        'deposit', {
                            marketId,
                            player: this.$store.state.user.get('ethAddress'),
                            moneyNo:  _moneyWaged[0],
                            moneyYes: _moneyWaged[1],
                            sharesNo: _sharesOwned[0],
                            sharesYes: _sharesOwned[1]
                        }
                    );
                    console.log('player saved!')

                    //reload the page
                    this.$router.go();
                }
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
        background: linear-gradient(90deg, rgb(25 31 74) 0%, rgba(18,47,74,1) 75%, rgba(18,47,74,1) 100%);
        grid-template-rows: repeat(4, max-content);
        border-radius: 10px;
        box-shadow: 1px 1px 8px #121212;
        color: #ffffff;
        font-family: 'Montserrat';
        font-size: 12px;
        position: absolute;
        top: 45vh;
        left: 50%;
        transform: translate(-50%, -50%);
    }

    .create-market-window .fa-xmark {
        position: relative;
    }

    .market-description {
        display: grid;
        grid-template-columns: max-content 1.5fr max-content 1.2fr max-content 1.7fr max-content;
        align-items: center;
        gap: 7px;
        position: relative;
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
        background: #16446c;
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
       row-gap: 25px;
       column-gap: 2px;
       width: max-content;
       color: #ffffff;
       grid-template-columns: repeat(3,max-content);
       grid-template-rows: repeat(2,1fr);
    }

    .market-stats-component {
        color:#ffffff;
        border:none;
        background-color: rgb(22, 68, 108);
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
        margin-right: 10px;
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
       margin-top: 10px;
       padding-right: 15px;
       border-radius: 15px;
       height: 30px;
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
      top: 99%;
   }

   .market-options{
        display: flex;
        gap: 67px;
        position: relative;
        left: 135px;
        margin-bottom: 10px;
        font-size: 14px;
   }

</style>