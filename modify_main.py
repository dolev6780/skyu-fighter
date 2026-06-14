with open('lib/main.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "'StartMenu': (context, game) => _StartMenuOverlay(game: game)," in line:
        lines[i] = line.replace("_StartMenuOverlay", "StartMenuOverlay")
    elif "import 'power_up.dart';" in line:
        lines[i] = line + "import 'start_menu.dart';\n"

start_idx = -1
end_idx = -1
for i, line in enumerate(lines):
    if line.startswith('class _StartMenuOverlay extends StatefulWidget'):
        start_idx = i
    if line.startswith('// ─── Level Complete Overlay ───────────────────────────────────────────────────'):
        end_idx = i - 1

if start_idx != -1 and end_idx != -1:
    del lines[start_idx:end_idx+1]

with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.writelines(lines)
print('Done modifying main.dart.')
