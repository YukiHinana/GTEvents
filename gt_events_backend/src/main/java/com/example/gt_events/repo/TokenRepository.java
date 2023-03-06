package com.example.gt_events.repo;

import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Token;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TokenRepository extends JpaRepository<Token, Long> {
    Optional<Token> findByUuid(String token);

    void deleteTokensByAccount(Account account);
}
