---
title:  "Dots and Boxes"
date:   2026-02-14 12:00:00 -0800
---

<p>I love the game Dots and Boxes. Graeme and I play it while we're waiting to be served in restaurants and have for years. He usually wins.</p>

<style>
  .dab-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-family: sans-serif;
    user-select: none;
  }
  .dab-info {
    margin-bottom: 12px;
    font-size: 1.1em;
  }
  .dab-score {
    display: flex;
    gap: 32px;
    margin-bottom: 12px;
    font-size: 1.1em;
    font-weight: bold;
  }
  .dab-score span {
    padding: 4px 12px;
    border-radius: 6px;
  }
  .dab-p1 { color: #2563eb; }
  .dab-p2 { color: #dc2626; }
  .dab-active { text-decoration: underline; }
  #dab-board {
    cursor: pointer;
  }
  #dab-reset {
    margin-top: 16px;
    padding: 8px 24px;
    font-size: 1em;
    cursor: pointer;
    border: 1px solid #888;
    border-radius: 6px;
    background: #f5f5f5;
  }
  #dab-reset:hover { background: #e0e0e0; }
  #dab-message {
    margin-top: 8px;
    font-size: 1.2em;
    font-weight: bold;
    min-height: 1.5em;
  }
</style>

<div class="dab-container">
  <div class="dab-score">
    <span class="dab-p1" id="dab-s1">Player 1: 0</span>
    <span class="dab-p2" id="dab-s2">Player 2: 0</span>
  </div>
  <div class="dab-info" id="dab-turn">Player 1's turn</div>
  <canvas id="dab-board"></canvas>
  <div id="dab-message"></div>
  <button id="dab-reset">New Game</button>
</div>

