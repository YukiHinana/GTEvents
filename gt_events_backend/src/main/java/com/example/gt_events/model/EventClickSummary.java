package com.example.gt_events.model;

import com.example.gt_events.entity.Event;

public class EventClickSummary {
    private Event event;
    private long clicks;

    public EventClickSummary(Event event, long clicks) {
        this.event = event;
        this.clicks = clicks;
    }

    public Event getEvent() {
        return event;
    }

    public long getClicks() {
        return clicks;
    }
}
