kind=defined
names=file_field
visibility=public

--- file_field(name = "", size = 20, maxlength = nil) -> String

�����פ� file �Ǥ��� input ���Ǥ��������ޤ���

@param name name °�����ͤ���ꤷ�ޤ���

@param size size °�����ͤ���ꤷ�ޤ���

@param maxlength maxlength °�����ͤ���ꤷ�ޤ���

��:
   file_field("name")
     # <INPUT TYPE="file" NAME="name" SIZE="20">

   file_field("name", 40)
     # <INPUT TYPE="file" NAME="name" SIZE="40">

   file_field("name", 40, 100)
     # <INPUT TYPE="file" NAME="name" SIZE="40" MAXLENGTH="100">

--- file_field(name = "", size = 20, maxlength = nil) -> String

�����פ� file �Ǥ��� input ���Ǥ��������ޤ���

@param attributes °����ϥå���ǻ��ꤷ�ޤ���

��:
   file_field({ "NAME" => "name", "SIZE" => 40 })
     # <INPUT TYPE="file" NAME="name" SIZE="40">


