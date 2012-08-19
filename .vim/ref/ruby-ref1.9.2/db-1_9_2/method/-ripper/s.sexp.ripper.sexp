kind=added
names=sexp
visibility=public

--- Ripper.sexp(src, filename = '-', lineno = 1) -> object

Ruby �ץ���� str ����Ϥ��� S ���Υĥ꡼�ˤ����֤��ޤ���

@param src Ruby �ץ�����ʸ���� IO ���֥������Ȥǻ��ꤷ�ޤ���

@param filename src �Υե�����̾��ʸ����ǻ��ꤷ�ޤ�����ά����� "-" �ˤʤ�ޤ���

@param lineno src �γ��Ϲ��ֹ����ꤷ�ޤ�����ά����� 1 �ˤʤ�ޤ���

�¹Է�̤ϡ���̤��������������ǤȤ��� S ���Υĥ꡼��ɽ�����Ƥ��ޤ���

��:

  require 'ripper'
  require 'pp'
  
  pp Ripper.sexp("def m(a) nil end")
    # => [:program,
          [[:def,
            [:@ident, "m", [1, 4]],
            [:paren, [:params, [[:@ident, "a", [1, 6]]], nil, nil, nil, nil]],
            [:bodystmt, [[:var_ref, [:@kw, "nil", [1, 9]]]], nil, nil, nil]]]]

�ѡ������٥�Ȥϰʲ��Τ褦�ʷ����ˤʤ�ޤ���

  [:���٥��̾, ...]

��:

  [:program, ...]

������ʥ��٥�Ȥϰʲ��Τ褦�ʷ����ˤʤ�ޤ���

  [:@���٥��̾, �ȡ�����, ���־���(�ԡ��������)]

��:

  [:@ident, "m", [1, 4]]

�ޤ���Ripper.sexp �� [[m:Ripper.sexp_raw]] �Ȥϰۤʤꡢ�ɤߤ䤹���Τ���
�� stmts_add �� stmts_new �Τ褦�� _add��_new �ǽ����ѡ������٥�Ȥ�
��ά���ޤ���_add �ǽ����ѡ������٥�Ȥϥϥ�ɥ�ΰ����� 0 �ĤΤ�Τ�
��ά����ޤ����ܤ����� [[m:Ripper::PARSER_EVENTS]] ���ǧ���Ƥ���������

@see [[m:Ripper.sexp_raw]]

