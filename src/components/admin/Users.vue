<script setup>
import { useUser } from '@/data/user'
import { useRoleStore } from '@/data/roles'
import { ref, onMounted, computed } from 'vue'
import { storeToRefs } from 'pinia'

import TitleText from './texts/TitleText.vue'
import SearchFrame from '@/components/admin/frames/SearchFrame.vue'
import UserTable from '@/components/admin/tables/UserTable.vue'
import UserDetail from '@/components/admin/CRUDforms/UserDetail.vue'
import EditUser from '@/components/admin/CRUDforms/EditUser.vue'
import AddUser from '@/components/admin/CRUDforms/AddUser.vue'

import ButtonCRUD from './buttons/ButtonCRUD.vue'
import ButtonText from './texts/ButtonText.vue'

const userStore = useUser()
const roleStore = useRoleStore()

// Use storeToRefs to maintain reactivity when destructuring
const { users } = storeToRefs(userStore)

const searchQuery = ref('')
const selectedUser = ref(null)
const editingUser = ref(null)
const addingUser = ref(false)
const selectedRoles = ref([])

// Computed filtered users based on search and roles
const filteredUsers = computed(() => {
  let filtered = users.value || []

  // Filter by search query
  const q = searchQuery.value.toLowerCase()
  if (q) {
    filtered = filtered.filter(user => {
      const fullName = `${user.firstName ?? ''} ${user.lastName ?? ''}`.trim().toLowerCase()
      return (
        fullName.includes(q) ||
        (user.email ?? '').toLowerCase().includes(q) ||
        user.username.toLowerCase().includes(q) ||
        user.id.toString().includes(q)
      )
    })
  }

  // Filter by roles
  if (selectedRoles.value.length) {
    filtered = filtered.filter(user => {
      return selectedRoles.value.some(selectedRole =>
        user.roleNames.includes(selectedRole)
      )
    })
  }

  return filtered
})

// Role options for multiselect
const roleOptions = computed(() => {
  return roleStore.roles.map(role => role.name)
})

// load danh sách khi mount
onMounted(() => {
  userStore.fetchUsers()
  roleStore.fetchRoles()
})

// VIEW
function handleViewUser(user) {
  selectedUser.value = user
}
function closeDetail() {
  selectedUser.value = null
}

// ADD
function handleAddUser() {
  addingUser.value = true
}
function closeAddUser() {
  addingUser.value = false
}
function addUser(newUser) {
  // ... gọi API tạo user ở đây nếu cần
  addingUser.value = false
}

// EDIT
function handleEditUser(user) {
  editingUser.value = { ...user }
}
function closeEdit() {
  editingUser.value = null
}
async function handleUpdateUser(payload) {
  try {
    await userStore.updateUserAPI(payload.id, payload)
    editingUser.value = null
  } catch (e) {
    console.error('Cập nhật user thất bại', e.response?.data || e.message)
  }
}

// DELETE
async function handleDeleteUser(userId) {
  try {
    console.log('[Users.vue] handleDeleteUser called for:', userId)
    await userStore.deleteUserAPI(userId)
    console.log('[Users.vue] deleteUserAPI completed successfully')
  } catch (e) {
    console.error('Xoá user thất bại', e.response?.data || e.message)
  }
}
</script>

<template>
  <div style="overflow-y: auto;">
    <!-- ADD -->
    <AddUser v-if="addingUser" @close="closeAddUser" @add-user="addUser" class="user-detail-full" />

    <!-- TABLE -->
    <div v-else-if="!selectedUser && !editingUser" class="content">
      <div class="top-bar">
        <TitleText class="left">
          <template #text>User Management</template>
        </TitleText>
        <div class="center">
          <v-select v-model="selectedRoles" :items="roleOptions"
            :label="selectedRoles.length ? `${selectedRoles.length} roles selected` : 'Filter by Roles'" multiple
            clearable variant="outlined" density="compact" class="role-filter" :loading="roleStore.loading"
            hide-details>
            <template #selection></template>
          </v-select>
        </div>
        <SearchFrame v-model="searchQuery" class="right" />
      </div>

      <UserTable :filteredItems="filteredUsers" @view-user="handleViewUser" @edit-user="handleEditUser"
        @delete-user="handleDeleteUser" />

      <ButtonCRUD @click="handleAddUser">
        <template #btn-text>
          <ButtonText><template #text>ADD USER</template></ButtonText>
        </template>
      </ButtonCRUD>
    </div>

    <!-- DETAIL -->
    <UserDetail v-else-if="selectedUser && !editingUser" :user="selectedUser" @close="closeDetail"
      class="user-detail-full" />

    <!-- EDIT -->
    <EditUser v-else-if="editingUser" :user="editingUser" @close="closeEdit" @update-user="handleUpdateUser"
      class="user-detail-full" />
  </div>
</template>

<style scoped>
.content {
  width: 100%;
  height: 100%;
  padding: 20px;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  gap: 20px;
}

.left {
  flex: 1;
}

.center {
  flex-shrink: 0;
  display: flex;
  gap: 12px;
}

.right {
  flex-shrink: 0;
}

.role-filter {
  width: 220px;
  font-family: Montserrat;
  font-size: 14px;
}

::v-deep(.role-filter .v-field-label) {
  color: var(--vt-c-second-bg-color) !important;
  font-weight: 500;
}

::v-deep(.role-filter .v-field__input) {
  color: var(--vt-c-second-bg-color) !important;
  font-family: Montserrat;
  font-size: 14px;
}

::v-deep(.role-filter .v-field__outline) {
  color: var(--vt-c-second-bg-color) !important;
}

::v-deep(.role-filter .v-icon) {
  color: var(--vt-c-second-bg-color) !important;
}
</style>
