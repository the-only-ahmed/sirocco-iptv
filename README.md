# Sirocco IPTV (Roku)

Xtream Codes IPTV player for Roku TV — BrighterScript + SceneGraph.

## Quick start

1. **Roku Developer Mode**: on the remote press Home ×3, Up ×2, Right, Left, Right, Left, Right. Enable, set a password, note the IP.
2. **Install tooling**
   ```bash
   npm install
   ```
   In VS Code, install the recommended *BrightScript Language* extension (RokuCommunity).
3. **Run on the TV**
   - VS Code: press F5, enter the Roku IP and dev password.
   - CLI: `cp .env.example .env`, edit, then `source .env && npm run deploy`.
4. On the TV enter your provider's server (`host:port`), username and password → Connect.

## Layout

```
src/manifest                 channel metadata
src/source/                  entry point + shared libs (Xtream API, registry, log)
src/components/              SceneGraph components (router, screens, grid items, tasks)
src/images/                  icons / splash / placeholder
```

## Notes
- Live streams use the `.m3u8` (HLS) URL — Roku cannot play raw `.ts`.
- Credentials are stored in the Roku registry on the device only.
- Distribution: see PLAN.md Phase 10 (Beta channel vs Channel Store).
