package com.example.gt_events.controller;

import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;
import com.example.gt_events.exception.InvalidRequestException;
import com.example.gt_events.model.CreateEventRequest;
import com.example.gt_events.model.SearchEventRequest;
import com.example.gt_events.repo.AccountRepository;
import com.example.gt_events.repo.EventRepository;
import com.example.gt_events.repo.TagRepository;
import com.example.gt_events.repo.TokenRepository;
import com.example.gt_events.service.EventService;
import com.example.gt_events.service.FileService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.hibernate.Hibernate;
import org.hibernate.Internal;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.*;


@RestController
@RequestMapping("/events")
public class EventController {
    @PersistenceContext
    EntityManager entityManager;
    private final EventRepository eventRepository;
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;
    private final TagRepository tagRepository;
    private final FileService fileService;
    private final EventService eventService;

    @Autowired
    public EventController(EventRepository eventRepository, AccountRepository accountRepository,
                           TokenRepository tokenRepository, TagRepository tagRepository, FileService fileService,
                           EventService eventService) {
        this.eventRepository = eventRepository;
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
        this.tagRepository = tagRepository;
        this.fileService = fileService;
        this.eventService = eventService;
    }

    @GetMapping("/events")
    public ResponseWrapper<?> getEvents(@RequestParam int pageNumber, @RequestParam int pageSize) {
        Pageable aa = PageRequest.of(pageNumber, pageSize, Sort.by(Sort.Order.desc("eventDate").ignoreCase()));
        return new ResponseWrapper<>(eventRepository.findAll(aa));
    }

    @GetMapping("/events/sort/event-date")
    public ResponseWrapper<?> sortEventsByEventDate(@RequestParam int pageNumber, @RequestParam int pageSize) {
        Pageable aa = PageRequest.of(pageNumber, pageSize, Sort.by(Sort.Order.desc("eventDate").ignoreCase()));
        return new ResponseWrapper<>(eventRepository.findAll(aa));
    }

    @GetMapping("/events/search")
    public ResponseWrapper<?> getEventsByKeyword(@RequestParam String keyword,
                                                 @RequestParam int pageNumber, @RequestParam int pageSize) {
        Pageable aa = PageRequest.of(pageNumber, pageSize);
        return new ResponseWrapper<>(eventRepository.findByTitleContainingOrAuthor_UsernameContaining(keyword, keyword, aa));
    }

    @GetMapping("/events/find/event-date-between")
    public ResponseWrapper<?> getEventsByDateRange(@RequestParam int pageNumber, @RequestParam int pageSize,
                                                   @RequestParam Date startDate, @RequestParam Date endDate) {
        Pageable aa = PageRequest.of(pageNumber, pageSize);
        return new ResponseWrapper<>(eventRepository.findByEventDateBetween(startDate, endDate, aa));
    }

    @GetMapping("/events/find/event-creation-date-between")
    public ResponseWrapper<?> getEventsByCreationDateRange(@RequestParam int pageNumber, @RequestParam int pageSize,
                                                           @RequestParam Date startDate, @RequestParam Date endDate) {
        Pageable aa = PageRequest.of(pageNumber, pageSize);
        return new ResponseWrapper<>(eventRepository.findByEventCreationDateBetween(startDate, endDate, aa));
    }

