<script setup>
import { useBook } from '@/data/book'
import { useCategoryStore } from '@/data/categories'
import { useAuthorStore } from '@/data/authors'
import { computed, onMounted, ref } from 'vue'
import { storeToRefs } from 'pinia'
import ButtonCRUD from '@/components/admin/buttons/ButtonCRUD.vue'
import AddBook from '@/components/admin/CRUDforms/AddBook.vue'
import BookDetail from '@/components/admin/CRUDforms/BookDetail.vue'
import EditBook from '@/components/admin/CRUDforms/EditBook.vue'
import SearchFrame from '@/components/admin/frames/SearchFrame.vue'
import BookTable from '@/components/admin/tables/BookTable.vue'
import ButtonText from '@/components/admin/texts/ButtonText.vue'
import TitleText from '@/components/admin/texts/TitleText.vue'

const bookStore = useBook()
const categoryStore = useCategoryStore()
const authorStore = useAuthorStore()

// Use storeToRefs to maintain reactivity
const { items: bookItems, fullBookDetails } = storeToRefs(bookStore)

const searchQuery = ref('')
const selectedCategories = ref([])
const selectedAuthors = ref([])
const addingBook = ref(false)
const selectedBook = ref(null)
const editingBook = ref(null)

onMounted(() => {
  bookStore.fetchBooks()
  categoryStore.fetchCategories()
  authorStore.fetchAuthors()
})

const filteredBooks = computed(() => {
  let filtered = bookItems.value || []

  // Filter by search query
  const q = searchQuery.value.toLowerCase()
  if (q) {
    filtered = filtered.filter(item =>
      item.id.toLowerCase().includes(q) ||
      item.title.toLowerCase().includes(q)
    )
  }

  // Filter by categories
  if (selectedCategories.value.length) {
    filtered = filtered.filter(item => {
      const bookCategories = fullBookDetails.value[item.id]?.categories || []
      return selectedCategories.value.some(selectedCategory =>
        bookCategories.includes(selectedCategory)
      )
    })
  }

  // Filter by authors
  if (selectedAuthors.value.length) {
    filtered = filtered.filter(item => {
      const bookAuthors = fullBookDetails.value[item.id]?.authors || []
      return selectedAuthors.value.some(selectedAuthor =>
        bookAuthors.includes(selectedAuthor)
      )
    })
  }

  return filtered
})

// Category options for multiselect
const categoryOptions = computed(() => {
  return categoryStore.categories.map(cat => cat.categoryName)
})

// Author options for multiselect
const authorOptions = computed(() => {
  return authorStore.authors
})

function handleAddBook() {
  addingBook.value = true
}
function closeAddBook() {
  addingBook.value = false
}
async function addBook(newBook) {
  try {
    await bookStore.createBook(newBook)
  } catch (e) {
    console.error('Tạo sách thất bại', e)
  } finally {
    addingBook.value = false
  }
}

async function handleViewBook(bookId) {
  console.log('[ViewBook] bookId:', bookId)
  try {
    const book = await bookStore.fetchBookById(bookId)
    selectedBook.value = book
  } catch (e) {
    console.error('Không tải được chi tiết sách', e)
  }
}
function closeDetail() {
  selectedBook.value = null
}

async function handleEditBook(bookId) {
  try {
    const book = await bookStore.fetchBookById(bookId)
    editingBook.value = book
  } catch (e) {
    console.error('Không tải được sách để edit', e)
  }
}
async function updateBook(bookData) {
  try {
    await bookStore.editBook(bookData.bookId, {
      name: bookData.name,
      publishedYear: bookData.publishedYear,
      importPrice: bookData.importPrice,
      quantity: bookData.quantity,
      authors: bookData.authors,
      categories: bookData.categories
    })
  } catch (e) {
    console.error('Cập nhật sách thất bại', e)
  } finally {
    editingBook.value = null
  }
}

const bookTable = ref(null)

