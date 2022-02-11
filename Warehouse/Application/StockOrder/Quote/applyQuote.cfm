

<!--- apply quote --->

<table width="100%" height="100%">
<tr>
<td style="width:200px" valign="top">

      <table>
	  <tr>
	  
	  	<cf_tl id="Print Quote" var="1">
		<cfset wd = "68">
		<cfset ht = "68">
		<cfset itm = "1">
			 			
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/System/Document.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "4"					
					targetitem = "1"
					name       = "#lt_text#"
					source     = "applyQuoteGo.cfm?requestno=#url.requestno#&action=pdf&idmenu=#url.idmenu#">		
							
		</tr>	
		
		<tr>
	  
	  	<cf_tl id="Mail Quote" var="1">
		<cfset itm = itm+1>
					 			
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/System/MailOut.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "4"					
					targetitem = "1"
					name       = "#lt_text#"
					source     = "applyQuoteGo.cfm?requestno=#url.requestno#&action=quote&idmenu=#url.idmenu#">		
							
		</tr>		
		
		<tr>
	  
	  	<cf_tl id="Whatsapp" var="1">
		<cfset itm = itm+1>
					 			
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/System/Whatsapp.png?id=1" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "4"					
					targetitem = "1"
					name       = "#lt_text#"
					source     = "">		
							
		</tr>	
		
		<tr>
	  
	  	<cf_tl id="SalesForce" var="1">
		<cfset itm = itm+1>
					 			
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/System/SalesForce.png?id=3" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "4"					
					targetitem = "1"
					name       = "#lt_text#"
					source     = "applyQuoteGo.cfm?requestno=#url.requestno#&action=sf&idmenu=#url.idmenu#">		
							
		</tr>	
		
		<tr>
	  
	  	<cf_tl id="Send to POS" var="1">
		<cfset itm = itm+1>
					 			
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/WorkOrder/Billing.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "4"					
					targetitem = "1"
					name       = "#lt_text#"
					source     = "applyQuoteGo.cfm?requestno=#url.requestno#&action=pos&idmenu=#url.idmenu#">		
							
		</tr>		
		
		<tr>
	  
	  	<cf_tl id="Sales Order" var="1">
		<cfset itm = itm+1>
		
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/WorkOrder/Notes.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "4"					
					targetitem = "1"
					name       = "#lt_text#"
					source     = "applyQuoteGo.cfm?requestno=#url.requestno#&action=workorder&idmenu=#url.idmenu#">		
							
		</tr>									

		</table>				     
</td>

<td id="contentbox1" valign="top" style="height:100%;width:100%;padding-right:10px;padding-left:20px"></td>

</tr>
</table>

