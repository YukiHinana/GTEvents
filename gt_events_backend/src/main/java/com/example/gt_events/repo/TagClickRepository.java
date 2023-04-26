package com.example.gt_events.repo;

import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.EventClick;
import com.example.gt_events.entity.Tag;
import com.example.gt_events.entity.TagClick;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface TagClickRepository extends JpaRepository<TagClick, Long> {
    Optional<TagClick> findByTag(Tag t);

    List<TagClick> findByClickDateBetween(Date startDate, Date endDate);
}