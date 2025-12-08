import { createRouter, createWebHistory } from 'vue-router'
import CreateCampaignPage from '@/views/CreateCampaignPage.vue'
import CrowdFund from '@/components/CrowdFund.vue'
import Homepage from '@/components/Homepage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Homepage,
    },
    {
      path: '/create',
      name: 'createcampaign',
      component: CreateCampaignPage,
    },
    {
      path: '/crowdfund',
      name: 'crowdfund',
      component: CrowdFund,
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/AboutView.vue'),
    },
  ],
})

export default router
