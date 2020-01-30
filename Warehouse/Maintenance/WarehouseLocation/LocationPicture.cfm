
<!--- check access rights 
	
	<cfinvoke component = "Service.Access"  
	   method           = "AssetManager" 
	   mission          = "#Asset.Mission#" 
	   assetclass       = "#Asset.category#"
	   returnvariable   = "access">	
	
	<cfif access eq "ALL" or Access eq "EDIT">
	 <cfset mode = "edit">
	<cfelse>
	 <cfset mode = "view">
	</cfif>   

--->

<cfset mode = "edit">

<cf_divscroll>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td id="picturebox">
	
	    <cf_PictureView documentpath="Warehouse"
	        subdirectory="#url.id#"
			filter="Picture_" 							
			width="800" 
			height="400" 
			scope="dialog"
			mode="#mode#">		
	
	</td></tr>

</table>

</cf_divscroll>
