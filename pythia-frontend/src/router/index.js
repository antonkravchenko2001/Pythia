import { createRouter, createWebHistory} from 'vue-router'
import HomePage from '../views/HomePage.vue'
import WageMoneyPage from '../views/WageMoneyPage.vue'
import AboutPage from '../views/AboutPage'

const routes = [
    {
        path: '/',
        name: 'home',
        component: HomePage
    },
    {
        path: '/markets/:marketId',
        name: 'markets',
        component: WageMoneyPage
    },
    {
        path: '/about',
        name: 'about',
        component: AboutPage
    }

];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;