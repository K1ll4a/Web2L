
(function () {
    const form    = document.getElementById('form');
    const xBtns   = document.getElementById('xButtons');
    const xField  = document.getElementById('xField');
    const yField  = document.getElementById('yField');
    const rField  = document.getElementById('rField');
    const errEl   = document.getElementById('error');

    const img     = document.getElementById('graph');
    const wrap    = document.getElementById('imgWrap');
    const overlay = document.getElementById('overlay');
    const ctx     = overlay.getContext('2d');


    const PADDING = { left: 0, right: 0, top: 0, bottom: 0 };



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


    function fitOverlay() {
        const w = img.clientWidth, h = img.clientHeight;
        overlay.width  = w;
        overlay.height = h;
        overlay.style.width  = w + 'px';
        overlay.style.height = h + 'px';
        clearOverlay();
    }
    function clearOverlay(){ ctx.clearRect(0,0,overlay.width, overlay.height); }
    function drawPoint(px, py) {
        clearOverlay();
        ctx.beginPath(); ctx.arc(px, py, 4, 0, Math.PI*2); ctx.fillStyle = '#ffffff'; ctx.fill();
    }


    if (img.complete) fitOverlay(); else img.onload = fitOverlay;
    window.addEventListener('resize', fitOverlay);


    overlay.addEventListener('click', (e) => {
        if (!rField.value) { errEl.textContent = 'Сначала выберите R.'; return; }

        const rect = overlay.getBoundingClientRect();
        let px = e.clientX - rect.left;
        let py = e.clientY - rect.top;


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
            errEl.textContent = 'Y вне диапазона [−5;5]. При необходимости скорректируй PADDING или R.';
            return;
        }
        form.submit();
    });
})();
