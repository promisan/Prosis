
<!--- launch template menu --->

<cfparam name="URL.ID1" default="">

<cf_NavigationLeftmenu
	 Alias     = "AppsTravelClaim"
	 Object    = "Claim"
	 TableName = "Claim"
	 Section   = "#URL.Section#"
	 Group     = "TravelClaim"
	 PersonNo  = "#URL.PersonNo#"
	 ID        = "#URL.ID#">
		 
		 