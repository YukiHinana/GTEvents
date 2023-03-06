package com.example.gt_events.controller;

import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Token;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.AccountChangePasswordRequest;
import com.example.gt_events.model.AccountLogoutRequest;
import com.example.gt_events.model.AccountRequest;
import com.example.gt_events.model.CreateAccountRequest;
import com.example.gt_events.repo.AccountRepository;
import com.example.gt_events.repo.TokenRepository;
import jakarta.validation.Valid;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/account")
public class AccountController {
    private AccountRepository accountRepository;

    private TokenRepository tokenRepository;

    public AccountController(AccountRepository accountRepository, TokenRepository tokenRepository) {
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
    }

    private final BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();

    @GetMapping("/")
    public ResponseWrapper<List<Account>> getAllAccounts() {
        return new ResponseWrapper<>(accountRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseWrapper<?> getAccountById(@PathVariable Long id)
            throws InvalidRequestException {
        Optional<Account> result = accountRepository.findById(id);
        if (result.isEmpty()) {
            throw new InvalidRequestException("Account not found");
        }
        return new ResponseWrapper<>(result.get());
    }

    @GetMapping("/find")
    @RequireAuth
    public ResponseWrapper<?> getAccountByToken(Account a) {
        return new ResponseWrapper<>(a);
    }

    @DeleteMapping("/delete")
    public ResponseWrapper<String> deleteAccountById(@RequestBody AccountRequest request) {
        if (request.getUsername() == null || request.getUsername().isEmpty()
                || request.getPassword() == null || request.getPassword().isEmpty()) {
            throw new InvalidRequestException("Failed. Account not found.");
        }
        Optional<Account> result = accountRepository.findByUsername(request.getUsername());
        if (result.isEmpty()) {
            throw new InvalidRequestException("Failed. Account not found.");
        }
        Account targetAccount = result.get();
        if (!bCryptPasswordEncoder.matches(request.getPassword(), targetAccount.getPassword())) {
            throw new InvalidRequestException("Failed. Incorrect password.");
        } else {
            accountRepository.delete(targetAccount);
            tokenRepository.deleteTokensByAccount(targetAccount);
            return new ResponseWrapper<>("Account " + request.getUsername() + " successfully deleted");
        }
    }

    @PostMapping("/register")
    public ResponseWrapper<?> register(@RequestBody @Valid CreateAccountRequest request) {
        Optional<Account> findAccount = accountRepository.findByUsername(request.getUsername());
        if (findAccount.isPresent()) {
            throw new InvalidRequestException("Username already exists!");
        }
        // TODO: change isOrganizer later
        Account newAccount = new Account(request.getUsername(),
                bCryptPasswordEncoder.encode(request.getPassword()),
                true);
        accountRepository.save(newAccount);
        return new ResponseWrapper<>("Sign up success");
    }

    @PostMapping("/login")
    public ResponseWrapper<?> login(@RequestBody @Valid AccountRequest request) {
        String username = request.getUsername();
        Optional<Account> account = accountRepository.findByUsername(username);
        if (account.isPresent()) {
            if (bCryptPasswordEncoder.matches(request.getPassword(), account.get().getPassword())) {
                String uuid = UUID.randomUUID().toString();
                tokenRepository.save(new Token(uuid, account.get()));
                return new ResponseWrapper<>(uuid);
            }
        }
        throw new InvalidRequestException("Incorrect username or password");
    }

    @PutMapping("/replace")
    @Transactional
    public ResponseWrapper<?> changePassword(@RequestBody AccountChangePasswordRequest request) {
        if (request.getUsername() == null || request.getUsername().isEmpty()
                || request.getOldPassword() == null || request.getOldPassword().isEmpty()
                || request.getNewPassword() == null || request.getNewPassword().isEmpty()) {
            throw new InvalidRequestException("Username and password required1");
        }
        if (request.getOldPassword().equals(request.getNewPassword())) {
            throw new InvalidRequestException("The new password cannot be the same as the old one");
        }

        Optional<Account> account = accountRepository.findByUsername(request.getUsername());
        if (account.isPresent()) {
            if (bCryptPasswordEncoder.matches(request.getOldPassword(), account.get().getPassword())) {
                Account a = account.get();
                tokenRepository.deleteTokensByAccount(a);
                a.setPassword(bCryptPasswordEncoder.encode(request.getNewPassword()));
                return new ResponseWrapper<>(accountRepository.save(a));
            }
        }
        throw new InvalidRequestException("Incorrect username or password2");
    }

    @PostMapping("/logout")
    public ResponseWrapper<?> logout(@RequestBody AccountLogoutRequest request) {
        Optional<Token> token = tokenRepository.findByUuid(request.getToken());
        if (token.isEmpty()) {
            throw new InvalidRequestException("Invalid token");
        } else {
            tokenRepository.delete(token.get());
        }
        return new ResponseWrapper<>("Account logged out");
    }
}
