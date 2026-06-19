// AeroFighter app — GAME OVER and SYSTEM PAUSED modals.
function GameOverModal({ score = 48250, best = 112400, onRelaunch, onAbort }) {
  const { GlassModal, Button } = window.AeroFighterDesignSystem_9520d9;
  const pad = (n) => n.toString().padStart(6, '0');
  const isBest = score >= best;
  return (
    <GlassModal accent="var(--af-danger)" glow onScrimClick={onAbort} width={320}>
      <div style={{ textAlign: 'center' }}>
        <div style={{ fontFamily: 'var(--af-font-display)', fontSize: 34, fontWeight: 700, letterSpacing: '4px', color: 'var(--af-danger)', textShadow: 'var(--af-text-glow-danger)' }}>GAME OVER</div>
        <div style={{ height: 22 }} />
        <div style={{ color: 'var(--af-text-muted)', fontSize: 12, letterSpacing: '2px', fontFamily: 'var(--af-font-ui)' }}>FINAL SCORE:</div>
        <div style={{ fontFamily: 'var(--af-font-mono)', fontSize: 30, color: 'var(--af-blue-soft)', letterSpacing: '2px', margin: '4px 0 18px' }}>{pad(score)}</div>
        <div style={{ color: 'var(--af-text-muted)', fontSize: 11, letterSpacing: '2px', fontFamily: 'var(--af-font-ui)' }}>{isBest ? 'NEW PERSONAL BEST' : 'PERSONAL BEST'}</div>
        <div style={{ fontFamily: 'var(--af-font-mono)', fontSize: 18, color: 'var(--af-gold)', letterSpacing: '2px', margin: '2px 0 24px' }}>{pad(best)}</div>
        <Button block variant="primary" icon="rocket_launch" onClick={onRelaunch}>Re-launch Mission</Button>
        <div style={{ height: 12 }} />
        <Button block variant="danger" onClick={onAbort}>Abort to Menu</Button>
      </div>
    </GlassModal>
  );
}
window.GameOverModal = GameOverModal;

function PausedModal({ onResume, onAbort }) {
  const { GlassModal, Button } = window.AeroFighterDesignSystem_9520d9;
  return (
    <GlassModal accent="var(--af-cyan-mid)" onScrimClick={onResume} width={300}>
      <div style={{ textAlign: 'center' }}>
        <div style={{ fontFamily: 'var(--af-font-display)', fontSize: 28, fontWeight: 700, letterSpacing: '3px', color: 'var(--af-cyan)' }}>SYSTEM PAUSED</div>
        <div style={{ height: 24 }} />
        <Button block variant="primary" icon="play_arrow" onClick={onResume}>Resume Mission</Button>
        <div style={{ height: 12 }} />
        <Button block variant="danger" onClick={onAbort}>Abort to Menu</Button>
      </div>
    </GlassModal>
  );
}
window.PausedModal = PausedModal;