async function deleteBook(bookId) {
  try {
    console.log('[Books.vue] handleDeleteBook called for:', bookId)
    // Convert string ID to integer if needed
    const id = typeof bookId === 'string' ? parseInt(bookId) : bookId
    console.log('[Books.vue] Calling bookStore.deleteBook with ID:', id)
    await bookStore.deleteBook(id)
    console.log('[Books.vue] deleteBook completed successfully')
  } catch (e) {
    console.error('Xoá sách thất bại', e.response?.data || e.message)
    // Show error dialog in BookTable
    if (bookTable.value) {
      bookTable.value.showDeleteError()
    }
  }
}
function closeEdit() {
  editingBook.value = null
}
</script>

<template>
  <div style="height:100%; overflow-y:auto;">
    <AddBook v-if="addingBook" @close="closeAddBook" @add-book="addBook" class="book-detail-full" />

    <div v-else-if="!selectedBook && !editingBook" class="content">
      <div class="top-bar">
        <TitleText class="left">
          <template #text>Book Management</template>
        </TitleText>
        <div class="center">
          <v-select v-model="selectedCategories" :items="categoryOptions"
            :label="selectedCategories.length ? `${selectedCategories.length} categories selected` : 'Filter by Categories'"
            multiple clearable variant="outlined" density="compact" class="category-filter"
            :loading="categoryStore.loading" hide-details>
            <template #selection></template>
          </v-select>

          <v-select v-model="selectedAuthors" :items="authorOptions"
            :label="selectedAuthors.length ? `${selectedAuthors.length} authors selected` : 'Filter by Authors'"
            multiple clearable variant="outlined" density="compact" class="author-filter" :loading="authorStore.loading"
            hide-details>
            <template #selection></template>
          </v-select>
        </div>
        <SearchFrame v-model="searchQuery" class="right" />
      </div>

      <BookTable ref="bookTable" :filteredItems="filteredBooks" @view-book="handleViewBook" @edit-book="handleEditBook"
        @delete-book="deleteBook" />

      <ButtonCRUD @click="handleAddBook">
        <template #btn-text>
          <ButtonText><template #text>ADD BOOK</template></ButtonText>
        </template>
      </ButtonCRUD>
    </div>

    <BookDetail v-else-if="selectedBook && !editingBook" :book="selectedBook" @close="closeDetail"
      class="book-detail-full" />

    <EditBook v-else-if="editingBook" :book="editingBook" @close="closeEdit" @update-book="updateBook"
      class="book-detail-full" />
  </div>
</template>

<style scoped>
.content {
  width: 100%;
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

.category-filter {
  width: 220px;
  font-family: Montserrat;
  font-size: 14px;
}

::v-deep(.category-filter .v-field-label) {
  color: var(--vt-c-second-bg-color) !important;
  font-weight: 500;
}

::v-deep(.category-filter .v-field__input) {
  color: var(--vt-c-second-bg-color) !important;
  font-family: Montserrat;
  font-size: 14px;
}

::v-deep(.category-filter .v-field__outline) {
  color: var(--vt-c-second-bg-color) !important;
}

::v-deep(.category-filter .v-icon) {
  color: var(--vt-c-second-bg-color) !important;
}

.author-filter {
  width: 220px;
  font-family: Montserrat;
  font-size: 14px;
}

::v-deep(.author-filter .v-field-label) {
  color: var(--vt-c-second-bg-color) !important;
  font-weight: 500;
}

::v-deep(.author-filter .v-field__input) {
  color: var(--vt-c-second-bg-color) !important;
  font-family: Montserrat;
  font-size: 14px;
}

::v-deep(.author-filter .v-field__outline) {
  color: var(--vt-c-second-bg-color) !important;
}

::v-deep(.author-filter .v-icon) {
  color: var(--vt-c-second-bg-color) !important;
}

.book-detail-full {
  width: 100%;
  height: 100%;
}
</style>