package com.example.gt_events.controller;
import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Tag;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.CreateTagRequest;
import com.example.gt_events.model.EditTagRequest;
import com.example.gt_events.repo.TagRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/tags")
public class TagController {
    private final TagRepository tagRepository;

    @Autowired
    public TagController(TagRepository tagRepository) {
        this.tagRepository = tagRepository;
    }

    @GetMapping("/")
    public ResponseWrapper<?> getTags() {
        return new ResponseWrapper<>(tagRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseWrapper<?> viewTag(@PathVariable Long id) {
        Optional<Tag> tag = tagRepository.findById(id);
        if (tag.isEmpty()) {
            throw new InvalidRequestException("Target tag does not exist");
        }
        return new ResponseWrapper<>(tag.get());
    }

    @PostMapping("/create")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> createTag(@RequestBody @Valid CreateTagRequest request) {
        if (tagRepository.findTagByName(request.getTagName()).isPresent()) {
            throw new InvalidRequestException("The tag name already exists");
        } else {
            Tag tag = new Tag(request.getTagName());
            return new ResponseWrapper<>(tagRepository.save(tag));
        }
    }

    @PutMapping("/{tagId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> editTag(@RequestBody @Valid EditTagRequest request, @PathVariable Long tagId) {
        Optional<Tag> result = tagRepository.findById(tagId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("can't find the tag");
        }
        Tag tag = result.get();
        String newTagName = request.getTagName();
        if (tagRepository.findTagByName(newTagName).isPresent()) {
            throw new InvalidRequestException("tag name already exists");
        }
        tag.setName(newTagName);
        return new ResponseWrapper<>(tagRepository.save(tag));
    }

    // TODO: rethink who can delete a tag
    @DeleteMapping("/{tagId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> deleteTag(@PathVariable Long tagId) {
        Optional<Tag> result = tagRepository.findById(tagId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("Tag does not exist");
        }
        tagRepository.deleteById(tagId);
        return new ResponseWrapper<>("Tag " + result.get().getName() + " successfully deleted");
    }
}