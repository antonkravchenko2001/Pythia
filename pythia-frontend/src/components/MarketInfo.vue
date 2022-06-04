<template>
    <div class="market-info">
        <div class="info-container">
            <div class="info-container">
                <div class="item-name">Asset</div>
                <div class="item-val">ETH / USD</div>
            </div>
            <div class="info-container">
                <div class="item-name">Strike Price</div>
                <div class="item-val">2000</div>
            </div>
        </div>
        <div class="info-container">
            <div class="info-container">
                <div class="item-name">Wage Deadline</div>
                <div class="item-val">01/02/2022</div>
            </div>
            <div class="info-container">
                <div class="item-name">Resolve Date</div>
                <div class="item-val">03/02/2022</div>
            </div>
        </div>
        <div class='item-val'>
            eTH VS USD Market
        </div>
        <div class="field-with-buttons">
            <div class="button-container">
                <button class="market-info-button">Market Stats</button>
                <button class="portfolio-info-button">My Portfolio</button>
            </div>
            <div class="item-val market-stats">
                <div>
                </div>
                <div class="market-info-text">No</div>
                <div class="market-info-text">Yes</div>
                <div class="market-info-text">Money Waged</div>
                <div class="market-stats-component">
                </div>
                <div class="market-stats-component">
                </div>
                <div class="market-info-text">Shares Owned</div>
                <div class="market-stats-component">
                </div>
                <div class="market-stats-component">
                </div>
            </div>
        </div>
    </div>
</template>


<style scoped>

    .market-info {
        display: grid;
        gap: 20px;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 1fr 2fr 6fr;

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
    }
    .item-val {
        border: none;
        border-radius: 5px;
        padding: 5px;
        background-color: #122D46;
        border-radius: 5px;
        color: #cecece;
        font-size: 11px;
        font-weight: 300;
    }

    .colored-border {
        border: 1.5px solid;
        border-color: #cecece
    }

    .field-with-buttons {
        display: grid;
        grid-template-columns: 1fr;
        grid-template-rows: 1fr 6fr;

    }

    .button-container {
        display: flex;
        justify-content: flex-end;
    }

    .market-info-button {
        background-color: #0b1723;
        margin-bottom: 1.5px;
        border: none;
        color: #cecece;
        font-size: 13px;
    }

    .market-info-button:active {
        color: #57D9A3;
        border-bottom: 1.5px solid;
        border-color: #57D9A3;
        margin-bottom: 0px;
        background-color: #122D46;
    }

    .portfolio-info-button {
        background-color: #0b1723;
         margin-bottom: 1.5px;
        border: none;
        color: #cecece;
        font-size: 13px;

    }

    .portfolio-info-button:active {
        color: #79e2f2;
        border-bottom: 1.5px solid;
        border-color: #79e2f2;
        background-color: #122D46;
        margin-bottom: 0px;
    }

    .market-stats {
       display: grid;
       row-gap: 10px;
       column-gap: 10px;
       grid-template-columns: 2fr 2fr 2fr;
       grid-template-rows: 0.3fr 1fr 1fr;
       padding-left: 20px;
       padding-right: 20px;
       padding-bottom: 10px;
       padding-top: 10px;
    }

    .market-stats-component {
        background-color: #243b53;
        border: 1.2px solid;
        border-color: #79e2f2;
    }
    .market-info-text {
        font-size: 12.5px
    }
</style>