// ✅ book.js (Pinia Store)
import { api } from '@/plugins/axios'
import { defineStore } from 'pinia'
import { reactive, ref } from 'vue'

export const useBook = defineStore('book', () => {
  const items = ref([])
  const fullBookDetails = reactive({})
  const loading = ref(false)
  const error = ref(null)

  async function fetchBooks() {
    loading.value = true; error.value = null
    try {
      console.log('[BookStore] fetchBooks called')
      const { data } = await api.get('/books')
      const list = Array.isArray(data.result) ? data.result : []
      console.log('[BookStore] Received', list.length, 'books from API')

      items.value = list.map(b => ({
        bookId: b.bookId,
        id: String(b.bookId),
        title: b.name,
        authors: b.authors?.map(a => a.authorName) || [],
        categories: b.categories?.map(c => c.categoryName) || [],
        quantity: b.quantity,
        import_price: b.importPrice,
        publishedYear: b.publishedYear,
        _raw: b
      }))
      items.value.forEach(b => { fullBookDetails[b.id] = b })
      console.log('[BookStore] Updated items.value to', items.value.length, 'books')
    } catch (e) {
      console.error('[BookStore] fetchBooks failed:', e)
      error.value = e
    } finally {
      loading.value = false
    }
  }

  async function fetchBookById(id) {
    loading.value = true
    try {
      const { data } = await api.get(`/books/dto/${id}`)
      const b = data.result
      if (!b) throw new Error('Book not found')

      return {
        bookId: b.bookId,
        id: String(b.bookId),
        name: b.name,
        authors: b.authors.map(a => a.authorName),           // ✅ fix ở đây
        categories: b.categories.map(c => c.categoryName),   // ✅ fix ở đây
        quantity: b.quantity,
        importPrice: b.importPrice,
        publishedYear: b.publishedYear,
      }
    } catch (e) {
      error.value = e
      throw e
    } finally {
      loading.value = false
    }
  }



  async function createBook(payload) {
    loading.value = true; error.value = null
    try {
      await api.post('/books', payload)
      await fetchBooks()
    } catch (e) {
      error.value = e
      throw e
    } finally {
      loading.value = false
    }
  }

  async function editBook(bookId, payload) {
    loading.value = true; error.value = null
    try {
      await api.put(`/books/edit/${bookId}`, payload)
      await fetchBooks()
    } catch (e) {
      error.value = e
      throw e
    } finally {
      loading.value = false
    }
  }

  async function deleteBook(bookId) {
    loading.value = true; error.value = null
    try {
      console.log('[BookStore] Starting delete for book:', bookId)
      console.log('[BookStore] Books before delete:', items.value.length)

      await api.delete(`/books/${bookId}`)
      console.log('[BookStore] Delete API call successful')

      // Optimistic update - remove book from local array immediately
      const bookIndex = items.value.findIndex(b => b.bookId === bookId || b.id === String(bookId))
      if (bookIndex !== -1) {
        const deletedBook = items.value[bookIndex]
        items.value.splice(bookIndex, 1)
        // Also remove from fullBookDetails
        delete fullBookDetails[deletedBook.id]
        console.log('[BookStore] Removed book from local array. New count:', items.value.length)
      }

      // Also fetch fresh data as backup
      await fetchBooks()
      console.log('[BookStore] Books after refetch:', items.value.length)
    } catch (e) {
      console.error('[BookStore] deleteBook failed:', e)
      error.value = e
      // If API call failed, refetch to ensure data consistency
      await fetchBooks()
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    items,
    fullBookDetails,
    loading,
    error,
    fetchBooks,
    fetchBookById,
    createBook,
    editBook,
    deleteBook
  }
})
