package com.example.gt_events.controller;

import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.CreateEventRequest;
import com.example.gt_events.repo.AccountRepository;

import com.example.gt_events.repo.EventRepository;
import com.example.gt_events.repo.TagRepository;
import com.example.gt_events.repo.TokenRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/events")
public class EventController {
    private final EventRepository eventRepository;
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;
    private final TagRepository tagRepository;

    @Autowired
    public EventController(EventRepository eventRepository, AccountRepository accountRepository,
                           TokenRepository tokenRepository, TagRepository tagRepository) {
        this.eventRepository = eventRepository;
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
        this.tagRepository = tagRepository;
    }

    @GetMapping("/events")
    public ResponseWrapper<List<Event>> getEvents() {
        return new ResponseWrapper<>(eventRepository.findAll());
    }

    @PostMapping("/events")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> createEvent(@RequestBody @Valid CreateEventRequest request, Account a) {
        LinkedHashSet<Long> tagIds = request.getTagIds();
        LinkedHashSet<Tag> tagList = new LinkedHashSet<>();
        for (Long id : tagIds) {
            Optional<Tag> result = tagRepository.findById(id);
            if (result.isEmpty()) {
                throw new InvalidRequestException("invalid tag");
            }
            tagList.add(result.get());
        }
        Event event = new Event(request.getTitle(), request.getLocation(), request.getDescription(),
                request.getEventDate(), request.getCapacity(), request.getFee(), tagList, a);
        return new ResponseWrapper<>(eventRepository.save(event));
    }

    @GetMapping("/events/{eventId}")
    public ResponseWrapper<?> getEvent(@PathVariable Long eventId) {
        Optional<Event> event = eventRepository.findById(eventId);
        if (event.isEmpty()) {
            throw new InvalidRequestException("Event does not exist");
        }
        return new ResponseWrapper<>(event.get());
    }

    @PutMapping("/events/{eventId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> editEvent(@PathVariable Long eventId, @RequestBody @Valid CreateEventRequest request, Account a) {
        Optional<Event> eventOptional = eventRepository.findById(eventId);
        if (eventOptional.isEmpty()) {
            throw new InvalidRequestException("can't find the event");
        }
        Event event = eventOptional.get();
        if (!a.getUsername().equals(event.getAuthor().getUsername())) {
            throw new InvalidRequestException("can't edit the event");
        }
        LinkedHashSet<Long> tagIds = request.getTagIds();
        LinkedHashSet<Tag> tagList = new LinkedHashSet<>();
        for (Long id : tagIds) {
            Optional<Tag> result = tagRepository.findById(id);
            if (result.isEmpty()) {
                throw new InvalidRequestException("invalid tag");
            }
            tagList.add(result.get());
        }
        event.setTitle(request.getTitle());
        event.setLocation(request.getLocation());
        event.setDescription(request.getDescription());
        event.setEventDate(request.getEventDate());
        event.setCapacity(request.getCapacity());
        event.setTags(tagList);
        event.setFee(request.getFee());
        return new ResponseWrapper<>(eventRepository.save(event));
    }

    @DeleteMapping("/events/{eventId}")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> deleteEvent(@PathVariable Long eventId, Account a) {
        Optional<Event> result = eventRepository.findById(eventId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("can't find the event");
        }
        if (!a.getUsername().equals(result.get().getAuthor().getUsername())) {
            throw new InvalidRequestException("can't delete the event");
        }
        eventRepository.delete(result.get());
        return new ResponseWrapper<>("successfully delete the event");
    }

    @GetMapping("/events/{eventId}/tags")
    public ResponseWrapper<?> getTagsByEvent(@PathVariable Long eventId) {
        Optional<Event> result = eventRepository.findById(eventId);
        if (result.isEmpty()) {
            throw new InvalidRequestException("can't find the event");
        }
        return new ResponseWrapper<>(result.get().getTags());
    }

    @PostMapping("/saved/{eventId}")
    @RequireAuth
    public ResponseWrapper<?> saveEvent(@PathVariable Long eventId, Account a) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("can't find this event"));
        a.getSavedEvents().add(event);
        accountRepository.save(a);
        return new ResponseWrapper<>("success");
    }

    @DeleteMapping("/saved/{eventId}")
    @RequireAuth
    public ResponseWrapper<?> deleteSavedEvent(@PathVariable Long eventId, Account a) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("can't find this event"));
        a.getSavedEvents().remove(event);
        accountRepository.save(a);
        return new ResponseWrapper<>("success");
    }

    @GetMapping("/saved")
    @RequireAuth
    public ResponseWrapper<?> getSavedEvents(Account a) {
        return new ResponseWrapper<>(a.getSavedEvents());
    }

    @GetMapping("/created")
    @RequireAuth
    public ResponseWrapper<?> getCreatedEvents(Account a) {
        return new ResponseWrapper<>(a.getCreatedEvents());
    }
}
