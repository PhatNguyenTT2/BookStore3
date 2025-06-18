// src/data/user.js
import { api } from '@/plugins/axios'
import { defineStore } from 'pinia'
import { computed, ref } from 'vue'

// Pinia store để quản lý người dùng
export const useUser = defineStore('user', () => {
  const users = ref([])
  const searchQuery = ref('')
  const loading = ref(false)
  const error = ref(null)
  const currentUser = ref(null)

  // Computed list đã lọc theo searchQuery
  const filteredUsers = computed(() => {
    const q = searchQuery.value.toLowerCase()
    return users.value.filter(u => {
      const fullName = `${u.firstName ?? ''} ${u.lastName ?? ''}`.trim().toLowerCase()
      return (
        fullName.includes(q) ||
        (u.email ?? '').toLowerCase().includes(q) ||
        u.username.toLowerCase().includes(q)
      )
    })
  })

  /**
   * fetchUsers: Gọi API GET /users với token hợp lệ
   */
  async function fetchUsers() {
    loading.value = true
    error.value = null
    try {
      console.log('[UserStore] fetchUsers called')
      const resp = await api.get('/users')
      const list = Array.isArray(resp.data)
        ? resp.data
        : Array.isArray(resp.data.result)
          ? resp.data.result
          : []

      console.log('[UserStore] Received', list.length, 'users from API')
      users.value = list.map(u => ({
        id: u.id,
        firstName: u.firstName,
        lastName: u.lastName,
        name: `${u.firstName ?? ''} ${u.lastName ?? ''}`.trim(),
        email: u.email ?? '',
        username: u.username,
        dob: u.dob,
        phone: u.phone,
        role: u.roles?.[0]?.name ?? '',
        password: u.password ?? '',
        debtAmount: u.debtAmount,
        _raw: u
      }))
      console.log('[UserStore] Updated users.value to', users.value.length, 'users')
    } catch (e) {
      console.error('[UserStore] fetchUsers failed:',
        e.response?.status,
        e.response?.data || e.message
      )
      error.value = e
    } finally {
      loading.value = false
    }
  }

  async function addUser(userData) {
    try {
      loading.value = true
      error.value = null
      await api.post('/users', userData)
      await fetchUsers()
      return true
    } catch (e) {
      error.value = e
      return false
    } finally {
      loading.value = false
    }
  }

  function updateUser(updated) {
    const idx = users.value.findIndex(u => u.id === updated.id)
    if (idx !== -1) users.value[idx] = { ...updated }
  }

  async function updateUserAPI(userId, payload) {
    // Normalize payload.dob nếu là Date
    if (payload.dob instanceof Date) {
      const y = payload.dob.getFullYear()
      const m = String(payload.dob.getMonth() + 1).padStart(2, '0')
      const d = String(payload.dob.getDate()).padStart(2, '0')
      payload.dob = `${y}-${m}-${d}`
    }
    loading.value = true
    try {
      const { data } = await api.put(`/users/${userId}`, payload)
      await fetchUsers()
    } catch (e) {
      console.error('[UserStore] updateUser failed', e)
      throw e
    } finally {
      loading.value = false
    }
  }

  async function deleteUserAPI(userId) {
    loading.value = true; error.value = null
    try {
      console.log('[UserStore] Starting delete for user:', userId)
      console.log('[UserStore] Users before delete:', users.value.length)

      await api.delete(`/users/${userId}`)
      console.log('[UserStore] Delete API call successful')

      // Optimistic update - remove user from local array immediately
      const userIndex = users.value.findIndex(u => u.id === userId)
      if (userIndex !== -1) {
        users.value.splice(userIndex, 1)
        console.log('[UserStore] Removed user from local array. New count:', users.value.length)
      }

      // Also fetch fresh data as backup
      await fetchUsers()
      console.log('[UserStore] Users after refetch:', users.value.length)
    } catch (e) {
      console.error('[UserStore] deleteUserAPI failed:', e)
      error.value = e
      // If API call failed, refetch to ensure data consistency
      await fetchUsers()
      throw e
    } finally {
      loading.value = false
    }
  }


  return {
    users,
    searchQuery,
    filteredUsers,
    loading,
    error,
    currentUser,
    fetchUsers,
    addUser,
    updateUserAPI,
    deleteUserAPI
  }
})
