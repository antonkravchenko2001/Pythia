import { createRouter, createWebHistory} from 'vue-router'
import HomePage from '../views/HomePage.vue'
import MarketPage from '../views/MarketPage.vue'
import AboutPage from '../views/AboutPage.vue'
import LeaderBoard from '../views/LeaderBoard.vue'
import AssetsPage from '../views/AssetsPage.vue'

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
        path: '/user-guide',
        name: 'user-guide',
        component: AboutPage
    },
    {
        path: '/leaderboard',
        name: 'leaderboard',
        component: LeaderBoard
    },
    {
        path: '/assets',
        name: 'assets',
        component: AssetsPage
    }

];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;