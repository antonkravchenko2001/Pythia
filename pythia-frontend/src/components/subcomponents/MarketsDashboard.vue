<template>
    <div >
        <div>
            <input class='search-bar' placeholder='Search Markets' v-model='searchInput' @keyup="findMarkets()"/>
            <i class="fa fa-search"></i>
        </div>
        <div class="markets-display">
            <div class="market-info" v-for="market in markets" :key="market">
                <div class="price-info">
                    <div>{{market.get('asset')}}</div>
                    <div>{{market.get('strikePrice')}}</div>
                </div>
                <div>
                    <div>{{market.get('description')}}</div>
                </div>
                <div class="volume-info">
                    <div style="padding-right:10px">Volume:</div>
                    <div>{{market.get('volume')}} Dai</div> 
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
            }
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
        font-weight: 350;
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
        font-weight: 250;
        font-size: 13px;
        left: 10px;
    }

    .markets-display {
        display: grid;
        gap: 15px;
        grid-template-columns: repeat(3, 1fr);
        grid-template-rows: repeat(auto, 1fr);
    }

    .market-info{
        display: grid;
        grid-template-rows: 1fr 2fr 1fr;
        gap: 10px;
        background-color: #0c1827;
        padding:10px;
        border: #8925bc 1.2px solid;
        border-radius: 10px;
        box-shadow: 1px 1px 8px #121212;
        color:#cecece;
        font-size: 12px;
        font-family: 'Montserrat';
        font-weight: 350;
    }

    .market-info:hover{
        box-shadow: 1px 1px 8px #121212;
    }

    .price-info {
        display: flex;
        justify-content: space-between;
    }
    .volume-info {
        display: flex;
        justify-content: flex-start;
    }
</style>