# TailwindCSSの実装環境を作った時のメモ

Rustのテンプレートエンジンであるteraで使うテンプレートをTailwindCSSで作りたくて環境を作った時のメモ  

VSCodeのnode devcontainerを使います  


#### まずは[公式](https://tailwindcss.com/docs/installation/using-vite)の通りにプロジェクトを作ります

VSCodeのターミナルで
```
npm create vite@latest tailwind-vite
```
色々聞かれますが下記のように選択しました
```
> npx
> "create-vite" tailwind-vite

│
◇  Select a framework:
│  Vanilla
│
◇  Select a variant:
│  JavaScript
│
◇  Use rolldown-vite (Experimental)?:
│  No
│
◇  Install with npm and start now?
│  No
│
◇  Scaffolding project in /workspace/tailwind-vite-test...
│
└  Done. Now run:

  cd tailwind-vite-test
  npm install
  npm run dev
```

VSCodeで `tailwind-vite` を開きます

VSCodeのターミナルで
```
npm install tailwindcss @tailwindcss/vite
```
```
added 104 packages, and audited 105 packages in 12s

17 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

`vite.config.js` を作って
```
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
    server: {
        host: '0.0.0.0',
    },
    plugins: [
        tailwindcss(),
    ],
})
```

`src/style.css` を
```
@import "tailwindcss";
```

`index.html` を
```
<!doctype html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="/src/style.css" rel="stylesheet">
</head>
<body>
  <h1 class="text-3xl font-bold underline">
    Hello world!
  </h1>
</body>
</html>
```

VSCodeのターミナルで
```
npm run dev
```
```
> tailwind-vite@0.0.0 dev
> vite


  VITE v7.1.7  ready in 184 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://172.18.0.2:5173/
  ➜  press h + enter to show help
```

ブラウザで `http://localhost:5173/` にアクセスして表示されればOK

ここまでのディレクトリ構成は以下の通り

```
.
├── node_modules
│   └── ...
├── index.html
├── package-lock.json
├── package.json
├── public
│   └── vite.svg
├── src
│   ├── counter.js
│   ├── javascript.svg
│   ├── main.js
│   └── style.css
└── vite.config.js
```

#### 開発環境を作る

このままでは使い辛いのでディレクトリ構成と設定を変えます

`vite.config.js`
```
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import VitePluginClean from 'vite-plugin-clean';

export default defineConfig({
    server: {
        host: '0.0.0.0',
    },
    plugins: [
        tailwindcss(),
    ],
    base: './',
    root: 'src',
    build: {
        outDir: '../dist',
        rollupOptions: {
            input: {
                main: 'src/index.html',
                list: 'src/list.html',
                search: 'src/search.html',
            },
            output: {
                entryFileNames: `js/[name].js`,
                chunkFileNames: `js/[name].js`,
                assetFileNames: (assetInfo) => {
                    const { name } = assetInfo
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
`index.html` 以外にも作りたいページがあるので追加しています。  
ここでちょっとはまりポイントがありました。  
`build.outDir` は `root` から見た場所に作られますが `build.rollupOptions.input` はプロジェクトのルートから見た場所を参照するようです。

`src/index.html`  
CSSやJSの場所は `index.html` からの相対パスに変更します
```
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="./js/main.js"></script>
  <link href="./css/style.css" rel="stylesheet">
  <title>Tailwindで作るレスポンシブブログ | My Blog</title>
