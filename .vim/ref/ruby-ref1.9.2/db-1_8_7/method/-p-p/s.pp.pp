kind=defined
names=pp
visibility=public

--- pp(obj, out = $>, width = 79)    -> object

���ꤵ�줿���֥������� obj ������� out ���� width �ǽ��Ϥ��ޤ���
������ out ���֤��ޤ���

@param obj ɽ�����������֥������Ȥ���ꤷ�ޤ���

@param out ���������ꤷ�ޤ���<< �᥽�åɤ��������Ƥ���ɬ�פ�����ޤ���

@param width �������������ꤷ�ޤ���

  str = PP.pp([[:a, :b], [:a, [[:a, [:a, [:a, :b]]], [:a, :b],]]], '', 20)
  puts str
  #=>
  [[:a, :b],
   [:a,
    [[:a,
      [:a, [:a, :b]]],
     [:a, :b]]]]

@see [[m:$>]]

