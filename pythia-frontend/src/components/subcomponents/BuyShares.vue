<template>
    <div class="buy-shares-outer">
        <div class="buy-withdraw-buttons">
            <button class="buy-button">Buy</button>
            <button class="withdraw-button">Withdraw</button>
        </div>
        <div class="buy-shares-inner">
            <div class="share-type">No</div>
            <div class="share-type">Yes</div>
            <div></div><div></div>
            <div>
            </div>
            <div>
            </div>
            <div class="grid-spec"></div>
            <div></div><div></div>
        </div>
    </div>
</template>

<style scoped>
    .buy-shares-outer {
        display: grid;
        grid-template-rows: 1fr 8.5fr;
        color:#cecece;
    }

    .buy-shares-inner {
        display: grid;
        gap: 15px;
        grid-template-rows: 0.8fr 1.5fr 1.2fr 1fr 1fr;
        grid-template-columns: repeat(2,1fr);
        background-color: #122D46;
        padding:10px;
    }
    .buy-withdraw-buttons {
        display: flex;
        justify-content: flex-end;
    }

    .withdraw-button {
        background-color: #0b1723;
        margin-bottom: 1.5px;
        border: none;
        color: #cecece;
        font-size: 13px;
    }

    .withdraw-button:active {
        color: #57D9A3;
        border-bottom: 1.5px solid;
        border-color: #57D9A3;
        margin-bottom: 0px;
        background-color: #122D46;
    }

    .buy-button {
        background-color: #0b1723;
         margin-bottom: 1.5px;
        border: none;
        color: #cecece;
        font-size: 13px;

    }

    .buy-button:active {
        color: #79e2f2;
        border-bottom: 1.5px solid;
        border-color: #79e2f2;
        background-color: #122D46;
        margin-bottom: 0px;
    }

    .buy-info-container {
        display: flex;
        justify-content: space-between;
    }

    .grid-spec {
        grid-column-start: 1;
        grid-column-end: 3;
    }

    .buy-info {
        font-weight: 300;
        font-size: 11px;
        border: 1.2px solid;
        border-color: #79e2f2;
    }

    .buy-form{
        display: grid;
        justify-content: center;
        align-items: center;
        background-color: #243b53;
        border: 1.2px solid;
        border-color: #79e2f2;
        width: 100
    }

    .share-type{
        font-size: 13px;
    }


</style>