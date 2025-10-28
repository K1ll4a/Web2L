package com.K1ll4a.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class HitResult implements Serializable {
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm:ss");

    private final Point point;
    private final boolean hit;
    private final LocalDateTime timestamp;

    public HitResult(Point point, boolean hit, LocalDateTime timestamp) {
        this.point = point;
        this.hit = hit;
        this.timestamp = timestamp;
    }

    public Point getPoint() { return point; }
    public boolean isHit() { return hit; }
    public LocalDateTime getTimestamp() { return timestamp; }


    public String getDateStr() {
        return timestamp.toLocalDate().toString();
    }
    public String getTimeStr() {
        return timestamp.toLocalTime().truncatedTo(ChronoUnit.SECONDS).format(TIME_FMT);
    }
}