    /**
     * GET-get image keys
     * */
    @GetMapping("/events/{eventId}/file")
    public ResponseWrapper<?> getFileKeysByEvent(@PathVariable Long eventId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("no such event"));
        return new ResponseWrapper<>(event.getImagesKeys());
    }

    @PostMapping("/events/{eventId}/file")
    @RequireAuth(requireOrganizer = true)
    public ResponseWrapper<?> handleFileUpload(@PathVariable Long eventId,
                                               @RequestParam("file") MultipartFile file,
                                               Account a) throws IOException {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("no such event"));
        if (!a.getUsername().equals(event.getAuthor().getUsername())) {
            throw new InvalidRequestException("can't edit the event");
        }
        String key = UUID.randomUUID().toString();
        event.getImagesKeys().add(key);
        eventRepository.save(event);
        fileService.uploadStream(key, file.getInputStream());
        return new ResponseWrapper<>(key);
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
        List<Account> list = accountRepository.findAllBySavedEvents(result.get());
        for (Account account : list) {
            account.getSavedEvents().remove(result.get());
            accountRepository.save(account);
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

    @GetMapping("/events/tag-ids")
    public ResponseWrapper<?> getEventsByTagIds(@RequestParam(defaultValue = "") String[] eventTypeTagIds,
                                                @RequestParam String[] degreeTagIds,
                                                @RequestParam int pageNumber,
                                                @RequestParam int pageSize) {
        Set<Long> eventTypeTagIdSet = new HashSet<>();
        for (String tagId : eventTypeTagIds) {
            eventTypeTagIdSet.add(Long.parseLong(tagId));
        }
        List<Tag> eventTypeTagList = tagRepository.findAllById(eventTypeTagIdSet);
        List<Event> eventTypeEventList = eventRepository.findAllByTagsIn(eventTypeTagList);

        Set<Long> degreeTagIdsIdSet = new HashSet<>();
        for (String tagId : degreeTagIds) {
            degreeTagIdsIdSet.add(Long.parseLong(tagId));
        }
        List<Tag> degreeTagIdsList = tagRepository.findAllById(degreeTagIdsIdSet);
        List<Event> degreeEventList = eventRepository.findAllByTagsIn(degreeTagIdsList);

        List<Event> result = new ArrayList<>();
        if (degreeEventList.size() == 0) {
            result = eventTypeEventList;
        } else if (eventTypeEventList.size() == 0) {
            result = degreeEventList;
        } else {
            for (Event e : degreeEventList) {
                if (eventTypeEventList.contains(e)) {
                    result.add(e);
                }
            }
        }
        result.sort((e1, e2) -> e2.getEventDate().compareTo(e1.getEventDate()));

        int startIndex = Math.min(pageNumber * pageSize, result.size());
        int endIndex = pageNumber * pageSize + pageSize;
        if (endIndex > result.size()) {
            endIndex = result.size();
        }
        Pageable aa = PageRequest.of(pageNumber, pageSize);

        return new ResponseWrapper<>(
                new PageImpl<>(result.subList(startIndex, endIndex), aa, result.size()));
    }

    @PostMapping("/saved/{eventId}")
    @RequireAuth
    public ResponseWrapper<?> saveEvent(@PathVariable Long eventId, Account a) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("can't find this event"));
        Account account = accountRepository.findById(a.getId()).get();
        eventService.getSavedEvents(account).add(event);
        accountRepository.save(account);
        return new ResponseWrapper<>("success");
    }

    @DeleteMapping("/saved/{eventId}")
    @RequireAuth
    public ResponseWrapper<?> deleteSavedEvent(@PathVariable Long eventId, Account a) {
        Event e = eventRepository.findById(eventId)
                .orElseThrow(() -> new InvalidRequestException("can't find this event"));
        Account account = accountRepository.findById(a.getId()).get();
        account.getSavedEvents().remove(e);
        accountRepository.save(account);
        return new ResponseWrapper<>("success");
    }

    @GetMapping("/saved")
    @RequireAuth
    public ResponseWrapper<?> getSavedEvents(Account a) {
        Account account = accountRepository.findById(a.getId()).get();
        return new ResponseWrapper<>(eventService.getSavedEvents(account));
    }

//    @GetMapping("/saved")
//    @RequireAuth
//    public ResponseWrapper<?> getSavedEvents(@RequestParam int pageNumber, @RequestParam int pageSize, Account a) {
//        Pageable aa = PageRequest.of(pageNumber, pageSize);
//        Set<Event> savedSet = a.getSavedEvents();
//
//        return new ResponseWrapper<>(new PageImpl<>(Arrays.asList(a.getSavedEvents().toArray()), aa, savedSet.size()));
//    }

    @GetMapping("/created")
    @RequireAuth
    public ResponseWrapper<?> getCreatedEvents(Account a) {
        Account account = accountRepository.findById(a.getId()).get();
        return new ResponseWrapper<>(eventService.getCreatedEvents(account));
    }
//    @GetMapping("/created")
//    @RequireAuth
//    public ResponseWrapper<?> getCreatedEvents(@RequestParam int pageNumber, @RequestParam int pageSize, Account a) {
//        Pageable aa = PageRequest.of(pageNumber, pageSize);
//        Set<Event> createdEvents = a.getCreatedEvents();
//        return new ResponseWrapper<>(new PageImpl<>(Arrays.asList(a.getCreatedEvents().toArray()), aa, createdEvents.size()));
//    }
}