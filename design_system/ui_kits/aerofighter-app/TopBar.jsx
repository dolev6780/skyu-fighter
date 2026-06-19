// AeroFighter app — top bar (avatar · callsign · currency · wifi)
function TopBar({ currency = '25,400', gems = '150' }) {
  const { Avatar } = window.AeroFighterDesignSystem_9520d9;
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '12px 16px' }}>
      <Avatar />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ color: 'var(--af-cyan-mid)', fontSize: 10, letterSpacing: '2px', fontFamily: 'var(--af-font-ui)', fontWeight: 600 }}>CALLSIGN</div>
        <div style={{ color: 'var(--af-cyan)', fontSize: 22, fontWeight: 700, letterSpacing: '3px', fontFamily: 'var(--af-font-display)', lineHeight: 1.1 }}>MAVERICK</div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 3 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <span className="material-symbols-rounded" style={{ color: 'var(--af-cyan)', fontSize: 15 }}>paid</span>
          <span style={{ color: 'var(--af-text)', fontFamily: 'var(--af-font-mono)', fontSize: 15, fontWeight: 700 }}>{currency}</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <span className="material-symbols-rounded" style={{ color: 'var(--af-amber)', fontSize: 15 }}>diamond</span>
          <span style={{ color: 'var(--af-orange)', fontFamily: 'var(--af-font-mono)', fontSize: 14, fontWeight: 700 }}>{gems}</span>
        </div>
      </div>
      <span className="material-symbols-rounded" style={{ color: 'var(--af-cyan)', fontSize: 24, marginLeft: 4 }}>wifi</span>
    </div>
  );
}
window.TopBar = TopBar;
