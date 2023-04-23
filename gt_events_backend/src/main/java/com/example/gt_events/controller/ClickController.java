package com.example.gt_events.controller;

import com.example.gt_events.ResponseWrapper;
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

    @Autowired
    public ClickController(EventRepository eventRepository, AccountRepository accountRepository,
                           TokenRepository tokenRepository, TagRepository tagRepository, FileService fileService,
                           EventService eventService, EventClickRepository eventClickRepository) {
        this.eventRepository = eventRepository;
        this.accountRepository = accountRepository;
        this.tokenRepository = tokenRepository;
        this.tagRepository = tagRepository;
        this.fileService = fileService;
        this.eventService = eventService;
        this.eventClickRepository = eventClickRepository;
    }

    @GetMapping("/view-events-top-10")
    public ResponseWrapper<?> getTop10ViewedEvents() {
        return new ResponseWrapper<>(eventClickRepository.findTop3ByOrderByNumClickDesc());
    }
}
