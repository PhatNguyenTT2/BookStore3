package com.bookstore.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.bookstore.entity.Users;

@Repository
public interface UserRepository extends JpaRepository<Users, String> {
    boolean existsByUsername(String username);

    Users findByPhone(String phone);

    Optional<Users> findByUsername(String username);

    @Query("""
            select u from Users u
            join u.roles r
            where r.name <> :roleName
            """)
    List<Users> findAllByRoleNot(@Param("roleName") String roleName);

    /**
     * Count users whose ID starts with the given prefix
     */
    @Query("SELECT COUNT(u) FROM Users u WHERE u.id LIKE :prefix%")
    Long countByIdStartsWith(@Param("prefix") String prefix);

}
