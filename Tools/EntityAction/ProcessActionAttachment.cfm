
<table width="100%" height="100%" align="center" class="formpadding">
<tr><td>
	
	<cfparam name="box" default="1">
	<cfset color = "ffffff">
	<cfparam name="script" default="yes">
		
		<cfif Mode eq "Inquiry">
	
		<cfif SESSION.isAdministrator eq "Yes">
			 <cfset md = "yes">
		<cfelse>
			 <cfset md = "no"> 
		</cfif>
	
		<cf_filelibraryN
				DocumentPath = "#EntityCode#"
				SubDirectory = "#ActionId#" 
				Filter       = ""		
				Color        = "#color#"		
				Width        = "100%"
				Box          = "reg#Box#"
				AttachDialog = "Yes"
				LoadScript   = "#script#"
				rowheader    = "No"
				Insert       = "#md#"
				Remove       = "#md#">	
	
	<cfelse>
	
		<cf_filelibraryN
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ActionId#" 
				Filter        = ""			
				Color        = "#color#"		
				Width         = "100%"
				AttachDialog  = "Yes"
				LoadScript    = "#script#"
				Box           = "reg#Box#"
				Insert        = "yes"
				Remove        = "yes">	
			
	</cfif>	
		
</td></tr>
</table>
		