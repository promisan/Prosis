<!---
<cfif SESSION.isAdministrator eq "No">

	<table width="100%" align="center">
	<tr><td height="60" align="center"><font face="Verdana" size="3" color="FF0000">You do not have access to this function</font></td></tr>
	</table>
	
	<cfabort>

</cfif>
--->

<cf_screentop html="no" jquery="yes">

<cf_menuscript>
<cf_listingscript>

<cfajaximport tags="cfform,cfinput-datefield">

<cfoutput>

	<script>
		function toggledate(line,image) {
		   
			se   = document.getElementsByName(line);		
			img  = document.getElementById(image);
			cnt = 0
					
			if (se[0].className == "regular") {			
			
				    img.src = "#SESSION.root#/Images/arrowright.gif";
					while (se[cnt]) {
					     se[cnt].className = "hide";
					     cnt++
					}			
								
			} else {
				
				    img.src= "#SESSION.root#/Images/arrowdown.gif";
					while (se[cnt]) {
						se[cnt].className = "regular";
						cnt++
					    }					
			}		
		}	
	</script>
	
</cfoutput>
<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

	<tr>
		<td height="20" style="padding-top:17px">
		
			<table width="98%" align="center" cellspacing="0" cellpadding="0">
			<tr>
			
					<cfset wd = "64">
					<cfset ht = "64">		
					
					<cf_menutab base       = "exception"
					            item       = "1" 
					            iconsrc    = "Pending-Tickets.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "1"
								padding    = "8"
								class      = "highlight1"
								name       = "Pending Exceptions"
								source     = "#client.root#/System/Portal/Exception/ExceptionListingPending.cfm">
								
					<cf_menutab base       = "exception"
					            item       = "2" 
					            iconsrc    = "Pending-Review.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#"
								targetitem = "1"
								padding    = "8"
								name       = "Pending Review"
								source     = "#client.root#/System/Portal/Exception/ExceptionListingForReview.cfm">			
								
					<cf_menutab base       = "exception"
					            item       = "3" 
					            iconsrc    = "Dismissed-Tickets.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "1"
								padding    = "8"							
								name       = "Dismissed Exceptions"
								source     = "#client.root#/System/Portal/Exception/ExceptionListingDismiss.cfm">													
					
				<td width="20%"></td>	
					
			</tr>						
			</table>		
		
		</td>
	</tr>
	
	<tr><td height="4"></td></tr>

	<tr><td height="1" class="line"></td></tr>

	<tr><td height="98%" style="padding:10px">
	
		<cf_divscroll>

		<table width="100%" height="100%">
				
				<cf_menucontainer item="1" class="regular">
					    <cfinclude template="ExceptionListingPending.cfm">					
				</cf_menucontainer>
							
		</table>
		
		</cf_divscroll>

	</td>	
	</tr>

	<tr><td height="4"></td></tr>

</table>