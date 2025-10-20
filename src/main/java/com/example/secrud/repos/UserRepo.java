package com.example.secrud.repos;

import com.example.secrud.models.UserModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepo extends JpaRepository<UserModel, Long> {

    Optional<UserModel> findByEmail(String email);

    List<UserModel> findByDeleteStatus(boolean deleteStatus);

    @Modifying
    @Transactional
    @Query("UPDATE UserModel u SET u.firstName = :firstName WHERE u.id = :id")
    void updateFirstName(@Param("id") Long id, @Param("firstName") String firstName);

    @Modifying
    @Transactional
    @Query("UPDATE UserModel u SET u.lastName = :lastName WHERE u.id = :id")
    void updateLastName(@Param("id") Long id, @Param("lastName") String lastName);

    @Modifying
    @Transactional
    @Query("UPDATE UserModel u SET u.contactNumber = :contactNumber WHERE u.id = :id")
    void updateContactNumber(@Param("id") Long id, @Param("contactNumber") String contactNumber);

    @Modifying
    @Transactional
    @Query("UPDATE UserModel u SET u.password = :password WHERE u.id = :id")
    void updatePassword(@Param("id") Long id, @Param("password") String password);

    @Modifying
    @Transactional
    @Query("UPDATE UserModel u SET u.deleteStatus = :deleteStatus WHERE u.id = :id")
    void updateDeleteStatus(@Param("id") Long id, @Param("deleteStatus") boolean deleteStatus);
}
