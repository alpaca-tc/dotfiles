kind=added
names=pretty_print_cycle
visibility=public

--- pretty_print_cycle(pp)    -> ()

�ץ�ƥ��ץ��Ȼ��˥��֥������Ȥν۴Ļ��Ȥ����Ф��줿��硢
[[m:Object#pretty_print]] ������˸ƤФ��᥽�åɤǤ���

���륯�饹�� pp �ν��Ϥ򥫥����ޥ������������ϡ�
���Υ᥽�åɤ���������ɬ�פ�����ޤ���

@param pp [[c:PP]] ���֥������ȤǤ���

��:
 
 class Array 
   def pretty_print_cycle(q)
     q.text(empty? ? '[]' : '[...]')
   end
 end

@see [[m:Object#pretty_print]]

