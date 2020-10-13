# README
- jsは適用させていない(スコープ外かつwebpackでエラーが起きるため)
- `<%# javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>`

- アプリの状態、正常に動く状態ではない

## [コールバック](https://railsguides.jp/active_record_callbacks.html)
### [トランザクションコールバック](https://railsguides.jp/active_record_callbacks.html#%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%B3%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF)

- 当初、リアクティブにトランザクションコールバックを動作させようと簡単なポイント交換機能を実装しようと試みたがエラーハンドリングがうまくいかなかった。
- railsガイド以外にユーザの記事を読んだところ、コントローラーでの使用はアンチパターンであることやバッチ処理向けの記事がありコントローラーで直列処理で管理するのは向いていないのではないかと判断した。
  - 実装しきるのなら、sidekiqなどで非同期処理にすべきか。というところで終了している。