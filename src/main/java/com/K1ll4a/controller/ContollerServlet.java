package com.K1ll4a.controller;

import com.K1ll4a.sevice.ValidationService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/controller"})
public class ContollerServlet extends HttpServlet {

    private final ValidationService validator = new ValidationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RequestDispatcher rd = req.getRequestDispatcher("/index.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {


        ValidationService.Parsed parsed = validator.parse(req);

        if (!parsed.ok()) {

            req.setAttribute("errors", parsed.errors);
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }


        req.setAttribute("x", parsed.x);
        req.setAttribute("y", parsed.y);
        req.setAttribute("r", parsed.r);


        req.getRequestDispatcher("/area-check").forward(req, resp);
    }
}
