# Lindera 辞書ビルダー

## 概要

このリポジトリは、Rust製の形態素解析器である [Lindera](https://github.com/lindera-project/lindera) で使用するカスタム辞書をビルドするためのDocker環境を提供します。

## 前提条件

*   Dockerがインストールされていること。

## 使い方

1.  **Dockerイメージをビルドします。**

    ```bash
    docker build -t lindera-dict-builder .
    ```

2.  **辞書ビルドスクリプトを実行します。**

    以下のコマンドは、`work`ディレクトリを作成し、その中で辞書ビルド処理を実行します。

    ```bash
    rm -rf ./work
    mkdir ./work
    cp ./build-dic.sh ./work/build-dic.sh

    docker run --rm -v $(pwd)/work:/work lindera-dict-builder bash /work/build-dic.sh
    ```

## ビルド成果物

スクリプトの実行が完了すると、`work`ディレクトリ以下にLindera用の辞書ファイルが生成されます。
これらのファイルをプロジェクトに組み込んで利用してください。
