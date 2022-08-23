<template>
    <div class="create-market-window" style="z-index:100">
        <div style="display:flex;gap: 10px;flex-direction:column;justify-content:space-between">
            <i class="fa-solid fa-xmark" @click="cancel"></i>
            <AlertWindow 
                v-if="transaction.status === 'fail'"
                style="font-family:monospace"
                color='red'
                :text='transaction.message'
                :status="transaction.status"
            />
            <AlertWindow 
                v-if="transaction.status === 'success'"
                style="font-family:monospace"
                color='green'
                :text='transaction.message'
                :success="true"
                :status="transaction.status"
            />
            <AlertWindow 
                v-if="transaction.status === 'pending'"
                style="font-family:monospace"
                color='#ffaf00'
                :text='transaction.message'
                :status="transaction.status"
            />
        </div>
        <div class="market-description">
            Will
            <div style="display: flex;flex-direction: column;justify-content: center;">
                <DropDown defaultValue='ETH/USD' :objects="assetNames" height="100px" background="#16446c" ref="dropdown"/>
            </div>
            exceed
            <div style="position:relative">
                <input
                    style="width:60%"
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
                :class="{'incorrect-field': !formStatus.resolutionDate.correct}"
                v-model="marketParams.resolutionDate"
                />
                <div v-if="!formStatus.resolutionDate.correct" class="error-message">
                    {{formStatus.resolutionDate.message}}
                </div>
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
            </div>
            <PopUpWindow 
                text='Deadline for waging money in this market' 
                background="#213f58"
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
    import {dateToUnix, unixToDate, ethToWei, dateToStr} from '../../utils.js'
    import {_createMarket} from '../../contract-functions/ContractFunctions.js'
    import {minMoneyCreate, minSharesCreate} from '../../config.js';
    import DropDown from '../subcomponents/DropDown.vue';
    import Moralis from '../../main.js'
    import { defineAsyncComponent } from 'vue';
    export default {
        components: {
            DropDown,
            PopUpWindow: defineAsyncComponent(() => import("../subcomponents/PopUpWindow.vue")),
            AlertWindow: defineAsyncComponent(() => import("../subcomponents/AlertWindow.vue")),
        },
        props: ['assetNames'],
        data() {
            return {
                marketParams: {
                    marketId: '',
                    asset: '',
                    strikePrice: null,
                    wageDeadline: '',
                    resolutionDate: '',
                    moneyWaged: [null, null],
                    sharesOwned: [null, null]
                },
                formStatus: {
                    strikePrice: {correct: true, message: ''},
                    wageDeadline: {correct: true, message: ''},
                    resolutionDate: {correct: true, message: ''},
                    moneyWaged: {
                        0: {correct: true, message: ''},
                        1: {correct: true, message: ''},
                    },
                    sharesOwned: {
                        0: {correct: true, message: ''},
                        1: {correct: true, message: ''},
                    }
                },
                transaction: {
                    message: '',
                    status: null
                },
                minMoney: minMoneyCreate,
                minShares: minSharesCreate
            };
        },
        methods: {
            cancel(){
                this.$store.state.showForm=false;
            },
            delay(time) {
                return new Promise(resolve => setTimeout(resolve, time));
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
            validateResolutionDate(){
                const resolutionDate = dateToUnix(this.marketParams.resolutionDate);
                const wageDeadline = dateToUnix(this.marketParams.wageDeadline);
                if(!this.marketParams.resolutionDate){
                    this.formStatus.resolutionDate.correct = false;
                    this.formStatus.resolutionDate.message = 'select resolution date';
                }else if(resolutionDate < wageDeadline){
                    this.formStatus.resolutionDate.correct = false;
                    this.formStatus.resolutionDate.message = 'resolution must be >= wage deadline';
                }else{
                    this.formStatus.resolutionDate.correct = true;
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
                    this.formStatus.resolutionDate.correct &
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
            validateInputs(){
                //validate inputs
                this.validateStrikePrice();
                this.validateMoneyWaged();
                this.validateSharesOwned();
                this.validateWageDeadline();
                this.validateResolutionDate();

                //get form status
                return this.getFormStatus();
            },
            setTransactionStatus(status, message){
                this.transaction.message = message;
                this.transaction.status = status;
            },
            getDescription(strikePrice, assetPair, resolutionDate){
                return `will ${assetPair} exceed ${strikePrice} by ${resolutionDate}`
                        .toLocaleLowerCase()
            },
            getCreateMarketParams(){
                return {
                    _sharesOwned: ethToWei(this.marketParams.sharesOwned),
                    _moneyWaged: ethToWei(this.marketParams.moneyWaged),
                    _priceFeedAddress: this.marketParams.asset.get('priceFeed'),
                    _strikePrice: ethToWei([this.marketParams.strikePrice])[0],
                    _resolutionDate: dateToUnix(this.marketParams.resolutionDate),
                    _wageDeadline: dateToUnix(this.marketParams.wageDeadline)
                }
            },
            getSaveMarketParams(){
                return {
                    marketId: this.marketParams.marketId,
                    asset: this.marketParams.asset.get('asset'),
                    strikePrice: this.marketParams.strikePrice,
                    wageDeadline: unixToDate(dateToUnix(this.marketParams.wageDeadline)),
                    resolutionDate: unixToDate(dateToUnix(this.marketParams.resolutionDate)),
                    description: this.getDescription(
                        this.marketParams.strikePrice,
                        this.marketParams.asset.get('asset'),
                        dateToStr(this.marketParams.resolutionDate)
                    ),
                    creator: this.$store.state.user.get('ethAddress'),

                }
            },
            getDepositParams(){
                return {
                    marketId: this.marketParams.marketId,
                    player: this.$store.state.user.get('ethAddress'),
                    moneyNo:  this.marketParams.moneyWaged[0],
                    moneyYes: this.marketParams.moneyWaged[1],
                    sharesNo: this.marketParams.sharesOwned[0],
                    sharesYes: this.marketParams.sharesOwned[1],
                    marketCreation: true,
                }
            },
            async createMarket(){
                //get asset
                const asset =  await this.getAsset();
                this.marketParams.asset = asset;
                
                //get form status
                const formStatus = this.validateInputs();

                if(formStatus){

                    //create market
                    const createOptions = this.getCreateMarketParams();
                    this.marketParams.marketId = await _numMarkets();

                    this.setTransactionStatus(
                        'pending',
                        'Transaction pending: wait until it is completed'
                    );
                    
                    //get transaction status
                    const creationStatus  = await _createMarket(createOptions);

                    //check if transaction is successful
                    if(creationStatus){

                        //save market
                        this.setTransactionStatus('success', 'Transaction successful: market is created');
                        const saveMarketParams = this.getSaveMarketParams();
                        await Moralis.Cloud.run(
                            'saveMarket', {
                                marketId: this.marketParams.marketId,
                                values: saveMarketParams
                            }
                        );

                        // save deposit transaction
                        const saveDepositParams = this.getDepositParams();
                        await Moralis.Cloud.run(
                            'deposit',
                            saveDepositParams
                        );


                        //delay loading
                        this
                        .delay(2000)
                        .then(
                            () => this.$router.go()
                        );

                    }else{
                        this.setTransactionStatus('fail', 'Transaction failed: try creating market again');
                    }
                }
            },
        },
    }
</script>

<style scoped>
    .create-market-window {
        display: grid;
        padding: 20px;
        width:450px;
        gap: 25px;
        background: #0e2a44;
        grid-template-rows: repeat(auto-fit, max-content);
        border-radius: 10px;
        color: #ffffff;
        font-family: 'Montserrat';
        font-size: 14px;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
    }

    .create-market-window .fa-xmark {
        position: relative;
        width: max-content;
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
        background: #16446c;
        color:#ffffff;
        border: none;
        border-radius: 5px;
    }

    .description-component .fa-solid {
        right: 5px;
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
        font-weight: 400;
    }
    .market-info-text {
        display: flex;
        align-items: center;
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
       width: 100%;
   }


   .submit-button:hover{
       background:#4377e8;
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
        gap: 88px;
        position: relative;
        left: 156px;
        margin-bottom: 10px;
        font-size: 14px;
   }

</style>