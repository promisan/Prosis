
<table width="350" height="100%" border="0" class="formspacing" cellspacing="0" cellpadding="0"> 

<tr><td height="4"></td></tr>
<tr>

<cfset wd = "25">
<cfset ht = "25">
				
	<cf_menutab item       = "1" 
	            iconsrc    = "note1.gif" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "0"
				type       = "Horizontal"
				name       = "New Note"
				source     = "javascript:noteentry('#url.objectid#','','','notes','','regular','notecontainerdetail')">

	<cf_menutab item       = "2" 
	            iconsrc    = "logos/system/email.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "0"
				type       = "Horizontal"
				name       = "New Mail"
				source     = "javascript:noteentry('#url.objectid#','','','mail','','regular','notecontainerdetail')">

	<cf_menutab item       = "3" 
	            iconsrc    = "print.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "0"
				type       = "Horizontal"
				name       = "Print"
				source     = "javascript:printme()">
			
		
<cfparam name="url.mode" default="regular">

</tr>

</table>
