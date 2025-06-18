import { api } from '@/plugins/axios'
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useRoleStore = defineStore('role', () => {
  const roles = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchRoles() {
    loading.value = true
    error.value = null
    try {
      console.log('[RoleStore] fetchRoles called')
      const resp = await api.get('/roles')
      const roleData = resp.data?.result || resp.data || []

      roles.value = Array.isArray(roleData) ? roleData : []
      console.log('[RoleStore] Received', roles.value.length, 'roles from API')
    } catch (e) {
      console.error('[RoleStore] fetchRoles failed:', e.response?.data || e.message)
      error.value = e
      roles.value = []
    } finally {
      loading.value = false
    }
  }

  return {
    roles,
    loading,
    error,
    fetchRoles
  }
}) 