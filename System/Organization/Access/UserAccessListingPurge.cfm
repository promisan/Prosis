
<cfinvoke component="Service.Access.AccessLog"  
		 method="DeleteAccessAll"
		 UserAccount   = "#URL.ID#"
		 OfficerUserId = "#URL.OfficerUserId#">	 

<cflocation url="UserAccessListingGranted.cfm?id=#url.id#" addtoken="No">


