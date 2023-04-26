package com.example.gt_events.model;

import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;

public class TagClickSummary {
    private Tag tag;
    private long clicks;

    public TagClickSummary(Tag tag, long clicks) {
        this.tag = tag;
        this.clicks = clicks;
    }

    public Tag getTag() {
        return tag;
    }

    public long getClicks() {
        return clicks;
    }
}
