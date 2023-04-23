package com.example.gt_events.repo;

import com.example.gt_events.entity.Event;
import com.example.gt_events.entity.Tag;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {
     Page<Event> findAll(Pageable pageable);

     Page<Event> findByEventDateBetween(Date startDate, Date endDate, Pageable pageable);

     List<Event> findAllByEventDateBetween(Date startDate, Date endDate);

     Page<Event> findByEventCreationDateBetween(Date startDate, Date endDate, Pageable pageable);

     Page<Event> findByTitleContainingOrAuthor_UsernameContaining(String keywordTitle, String keywordUsername, Pageable pageable);

     List<Event> findAllByTagsIn(List<Tag> tags);

     List<Event> findAllByEventDateBetweenAndTagsIn(Date startDate, Date endDate, List<Tag> tags);
}
