kind=defined
names=password_field
visibility=public

--- password_field(name = "", value = nil, size = 40, maxlength = nil) -> String
�����פ� password �Ǥ��� input ���Ǥ��������ޤ���

@param name name °�����ͤ���ꤷ�ޤ���

@param value °�����ͤ���ꤷ�ޤ���

@param size size °�����ͤ���ꤷ�ޤ���

@param maxlength maxlength °�����ͤ���ꤷ�ޤ���

��:
  password_field("name")
    # <INPUT TYPE="password" NAME="name" SIZE="40">

  password_field("name", "value")
    # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="40">

  password_field("password", "value", 80, 200)
    # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">

--- password_field(name = "", value = nil, size = 40, maxlength = nil) -> String
�����פ� password �Ǥ��� input ���Ǥ��������ޤ���

@param attributes °����ϥå���ǻ��ꤷ�ޤ���

��:
  password_field({ "NAME" => "name", "VALUE" => "value" })
    # <INPUT TYPE="password" NAME="name" VALUE="value">

