kind=added
names=sexp_raw
visibility=public

--- Ripper.sexp_raw(src, filename = '-', lineno = 1)

Ruby �ץ���� str ����Ϥ��� S ���Υĥ꡼�ˤ����֤��ޤ���

@param src Ruby �ץ�����ʸ���� IO ���֥������Ȥǻ��ꤷ�ޤ���

@param filename src �Υե�����̾��ʸ����ǻ��ꤷ�ޤ�����ά����� "-" �ˤʤ�ޤ���

@param lineno src �γ��Ϲ��ֹ����ꤷ�ޤ�����ά����� 1 �ˤʤ�ޤ���

�¹Է�̤ϡ���̤��������������ǤȤ��� S ���Υĥ꡼��ɽ�����Ƥ��ޤ���

��:

  require 'ripper'
  require 'pp'
  
  pp Ripper.sexp_raw("def m(a) nil end")
    # => [:program,
          [:stmts_add,
           [:stmts_new],
           [:def,
            [:@ident, "m", [1, 4]],
            [:paren, [:params, [[:@ident, "a", [1, 6]]], nil, nil, nil]],
            [:bodystmt,
             [:stmts_add, [:stmts_new], [:var_ref, [:@kw, "nil", [1, 9]]]],
             nil,
             nil,
             nil]]]]

Ripper.sexp_raw �� [[m:Ripper.sexp]] �Ȥϰۤʤ���Ϸ�̤�ù����ޤ���

@see [[m:Ripper.sexp]]
