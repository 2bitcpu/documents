```bash
$ pnpm create vite@latest
✔ Project name: … svelte-app
✔ Select a framework: › Svelte
✔ Select a variant: › JavaScript
```

```json:package.json
{
  "name": "svelte-app",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --host",
    "build": "vite build",
    "preview": "vite preview"
  },
  "devDependencies": {
    "@sveltejs/vite-plugin-svelte": "^5.0.3",
    "svelte": "^5.15.0",
    "vite": "^6.0.5"
  }
}
```

```js:vite.config.js
import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// https://vite.dev/config/
export default defineConfig({
  plugins: [svelte()],
  server: {
    host: true,
  },
  base: './',
  build:{
    outDir: 'dist',
    rollupOptions: {
      output: {
        entryFileNames: `js/[name].js`,
        chunkFileNames: `js/[name].js`,
        assetFileNames: (assetInfo) => {
          const {name} = assetInfo
          if (/\.(js)$/.test(name ?? '')) {
            return 'js/[name][extname]';
          }
          if (/\.(css)$/.test(name ?? '')) {
            return 'css/[name][extname]';
          }
          if (/\.(wasm)$/.test(name ?? '')) {
            return 'wasm/[name][extname]';
          }
          if (/\.(jpe?g|png|gif|svg)$/.test(name ?? '')) {
            return 'img/[name][extname]';
          }
          if (/\.(woff?2|ttf|otf)$/.test(name ?? '')) {
            return 'fonts/[name][extname]';
          }
          return 'assets/[name][extname]';
        }
      },
    },
  },
})
```

```bash
pnpm install
pnpm run dev
```