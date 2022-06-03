<template>
    <div v-if="!clicked" class="create-market-div">
        <button @click="click()" class="create-market-button" >CREATE MARKET</button>
    </div>
    <div v-if="clicked" class="flex-container">
        <div class="grid">
            <input type="text" class='long-input' required v-model='marketParams.marketName'>
            <input type="text" class='long-input' required v-model='marketParams.priceFeedAddress'/>
            <input type="number" class='long-input' required v-model='marketParams.strikePrice' />
            <input type="text" required v-model='marketParams.wageDeadline'/>
            <input type="text" required v-model='marketParams.resolutionDate' />
            <input type="number" required v-model='marketParams.sharesOwned[0]'/>
            <input type="number" required v-model='marketParams.sharesOwned[1]'/>
            <input type="number" required v-model='marketParams.moneyWaged[0]'/>
            <input type="number" required v-model='marketParams.moneyWaged[1]'/>
            <textarea class='long-input text-area' v-model='marketParams.marketDescription'></textarea>
            <button @click="createMarket" class="submit-button">create market</button>
            <button @click="close()" class="close-button">cancel</button>
        </div>
    </div>
</template>

<script>
import { _createMarket, _numMarkets} from '../contract-functions/ContractFunctions.js';
import Moralis from '../main.js'
import saveCreatedMarket from '../cloud-functions/db-functions.js';

export default {
    data() {
        return  {
                marketParams: {
                    marketName: '',
                    priceFeedAddress: '0',
                    strikePrice: 0,
                    resolutionDate: 0,
                    wageDeadline: 0,
                    sharesOwned: [0, 0],
                    moneyWaged: [0, 0],
                    marketDescr: ''

                },
                clicked : false
        };
    },
    methods: {
        click() {
            this.clicked = true;
        },
        close() {
            this.clicked = false;
        },

        async saveMarket() {
            let marketId = await _numMarkets();
            marketId = marketId.toString();
            const marketName = this.marketParams.marketName;
            const marketDescription = this.marketParams.marketDescription;
            const totalMoneyWaged = this.marketParams.moneyWaged.reduce(
                (acc, curr) => {return acc + curr;}
            );

            try{
                await saveCreatedMarket(
                    {
                        marketId,
                        marketName,
                        marketDescription,
                        totalMoneyWaged
                    }
                );
            } catch(error){
                console.error(error)
            }
        },
        async createMarket() {
            const params = {
                _sharesOwned: this.marketParams.sharesOwned,
                _moneyWaged: this.marketParams.moneyWaged,
                _priceFeedAddress: this.marketParams.priceFeedAddress,
                _strikePrice: Moralis.Units.ETH(`${this.marketParams.strikePrice}`),
                _resolutionDate: this.dateToUnix(this.marketParams.resolutionDate),
                _wageDeadline: this.dateToUnix(this.marketParams.wageDeadline),
            };
            try{
                await this.saveMarket();
                await _createMarket(params);
            } catch(error){
                console.log(error);
            }
        },
        dateToUnix(dateStr){
            const date = new Date(dateStr);
            console.log(date);
            const unixTimestamp = Math.floor(date.getTime() / 1000) + 43200;
            console.log(unixTimestamp);
            return unixTimestamp;
        }
    }
}
</script>

<style scoped>

    .flex-container {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .grid {
        display: grid;
        row-gap: 10px;
        column-gap: 10px;
        grid-template-columns: repeat(2, minmax(120px, 150px));
        grid-template-rows: repeat(9, 1fr);
        background-color: #122d46;
        box-shadow: 1px 1px 8px #121212;
        border: none;
        border-radius: 5px;
        padding: 15px;
    }

    .long-input {
        grid-column-start: 1;
        grid-column-end: 3;
    }

    .text-area {
        grid-row-start: 7;
        grid-row-end: 9;
    }

    .submit-button {
        grid-column-start: 2;
        grid-column-end: 3;
        border: none;
        border-radius: 15px;
        background-color: #2968a7;
        color:#eeeeee;
        box-shadow: 1px 1px 8px #121212;
        font-family: sans-serif;
    }
    .submit-button:hover{
        background-color: #1f5082;
    }

    .close-button {
        grid-column-start: 1;
        grid-column-end: 2;
        grid-row-start: 9;
        border: 1.5px solid;
        border-color: #c6284d8a;
        border-radius: 15px;
        background-color: #212121;
        color:#eeeeee;
        box-shadow: 1px 1px 8px #121212;
        font-family: sans-serif;
    }

    .close-button:hover {
        background-color: #c6284d8a;
    }

    .create-market-div {
        display: flex;
        height: 70vh;
        justify-content: center;
        align-items: center;
    }

    .create-market-button{
        border: none;
        border-radius: 5px;
        border: solid 2px;
        border-color: #57c080dc;
        background-color: #0e2438;
        color:#cecece;
        font-size: 15px;
        padding: 20px;
        box-shadow: 1px 1px 8px #121212;
        font-family: sans-serif;
    }
    .create-market-button:hover{
        background-color: #35794fdc;
    }
</style>