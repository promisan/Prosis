
<table width="97%" height="100%">
<tr><td>
	
	<cfparam name="box"  default="1">
	<cfparam name="name" default="">
	<cfparam name="attributes.ajaxid" default="">
		
	<cfif Mode eq "Inquiry">
	
		<cf_filelibraryN
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ObjectId#" 
				Mode          = "portal"
				Filter        = "#DocumentCode#"
				LoadScript    = "No"
				AttachDialog  = "Yes"
				Width         = "100%"
				Box           = "#Box#"
				rowheader     = "No"
				Memo          = "#name#"
				Insert        = "no"
				Remove        = "no">	
	
	<cfelse>
	
		<cf_filelibraryN
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ObjectId#" 
				Mode          = "portal"
				Filter        = "#DocumentCode#"
				LoadScript    = "No"
				AttachDialog  = "Yes"				
				Width         = "100%"
				Box           = "#Box#"
				Memo          = "#name#"
				Insert        = "yes"
				Remove        = "yes">	
			
	</cfif>	
	
</td></tr>
</table>
		