# Kptchan

KPTちゃんはKPTを管理するIRC botです。

任意の文字列をKeep / Problem / Tryのカテゴリー毎に記録、リスト表示、削除をする機能を持っています。

## Installation

1. `config/config.yaml`の必要項目を埋める。

2. 起動

    ```
    bin/kptchan
    ```
    
## Usage

### KPTを記録する。

KPTちゃんは日本語がほんの少し話せます。
例えば、"プロジェクト概要をgistに書く"というTryを記録させたいなら、

```
hdemon: kpt-chan: "プロジェクト概要をgistに書く"をTryに追加して。
```

となどと話しかけましょう。
あるいはもっとくだけた感じで、

```
hdemon: KPT-chan: Tryに"プロジェクト概要をgistに書く"を足してくれる？
```

のように話しかけてもOKです。

細かい話をすると、記録するためには、以下の条件を満たしたメッセージをKPTちゃんに送る必要があります。

1. 記録したい文言を""で囲むこと。
2. カテゴリー名（Keep/Problem/Try等）の文字列をメッセージに入れること。
3. 「追加する」などの記録を命令する文字列をメッセージに入れること。

どんな言葉が使えるかは、[ここ](https://github.com/hdemon/anata-no-imouto-kpt-chan/blob/master/lib/category_word_map.coffee)や[ここ](https://github.com/hdemon/anata-no-imouto-kpt-chan/blob/master/lib/query_word_map.coffee)を見てください。
このルールは、以下のリスト閲覧と削除においても同様です。

### KPTのリストを見る。

今までに追加したKPTのリストを見たい場合は、

```
hdemon: kpt-chan: Tryのリストを見せて
kpt-chan: try(1)  プロジェクト概要をgistに書く (13-07-19 16:13 hdemon)
```

というように、「見せてほしい」ことを伝えて下さい。
この場合も記録と同じく、ある程度の表現のゆらぎを許容します。
なお、"try(1)"の括弧内の数字はKPT文言のidです。これは次に説明する削除の際に使います。

### KPTを削除する。

```
hdemon: KPT-chan: Tryのid:1を削除して。
kpt-chan: try id:1を消しました。
```

記録やリスト表示のときと同じように、「消して欲しい」ことをKPTちゃんに伝えて下さい。この場合、`id:{KPTのid}`の文言を文中に入れてください。


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
