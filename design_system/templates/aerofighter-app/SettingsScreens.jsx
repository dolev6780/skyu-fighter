// AeroFighter app — SHOP (placeholder) + PILOT (settings) tabs.
function ShopScreen() {
  const { GlassModal } = window.AeroFighterDesignSystem_9520d9;
  return (
    <div style={{ height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0 16px' }}>
      <GlassModal scrim={false} width={260} style={{ textAlign: 'center' }}>
        <span className="material-symbols-rounded" style={{ color: 'var(--af-cyan)', fontSize: 48 }}>storefront</span>
        <div style={{ height: 16 }} />
        <div style={{ color: 'var(--af-cyan)', fontSize: 16, fontWeight: 700, letterSpacing: '2px', fontFamily: 'var(--af-font-display)' }}>MARKETPLACE OFFLINE</div>
      </GlassModal>
    </div>
  );
}
window.ShopScreen = ShopScreen;

function PilotScreen() {
  const { GlassModal, SegmentedControl, Toggle } = window.AeroFighterDesignSystem_9520d9;
  const [diff, setDiff] = React.useState(1);
  const [sfx, setSfx] = React.useState(true);
  const [music, setMusic] = React.useState(true);
  const descs = [
    'Easy: 4 Lives. Reduced enemy speed.',
    'Normal: 3 Lives. Default arcade striker parameters.',
    'Hard: 2 Lives. Accelerated enemy speed.',
  ];
  const Label = ({ children }) => (
    <div style={{ color: 'var(--af-text-muted)', fontSize: 10, letterSpacing: '1px', fontFamily: 'var(--af-font-ui)' }}>{children}</div>
  );
  const SwitchRow = ({ icon, label, on, set }) => (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '6px 0' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <span className="material-symbols-rounded" style={{ color: 'var(--af-text-muted)', fontSize: 18 }}>{icon}</span>
        <span style={{ color: 'var(--af-text)', fontSize: 12, fontFamily: 'var(--af-font-ui)' }}>{label}</span>
      </div>
      <Toggle checked={on} onChange={set} />
    </div>
  );
  return (
    <div style={{ height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0 16px' }}>
      <GlassModal scrim={false} width={340}>
        <div style={{ color: 'var(--af-cyan)', fontSize: 15, fontWeight: 700, letterSpacing: '2px', fontFamily: 'var(--af-font-display)' }}>PILOT SYSTEM PARAMETERS</div>
        <div style={{ height: 16 }} />
        <Label>DIFFICULTY SCALE</Label>
        <div style={{ height: 8 }} />
        <SegmentedControl value={diff} onChange={setDiff} options={[
          { label: 'Easy', color: 'var(--af-success)' },
          { label: 'Normal', color: 'var(--af-blue)' },
          { label: 'Hard', color: 'var(--af-danger)' },
        ]} />
        <div style={{ height: 10 }} />
        <div style={{ color: 'var(--af-text-dim)', fontSize: 10, lineHeight: 1.4, fontFamily: 'var(--af-font-ui)' }}>{descs[diff]}</div>
        <div style={{ height: 18, borderBottom: '1px solid var(--af-border-quiet)', marginBottom: 10 }} />
        <SwitchRow icon="volume_up" label="SOUND FX (SIMULATED)" on={sfx} set={setSfx} />
        <SwitchRow icon="music_note" label="MUSIC TRACK (SIMULATED)" on={music} set={setMusic} />
      </GlassModal>
    </div>
  );
}
window.PilotScreen = PilotScreen;
