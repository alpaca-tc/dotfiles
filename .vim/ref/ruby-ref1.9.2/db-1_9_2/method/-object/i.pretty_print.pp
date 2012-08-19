kind=added
names=pretty_print
visibility=public

--- pretty_print(pp)    -> ()

[[m:PP.pp]] �� [[m:Kernel.#pp]] �����֥������Ȥ����Ƥ���Ϥ���Ȥ���
�ƤФ��᥽�åɤǤ���[[c:PP]] ���֥������� pp ������Ȥ��ƸƤФ�ޤ���

���륯�饹�� pp �ν��Ϥ򥫥����ޥ������������ϡ����Υ᥽�åɤ��������ޤ���
���ΤȤ� pretty_print �᥽�åɤϻ��ꤵ�줿 pp ���Ф���ɽ�����������Ȥ����Ƥ��ɲä���
�����ʤ���Ф����ޤ��󡣤����Ĥ����Ȥ߹��ߥ��饹�ˤĤ��ơ�
[[lib:pp]] �饤�֥��Ϥ��餫���� pretty_print �᥽�åɤ�������Ƥ��ޤ���

@param pp [[c:PP]] ���֥������ȤǤ���

��:
  
 class Array
   def pretty_print(q)
     q.group(1, '[', ']') {
       q.seplist(self) {|v|
         q.pp v
       }
     }
   end
 end

@see [[m:Object#pretty_print_cycle]], [[m:Object#inspect]], [[m:PrettyPrint#text]], [[m:PrettyPrint#group]], [[m:PrettyPrint#breakable]]

