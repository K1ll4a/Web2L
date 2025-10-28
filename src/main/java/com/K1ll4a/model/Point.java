package com.K1ll4a.model;

import java.io.Serializable;

public class Point implements Serializable {
    private double x;
    private double y;
    private double r;

    public Point(double x, double y, double r) {
        this.x = x; this.y = y; this.r = r;
    }
    public double getX() { return x; }
    public double getY() { return y; }
    public double getR() { return r; }

    @Override public String toString() {
        return "Point{x=" + x + ", y=" + y + ", r=" + r + '}';
    }
}
