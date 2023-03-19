package com.example.gt_events.controller;

import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Token;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.AccountChangePasswordRequest;
import com.example.gt_events.model.AccountLogoutRequest;
import com.example.gt_events.model.DeleteAccountRequest;
import com.example.gt_events.model.CreateAccountRequest;
import com.example.gt_events.repo.AccountRepository;
import com.example.gt_events.repo.EventRepository;
import com.example.gt_events.repo.TokenRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/account")
public class AccountController {
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;
    private final EventRepository eventRepository;

    @Autowired
    public AccountController(AccountRepository accountRepository,
                             TokenRepository tokenRepository,
                             EventRepository eventRepository) {
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
        this.eventRepository = eventRepository;
    }

    private final BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();

    @GetMapping("/")
    public ResponseWrapper<List<Account>> getAllAccounts() {
        return new ResponseWrapper<>(accountRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseWrapper<?> getAccountById(@PathVariable Long id) throws InvalidRequestException {
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
    @RequireAuth
    public ResponseWrapper<String> deleteAccountById(Account a) {
        if (accountRepository.findById(a.getId()).isEmpty()) {
            throw new InvalidRequestException("Failed. Account not found.");
        } else {
            accountRepository.delete(a);
            return new ResponseWrapper<>("Account " + a.getUsername() + " successfully deleted");
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
                false);
        accountRepository.save(newAccount);
        return new ResponseWrapper<>("Sign up success");
    }

    @PostMapping("/login")
    public ResponseWrapper<?> login(@RequestBody @Valid DeleteAccountRequest request) {
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

    @PutMapping("/reset")
    @Transactional
    public ResponseWrapper<?> changePassword(@RequestBody @Valid AccountChangePasswordRequest request) {
        if (request.getOldPassword().equals(request.getNewPassword())) {
            throw new InvalidRequestException("The new password cannot be the same as the old one");
        }
        Optional<Account> account = accountRepository.findByUsername(request.getUsername());
        if (account.isPresent()) {
            if (bCryptPasswordEncoder.matches(request.getOldPassword(), account.get().getPassword())) {
                Account a = account.get();
                tokenRepository.deleteTokensByOwner(a);
                a.setPassword(bCryptPasswordEncoder.encode(request.getNewPassword()));
                accountRepository.save(a);
                return new ResponseWrapper<>("Success");
            }
        }
        throw new InvalidRequestException("Incorrect username or password");
    }

    @PostMapping("/logout")
    public ResponseWrapper<?> logout(@RequestBody @Valid AccountLogoutRequest request) {
        Optional<Token> token = tokenRepository.findByUuid(request.getToken());
        if (token.isEmpty()) {
            throw new InvalidRequestException("Invalid token");
        } else {
            tokenRepository.delete(token.get());
        }
        return new ResponseWrapper<>("Account logged out");
    }

    @PostMapping("/save/events/{eventId}")
    @RequireAuth
    public ResponseWrapper<?> saveEvent(@PathVariable Long eventId, Account a) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("can't find this event"));
        a.getSavedEvents().add(event);
        accountRepository.save(a);
        return new ResponseWrapper<>(a.getSavedEvents());
    }
}