<script>
(function() {
  const N = 8; // 8x8 grid of boxes means 9x9 dots
  const DOTS = N + 1;
  const DOT_R = 5;
  const CELL = 52;
  const PAD = 20;
  const LINE_W = 4;
  const HIT = 12;

  const P1_COLOR = '#2563eb';
  const P2_COLOR = '#dc2626';
  const P1_FILL = 'rgba(37,99,235,0.18)';
  const P2_FILL = 'rgba(220,38,38,0.18)';
  const LINE_DEFAULT = '#ccc';

  // hLines[row][col] = 0 (none), 1 (p1), 2 (p2)
  // hLines has DOTS rows, N cols
  let hLines, vLines, boxes, scores, turn, gameOver;

  const canvas = document.getElementById('dab-board');
  const ctx = canvas.getContext('2d');
  const size = PAD * 2 + (DOTS - 1) * CELL;
  canvas.width = size;
  canvas.height = size;

  function init() {
    hLines = Array.from({length: DOTS}, () => new Uint8Array(N));
    vLines = Array.from({length: N}, () => new Uint8Array(DOTS));
    boxes = Array.from({length: N}, () => new Uint8Array(N));
    scores = [0, 0];
    turn = 1;
    gameOver = false;
    updateUI();
    draw();
  }

  function dotX(c) { return PAD + c * CELL; }
  function dotY(r) { return PAD + r * CELL; }

  function draw() {
    ctx.clearRect(0, 0, size, size);

    // boxes
    for (let r = 0; r < N; r++) {
      for (let c = 0; c < N; c++) {
        if (boxes[r][c]) {
          ctx.fillStyle = boxes[r][c] === 1 ? P1_FILL : P2_FILL;
          ctx.fillRect(dotX(c), dotY(r), CELL, CELL);
        }
      }
    }

    // horizontal lines
    for (let r = 0; r < DOTS; r++) {
      for (let c = 0; c < N; c++) {
        ctx.strokeStyle = hLines[r][c] ? (hLines[r][c] === 1 ? P1_COLOR : P2_COLOR) : LINE_DEFAULT;
        ctx.lineWidth = hLines[r][c] ? LINE_W + 1 : LINE_W;
        ctx.beginPath();
        ctx.moveTo(dotX(c), dotY(r));
        ctx.lineTo(dotX(c + 1), dotY(r));
        ctx.stroke();
      }
    }

    // vertical lines
    for (let r = 0; r < N; r++) {
      for (let c = 0; c < DOTS; c++) {
        ctx.strokeStyle = vLines[r][c] ? (vLines[r][c] === 1 ? P1_COLOR : P2_COLOR) : LINE_DEFAULT;
        ctx.lineWidth = vLines[r][c] ? LINE_W + 1 : LINE_W;
        ctx.beginPath();
        ctx.moveTo(dotX(c), dotY(r));
        ctx.lineTo(dotX(c), dotY(r + 1));
        ctx.stroke();
      }
    }

    // dots
    for (let r = 0; r < DOTS; r++) {
      for (let c = 0; c < DOTS; c++) {
        ctx.beginPath();
        ctx.arc(dotX(c), dotY(r), DOT_R, 0, Math.PI * 2);
        ctx.fillStyle = '#333';
        ctx.fill();
      }
    }
  }

  function checkBoxes() {
    let claimed = 0;
    for (let r = 0; r < N; r++) {
      for (let c = 0; c < N; c++) {
        if (boxes[r][c]) continue;
        if (hLines[r][c] && hLines[r + 1][c] && vLines[r][c] && vLines[r][c + 1]) {
          boxes[r][c] = turn;
          scores[turn - 1]++;
          claimed++;
        }
      }
    }
    return claimed;
  }

  function updateUI() {
    document.getElementById('dab-s1').textContent = 'Player 1: ' + scores[0];
    document.getElementById('dab-s2').textContent = 'Player 2: ' + scores[1];
    document.getElementById('dab-s1').className = 'dab-p1' + (turn === 1 && !gameOver ? ' dab-active' : '');
    document.getElementById('dab-s2').className = 'dab-p2' + (turn === 2 && !gameOver ? ' dab-active' : '');
    const turnEl = document.getElementById('dab-turn');
    const msgEl = document.getElementById('dab-message');
    if (gameOver) {
      turnEl.textContent = '';
      if (scores[0] > scores[1]) msgEl.textContent = 'Player 1 wins!';
      else if (scores[1] > scores[0]) msgEl.textContent = 'Player 2 wins!';
      else msgEl.textContent = "It's a tie!";
    } else {
      turnEl.textContent = 'Player ' + turn + "'s turn";
      msgEl.textContent = '';
    }
  }

  canvas.addEventListener('click', function(e) {
    if (gameOver) return;
    const rect = canvas.getBoundingClientRect();
    const mx = (e.clientX - rect.left) * (canvas.width / rect.width);
    const my = (e.clientY - rect.top) * (canvas.height / rect.height);

    let best = null, bestDist = HIT;

    // check horizontal lines
    for (let r = 0; r < DOTS; r++) {
      for (let c = 0; c < N; c++) {
        if (hLines[r][c]) continue;
        const cx = (dotX(c) + dotX(c + 1)) / 2;
        const cy = dotY(r);
        const dx = Math.abs(mx - cx);
        const dy = Math.abs(my - cy);
        if (dx <= CELL / 2 && dy <= HIT) {
          const d = dy;
          if (d < bestDist) { bestDist = d; best = {type: 'h', r, c}; }
        }
      }
    }

    // check vertical lines
    for (let r = 0; r < N; r++) {
      for (let c = 0; c < DOTS; c++) {
        if (vLines[r][c]) continue;
        const cx = dotX(c);
        const cy = (dotY(r) + dotY(r + 1)) / 2;
        const dx = Math.abs(mx - cx);
        const dy = Math.abs(my - cy);
        if (dy <= CELL / 2 && dx <= HIT) {
          const d = dx;
          if (d < bestDist) { bestDist = d; best = {type: 'v', r, c}; }
        }
      }
    }

    if (!best) return;

    if (best.type === 'h') hLines[best.r][best.c] = turn;
    else vLines[best.r][best.c] = turn;

    const claimed = checkBoxes();
    const totalBoxes = scores[0] + scores[1];

    if (totalBoxes === N * N) {
      gameOver = true;
    } else if (claimed === 0) {
      turn = turn === 1 ? 2 : 1;
    }
    // if claimed > 0, same player goes again

    updateUI();
    draw();
  });

  // hover effect
  canvas.addEventListener('mousemove', function(e) {
    if (gameOver) { canvas.style.cursor = 'default'; return; }
    const rect = canvas.getBoundingClientRect();
    const mx = (e.clientX - rect.left) * (canvas.width / rect.width);
    const my = (e.clientY - rect.top) * (canvas.height / rect.height);

    let hovering = false;
    for (let r = 0; r < DOTS && !hovering; r++) {
      for (let c = 0; c < N && !hovering; c++) {
        if (hLines[r][c]) continue;
        const cx = (dotX(c) + dotX(c + 1)) / 2;
        const cy = dotY(r);
        if (Math.abs(mx - cx) <= CELL / 2 && Math.abs(my - cy) <= HIT) hovering = true;
      }
    }
    for (let r = 0; r < N && !hovering; r++) {
      for (let c = 0; c < DOTS && !hovering; c++) {
        if (vLines[r][c]) continue;
        const cx = dotX(c);
        const cy = (dotY(r) + dotY(r + 1)) / 2;
        if (Math.abs(my - cy) <= CELL / 2 && Math.abs(mx - cx) <= HIT) hovering = true;
      }
    }
    canvas.style.cursor = hovering ? 'pointer' : 'default';
  });

  document.getElementById('dab-reset').addEventListener('click', init);
  init();
})();
</script>
