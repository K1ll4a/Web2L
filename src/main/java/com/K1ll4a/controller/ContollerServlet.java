package com.K1ll4a.controller;

import com.K1ll4a.sevice.ValidationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/controller"})
public class ContollerServlet extends HttpServlet {
    private final ValidationService validator = new ValidationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Object lastR = req.getSession().getAttribute("lastR");
        if (lastR != null) req.setAttribute("lastR", lastR);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        ValidationService.Parsed parsed = validator.parse(req);

        if (!parsed.ok()) {
            req.setAttribute("errors", parsed.errors);
            req.setAttribute("x", req.getParameter("x"));
            req.setAttribute("y", req.getParameter("y"));
            req.setAttribute("lastR", req.getParameter("r"));
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        // точные значения далее в AreaCheck
        req.setAttribute("x", parsed.x);
        req.setAttribute("y", parsed.y);
        req.setAttribute("r", parsed.r);

        // запомним последний R в сессии для отрисовки истории
        req.getSession().setAttribute("lastR", parsed.r);

        req.getRequestDispatcher("/area-check").forward(req, resp);
    }
}
