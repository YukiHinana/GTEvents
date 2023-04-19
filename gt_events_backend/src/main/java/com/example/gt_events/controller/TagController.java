package com.example.gt_events.controller;
import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;
import com.example.gt_events.entity.TagGroup;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.CreateTagGroupRequest;
import com.example.gt_events.model.CreateTagRequest;
import com.example.gt_events.model.EditTagGroupRequest;
import com.example.gt_events.model.EditTagRequest;
import com.example.gt_events.repo.EventRepository;
import com.example.gt_events.repo.TagGroupRepository;
import com.example.gt_events.repo.TagRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/tags")
public class TagController {
    private final TagRepository tagRepository;
    private final TagGroupRepository tagGroupRepository;
    private final EventRepository eventRepository;

    @Autowired
    public TagController(TagRepository tagRepository,
                         TagGroupRepository tagGroupRepository,
                         EventRepository eventRepository) {
        this.tagRepository = tagRepository;
        this.tagGroupRepository = tagGroupRepository;
        this.eventRepository = eventRepository;
    }

    // view all tags under a certain group
    @GetMapping("/group")
    public ResponseWrapper<?> viewTagsUnderGroup(@RequestParam String groupName) {
        Optional<TagGroup> group = tagGroupRepository.findTagGroupByName(groupName);
        if (group.isEmpty()) {
            throw new InvalidRequestException("Target group does not exist");
        }
        return new ResponseWrapper<>(group.get().getTags());
    }

    @PostMapping("/group/create")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> createTagGroup(@RequestBody @Valid CreateTagGroupRequest request) {
        if (tagGroupRepository.findTagGroupByName(request.getGroupName()).isPresent()) {
            throw new InvalidRequestException("The tag group already exists");
        } else {
            TagGroup group = new TagGroup(request.getGroupName());
            return new ResponseWrapper<>(tagGroupRepository.save(group));
        }
    }

    @PutMapping("/group/{groupId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> editTag(@RequestBody @Valid EditTagGroupRequest request, @PathVariable Long groupId) {
        Optional<TagGroup> result = tagGroupRepository.findById(groupId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("can't find the group");
        }
        TagGroup group = result.get();
        String newGroupName = request.getGroupName();
        if (tagGroupRepository.findTagGroupByName(newGroupName).isPresent()) {
            throw new InvalidRequestException("tag name already exists");
        }
        group.setName(newGroupName);
        return new ResponseWrapper<>(tagGroupRepository.save(group));
    }

    // test only
    @DeleteMapping("/group/{groupId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> deleteTagGroup(@PathVariable Long groupId) {
        Optional<TagGroup> result = tagGroupRepository.findById(groupId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("Group does not exist");
        }
        tagGroupRepository.deleteById(groupId);
        return new ResponseWrapper<>("Group " + result.get().getName() + " successfully deleted");
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
            TagGroup group = tagGroupRepository.findTagGroupByName(request.getGroupName())
                    .orElseThrow(() -> new InvalidRequestException("no such group"));;
            Tag tag = new Tag(request.getTagName(), group);
            return new ResponseWrapper<>(tagRepository.save(tag));
        }
    }

    // test only
    @DeleteMapping("/{tagId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> deleteTag(@PathVariable Long tagId) {
        Optional<Tag> result = tagRepository.findById(tagId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("Tag does not exist");
        }
        List<Event> list = eventRepository.findAllByTags(result.get());
        for (Event e : list) {
            e.getTags().remove(result.get());
            eventRepository.save(e);
        }
        tagRepository.deleteById(tagId);
        return new ResponseWrapper<>("Tag " + result.get().getName() + " successfully deleted");
    }
}