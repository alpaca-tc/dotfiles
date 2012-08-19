kind=defined
names=html
visibility=public

--- html(attributes = {}) -> String
--- html(attributes = {}){ ... } -> String
�ȥåץ�٥�� html ���Ǥ��������ޤ���
�֥�å���Ϳ����ȡ��֥�å���ɾ��������̤����Ƥˤʤ�ޤ���

@param attributes °����ϥå���ǻ��ꤷ�ޤ���
                  ����°���� "PRETTY" ��ʸ�����Ϳ����Ȥ���ʸ����ǥ���ǥ�Ȥ��� HTML ���������ޤ���
                  ����°���� "DOCTYPE" �ˤ� DOCTYPE ����Ȥ��ƻ��Ѥ���ʸ�����Ϳ���뤳�Ȥ��Ǥ��ޤ���

��:

  html{ "string" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><HTML>string</HTML>

  html({ "LANG" => "ja" }){ "string" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><HTML LANG="ja">string</HTML>

  html({ "DOCTYPE" => false }){ "string" }
    # <HTML>string</HTML>

  html({ "DOCTYPE" => '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">' }){ "string" }
    # <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN"><HTML>string</HTML>

  html({ "PRETTY" => "  " }){ "<BODY></BODY>" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    # <HTML>
    #   <BODY>
    #   </BODY>
    # </HTML>

  html({ "PRETTY" => "\t" }){ "<BODY></BODY>" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    # <HTML>
    #         <BODY>
    #         </BODY>
    # </HTML>

  html("PRETTY"){ "<BODY></BODY>" }
    # = html({ "PRETTY" => "  " }){ "<BODY></BODY>" }

  html(if $VERBOSE then "PRETTY" end){ "HTML string" }

