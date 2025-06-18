package com.bookstore.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bookstore.repository.UserRepository;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class IdGeneratorService {

    @Autowired
    private UserRepository userRepository;

    /**
     * Generate next User ID following pattern: admin-001, user-001, user-002, etc.
     * Admin users get prefix "admin-", regular users get prefix "user-"
     */
    @Transactional
    public String generateUserId(boolean isAdmin) {
        String prefix = isAdmin ? "admin-" : "user-";
        
        // Count existing users with the same prefix
        Long count = userRepository.countByIdStartsWith(prefix);
        
        // Generate next number in sequence
        long nextNumber = count + 1;
        
        // Format as 3-digit padded number
        String formattedNumber = String.format("%03d", nextNumber);
        
        String newId = prefix + formattedNumber;
        
        log.info("Generated new user ID: {}", newId);
        return newId;
    }

    /**
     * Generate next Book ID following pattern: book-001, book-002, etc.
     */
    public String generateBookId() {
        // Since Books use Integer ID with auto-increment, 
        // this method is for future enhancement if needed
        return null;
    }

    /**
     * Generate next Import Receipt ID following pattern: import-001, import-002, etc.
     */
    public String generateImportReceiptId() {
        // Since ImportReceipts use Integer ID with auto-increment,
        // this method is for future enhancement if needed
        return null;
    }

    /**
     * Generate next Invoice ID following pattern: inv-001, inv-002, etc.
     */
    public String generateInvoiceId() {
        // Since Invoices use Integer ID with auto-increment,
        // this method is for future enhancement if needed
        return null;
    }

    /**
     * Generate next Payment Receipt ID following pattern: pay-001, pay-002, etc.
     */
    public String generatePaymentReceiptId() {
        // Since PaymentReceipts use Integer ID with auto-increment,
        // this method is for future enhancement if needed
        return null;
    }
} 