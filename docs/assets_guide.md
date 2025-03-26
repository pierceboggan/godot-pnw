# Asset Guide for Pacific Northwest Survival Game

This document provides instructions for obtaining and using assets for the PNW Survival game.

## Asset Requirements

The game requires various types of assets to create the Pacific Northwest atmosphere:

1. **Character Models**
   - A basic player character (placeholder already created)
   - Future: NPC models for coffee shop staff and pedestrians

2. **Environment Assets**
   - Trees (particularly pine, fir, cedar)
   - Buildings (coffee shops, bookstores, local businesses)
   - Terrain textures (wet pavement, grass, dirt paths)
   - Atmospheric elements (rain particles, puddles)

3. **UI Elements**
   - Dampness and caffeine meters (placeholder SVGs created)
   - Inventory icons
   - Mission UI elements

4. **Audio Files**
   - Rain ambient sounds (light to heavy)
   - Footstep sounds (on various surfaces)
   - Coffee shop ambience
   - UI interaction sounds

## Free Asset Resources

Here are recommended sources for free assets compatible with Godot 4.x:

### 3D Models and Environments
1. **Kenney Assets** (https://kenney.nl/)
   - Provides extensive free game assets with no attribution required
   - Recommended sets: Nature Pack, City Kit, Character Pack

2. **Quaternius** (https://quaternius.com/)
   - Free low-poly 3D model packs
   - Ultimate Nature Pack and Simple City packs are ideal for our PNW theme

3. **Godot Asset Library** (accessible through Godot Editor)
   - Search for "low poly environment" or "character controller"
   - Look for assets compatible with Godot 4.x

4. **Sketchfab** (https://sketchfab.com/feed)
   - Filter for models with free download and appropriate licenses
   - Search for "coffee shop", "pine tree", or "rain"

### Audio Assets
1. **Freesound.org** (https://freesound.org/)
   - Search for "rain ambient", "coffee shop ambience", "footsteps"
   - Filter for Creative Commons 0 license for attribution-free use

2. **ZapSplat** (https://www.zapsplat.com/)
   - Free sound effects with account registration
   - Good source for UI sounds and ambience

### Textures
1. **OpenGameArt.org** (https://opengameart.org/)
   - Filter for 3D textures with appropriate licenses
   - Look for seamless textures for terrain and buildings

2. **Texture Haven** (https://texturehaven.com/)
   - High-quality free textures
   - CC0 licensed (no attribution required)

## Importing Assets into Godot

### 3D Models
1. Download the desired assets (.gltf, .glb or .obj formats work best)
2. Place them in the appropriate folder in `assets/` (e.g., environment, characters)
3. Drag the files into the Godot FileSystem panel
4. Set import settings as needed:
   - For static objects: Ensure "Create Collider" is checked if needed
   - For animated characters: Check "Import Animation" if present

### Audio Files
1. Download audio files (preferably .wav or .ogg formats)
2. Place them in the relevant subfolder in `assets/audio/`
3. Import settings:
   - For ambient loops: Check "Loop" in the import settings
   - Adjust "Max Distance" for 3D sounds as appropriate

### Textures
1. Download texture files (.png or .jpg)
2. Place them in the relevant asset folder
3. Import settings:
   - Enable mipmaps for textures used on 3D models
   - For normal maps, set the texture type to "Normal Map"

## Using Placeholder Assets

Until final assets are obtained, the project includes several placeholder assets:

1. **Player Character**: A basic humanoid shape built with CSG shapes
2. **Materials**: Simple materials for ground, wood, and water
3. **UI Elements**: SVG files for UI meters

You can verify these placeholder assets in the `AssetTestScene.tscn` file, which loads and displays all current assets for testing.

## Asset Attribution

When using external assets, maintain proper attribution as required by the asset licenses:

1. Create an `ATTRIBUTIONS.md` file in the project root
2. For each asset, include:
   - Asset name
   - Creator/Author
   - Source URL
   - License type
   - Any required attribution text

## Custom Asset Creation

For any custom assets needed:
1. Use Blender for 3D models (export as .glb)
2. Use GIMP or Krita for texture creation
3. Use Audacity for audio editing
4. Ensure all custom assets follow the low-poly, stylized aesthetic of the game