# Kptchan

KPTちゃんはKPTを管理するIRC botです。

任意の文字列をKeep / Problem / Tryのカテゴリー毎に記録、リスト表示、削除をする機能を持っています。

## Installation

1: bundle installする。

    $ bundle

2: config/config.yamlの必要項目を埋める。

    server: "127.0.0.1"
    port: "6667"
    password: ""
    channel: "#test"
    username: "zircon"
    ssl: false

3: 起動

    bundle exec ruby lib/kptchan.rb

## Usage



### KPTを記録する。

例えば、Tryとして"プロジェクト概要をgistに書く"という文言を記録させたいしましょう。

その場合、以下のようなメッセージを送れば、KPTちゃんがTryとして覚えておいてくれます。

```
hdemon: kpt-chan: "プロジェクト概要をgistに書く"をTryに追加して。
kpt-chan: "プロジェクト概要をgistに書く"を、tryのid:1として追加しました。
```

記録するためには、以下の条件を満たしたメッセージをKPTちゃんに送る必要があります。

1. 記録したい文言を""で囲むこと。
2. カテゴリー名（Keep/Problem/Try等）の文字列をメッセージに入れること。
3. 「追加する」などの記録を命令する文字列をメッセージに入れること。

これらを備えたメッセージを、KPTちゃん（ここではニックネーム:kpt-chan）に対して送ることで、KPTちゃんは、「"プロジェクト概要をgistに書く"という文言をTryとして記録しろ」という指示であると解釈します。

言葉の順番や表現のゆらぎを許容する設計になっているので、例えば次のように指示することも可能です。

```
hdemon: KPT-chan: Tryに"プロジェクト概要をgistに書く"を足してくれる？
```

ちなみに、"Try"の文字は"TRY"でも"トライ"でも構いません。

同様に、"追加して"の他にも、"加えて"や"足して"などの言葉でも、同じく「記録しろ」という命令だと解釈します。

他にどんな言葉が使えるかは、https://github.com/hdemon/anata-no-imouto-kpt-chan/blob/master/lib/category_word_map.coffee や https://github.com/hdemon/anata-no-imouto-kpt-chan/blob/master/lib/query_word_map.coffee を見てください。

### KPTのリストを見る。

今までに追加したKPTのリストを見たい場合は、次のようにします。

```
hdemon: kpt-chan: トライのリストを見せて
kpt-chan: try(1)  プロジェクト概要をgistに書く (13-07-19 16:13 hdemon)
```

この場合も記録の指示と同様に、文中にカテゴリーとリストを示す文言が現れてさえいれば、リストを表示しろという命令だと解釈してくれます。

例えば、次のような指示でも同様にリストを表示してくれます。

```
hdemon: kpt-chan: TRYの一覧が見たい
kpt-chan: try(1)  プロジェクト概要をgistに書く (13-07-19 16:13 hdemon)
```

"try(1)"の括弧内の数字は、KPT文言のidです。これは次に説明する削除の際に使います。


### KPTを削除する。

```
hdemon: KPT-chan: Tryのid:1を削除して。
kpt-chan: try id:1を消しました。
```

記録やリスト表示のときと同じように、カテゴリーと、"削除"、"消して"などの言葉をセットにした上で、消したい文言のidを指定して下さい。

idは"id:（数字）"の文字列をメッセージ中に入れることで指定出来ます。



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
