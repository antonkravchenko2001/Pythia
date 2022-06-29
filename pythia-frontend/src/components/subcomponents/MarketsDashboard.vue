<template>
    <div >
        <div class="title">
            Available Markets
        </div>
        <div>
            <input class='search-bar' placeholder='Search Markets' v-model='searchInput' @keyup="findMarkets()"/>
            <i class="fa fa-search"></i>
        </div>
        <div class="markets-display">
            <div class="market-info unselectable" v-for="market in markets" :key="market" @click="$router.push(`/markets/${market.get('marketId')}`)">
                <div class="item-container">
                    <div class="item-type">
                        <div>{{market.get('asset').toUpperCase()}}</div>
                    </div>
                    <div class="item-container">
                        <div style="padding-right: 5px" class="item-type">Strike Price: </div>
                        <div class="item-val">{{market.get('strikePrice')}}</div>
                    </div>
                </div>
                <div>
                    <div class="item-val">{{market.get('description')}}</div>
                </div>
                <div class="item-container">
                    <div style="display: flex">
                        <div class="item-type">Volume: </div>
                        <div class="item-val">{{Math.round(market.get('volume') * 100) / 100}} Dai</div> 
                    </div>
                    <div>
                        <div v-if="market.get('resolved')" style="color:#4decc9c2">Resolved</div>
                        <div v-if="!market.get('resolved')" style="color:#ec4d4dc2">Unresolved</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Moralis from '../../main.js'
    export default {
        data(){
            return {
                searchInput: '',
                markets: {}
            }
        },
        methods: {
            async findMarkets(){
                if(this.searchInput == ''){
                    this.markets = await Moralis.Cloud.run('getMarkets')
                } else {
                    this.markets = await Moralis.Cloud.run(
                        'getMarkets', 
                        {
                            filters: {
                                description: this.searchInput
                            }
                        }
                    )
                }
            },
        },
        async created(){
            const markets = await Moralis.Cloud.run('getMarkets');
            this.markets = markets;
        }
    }
</script>

<style scoped>

    .search-bar-container {
        display: flex;
        justify-content: center;
    }

    .title{
        font-family: 'Montserrat';
        font-weight: 500;
        font-size: 20px;
        color: #ffffff;
        margin-bottom: 15px;
    }
    .search-bar[data-v-5510c766] {
        width: calc(100% - 40px);
        background-color: #091420;
        border: none;
        max-height: 50px;
        padding-top: 10px;
        padding-left: 30px;
        padding-right: 10px;
        padding-bottom: 10px;
        border-radius: 5px;
        color: #cecece;
        font-family: 'Montserrat';
        box-shadow: none;
    }

    .search-bar:focus{
        outline: none;
    }

    .search-bar::placeholder{
        font-family: 'Montserrat';
        font-weight: 250;
        color:#8c8c8c;
    }

    .fa-search[data-v-5510c766] {
        bottom: 26.5px;
        color: #8c8c8c;
        position: relative;
        font-size: 12px;
        left: 10px;
    }

    .markets-display {
        display: grid;
        gap: 15px;
        padding-bottom: 10px;
        grid-template-columns: repeat(3, 1fr);
        grid-template-rows: repeat(auto, 1fr);
    }

    .market-info{
        display: grid;
        grid-template-rows: 1fr 3fr 1fr;
        gap: 10px;
        background-color: #0c1827;
        padding:10px;
        border: #8925bc 1.2px solid;
        border-radius: 10px;
        box-shadow: 1px 1px 8px #121212;
        color:#ffffff;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 350;
        cursor: pointer;
    }

    .market-info:hover{
        background-color: #102135;
        box-shadow: none;
    }

    .market-info:hover{
        box-shadow: 1px 1px 8px #121212;
    }

    .item-container{
        display: flex;
        justify-content: space-between;
    }

    .unselectable {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
    user-select: none;
    }

    .item-type{
        font-weight: 200;
        padding-right: 5px;
    }
    
    .item-val{
        font-weight: 300;
        padding-right: 5px;
    }
</style>