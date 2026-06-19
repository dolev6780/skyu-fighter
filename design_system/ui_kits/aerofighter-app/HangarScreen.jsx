// AeroFighter app — HANGAR tab. Jet configurator inside a glass sheet.
const JET_SKINS = [
  { name: 'COBALT ALPHA', color: 'var(--af-skin-cobalt)', nameColor: 'var(--af-cyan)', desc: 'Standard multi-role tactical interceptor. Perfectly balanced design.', speed: 0.6, armor: 0.6, power: 0.6 },
  { name: 'CRIMSON PHOENIX', color: 'var(--af-skin-crimson)', nameColor: 'var(--af-skin-crimson)', desc: 'High-speed interceptor. Advanced engine allows rapid response.', speed: 0.9, armor: 0.4, power: 0.7 },
  { name: 'SOLAR EAGLE', color: 'var(--af-skin-solar)', nameColor: 'var(--af-skin-solar)', desc: 'Heavy tactical fighter. Superior armor plating to absorb impacts.', speed: 0.4, armor: 0.9, power: 0.7 },
  { name: 'EMERALD VIPER', color: 'var(--af-skin-emerald)', nameColor: 'var(--af-skin-emerald)', desc: 'Experimental design. Upgraded cooling for high fire rates.', speed: 0.7, armor: 0.5, power: 0.9 },
];

function HangarScreen() {
  const { GlassModal, StatBar, JetChip, Button } = window.AeroFighterDesignSystem_9520d9;
  const [sel, setSel] = React.useState(1);
  const [equipped, setEquipped] = React.useState(0);
  const skin = JET_SKINS[sel];
  const isEquipped = sel === equipped;

  return (
    <div style={{ height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '0 16px' }}>
      <GlassModal scrim={false} width={340}>
        <div style={{ color: 'var(--af-cyan)', fontSize: 15, fontWeight: 700, letterSpacing: '2px', fontFamily: 'var(--af-font-display)' }}>JET CONFIGURATOR</div>
        <div style={{ height: 14 }} />
        <div style={{ display: 'flex', gap: 12, overflowX: 'auto', paddingBottom: 2 }}>
          {JET_SKINS.map((s, i) => (
            <JetChip key={s.name} color={s.color} highlighted={i === sel} equipped={i === equipped} onClick={() => setSel(i)} />
          ))}
        </div>
        <div style={{ height: 16 }} />
        <div style={{ color: skin.nameColor, fontSize: 16, fontWeight: 700, letterSpacing: '2px', fontFamily: 'var(--af-font-display)' }}>{skin.name}</div>
        <div style={{ height: 6 }} />
        <div style={{ color: 'var(--af-text-dim)', fontSize: 11, lineHeight: 1.4, fontFamily: 'var(--af-font-ui)' }}>{skin.desc}</div>
        <div style={{ height: 16 }} />
        <StatBar label="Engine Speed" value={skin.speed} color="var(--af-cyan)" />
        <div style={{ height: 8 }} />
        <StatBar label="Hull Integrity" value={skin.armor} color="var(--af-warning)" />
        <div style={{ height: 8 }} />
        <StatBar label="Firepower" value={skin.power} color="#ff4444" />
        <div style={{ height: 20 }} />
        <Button block variant={isEquipped ? 'primary' : 'primary'} disabled={isEquipped} onClick={() => setEquipped(sel)}>
          {isEquipped ? 'Equipped' : 'Equip Fighter Jet'}
        </Button>
      </GlassModal>
    </div>
  );
}
window.HangarScreen = HangarScreen;
