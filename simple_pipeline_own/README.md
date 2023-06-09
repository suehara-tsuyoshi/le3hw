# simple_pipeline について

今まで作った部品をパイプライン処理っぽくつなげてみました

5/10
色々変更してたらテスト通ったので置いておきます。可能な限り変更点思い出してここに書いておきます。ただ、コードが色々汚い部分あるのでわかりにくかったら申し訳ないです。。。

## 留意点

### 全体

全体はテスト部分も含めて作っていて、プロセッサ自体はprosessorという名前のファイルにまとめています。


### パイプラインレジスタの導入

if_id,id_ex,ex_mem,mem_wbという名前のverilogファイルでパイプラインレジスタを作成しました。やってることは単に各フェーズのoutput regだった部分をoutputにしてregへの書き込みをこれらのファイルで行っているだけです。なので特に意味は無いですが、個人的に見やすかったのとストール処理やフラッシュ処理がしやすいかなと思ったのでちょっと分けてみました。正直あんま変える必要なかったかもです。

### 制御線名の変更

op_●●_23などの数字がはじめわからず(理解不足でごめん、名前変更途中に気づきました)、制御線の名前を
op_●●_exというように使用されているフェーズ名で表現してます。これも名前変えただけで特に意味なかった気がします。あとis_branchedはop_branch、op_stall_dataはop_if_id_writeやop_id_ex_writeに変えています。

### register_fileの作成

decode2の中身が複雑になってきたのでregister_fileという名前のモジュール作成しました。中身はほぼ変更なしですが、レジスタ読み出しをマルチプレクサ(mux8)で行っている点とレジスタ書き込みをクロックの立ち下がり（正確には逆位相クロックの立ち上がり）で行うようにしている点がちょっとした変更です。

### fetch_p1とinstruction_memory

パイプラインレジスタを作成したのにともなってinstruction_register関連の処理はif_id内で行っています。fetch_p1内ではprogram_counterのみレジスタを用意して処理を行っています。op_stall_dataという信号線はif_idの入力op_if_id_writeで代替してます。

### decode_p2

decode_p2内にcontrol_unit,hazard_unit,regsiter_fileをまとめました。各モジュールの詳細は下に書きます。branch_addressの計算時、即値が0拡張になっていたので符号拡張に直しました。

### control_unit

新しくop_haltという制御線を追加しました。名前の通りhalt命令のとき1になるやつです。

### forwarding_unit

フォワーディングを行うためのモジュールです。
~~計算機アーキテクチャの授業資料の、「フォワーディング改良版」ってところを参考に作成しました。~~
パタヘネのp307の図を参考に作成しました(p3に置いてあるイメージです)。
まずp4とp5にいるrs,rd,op_reg_write_addressの値からそれぞれの書き込み先のレジスタrt_memとrt_wbを決定しています。次に関数でop_forward_a,op_forward_b,op_forward_cの値を決定しています(作成してもらった関数を少しいじりました)。ここでop_forward_aはalu_src_a,op_forward_bはalu_src_b,op_forward_cはar(データメモリへの書き込みデータ)を決定する制御線となっています。これらの制御線をexecute_p3につっこんでます。

### hazard_unit

データハザードによるストールを行うためのモジュールです。
これもパタヘネのp307の図を参考に作成しました(p2に置いてあるイメージです)。

・op_haltが1のとき
program_counterの更新、if_idレジスタの更新、id_exレジスタの更新を止めています。
・先のロード命令の格納先を使用するとき
条件はstall_unitのものが1フェーズずれているだけで同じだと思います。program_counterの更新、if_idレジスタの更新、id_exレジスタの更新を止めています。
・条件分岐するとき
ここが少しややこしいです(改善の余地ありです)。まず条件分岐命令のとき(op1==10かつ即値ロード以外のとき)必ずストールするようにしています。これは1つ前の演算結果のcondを格納するためです。次にその値でop_branchを調べたあとその値が1ならif_idレジスタをフラッシュして条件分岐するようにしています。このとき1度ストールしているかどうかを判定するために内部レジスタstallを用意しています。これがないとたまたま2つ前のcondの値が条件を満たしたときに条件分岐されてしまうので。フラッシュの処理やストールの処理はif_idレジスタ、id_exレジスタ内で行っています。

### state

~~各モジュールに state 入力を作って、exec による停止を反映しました。
phase_counter がなくなったことによる処置。~~
ややこしくなったので、一旦state消しています。あとでexec反映させればいいかなと思います。

### テスト進捗

サンプルのテストデータは全て通りました(バブルソート・フィボナッチ含め)。
各記憶装置の語数は下記参照

### 主記憶

p1 と p4 によるアクセスの競合を防ぐために、メモリをデータメモリと命令メモリにに分割してある。

instruction_memory : ROM. 命令メモリ、1024 語格納可能
data_memory : RAM. データメモリ。2048 語格納可能

よって、データメモリに与えるアドレスは、元のアドレスから 1024 引いたものとなる。
simple-sample の BubbleSort.txt を見ながら語数決定してます。


