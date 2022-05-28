import { createRouter, createWebHistory} from 'vue-router'
import CreateMarketPage from '../views/CreateMarketPage.vue'
import HomePage from '../views/HomePage.vue'
import WageMoneyPage from '../views/WageMoneyPage.vue'

const routes = [
    {
        path: '/',
        component: HomePage
    },
    {
        path: '/create-market',
        component: CreateMarketPage
    },
    {
        path: '/markets/:marketId',
        component: WageMoneyPage
    }

];

const router = createRouter({
    history: createWebHistory('http://localhost:8080/'),
    routes
});

export default router;