// AeroFighter app — gameplay HUD over the scrolling sky.
// Tap the field to score (floating +pts); TAKE HIT damages you toward GAME OVER.
function GameplayHUD({ world, score = 48250, lives = 3, onScore, onHit, onPause }) {
  const { ProgressBar, PowerUpBadge } = window.AeroFighterDesignSystem_9520d9;
  const STRIP = '../../assets/sprites/powerups_strip_128.png';
  const pad = (n) => n.toString().padStart(6, '0');
  const [floats, setFloats] = React.useState([]);
  const [combo, setCombo] = React.useState(0);
  const comboTimer = React.useRef(null);
  const accent = (world && world.accent) || 'var(--af-world-midday)';
  const bg = (world && world.bg) || 'bg_midday';
  const level = (world && world.level) || '2-3';

  const spawnFloat = (e) => {
    const host = e.currentTarget.getBoundingClientRect();
    const x = ((e.clientX - host.left) / host.width) * 100;
    const y = ((e.clientY - host.top) / host.height) * 100;
    const id = Math.random().toString(36).slice(2);
    setFloats((f) => [...f, { id, x, y, text: '+250' }]);
    setTimeout(() => setFloats((f) => f.filter((it) => it.id !== id)), 850);
    setCombo((c) => c + 1);
    clearTimeout(comboTimer.current);
    comboTimer.current = setTimeout(() => setCombo(0), 1400);
    onScore && onScore();
  };

  return (
    <div
      onClick={spawnFloat}
      style={{
        position: 'absolute', inset: 0, overflow: 'hidden', cursor: 'crosshair',
        backgroundImage: `url(../../assets/backgrounds/${bg}.png)`,
        backgroundSize: 'cover', backgroundPosition: 'center',
      }}
    >
      <div style={{ position: 'absolute', inset: 0, background: 'var(--af-grad-hud-vignette)', pointerEvents: 'none' }} />
      <div className="hud-scanlines" style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }} />
      {/* sector accent top edge */}
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, height: 3, background: accent, boxShadow: `0 0 12px ${accent}`, opacity: 0.8, pointerEvents: 'none' }} />

      {/* Top HUD row */}
      <div style={{ position: 'absolute', top: 14, left: 16, right: 16, display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', pointerEvents: 'none' }}>
        <div>
          <div style={{ fontFamily: 'var(--af-font-mono)', fontSize: 18, color: 'var(--af-blue-soft)', letterSpacing: '1px', textShadow: 'var(--af-text-shadow-hud)' }}>SCORE: {pad(score)}</div>
          <div style={{ marginTop: 6, display: 'flex', alignItems: 'center', gap: 4 }}>
            {Array.from({ length: lives }).map((_, i) => (
              <span key={i} className="material-symbols-rounded" style={{ color: 'var(--af-danger)', fontSize: 18, textShadow: 'var(--af-text-shadow-hud)' }}>favorite</span>
            ))}
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <button onClick={(e) => { e.stopPropagation(); onPause && onPause(); }} style={{
            width: 44, height: 44, borderRadius: 'var(--af-radius-md)', cursor: 'pointer', pointerEvents: 'auto',
            background: 'rgba(0,5,15,0.5)', border: '1.5px solid rgba(0,238,255,0.5)', color: 'var(--af-cyan)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <span className="material-symbols-rounded" style={{ fontSize: 24 }}>pause</span>
          </button>
          <div style={{ marginTop: 8, fontFamily: 'var(--af-font-mono)', fontSize: 12, color: accent, letterSpacing: '1px', textShadow: 'var(--af-text-shadow-hud)' }}>LVL {level}</div>
        </div>
      </div>

      {/* Combo */}
      {combo >= 2 && (
        <div key={combo} style={{ position: 'absolute', top: 96, left: 0, right: 0, textAlign: 'center', pointerEvents: 'none' }}>
          <span className="af-combo-pop" style={{ display: 'inline-block', fontFamily: 'var(--af-font-display)', fontWeight: 700, fontStyle: 'italic', fontSize: 22, color: 'var(--af-orange)', letterSpacing: '2px', textShadow: 'var(--af-text-glow-orange)' }}>x{combo} COMBO</span>
        </div>
      )}

      {/* Floating score popups */}
      {floats.map((f) => (
        <span key={f.id} className="af-float" style={{
          position: 'absolute', left: `${f.x}%`, top: `${f.y}%`, transform: 'translate(-50%,-50%)',
          fontFamily: 'var(--af-font-mono)', fontSize: 18, fontWeight: 700, color: 'var(--af-gold)',
          textShadow: '0 0 10px rgba(255,215,0,0.8)', pointerEvents: 'none',
        }}>{f.text}</span>
      ))}

      {/* Player jet */}
      <img src="../../assets/sprites/jet_2_level.png" alt="" style={{
        position: 'absolute', bottom: 150, left: '50%', width: 96, transform: 'translateX(-50%)',
        filter: 'drop-shadow(0 0 12px rgba(0,170,255,0.6))', pointerEvents: 'none',
      }} />

      {/* TAKE HIT control */}
      <button onClick={(e) => { e.stopPropagation(); onHit && onHit(); }} style={{
        position: 'absolute', bottom: 122, left: '50%', transform: 'translateX(-50%)', pointerEvents: 'auto',
        padding: '6px 14px', borderRadius: 'var(--af-radius-pill)', cursor: 'pointer',
        background: 'rgba(40,0,8,0.6)', border: '1.5px solid var(--af-danger)', color: 'var(--af-danger)',
        fontFamily: 'var(--af-font-ui)', fontSize: 9, fontWeight: 700, letterSpacing: '2px', textTransform: 'uppercase',
      }}>Simulate Hit</button>

      {/* Active power-up timers (pulsing) */}
      <div style={{ position: 'absolute', bottom: 64, left: 16, right: 16, display: 'flex', gap: 14, justifyContent: 'center', pointerEvents: 'none' }}>
        {['rapidFire', 'armor', 'missiles'].map((t, i) => (
          <span key={t} className="af-pulse" style={{ animationDelay: `${i * 0.4}s` }}>
            <PowerUpBadge type={t} src={STRIP} size={44} />
          </span>
        ))}
      </div>

      {/* Kill progress */}
      <div style={{ position: 'absolute', bottom: 26, left: 16, right: 16, pointerEvents: 'none' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 5 }}>
          <span style={{ fontFamily: 'var(--af-font-ui)', fontSize: 9, letterSpacing: '1px', color: 'var(--af-text-dim)', textShadow: 'var(--af-text-shadow-hud)' }}>SECTOR CLEAR</span>
          <span style={{ fontFamily: 'var(--af-font-mono)', fontSize: 9, color: 'var(--af-text-dim)', textShadow: 'var(--af-text-shadow-hud)' }}>18 / 25</span>
        </div>
        <ProgressBar value={18 / 25} color={accent} />
      </div>
    </div>
  );
}
window.GameplayHUD = GameplayHUD;
