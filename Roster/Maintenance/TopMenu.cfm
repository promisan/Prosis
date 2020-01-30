
<cfparam name="URL.IDRefer" default="">

<cf_menuTopHeader
  idrefer        = "#URL.IDRefer#"
  idmenu         = "#URL.IDMenu#"
  template       = "HeaderMenu1"
  systemModule   = "'Roster'"
  items          = "2"
    
  Header1        = "Reference Tables"
  FunctionClass1 = "'Maintain'"
  MenuClass1     = "'Main'"
  
  Header2        = "PHP Keywords"
  FunctionClass2 = "'Maintain'"
  MenuClass2     = "'PHP'">