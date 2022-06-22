import { createRouter, createWebHistory} from 'vue-router'
import HomePage from '../views/HomePage.vue'
import MarketPage from '../views/MarketPage.vue'
import AboutPage from '../views/AboutPage.vue'

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
        path: '/guide',
        name: 'guide',
        component: AboutPage
    },

];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;