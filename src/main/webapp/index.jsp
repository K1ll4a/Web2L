<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Определение попадания точки в область</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <style>
        body { font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, "Helvetica Neue", Arial; background:#0f1622; color:#e4ecfb; }
        .wrap { max-width: 1100px; margin: 36px auto; padding: 24px; background:#0c1220; border-radius:16px; }
        .row { margin: 12px 0; }
        label { display:block; margin-bottom:6px; opacity:.9 }
        .btn { padding:8px 14px; border-radius:10px; background:#1e2b47; color:#e4ecfb; border:1px solid #314267; cursor:pointer; }
        .btn:hover { background:#243457; }
        .btn.active { background:#2f6fec; border-color:#2f6fec; }
        .btn-outline { background:transparent; border:1px solid #314267; color:#e4ecfb; }
        .grid { display:grid; grid-template-columns: 1fr 360px; gap:28px; align-items:flex-start; }
        input, select { width:100%; padding:12px 14px; border-radius:12px; border:1px solid #314267; background:#0f1a33; color:#e4ecfb; }
        table { width:100%; border-collapse: collapse; margin-top: 16px; }
        th, td { padding:10px 8px; border-bottom:1px solid #223154; }
        .ok { color:#39c16c; }
        .err { color:#ff7b7b; }
        #imgWrap { position:relative; display:inline-block; }
        #overlay { position:absolute; left:0; top:0; }
        .hint { font-size: 13px; opacity:.7; margin-top:6px; }
        .error { margin-top:8px; color:#ff7b7b; min-height: 1.2em; }
    </style>
</head>
<body>
<div class="wrap">
    <h2>Определение попадания точки в область</h2>

    <div class="grid">

        <!-- Левая колонка: форма -->
        <div>

            <form id="form" method="post" action="${pageContext.request.contextPath}/controller">
                <!-- X -->
                <div class="row">
                    <label>Изменение X: {−5 … 3}</label>
                    <div id="xButtons">
                        <c:forEach var="xv" items="${fn:split('-5,-4,-3,-2,-1,0,1,2,3', ',')}">
                            <button type="button" class="btn" data-x="${xv}">${xv}</button>
                        </c:forEach>
                    </div>

                    <input type="hidden" id="xField" name="x" value="${x}"/>
                    <div class="hint">Выберите одно значение X.</div>
                </div>

                <!-- Y -->
                <div class="row">
                    <label>Изменение Y: текст (−5 … 5)</label>
                    <input id="yField" name="y" placeholder="например, 1.5" value="${y}" />
                </div>

                <!-- R -->
                <div class="row">
                    <label>Изменение R: {1, 2, 3, 4, 5}</label>
                    <select id="rField" name="r" required>
                        <option value="">Выберите радиус R</option>
                        <c:forEach var="rv" begin="1" end="5">
                            <option value="${rv}" <c:if test="${sessionScope.lastR == rv}">selected</c:if>>${rv}</option>
                        </c:forEach>
                    </select>
                </div>

                <div id="error" class="error">
                    <c:if test="${not empty errors}">
                        ${errors}
                    </c:if>
                </div>

                <div class="row">
                    <button class="btn" type="submit">Проверить (POST)</button>
                </div>
            </form>

            <!-- История -->
            <div class="row">
                <h3>История проверок</h3>
                <form method="post" action="${pageContext.request.contextPath}/history/clear">
                    <button type="submit" class="btn btn-outline">Очистить историю</button>
                </form>

                <c:choose>
                    <c:when test="${not empty sessionScope.hits and not empty sessionScope.hits.history}">
                        <table>
                            <thead>
                            <tr><th>Дата</th><th>Время</th><th>X</th><th>Y</th><th>R</th><th>Результат</th></tr>
                            </thead>
                            <tbody>
                            <c:forEach var="h" items="${sessionScope.hits.history}">
                                <tr>
                                    <td>${h.dateStr}</td>
                                    <td>${h.timeStr}</td>
                                    <td>${h.point.x}</td>
                                    <td>${h.point.y}</td>
                                    <td>${h.point.r}</td>
                                    <td><span class="${h.hit ? 'ok' : 'err'}">${h.hit ? 'попадание' : 'мимо'}</span></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise><div class="hint">История пуста.</div></c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Правая колонка: изображение + холст -->
        <div>
            <div class="row"><label>График области</label></div>
            <div id="imgWrap">
                <img id="graph" src="${pageContext.request.contextPath}/static/images/graph.png" alt="area">
                <canvas id="overlay"></canvas>
            </div>
            <div class="hint">Выберите R и кликните по изображению — X,Y.</div>
        </div>

    </div>
</div>

<!-- Сериализуем историю для рисования на графике -->
<script>
    window.HIT_HISTORY = [
        <c:forEach items="${sessionScope.hits.history}" var="h" varStatus="st">
        { x: ${h.point.x}, y: ${h.point.y}, r: ${h.point.r}, hit: ${h.hit} }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    window.LAST_R = '${sessionScope.lastR}';
</script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>
