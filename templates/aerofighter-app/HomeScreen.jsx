// AeroFighter app — HOME tab. Sector selector + reticle + SCRAMBLE launcher, status panels, action pills.
function HomeScreen({ onScramble, worldIndex = 1, onSelectWorld = () => {} }) {
  const NS = window.AeroFighterDesignSystem_9520d9;
  const { Button, Panel, ProgressBar, Badge } = NS;
  const WORLDS = NS.WORLDS || [
    { id: 1, name: 'DAWN SECTOR',  accent: 'var(--af-world-dawn)' },
    { id: 2, name: 'MIDDAY FRONT', accent: 'var(--af-world-midday)' },
    { id: 3, name: 'DUSK ZONE',    accent: 'var(--af-world-dusk)' },
    { id: 4, name: 'NIGHT OPS',    accent: 'var(--af-world-night)' },
  ];
  const WorldChip = NS.WorldChip || function FallbackWorldChip({ id, name, accent, selected, onClick }) {
    return (
      <button onClick={onClick} style={{ display: 'flex', alignItems: 'center', gap: 10, flex: '0 0 auto', padding: '8px 14px', cursor: 'pointer', whiteSpace: 'nowrap', borderRadius: 'var(--af-radius-md)', background: selected ? 'rgba(0,170,255,0.16)' : 'rgba(0,0,0,0.25)', border: selected ? '2px solid ' + accent : '1.2px solid var(--af-border-inactive)' }}>
        <span style={{ width: 12, height: 12, borderRadius: '999px', background: accent, boxShadow: '0 0 8px ' + accent }} />
        <div style={{ textAlign: 'left' }}>
          <div style={{ fontFamily: 'var(--af-font-mono)', fontSize: 9, letterSpacing: '1px', color: 'var(--af-text-muted)' }}>W{id}</div>
          <div style={{ fontFamily: 'var(--af-font-ui)', fontSize: 11, fontWeight: 700, letterSpacing: '1px', color: selected ? 'var(--af-text)' : 'var(--af-text-muted)' }}>{name}</div>
        </div>
      </button>
    );
  };
  const world = WORLDS[worldIndex] || WORLDS[0];

  const StatusPanel = ({ title, status, value, color }) => (
    <Panel padding="14px 16px" style={{ flex: 1 }}>
      <div style={{ color: 'var(--af-cyan-mid)', fontSize: 10, fontWeight: 700, letterSpacing: '1px' }}>{title}</div>
      <div style={{ height: 8 }} />
      <ProgressBar value={value} color={color} glow={false} />
      <div style={{ height: 6 }} />
      <div style={{ textAlign: 'right', color: 'var(--af-text)', fontFamily: 'var(--af-font-mono)', fontSize: 11, letterSpacing: '1px' }}>{status}</div>
    </Panel>
  );

  const ActionPill = ({ icon, label, dot }) => (
    <div style={{
      flex: 1, height: 60, position: 'relative',
      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      background: 'rgba(5,16,32,0.85)', border: '1.5px solid var(--af-border)',
      borderRadius: 'var(--af-radius-pill)',
    }}>
      <span className="material-symbols-rounded" style={{ color: 'var(--af-cyan)', fontSize: 20 }}>{icon}</span>
      <span style={{ color: 'var(--af-text-dim)', fontSize: 11, fontFamily: 'var(--af-font-ui)', whiteSpace: 'pre-line', textAlign: 'center', lineHeight: 1.15 }}>{label}</span>
      {dot && <span style={{ position: 'absolute', top: 11, right: 16 }}><Badge dot color="var(--af-amber)" /></span>}
    </div>
  );

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '0 20px 12px', boxSizing: 'border-box' }}>
      {/* Sector selector */}
      <div style={{ paddingTop: 4 }}>
        <div style={{ color: 'var(--af-cyan-mid)', fontSize: 9, fontWeight: 700, letterSpacing: '2px', marginBottom: 8 }}>SELECT SECTOR</div>
        <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 4, scrollbarWidth: 'none' }}>
          {WORLDS.map((w, i) => (
            <WorldChip key={w.id} id={w.id} name={w.name} accent={w.accent} selected={i === worldIndex} onClick={() => onSelectWorld(i)} />
          ))}
        </div>
      </div>

      {/* Reticle (tinted to the selected sector) */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div style={{ position: 'relative', width: 150, height: 150, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Reticle accent={world.accent} />
          <span className="material-symbols-rounded" style={{ position: 'absolute', color: world.accent, fontSize: 84, textShadow: `0 0 24px ${world.accent}`, transition: 'color var(--af-dur) var(--af-ease)' }}>flight</span>
        </div>
      </div>

      <Button block variant="primary" size="lg" icon="rocket_launch" onClick={onScramble}>Scramble</Button>
      <div style={{ height: 20 }} />
      <div style={{ display: 'flex', gap: 16 }}>
        <StatusPanel title="FUEL SYSTEM" status="85% OPTIMAL" value={0.85} color="var(--af-cyan)" />
        <StatusPanel title="WEAPONS LOAD" status="READY" value={1.0} color="var(--af-orange)" />
      </div>
      <div style={{ height: 18 }} />
      <div style={{ display: 'flex', gap: 12 }}>
        <ActionPill icon="emoji_events" label={'Daily\nRewards'} />
        <ActionPill icon="mail" label="Inbox" />
        <ActionPill icon="event" label="Event" dot />
      </div>
    </div>
  );
}

// Decorative HUD reticle ring (matches the game's _ReticlePainter), tinted per sector.
function Reticle({ accent = '#00eeff' }) {
  return (
    <svg width="150" height="150" viewBox="0 0 150 150" style={{ position: 'absolute', transition: 'stroke 0.2s' }}>
      <g fill="none" stroke={accent} strokeWidth="2.5" opacity="0.9">
        <circle cx="75" cy="75" r="66" strokeDasharray="40 18" opacity="0.5">
          <animateTransform attributeName="transform" type="rotate" from="0 75 75" to="360 75 75" dur="24s" repeatCount="indefinite" />
        </circle>
        <path d="M75 6 v16 M75 128 v16 M6 75 h16 M128 75 h16" />
        <circle cx="75" cy="75" r="48" opacity="0.35" />
      </g>
    </svg>
  );
}
window.HomeScreen = HomeScreen;
