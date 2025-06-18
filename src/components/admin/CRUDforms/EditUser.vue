<script setup>
import { useUser } from '@/data/user'
import { useRoleStore } from '@/data/roles'
import { reactive, computed, onMounted, ref } from 'vue'
import ButtonCRUD from '../buttons/ButtonCRUD.vue'
import DatePickerFrame from '../frames/DatePickerFrame.vue'
import FrameRU from '../frames/FrameRU.vue'
import ButtonText from '../texts/ButtonText.vue'
import TitleText from '../texts/TitleText.vue'
import CRUDMainForm from './CRUDMainForm.vue'

const props = defineProps(['user'])
const emit = defineEmits(['close', 'update-user'])

const editedUser = reactive({
  ...props.user,
  selectedRole: props.user.roleNames && props.user.roleNames.length > 0 ? props.user.roleNames[0] : ''
})

const userStore = useUser()
const roleStore = useRoleStore()
const isRoleDropdownOpen = ref(false)

// Role options for single select
const roleOptions = computed(() => {
  return roleStore.roles.map(role => role.name)
})

onMounted(() => {
  roleStore.fetchRoles()
})

const handleEdit = async () => {
  try {
    // Gọi API update, trong đó có fetchUsers() để reload lại danh sách
    await userStore.updateUserAPI(editedUser.id, {
      firstName: editedUser.firstName,
      lastName: editedUser.lastName,
      dob: editedUser.dob,
      phone: editedUser.phone,
      roles: editedUser.selectedRole ? [editedUser.selectedRole] : []
    })
    // Nếu updateUserAPI chưa fetch lại thì bạn có thể gọi thêm:
    // await userStore.fetchUsers()
  } catch (e) {
    console.error('Update failed', e)
  } finally {
    emit('close')
  }
}

const selectRole = (role) => {
  editedUser.selectedRole = role
  isRoleDropdownOpen.value = false
}

const toggleRoleDropdown = () => {
  isRoleDropdownOpen.value = !isRoleDropdownOpen.value
}
</script>

<template>
  <div class="detail-wrapper">
    <CRUDMainForm title="Edit User" :data="editedUser" @close="$emit('close')">
      <template #title>
        <TitleText>
          <template #text>
            Edit User
          </template>
        </TitleText>
      </template>

      <template #content>
        <div class="frame-wrapper">
          <FrameRU v-model="editedUser.firstName" placeholder="First Name" />
          <FrameRU v-model="editedUser.lastName" placeholder="Last Name" />
          <DatePickerFrame v-model="editedUser.dob" placeholder="DOB" />
          <FrameRU v-model="editedUser.phone" placeholder="Phone" />

          <!-- Custom Role Selector matching FrameRU style -->
          <div class="role-wrapper">
            <div class="frame role-frame" :class="{ 'focused': isRoleDropdownOpen || editedUser.selectedRole }" @click="toggleRoleDropdown">
              <label class="floating-label" :class="{ 'active': isRoleDropdownOpen || editedUser.selectedRole }">
                Role
              </label>
              <div class="role-display">
                {{ editedUser.selectedRole || 'Select Role' }}
              </div>
              <div class="dropdown-icon" :class="{ 'open': isRoleDropdownOpen }">▼</div>
            </div>
            
            <!-- Dropdown options -->
            <div v-if="isRoleDropdownOpen" class="role-dropdown">
              <div 
                v-for="role in roleOptions" 
                :key="role"
                class="role-option"
                :class="{ 'selected': editedUser.selectedRole === role }"
                @click="selectRole(role)"
              >
                {{ role }}
              </div>
            </div>
          </div>

          <ButtonCRUD @click="handleEdit">
            <template #btn-text>
              <ButtonText>
                <template #text>EDIT</template>
              </ButtonText>
            </template>
          </ButtonCRUD>
        </div>
      </template>
    </CRUDMainForm>
  </div>
</template>

<style scoped>
.detail-wrapper {
  color: var(--vt-c-main-bg-color);
  width: 100%;
  height: 100%;
  padding: 12px;
  font-family: Montserrat;
}

.frame-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 18px;
  padding: 5vh 0;
}

/* Role selector styling to match FrameRU */
.role-wrapper {
  position: relative;
  width: 441px;
}

.role-frame {
  position: relative;
  display: flex;
  width: 100%;
  padding: 12px 16px;
  align-items: center;
  gap: 8px;
  border-radius: 12px;
  border: 1px solid #3D3E3E;
  background-color: var(--vt-c-main-bg-color);
  transition: border-color 0.3s ease;
  cursor: pointer;
  justify-content: space-between;
}

.role-frame.focused {
  border-color: var(--vt-c-second-bg-color);
}

.floating-label {
  position: absolute;
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 15px;
  font-family: Montserrat, sans-serif;
  color: #999;
  pointer-events: none;
  transition: all 0.3s ease;
  background-color: var(--vt-c-main-bg-color);
  padding: 0 4px;
}

.floating-label.active {
  top: 0;
  transform: translateY(-50%);
  font-size: 12px;
  color: var(--vt-c-second-bg-color);
  font-weight: 500;
}

.role-display {
  flex: 1;
  font-size: 15px;
  font-family: Montserrat, sans-serif;
  color: #333;
  padding-top: 8px;
}

.dropdown-icon {
  font-size: 12px;
  color: #999;
  transition: transform 0.3s ease;
}

.dropdown-icon.open {
  transform: rotate(180deg);
}

.role-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  z-index: 1000;
  background-color: var(--vt-c-main-bg-color);
  border: 1px solid #3D3E3E;
  border-radius: 12px;
  margin-top: 4px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  max-height: 200px;
  overflow-y: auto;
}

.role-option {
  padding: 12px 16px;
  font-size: 15px;
  font-family: Montserrat, sans-serif;
  color: #333;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.role-option:hover {
  background-color: #f5f5f5;
}

.role-option.selected {
  background-color: var(--vt-c-second-bg-color);
  color: white;
}

.role-option:first-child {
  border-top-left-radius: 12px;
  border-top-right-radius: 12px;
}

.role-option:last-child {
  border-bottom-left-radius: 12px;
  border-bottom-right-radius: 12px;
}
</style>
