let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.rfc = {
      \ 'description' : 'RFC definitions',
      \ }
let g:unite_source_menu_menus.rfc.candidates = {
      \   '(RFC 2145) HTTP バージョン番号の使用及びその解釈' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2145',
      \   '(RFC 2388) フォームから返される値: multipart/form-data' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2388',
      \   '(RFC 2616) ハイパーテキスト転送プロトコル -- HTTP/1.1' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2616',
      \   '(RFC 2817) HTTP/1.1 から TLS へのアップグレード' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2817',
      \   '(RFC 2818) TLS 上の HTTP' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2818',
      \   '(RFC 2936) HTTP MIME タイプハンドラの検出' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2936',
      \   '(RFC 2964) HTTP 状態管理の使い方' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2964',
      \   '(RFC 2965) HTTP 状態管理メカニズム' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc2965',
      \   '(RFC 3016) 言語識別のためのタグ' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3066',
      \   '(RFC 3205) 基層としての HTTP の使用' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3205',
      \   '(RFC 3229) HTTP における差分エンコーディング' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3229',
      \   '(RFC 3282) Content Language ヘッダ' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3282',
      \   '(RFC 3875) The Common Gateway Interface (CGI) Version 1.1' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3875',
      \   '(RFC 3986) Uniform Resource Identifier (URI): 一般的構文' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3986',
      \   '(RFC 4229) HTTP ヘッダフィールド登録一覧' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc4229',
      \   '(RFC 5987) ハイパーテキスト転送プロトコル（HTTP）ヘッダフィールドのパラメータのための文字セットと言語エンコーディング' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc5987',
      \   '(RFC 5989) HTTPのためのPATCHメソッド' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc5789',
      \   'HTTP におけるインスタンスダイジェスト' : 'OpenBrowser http://www.studyinghttp.net/rfc_ja/rfc3230',
      \ }
function g:unite_source_menu_menus.rfc.map(key, value)
  return {
        \       'word' : a:key, 'kind' : 'command',
        \       'action__command' : a:value,
        \     }
endfunction
