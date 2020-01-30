
<!--- launch template menu --->

<cfparam name="URL.ID1" default="">

<cf_NavigationLeftmenu
	 Alias           = "AppsEPAS"
	 Section         = "#URL.Section#"
	 ShowDescription = "1"
	 TableName       = "Contract"
	 Object          = "Contract"
	 Group           = "Contract"
	 PersonNo        = "#URL.PersonNo#"
	 ID              = "#URL.Id#"
	 ID1             = "#URL.ID1#"	 
	 IconWidth       = "28"
	 IconHeight      = "28">
		 