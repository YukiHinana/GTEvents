package com.example.gt_events.controller;

import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.EventClick;
import com.example.gt_events.entity.Tag;
import com.example.gt_events.entity.TagClick;
import com.example.gt_events.model.EventClickSummary;
import com.example.gt_events.model.TagClickSummary;
import com.example.gt_events.repo.*;
import com.example.gt_events.service.EventService;
import com.example.gt_events.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/clicks")
public class ClickController {
    private final EventRepository eventRepository;
    private final AccountRepository accountRepository;
    private final TokenRepository tokenRepository;
    private final TagRepository tagRepository;
    private final FileService fileService;
    private final EventService eventService;
    private final EventClickRepository eventClickRepository;
    private final TagClickRepository tagClickRepository;

    @Autowired
    public ClickController(EventRepository eventRepository, AccountRepository accountRepository,
                           TokenRepository tokenRepository, TagRepository tagRepository, FileService fileService,
                           EventService eventService, EventClickRepository eventClickRepository,
                           TagClickRepository tagClickRepository) {
        this.eventRepository = eventRepository;
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
        this.tagRepository = tagRepository;
        this.fileService = fileService;
        this.eventService = eventService;
        this.eventClickRepository = eventClickRepository;
        this.tagClickRepository = tagClickRepository;
    }

    @GetMapping("/view-events-top-10")
    public ResponseWrapper<?> getTop10ViewedEvents(@RequestParam Date startDate, @RequestParam Date endDate) {
        Map<Event, Long> map = new HashMap<>();
        List<EventClick> eventClickList = eventClickRepository.findByClickDateBetween(startDate, endDate);
        for (EventClick e : eventClickList) {
            if (!map.containsKey(e.getEvent())) {
                map.put(e.getEvent(), 0L);
            }
            map.put(e.getEvent(), map.get(e.getEvent()) + 1);
        }
        List<Map.Entry<Event, Long>> list = new ArrayList<>(map.entrySet());
        list.sort((a, b)->b.getValue().compareTo(a.getValue()));
        List<EventClickSummary> result = list.stream().limit(10).map((i)->
                new EventClickSummary(i.getKey(), i.getValue())).toList();

        return new ResponseWrapper<>(result);
    }

    @GetMapping("/view-tags")
    public ResponseWrapper<?> getViewedTags(@RequestParam Date startDate, @RequestParam Date endDate) {
        Map<Tag, Long> map = new HashMap<>();
        List<TagClick> tagClickList = tagClickRepository.findByClickDateBetween(startDate, endDate);

        for (TagClick t : tagClickList) {
            if (!map.containsKey(t.getTag())) {
                map.put(t.getTag(), 0L);
            }
            map.put(t.getTag(), map.get(t.getTag()) + 1);
        }
        List<Map.Entry<Tag, Long>> list = new ArrayList<>(map.entrySet());
        list.sort((a, b)->b.getValue().compareTo(a.getValue()));
        List<TagClickSummary> result = list.stream().map((i)->
                new TagClickSummary(i.getKey(), i.getValue())).toList();

        return new ResponseWrapper<>(result);
    }
}
