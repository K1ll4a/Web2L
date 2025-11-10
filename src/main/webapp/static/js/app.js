(function () {
    const form    = document.getElementById('form');
    const xBtns   = document.getElementById('xButtons');
    const xField  = document.getElementById('xField');
    const yField  = document.getElementById('yField');
    const rField  = document.getElementById('rField');
    const errEl   = document.getElementById('error');

    const img     = document.getElementById('graph');
    const overlay = document.getElementById('overlay');
    const ctx     = overlay.getContext('2d');

    const PADDING = { left: 0, right: 0, top: 0, bottom: 0 };

    // Выбор X кнопками
    xBtns.addEventListener('click', (e) => {
        const btn = e.target.closest('button[data-x]');
        if (!btn) return;
        [...xBtns.querySelectorAll('.btn')].forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        xField.value = btn.dataset.x;
    });

    function parseNum(v){ return v.replace(',', '.'); }
    function validateAll() {
        errEl.textContent = '';
        if (!xField.value) { errEl.textContent = 'Выберите X.'; return false; }
        const yv = parseFloat(parseNum(yField.value));
        if (isNaN(yv) || yv < -5 || yv > 5) { errEl.textContent = 'Y должен быть числом от −5 до 5.'; return false; }
        if (!rField.value) { errEl.textContent = 'Выберите R.'; return false; }
        return true;
    }
    form.addEventListener('submit', e => { if (!validateAll()) e.preventDefault(); });

    // Подгон холста под картинку
    function fitOverlay() {
        const w = img.clientWidth, h = img.clientHeight;
        overlay.width  = w;
        overlay.height = h;
        overlay.style.width  = w + 'px';
        overlay.style.height = h + 'px';
        clearOverlay();
    }
    function clearOverlay(){ ctx.clearRect(0,0,overlay.width, overlay.height); }

    // Рисование истории точек — теперь БЕЗ фильтра по R
    function drawCircle(px, py, ok) {
        ctx.beginPath();
        ctx.arc(px, py, 4, 0, Math.PI * 2);
        ctx.fillStyle = ok ? '#39c16c' : '#e05555'; // попал / мимо
        ctx.fill();
    }
    function drawHistory() {
        if (!window.HIT_HISTORY || !window.HIT_HISTORY.length) return;

        const usableW = overlay.width  - (PADDING.left + PADDING.right);
        const usableH = overlay.height - (PADDING.top  + PADDING.bottom);
        const cx = PADDING.left + usableW / 2;
        const cy = PADDING.top  + usableH / 2;

        // ВАЖНО: для каждой точки используем её СОБСТВЕННЫЙ R при переводе в пиксели.
        window.HIT_HISTORY.forEach(p => {
            const R = +p.r || 1; // защита от нуля/пустого
            const pxPerUnit = usableW / (2 * R);
            const px = cx + p.x * pxPerUnit;
            const py = cy - p.y * pxPerUnit;
            drawCircle(px, py, !!p.hit);
        });
    }

    // Текущая кликнутая точка поверх истории
    function drawPoint(px, py) {
        clearOverlay();
        drawHistory();
        ctx.beginPath();
        ctx.arc(px, py, 4, 0, Math.PI * 2);
        ctx.fillStyle = '#ffffff';
        ctx.fill();
    }

    // Инициализация
    if (img.complete) { fitOverlay(); drawHistory(); }
    else img.onload = function(){ fitOverlay(); drawHistory(); };

    window.addEventListener('resize', () => { fitOverlay(); drawHistory(); });

    // При смене текущего R мы больше НИЧЕГО не фильтруем — просто перерисовываем историю
    rField.addEventListener('change', () => { clearOverlay(); drawHistory(); });

    // Клик по графику → считаем X,Y по ТЕКУЩЕМУ R и сабмитим форму
    overlay.addEventListener('click', (e) => {
        if (!rField.value) { errEl.textContent = 'Сначала выберите R.'; return; }

        const rect = overlay.getBoundingClientRect();
        const px = e.clientX - rect.left;
        const py = e.clientY - rect.top;

        const usableW = overlay.width  - (PADDING.left + PADDING.right);
        const usableH = overlay.height - (PADDING.top  + PADDING.bottom);
        const cx = PADDING.left + usableW / 2;
        const cy = PADDING.top  + usableH / 2;

        const R = parseFloat(rField.value);
        const pxPerUnit = usableW / (2 * R);

        const x =  (px - cx) / pxPerUnit;
        const y = -(py - cy) / pxPerUnit;

        xField.value = x.toFixed(4);
        yField.value = y.toFixed(4);
        drawPoint(px, py);

        const yv = parseFloat(yField.value);
        if (isNaN(yv) || yv < -5 || yv > 5) {
            errEl.textContent = 'Y вне диапазона [−5;5].';
            return;
        }
        form.submit();
    });

    // Автовыбор последнего R (не обязателен, но полезен)
    if (window.LAST_R && !rField.value) {
        rField.value = String(window.LAST_R);
        if (overlay.width) { clearOverlay(); drawHistory(); }
    }
})();
