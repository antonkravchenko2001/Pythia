import { createRouter, createWebHashHistory} from 'vue-router'
import HomePage from '../views/HomePage.vue'
import MarketPage from '../views/MarketPage.vue'
import LeaderBoard from '../views/LeaderBoard.vue'

const routes = [
    {
        path: '/',
        name: 'home',
        component: HomePage
    },
    {
        path: '/markets/:marketId',
        name: 'markets',
        component: MarketPage
    },
    {
        path: '/leaderboard',
        name: 'leaderboard',
        component: LeaderBoard
    },

];

const router = createRouter({
    history: createWebHashHistory(),
    routes
});

export default router;