## 伝達事項

### simple_ver2_for_FPGAからの変更点

・フェーズカウンタの仕様変更
リセット時(スタート時)に000にセットし各フェーズを001~101で表す。
execスイッチが押されたときもしくはhalt命令時に101で止まるように固定
・同期部分の変更
基本的にnegedgeだった部分をposedgeに変え、主記憶アクセスを正しく行うためにmain_memoryには逆位相のクロックを入力
・p1_fetch_p4_mem_access部分の分割
同じところに書いていると複雑で仕様がわかりにくいのでfetch.vとmem_access.vの2つに分けました。また、main_memoryモジュールを複数書いて良いのか分からなかったのでこのモジュールも外に出しました。
・各モジュールの名称の変更
p1_fetch_p4_mem_access => fetch と mem_access
p2_decode => reg_access
p3_exec => execute
p5_write_back => write_back

### exec入力について

今回もデフォルトはstateを0にしているので、シミュレーションのときはロータリースイッチ（周波数の方）の番号を0にした上でテンキー右下端を押したら処理が始まるようにしています。
以前pcやirの値を止めるためにモジュールやp1p4にもexecを入れていただいたんですが、フェーズカウンタを101で止めるようにしたので今回は制御部にしかexec入れていません。ただ現時点ではexec入力のチャタリング除去をクロック周波数40MHz（ロータリースイッチの番号は0）想定で行っているため、他の周波数の場合ではexec入力が反応しません。もし、1Hzなどでゆっくり挙動が見たい場合は前やられていたようにstateの初期値を1にしてシミュレーションしてみてください。しかしその場合でもチャタリング部分を変更していなければexec入力は反応しないので、途中一時停止させて挙動を見たいなどの際はcontrol_unit部の38行目をtime_counter == 32'b0000_0000_0000_0000_0000_0000_0000_0001に変えてもらえれば上手くいくと思います。（ただそのときはチャタリング起きるかも）