</head>
<body class="bg-gray-50 text-gray-800">
  <!-- ヘッダー -->
  <header class="fixed top-0 left-0 w-full bg-white shadow z-50">
    <div class="max-w-5xl mx-auto px-4 py-4 flex justify-between items-center">
      <h1 class="text-xl font-bold">Blog Design</h1>
      <!-- PCナビ -->
      <nav class="hidden md:flex space-x-6">
        <a href="#" class="hover:text-blue-600">ホーム</a>
        <a href="#" class="hover:text-blue-600">記事一覧</a>
        <a href="#" class="hover:text-blue-600">プロフィール</a>
      </nav>
      <!-- モバイルボタン -->
      <button id="menu-btn" class="md:hidden text-gray-600 text-2xl">☰</button>
    </div>
  </header>
  <!-- オーバーレイ（クリックで閉じる） -->
  <div id="overlay" class="fixed inset-0 bg-black/30 hidden z-40"></div>
  <!-- モバイル用スライドインメニュー -->
  <nav id="mobile-menu"
    class="fixed top-0 right-0 h-full w-64 bg-white shadow-lg transform translate-x-full transition-transform duration-300 ease-in-out z-50">
    <div class="p-4 flex justify-between items-center border-b">
      <h2 class="text-lg font-bold">メニュー</h2>
      <button id="close-btn" class="text-2xl">&times;</button>
    </div>
    <ul class="p-4 space-y-4">
      <li><a href="#" class="block hover:text-blue-600">ホーム</a></li>
      <li><a href="#" class="block hover:text-blue-600">記事一覧</a></li>
      <li><a href="#" class="block hover:text-blue-600">プロフィール</a></li>
    </ul>
  </nav>
  <!-- メイン -->
  <main class="pt-20 max-w-5xl mx-auto px-4 py-8 grid grid-cols-1 md:grid-cols-3 gap-8">
    <!-- 記事本体 -->
    <article class="prose md:col-span-2 bg-white p-8 rounded-lg shadow">
      <h2 class="text-3xl font-bold mb-3">Tailwindで作るレスポンシブブログ</h2>
      <p class="text-gray-600 text-sm mb-6">2025-09-30 | カテゴリ: Web開発</p>
      <img src="https://placehold.co/800x400" alt="記事のイメージ" class="rounded-lg mb-6">
      <div class="prose max-w-none">
        <p>Tailwind CSS を使うと、モバイルファーストでシンプルかつ柔軟なデザインが可能です。この記事ではブログサイトのレイアウトを例に、レスポンシブ対応の作り方を紹介します。</p>
        <h3>ポイント1: グリッドレイアウト</h3>
        <p><code>grid-cols-1 md:grid-cols-3</code> のように記述すると、画面幅によってカラム数を切り替えることができます。</p>
        <h3>ポイント2: コンポーネント化</h3>
        <p>Tailwindはユーティリティクラスが豊富なので、記事カードやナビゲーションなどを簡単に再利用可能な形にできます。</p>
        <p>Viteとの組み合わせなら、開発環境も快適です 🚀</p>
      </div>
    </article>
    <!-- サイドバー -->
    <aside class="space-y-6">
      <!-- 同じカテゴリの記事 -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h3 class="text-lg font-bold mb-3">同じカテゴリの記事（Web開発）</h3>
        <ul class="space-y-2 list-disc list-inside text-blue-600">
          <li><a href="#" class="hover:underline">Viteで始めるフロント開発</a></li>
          <li><a href="#" class="hover:underline">Tailwindで作るUI</a></li>
          <li><a href="#" class="hover:underline">ReactとTypeScriptの基礎</a></li>
        </ul>
      </div>
      <!-- 最近の投稿 -->
      <div class="bg-white p-4 rounded-lg shadow">
        <h3 class="text-lg font-bold mb-3">最近の投稿</h3>
        <ul class="space-y-2">
          <li><a href="#" class="hover:text-blue-600">RustでDDDを実装する</a></li>
          <li><a href="#" class="hover:text-blue-600">ブログに検索機能を追加する</a></li>
          <li><a href="#" class="hover:text-blue-600">静的サイトをVercelにデプロイ</a></li>
        </ul>
      </div>
    </aside>
  </main>
  <!-- フッター -->
  <footer class="bg-white border-t mt-12">
    <div class="max-w-5xl mx-auto px-4 py-6 text-center text-gray-600 text-sm"> © 2025 My Blog. All rights reserved.
    </div>
  </footer>
</body>
</html>
```

`src/js/main.js`
```
document.addEventListener("DOMContentLoaded", () => {
  const menuBtn = document.getElementById("menu-btn");
  const closeBtn = document.getElementById("close-btn");
  const mobileMenu = document.getElementById("mobile-menu");
  const overlay = document.getElementById("overlay");

  function openMenu() {
    mobileMenu.classList.remove("translate-x-full");
    overlay.classList.remove("hidden");
  }

  function closeMenu() {
    mobileMenu.classList.add("translate-x-full");
    overlay.classList.add("hidden");
  }

  menuBtn.addEventListener("click", openMenu);
  closeBtn.addEventListener("click", closeMenu);
  overlay.addEventListener("click", closeMenu);
});
```

`sec/css/style.css` の内容は変わりません

使わないファイルを削除して、構成は下記になります
```
.
├── node_modules
│   └── ...
├── package-lock.json
├── package.json
├── public
│   └── vite.svg
├── src
│   ├── css
│   │   └── style.css
│   ├── js
│   │   └── main.js
│   ├── index.html
│   ├── list.html
│   └── search.html
└── vite.config.js
```

VSCodeのターミナルから
```
npm run dev
```
```
> tailwind-vite@0.0.0 dev
> vite


  VITE v7.1.7  ready in 147 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: http://172.18.0.2:5173/
  ➜  press h + enter to show help
```

ブラウザで `http://localhost:5173/` にアクセスして表示されればOK  
最初と違って少しだけカッコいいページが表示されるはずです

`build` してみる
```
npm run build
```
```
> tailwind-vite@0.0.0 build
> vite build

(!) outDir /workspace/tailwind-vite/dist is not inside project root and will not be emptied.
Use --emptyOutDir to override.

../dist/list.html      0.19 kB │ gzip: 0.16 kB
../dist/search.html    0.20 kB │ gzip: 0.17 kB
../dist/index.html     4.53 kB │ gzip: 1.91 kB
../dist/css/main.css  11.86 kB │ gzip: 3.08 kB
✓ built in 60ms
```

```
(!) outDir /workspace/tailwind-vite/dist is not inside project root and will not be emptied.
Use --emptyOutDir to override.
```
警告が表示されますが、これは `root` を `src` にしたための警告です。  
`outDir` に `root` より上位のディレクトリを指定した場合、警告が出ますが作成されるファイルには問題がないようです。  
