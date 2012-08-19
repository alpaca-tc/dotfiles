kind=defined
names=submit
visibility=public

--- submit(value = nil, name = nil) -> String
�����פ� submit �Ǥ��� input ���Ǥ��������ޤ���

@param value value °�����ͤ���ꤷ�ޤ���

@param name name °�����ͤ���ꤷ�ޤ���

��:
  submit
    # <INPUT TYPE="submit">
  
  submit("ok")
    # <INPUT TYPE="submit" VALUE="ok">
  
  submit("ok", "button1")
    # <INPUT TYPE="submit" VALUE="ok" NAME="button1">
  
--- submit(attributes) -> String
�����פ� submit �Ǥ��� input ���Ǥ��������ޤ���

@param attributes °����ϥå���ǻ��ꤷ�ޤ���

��:
  submit({ "VALUE" => "ok", "NAME" => "button1", "ID" => "foo" })
    # <INPUT TYPE="submit" VALUE="ok" NAME="button1" ID="foo">

