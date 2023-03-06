package com.example.gt_events.controller;

import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Post;
import com.example.gt_events.entity.Token;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.EditPostRequest;
import com.example.gt_events.model.PostRequest;
import com.example.gt_events.repo.AccountRepository;

import com.example.gt_events.repo.PostRepository;
import com.example.gt_events.repo.TokenRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/post")
public class PostController {
    private final PostRepository postRepository;
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;

    public PostController(PostRepository postRepository, AccountRepository accountRepository,
                          TokenRepository tokenRepository) {
        this.postRepository = postRepository;
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
    }

    @GetMapping("/")
    public ResponseWrapper<List<Post>> getPosts() {
        return new ResponseWrapper<>(postRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseWrapper<?> getPost(@PathVariable Long id) {
        Optional<Post> post = postRepository.findById(id);
        if (post.isEmpty()) {
            throw new InvalidRequestException("Post does not exist");
        }
        return new ResponseWrapper<>(post.get());
    }

    @PostMapping("/create")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> createPost(@RequestBody @Valid PostRequest request, Account a) {
        Post post = new Post(request.getTitle(), request.getBody(), a);
        return new ResponseWrapper<>(postRepository.save(post));
    }

    @PutMapping("/replace")
    @RequireAuth(requireOrganizer = true)
    @Transactional
    public ResponseWrapper<?> editPost(@RequestBody @Valid EditPostRequest request, Account a) {
        Optional<Post> result = postRepository.findById(request.getPostId());
        if (result.isEmpty()) {
            throw new InvalidRequestException("can't find the post");
        }
        if (!a.getUsername().equals(result.get().getAuthor().getUsername())) {
            throw new InvalidRequestException("can't edit the post");
        }
        Post post = result.get();
        post.setTitle(request.getTitle());
        post.setBody(request.getBody());
        return new ResponseWrapper<>(postRepository.save(post));
    }
}
