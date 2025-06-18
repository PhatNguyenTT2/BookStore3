<script setup>
import { computed, ref, watch } from 'vue'
import { useBook } from '@/data/book'
import { storeToRefs } from 'pinia'
import EditIcon from '@/assets/icons-vue/edit.vue'
import ViewIcon from '@/assets/icons-vue/receipt.vue'
import DeleteIcon from '@/assets/icons-vue/trash.vue'

const bookStore = useBook()
// Use storeToRefs to maintain reactivity when destructuring
const { items, fullBookDetails } = storeToRefs(bookStore)

const props = defineProps({
  showActions: { type: Boolean, default: true },
  showQuantity: { type: Boolean, default: true },
  showPrice: { type: Boolean, default: true },
  filteredItems: Array
})

// Debug: Watch for changes in items
watch(items, (newBooks, oldBooks) => {
  console.log('[BookTable] items changed from', oldBooks?.length, 'to', newBooks?.length)
}, { immediate: true })

// Debug: Watch for changes in filtered items from parent
watch(() => props.filteredItems, (newFiltered, oldFiltered) => {
  console.log('[BookTable] filteredItems from parent changed from', oldFiltered?.length, 'to', newFiltered?.length)
}, { immediate: true })

const emit = defineEmits(['view-book', 'edit-book', 'delete-book'])

// Use filtered items from parent if provided, otherwise use all items
const displayItems = computed(() => props.filteredItems || items.value)

const dialog = ref(false)
const errorDialog = ref(false)
const bookToDeleteId = ref(null)
const bookToDeleteTitle = ref('')

function openDelete(item) {
  // Use bookId (integer) instead of id (string) for backend compatibility
  bookToDeleteId.value = item.bookId || item.id
  bookToDeleteTitle.value = item.title
  dialog.value = true
  console.log('Opening delete dialog for book:', item.bookId || item.id, item.title)
}

function confirmDelete() {
  if (bookToDeleteId.value) {
    console.log('Confirming delete for book ID:', bookToDeleteId.value)
    emit('delete-book', bookToDeleteId.value)
    dialog.value = false
    bookToDeleteId.value = null
    bookToDeleteTitle.value = ''
  }
}

function showDeleteError() {
  errorDialog.value = true
}

// Expose function to parent component
defineExpose({
  showDeleteError
})

const rawHeaders = [
  { title: 'ID', key: 'id' },
  { title: 'Title', key: 'title' },
  { title: 'Authors', key: 'authors' },
  { title: 'Categories', key: 'categories' },
  { title: 'Quantity', key: 'quantity' },
  { title: 'Price', key: 'import_price' },
  { title: 'Action', key: 'action', sortable: false }
]

const headers = computed(() => rawHeaders.filter(h => {
  if (h.key === 'action' && !props.showActions) return false
  if (h.key === 'quantity' && !props.showQuantity) return false
  if (h.key === 'import_price' && !props.showPrice) return false
  return true
}))
</script>

<template>
  <div class="table-wrapper">
    <v-data-table :headers="headers" :items="displayItems" item-value="id" :items-per-page="-1" fixed-header
      height="66vh" class="elevation-1" hide-default-footer>
      <template #item.action="{ item }">
        <div class="action-icons">
          <v-tooltip text="View" location="top">
            <template #activator="{ props: tooltip }">
              <div v-bind="tooltip" @click="emit('view-book', item.id)" style="cursor: pointer;">
                <ViewIcon />
              </div>
            </template>
          </v-tooltip>

          <v-tooltip text="Edit" location="top">
            <template #activator="{ props: tooltip }">
              <div v-bind="tooltip" @click="emit('edit-book', item.id)" style="cursor: pointer;">
                <EditIcon />
              </div>
            </template>
          </v-tooltip>

          <v-tooltip text="Delete" location="top">
            <template #activator="{ props: tooltip }">
              <div v-bind="tooltip" @click="openDelete(item)" style="cursor: pointer;">
                <DeleteIcon />
              </div>
            </template>
          </v-tooltip>
        </div>
      </template>

      <template #item.categories="{ item }">
        <span>{{ fullBookDetails[item.id]?.categories?.join(', ') }}</span>
      </template>

      <template #item.authors="{ item }">
        <span>{{ fullBookDetails[item.id]?.authors?.join(', ') }}</span>
      </template>
    </v-data-table>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="dialog" width="400" class="delete-dialog" persistent>
      <v-card>
        <v-card-title class="text-h6">Xác nhận xóa</v-card-title>
        <v-card-text>
          Bạn có chắc chắn muốn xóa sách
          <strong>{{ bookToDeleteTitle }}</strong>?
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="grey" variant="text" @click="dialog = false">Hủy</v-btn>
          <v-btn color="var(--vt-c-second-bg-color)" variant="tonal" @click="confirmDelete">Xóa</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Delete Error Dialog -->
    <v-dialog v-model="errorDialog" width="400" class="delete-dialog" persistent>
      <v-card>
        <v-card-title class="text-h6">Không thể xóa</v-card-title>
        <v-card-text>
          Không thể xóa sách này vì vẫn còn ràng buộc với các dữ liệu khác trong hệ thống
          (ví dụ: phiếu nhập, hóa đơn bán, báo cáo tồn kho...).
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="var(--vt-c-second-bg-color)" variant="tonal" @click="errorDialog = false">Đóng</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<style scoped>
.table-wrapper {
  /* Remove scroll from wrapper, let v-data-table handle it */
}

.v-data-table {
  background-color: var(--vt-c-main-bg-color);
  border-radius: 12px;
  padding: 12px;
  font-family: Montserrat;
  font-size: 15px;
  color: var(--vt-c-second-bg-color);
}

::v-deep(.v-data-table__th) {
  background-color: var(--vt-c-main-bg-color) !important;
  color: var(--vt-c-second-bg-color) !important;
  font-weight: 600 !important;
}

::v-deep(.v-data-table-header__sort-btn) {
  color: var(--vt-c-second-bg-color) !important;
}

.action-icons {
  display: flex;
  gap: 12px;
}

.delete-dialog .v-card {
  width: 25vw;
  border-radius: 20px;
  background: var(--vt-c-main-bg-color);
}

.delete-dialog .v-card-title {
  color: var(--vt-c-second-bg-color);
  font-weight: bold;
  text-align: center;
}

.delete-dialog .v-card-text {
  font-size: 16px;
  color: var(--vt-c-second-bg-color);
}
</style>
