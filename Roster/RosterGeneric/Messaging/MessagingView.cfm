
<cf_screentop html="No" jquery="Yes">
<cfajaximport>

<cfparam name="CLIENT.ApplicantNo" default="">
<cfparam name="url.ApplicantNo"    default="#CLIENT.ApplicantNo#">

<cf_listingscript>
<cf_textAreaScript>	
<cf_PresentationScript>
<cf_FileLibraryScript>
<cf_LayoutScript>
<cf_DialogStaffing>

<table width="100%" height="100%"><tr><td style="padding:10px;width:100%;height:100%">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	   	position  = "top"
	   	name      = "phptop"
	   	minsize	  = "30px"
		maxsize	  = "30px"
		size 	  = "30px">	
		
	<table width="100%" height="100%">
	<tr><td style="padding-top:20px;padding:2px;font-size:30px" class="labellarge">
		<cfoutput>Exchange Messages with #url.owner# candidates </cfoutput>
	</td>
	</tr>
	</table>	
						 			  
	</cf_layoutarea>		
	
	<cf_layoutarea position="center" name="box">	
	
	<table width="100%" height="100%">
	<tr><td valign="top" style="padding:10px">
	    
		<cfset url.systemfunctionid = url.idmenu>
		
		<cfinclude template="MessagingListing.cfm">	
		
	</td>
	</tr>
	</table>	
	
	</cf_layoutarea>
	
	<cf_layoutarea size="29%" 
	    style= "border-left:1px solid ##d0d0d0;" 
		minsize = "300px" 
		position="right" 
		name="right" 
		collapsible="Yes">
			
		<table height="100%" width="100%"><tr><td align="center" id="messaging" valign="top"></td></tr></table>					
					
	</cf_layoutarea>
			
</cf_layout>	

</td></tr></table>

