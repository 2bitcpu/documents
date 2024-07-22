# GitHub Desktop

#### インストール
```bash
brew install --cask github
```

GitHub DesktopはHTTPSしかサポートしない  
HTTPSの場合CLIでの操作時にユーザーとパスワードを求められる  
この場合のパスワードはブラウザでのログインに使うパスワードではなくアクセストークンになる  

以下にアクセスしてアクセストークンを作成する  
[https://github.com/settings/tokens](https://github.com/settings/tokens)

```Note```に任意の文字を入力  
```Select scopes```は```repo```を選択しておけば一通りの操作は行える  
一番下の```Ganerate token```を押してアクセストークンを作成する  
作成したアクセストークンは控えておく

アクセストークンは40文字のランダムな文字列でとても覚えることはできない  
また、毎回入力するのも大変である
```
git config --global credential.helper store
```
この設定をしておくと、初回に入力したアクセストークンをファイルに保存してくれる