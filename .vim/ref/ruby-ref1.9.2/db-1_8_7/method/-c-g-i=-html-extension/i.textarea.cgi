kind=defined
names=textarea
visibility=public

--- textarea(name = "", cols = 70, rows = 10) -> String
textarea ���Ǥ��������ޤ���

@param name name °�����ͤ���ꤷ�ޤ���

@param cols cols °�����ͤ���ꤷ�ޤ���

@param rows rows °�����ͤ���ꤷ�ޤ���

��:
   textarea("name")
     # = textarea({ "NAME" => "name", "COLS" => 70, "ROWS" => 10 })

--- textarea(attributes) -> String
textarea ���Ǥ��������ޤ���

@param attributes °����ϥå���ǻ��ꤷ�ޤ���

��:
   textarea("name", 40, 5)
     # = textarea({ "NAME" => "name", "COLS" => 40, "ROWS" => 5 })

