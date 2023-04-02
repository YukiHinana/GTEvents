package com.example.gt_events.service;

import com.example.gt_events.ResponseWrapper;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Event;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

@Service
public class EventService {
    @Transactional(readOnly = true)
    public Set<Event> getCreatedEvents(Account a) {
        Hibernate.initialize(a.getCreatedEvents());
        return a.getCreatedEvents();
    }
}
