import { createRouter, createWebHistory} from 'vue-router'
import HomePage from '../views/HomePage.vue'
import WageMoneyPage from '../views/WageMoneyPage.vue'

const routes = [
    {
        path: '/',
        component: HomePage
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