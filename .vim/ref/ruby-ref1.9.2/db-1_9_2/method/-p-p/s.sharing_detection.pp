kind=defined
names=sharing_detection,sharing_detection=
visibility=public

--- sharing_detection                 -> bool
--- sharing_detection=(boolean)

��ͭ���Хե饰��ɽ�����������Ǥ���
�ǥե���Ȥ� false �Ǥ���true �Ǥ����硢
[[m:PP.pp]] �ϰ��ٽ��Ϥ������֥������Ȥ�Ƥӽ��Ϥ����
[[m:Object#pretty_print_cycle]] ��Ȥ��ޤ���

@param boolean ��ͭ���Хե饰�� true �� false �ǻ��ꤷ�ޤ���

��:

  require 'pp'
  b = [1, 2, 3]
  a = [b, b]
    
  pp a                        #=> [[1, 2, 3], [1, 2, 3]]
  
  PP.sharing_detection = true
  pp a                        #=> [[1, 2, 3], [...]]


