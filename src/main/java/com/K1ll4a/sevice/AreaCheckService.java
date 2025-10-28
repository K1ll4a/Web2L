package com.K1ll4a.sevice;

public class AreaCheckService {

    public boolean isHit(double x, double y, double r) {
        return inRect(x, y, r) || inQuarter(x, y, r) || inTriangle(x, y, r);
    }


    private boolean inRect(double x, double y, double r) {
        return (x >= -r && x <= 0) && (y >= 0 && y <= r);
    }


    private boolean inQuarter(double x, double y, double r) {
        if (x < 0 || y < 0) return false;
        double rad = r / 2.0;
        return x * x + y * y <= rad * rad + 1e-9;
    }


    private boolean inTriangle(double x, double y, double r) {
        double ax = -r, ay = 0;
        double bx = 0,  by = -r / 2.0;
        double cx = -r / 2.0, cy = -r;


        double d1 = sign(x, y, ax, ay, bx, by);
        double d2 = sign(x, y, bx, by, cx, cy);
        double d3 = sign(x, y, cx, cy, ax, ay);

        boolean hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
        boolean hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);
        return !(hasNeg && hasPos);
    }

    private double sign(double px, double py, double x1, double y1, double x2, double y2) {
        return (px - x2) * (y1 - y2) - (x1 - x2) * (py - y2);
    }
}
