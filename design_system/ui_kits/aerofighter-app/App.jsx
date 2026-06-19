// AeroFighter app — orchestrator. Menu (4 tabs + sector select) → Scramble → Gameplay → Game Over.
const AF_WORLDS = (window.AeroFighterDesignSystem_9520d9 || {}).WORLDS || [
  { id: 1, name: 'DAWN SECTOR',  accent: 'var(--af-world-dawn)' },
  { id: 2, name: 'MIDDAY FRONT', accent: 'var(--af-world-midday)' },
  { id: 3, name: 'DUSK ZONE',    accent: 'var(--af-world-dusk)' },
  { id: 4, name: 'NIGHT OPS',    accent: 'var(--af-world-night)' },
];

function App() {
  const { NavBar } = window.AeroFighterDesignSystem_9520d9;
  const WORLDS = AF_WORLDS;
  const WORLD_BG = ['bg_morning', 'bg_midday', 'bg_afternoon', 'bg_night'];
  const WORLD_LEVEL = ['1-1', '2-1', '3-1', '4-1'];

  const [mode, setMode] = React.useState('menu'); // menu | playing | paused | gameover
  const [tab, setTab] = React.useState(0);
  const [worldIdx, setWorldIdx] = React.useState(1);
  const [score, setScore] = React.useState(0);
  const [lives, setLives] = React.useState(3);
  const [shake, setShake] = React.useState(false);

  const world = {
    ...WORLDS[worldIdx],
    bg: WORLD_BG[worldIdx],
    level: WORLD_LEVEL[worldIdx],
  };

  const startRun = () => { setScore(0); setLives(3); setMode('playing'); };
  const addScore = () => setScore((s) => s + 250);
  const takeHit = () => {
    setShake(true);
    setTimeout(() => setShake(false), 360);
    setLives((l) => {
      const nl = l - 1;
      if (nl <= 0) { setMode('gameover'); return 0; }
      return nl;
    });
  };

  const tabContent = [
    <HomeScreen onScramble={startRun} worldIndex={worldIdx} onSelectWorld={setWorldIdx} />,
    <HangarScreen />,
    <ShopScreen />,
    <PilotScreen />,
  ][tab];

  const inGame = mode === 'playing' || mode === 'paused' || mode === 'gameover';

  return (
    <div className={'device' + (shake ? ' shaking' : '')}>
      <div className="sky" style={{ backgroundImage: `url(../../assets/backgrounds/${inGame ? world.bg : 'bg_midday'}.png)` }} />
      <div className="sky-veil" style={{ opacity: inGame ? 0 : 1 }} />

      {inGame ? (
        <React.Fragment>
          <GameplayHUD world={world} score={score} lives={lives}
            onScore={mode === 'playing' ? addScore : undefined}
            onHit={mode === 'playing' ? takeHit : undefined}
            onPause={() => setMode('paused')} />
          {mode === 'paused' && <PausedModal onResume={() => setMode('playing')} onAbort={() => setMode('menu')} />}
          {mode === 'gameover' && <GameOverModal score={score} best={112400} onRelaunch={startRun} onAbort={() => setMode('menu')} />}
        </React.Fragment>
      ) : (
        <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column' }}>
          <TopBar />
          <div style={{ flex: 1, minHeight: 0, position: 'relative' }}>{tabContent}</div>
          <div style={{ padding: '0 16px 16px' }}>
            <NavBar value={tab} onChange={setTab} items={[
              { icon: 'home', label: 'HOME' },
              { icon: 'flight', label: 'HANGAR' },
              { icon: 'shopping_cart', label: 'SHOP' },
              { icon: 'person', label: 'PILOT' },
            ]} />
          </div>
        </div>
      )}
    </div>
  );
}
window.App = App;
