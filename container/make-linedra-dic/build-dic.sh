#!/bin/bash
set -e

cd /work

# =========================
# 標準 IPADIC 辞書（成功）
# =========================
echo "=== Build IPADIC ==="
rm -f mecab-ipadic-2.7.0-20070801.tar.gz
rm -rf mecab-ipadic-2.7.0-20070801

curl -L -o ./mecab-ipadic-2.7.0-20070801.tar.gz "https://Lindera.dev/mecab-ipadic-2.7.0-20070801.tar.gz"
tar zxvf ./mecab-ipadic-2.7.0-20070801.tar.gz

mkdir -p ./lindera-ipadic
rm -f ./lindera-ipadic/metadata.json
curl -L -o ./lindera-ipadic/metadata.json https://raw.githubusercontent.com/lindera/lindera/main/lindera-ipadic/metadata.json

rm -rf ./lindera-ipadic-2.7.0-20070801
lindera build ./lindera-ipadic/metadata.json ./mecab-ipadic-2.7.0-20070801 ./lindera-ipadic-2.7.0-20070801
echo "=== IPADIC build complete ==="

# =========================
# UniDic 辞書（Dockerスペック不足で Killedのためコメントアウト）
# =========================
# echo "=== Build UniDic ==="
# rm -f ./unidic-mecab-2.1.2.tar.gz
# rm -rf ./unidic-mecab-2.1.2
# curl -L -o ./unidic-mecab-2.1.2.tar.gz "https://Lindera.dev/unidic-mecab-2.1.2.tar.gz"
# tar zxvf ./unidic-mecab-2.1.2.tar.gz
# mkdir -p ./lindera-unidic
# rm -f ./lindera-unidic/metadata.json
# curl -L -o ./lindera-unidic/metadata.json https://raw.githubusercontent.com/lindera/lindera/refs/heads/main/lindera-unidic/metadata.json
# rm -rf ./lindera-unidic-2.1.2
# lindera build ./lindera-unidic/metadata.json ./unidic-mecab-2.1.2 ./lindera-unidic-2.1.2
# echo "=== UniDic build complete (commented out) ==="

# =========================
# IPADIC-Neologd 辞書（Dockerスペック不足で Killedのためコメントアウト）
# =========================
# echo "=== Build IPADIC-Neologd ==="
# rm -f mecab-ipadic-neologd-0.0.7-20200820.tar.gz
# rm -rf mecab-ipadic-neologd-0.0.7-20200820
# curl -L -o ./mecab-ipadic-neologd-0.0.7-20200820.tar.gz "https://lindera.dev/mecab-ipadic-neologd-0.0.7-20200820.tar.gz"
# tar zxvf ./mecab-ipadic-neologd-0.0.7-20200820.tar.gz
# mkdir -p ./lindera-ipadic-neologd
# rm -f ./lindera-ipadic-neologd/metadata.json
# curl -L -o ./lindera-ipadic-neologd/metadata.json https://raw.githubusercontent.com/lindera/lindera/refs/heads/main/lindera-ipadic-neologd/metadata.json
# rm -rf ./lindera-ipadic-neologd-0.0.7-20200820
# lindera build ./lindera-ipadic-neologd/metadata.json ./mecab-ipadic-neologd-0.0.7-20200820 ./lindera-ipadic-neologd-0.0.7-20200820
# echo "=== IPADIC-Neologd build complete (commented out) ==="
