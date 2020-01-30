
<cfoutput>

<cfparam name="URL.Search" default="">
	
<cfsavecontent variable="header">
	
	<table cellspacing="0" width="100%" cellpadding="0" class="formpadding">
	
	<tr>
	
	 	 <cfset ht = "64">
		 <cfset wd = "64">
  
		  <cf_menutab item  = "1" 
		      iconsrc    = "Logos/System/Activity.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "1"
			  class      = "highlight"
			  name       = "User Activity"
			  source     = "#SESSION.root#/System/Access/User/Audit/UserOnLine.cfm?id=#url.id#">		
			  
		  <cf_menutab item  = "2" 
		      iconsrc    = "Logos/System/Sent-Mail.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  iframe     = "logbox"
			  targetitem = "2"
			  name       = "Mail Sent"
			  source     = "iframe:#SESSION.root#/System/Access/User/Audit/ListingMail.cfm?id=#url.id#">		
			  
		  <cf_menutab item = "3" 
		      iconsrc    = "Logos/System/Reports.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "2"
			  iframe     = "logbox"
			  name       = "Reports Generated"
			  source     = "iframe:#SESSION.root#/System/Access/User/Audit/ListingReport.cfm?id=#url.id#">					  		  	
			  
		  <cf_menutab item = "4" 
		      iconsrc    = "Logos/System/Errors.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "2"
			  iframe     = "logbox"
			  name       = "System Errors"
			  source     = "iframe:#SESSION.root#/System/Access/User/Audit/ListingError.cfm?id=#url.id#">				
		
		</tr>
		
	</table>
	
</cfsavecontent>	

<table width="100%" height="99%" border="0" cellspacing="0" align="center">
	
<tr>

    <td valign="top" colspan="7">
	
		<table width="98%" height="100%" cellspacing="0" cellpadding="0" align="center">		
			<tr><td height="28">#header#</td></tr>
			<tr><td height="1" class="line"></td></tr>	
			<tr><td height="100%">
			    <cf_divscroll style="height:96%">
				<table width="100%" height="100%" style="border:0px solid gray">	
				
				 <cf_menucontainer item="1"> 					
				 	<cfset init = "1">						
			  		<cfinclude template="UserOnLine.cfm">	
				 </cf_menucontainer>
				 				 
				 <cf_menucontainer item="2" class="hide" iframe="logbox">
				
				 </table>
				 </cf_divscroll>
			 </td>
			 </tr>
		</table>
	
	</td>
</tr>

</table>

</cfoutput>
