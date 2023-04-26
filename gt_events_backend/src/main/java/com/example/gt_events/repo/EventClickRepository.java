package com.example.gt_events.repo;

import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.EventClick;
import com.example.gt_events.entity.Tag;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface EventClickRepository extends JpaRepository<EventClick, Long> {
    Optional<EventClick> findByEventId(Event e);

//    List<EventClick> findTop3ByOrderByNumClickDesc();
//    long countByEventIdAndByEventDateBetween(Event e, Date startDate, Date endDate);
    List<EventClick> findByClickDateBetween(Date startDate, Date endDate);

    void deleteAllByEvent(Event e);
    List<EventClick> findAllByEvent(Event e);

}