package com.K1ll4a.sevice;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

public class ValidationService {

    public static class Parsed {
        public final Double x, y, r;
        public final List<String> errors;
        public Parsed(Double x, Double y, Double r, List<String> errors) {
            this.x = x; this.y = y; this.r = r; this.errors = errors;
        }
        public boolean ok() { return errors.isEmpty(); }
    }

    public Parsed parse(HttpServletRequest req) {
        List<String> errors = new ArrayList<>();
        Double x = null, y = null, r = null;

        String xs = req.getParameter("x");
        String ys = req.getParameter("y");
        String rs = req.getParameter("r");

        try { if (xs != null) x = Double.valueOf(xs.replace(',', '.')); }
        catch (Exception e) { errors.add("Некорректный X"); }

        try { if (ys != null) y = Double.valueOf(ys.replace(',', '.')); }
        catch (Exception e) { errors.add("Некорректный Y"); }

        try { if (rs != null) r = Double.valueOf(rs.replace(',', '.')); }
        catch (Exception e) { errors.add("Некорректный R"); }


        if (y == null || y < -5 || y > 5) errors.add("Y должен быть в диапазоне [-5; 5]");
        if (r == null || !(r == 1 || r == 2 || r == 3 || r == 4 || r == 5)) errors.add("R ∈ {1,2,3,4,5}");
        if (x == null || x < -5 || x > 3) errors.add("X должен быть в диапазоне [-5; 3]");

        return new Parsed(x, y, r, errors);
    }
}
