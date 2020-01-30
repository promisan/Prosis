
<!--- icon="receipt.png"  --->

<cfparam name="url.receiptno" default="">

<cfif url.receiptNo eq "">
	
	<cf_screentop height="100%"    
	   label="Shipment, Receipt and Inspection" 	  
	   scroll="no" 
	   html="Yes" 
	   line="no"
	   jquery="Yes" 
	   layout="webapp" 
	   banner="blue">
   
</cfif>
	
<!--- passtry to create a iframe for a saving destination --->	

<table width="100%" height="100%">
	
	<cfoutput>
		<tr>
		   <td>
		   		<iframe src="ReceiptEntryContent.cfm?#cgi.query_string#"
		   		        width="100%"
		   		        height="100%"
		   		        scrolling="no"
		   		        frameborder="0"></iframe>
		   </td>
		</tr>
	</cfoutput>

</table>

<cfif url.receiptNo eq "">

	<cf_screenbottom layout="webapp"> 

</cfif>