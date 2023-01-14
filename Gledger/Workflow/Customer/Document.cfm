
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionHeader
	WHERE   TransactionId = '#Object.objectKeyValue4#'
</cfquery>

<cfoutput> 

<table align="center" class="formpadding formspacing">

	   <tr><td height="10"></td></tr>
	   	  	   
	    <tr class="labelmedium2"><td style="height:15px"><cf_tl id="Customer">:</td>
		<td style="padding-left:5px"><input type="text" class="regularxxl" name="ReferenceName" value="#get.ReferenceName#" style="width:340px"></td>
		</tr>
		
		<tr class="labelmedium2"><td style="height:15px"><cf_tl id="Tax code">:</td>
		<td style="padding-left:5px"><input type="text" class="regularxxl" name="ReferenceNo" value="#get.ReferenceNo#" style="width:120px"></td>
		</tr>	  
	  				
</table>


<input name="savecustom" type="hidden"  value="GLedger/Workflow/Customer/DocumentSubmit.cfm">
<input name="Key4" type="hidden" value="#Object.ObjectKeyValue4#">

</cfoutput>

 

