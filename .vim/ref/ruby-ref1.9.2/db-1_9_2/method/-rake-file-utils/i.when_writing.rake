kind=defined
names=when_writing
visibility=public 

--- when_writing(msg = nil){ ... }

[[m:RakeFileUtils.nowrite_flag]] �����Ǥ�����Ϳ����줿�֥�å���¹Ԥ����ˡ�
Ϳ����줿��å�������ɽ�����ޤ���

�����Ǥʤ����ϡ�Ϳ����줿�֥�å���¹Ԥ��ޤ���

@param msg ɽ�������å���������ꤷ�ޤ���

��:
  when_writing("Building Project") do
    project.build
  end

