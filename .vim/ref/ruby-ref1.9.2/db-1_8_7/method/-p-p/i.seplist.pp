kind=defined
names=seplist
visibility=public

--- seplist(list, sep = lambda { comma_breakable }, iter_method = :each){|e| ...}    -> ()

�ꥹ�Ȥγ����Ǥ򲿤��Ƕ��ڤ�Ĥġ����Ȥ��ɲä��Ƥ�������˻Ȥ��ޤ���

list �� iter_method �ˤ�äƥ��ƥ졼�Ȥ��������Ǥ�����Ȥ��ƥ֥�å���¹Ԥ��ޤ���
�ޤ������줾��Υ֥�å��μ¹Ԥι�֤� sep ���ƤФ�ޤ���

�Ĥޤꡢ�ʲ��Τդ��Ĥ�Ʊ�ͤǤ���

  q.seplist([1,2,3]) {|v| q.pp v }

  q.pp 1
  q.comma_breakable
  q.pp 2
  q.comma_breakable
  q.pp 3

@param list ���Ȥ��ɲä����������Ϳ���ޤ���iter_method ��Ŭ�ڤ˻��ꤹ��С�
            Enumerable �Ǥʤ��Ƥ⹽���ޤ���

@param sep ���ڤ�򼫿Ȥ��ɲä���֥�å���Ϳ���ޤ���list �����ƥ졼�Ȥ���ʤ��ʤ顢
           sep �Ϸ褷�ƸƤФ�ޤ���

@param iter_method list �򥤥ƥ졼�Ȥ���᥽�åɤ򥷥�ܥ��Ϳ���ޤ���

@see [[m:PP#comma_breakable]]

