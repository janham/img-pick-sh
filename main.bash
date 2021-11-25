#!/bin/bash

PWD=`pwd`

# ファイルを検索するディレクトリのパス
dir_path=`find $PWD -maxdepth 1 -name $1`
# ディレクトリの中から指定した拡張子のファイルのみ抽出 (files = array)
files=`find $dir_path -type f \( -name '*.js' -o -name '*.css' -o -name '*.html' \)`

array=()

# ファイルの配列をループ処理
for file in $files
do
    # ファイルを読み込んで変数に代入
    FILE_DATA=$(<$file)

    # index.htmlの .(png|jpg|gif|svg)の直後で改行したものを出力
    NLINE=`echo "$FILE_DATA" | sed -e 's/\.png/\.png\n/g' -e 's/\.jpg/\.jpg\n/g' -e 's/\.gif/\.gif\n/g' -e 's/\.svg/\.svg\n/g'`

    # ファイル内から指定したパスが含まれる文字列を検索 /***.png,.jpg,.gif,.svg
    IMGPASS=`echo "$NLINE" | grep -oE '/[^/]*\.(png|jpg|gif|svg)'`

    # 検索でヒットした文字列から(/)を削除
    ILIST=`echo "$IMGPASS" | sed -e 's/\///g'`

    for VAL in $ILIST
    do
        array+=($VAL)
    done
done


# 配列を昇順にソートしファイル名が重複する行がある場合は1つにする
array=(`for item in "${array[@]}"; do echo "$item"; done | sort -uf`);

# ソートした配列を出力
for item in "${array[@]}"
do
    echo "$item" >> /Users/yamada33/desktop/img-pick.txt
done
