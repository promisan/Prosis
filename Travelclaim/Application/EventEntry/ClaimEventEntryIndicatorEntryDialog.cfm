<!-------------------------------------------------------------------- Modification  Details ----------------------------------
				Date: 		20/10/2008
				By: 		Huda Seid
				Detail:     Added a row at the top to display the text:
				"Please do not claim for taxi to and form airport/station and for accommodation and meals expenses here."
------------------------------------------------------------------------------------------------------------------------------------>
<cfquery name="Currency" 
 datasource="AppsLedger" 
 cachedwithin="#CreateTimeSpan(0, 2, 0, 0)#"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT *
  FROM   Currency
</cfquery>

<cfquery name="Detail" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   ClaimEventIndicatorCost
	 WHERE  ClaimEventId   IN (SELECT ClaimEventId 
	                           FROM ClaimEvent
							   WHERE ClaimId= '#URL.ClaimId#')
	 AND  IndicatorCode  = '#URL.IndicatorCode#' 
	 <cfif url.id2 eq "new">
	 AND 1=0
	 <cfelse>
	 AND CostLineNo = '#URL.ID2#'
	 </cfif>	
</cfquery>


<table width="100%" height="100%" bgcolor="white" cellspacing="0" cellpadding="0">
<tr><td valign="top">

	<table width="94%" align="center" cellspacing="4" cellpadding="4">
	
	<cfform 
    action="#SESSION.root#/travelclaim/application/evententry/ClaimEventEntryIndicatorEntryDialogSubmit.cfm?title=#url.title#&editclaim=#url.editclaim#&ClaimId=#URL.ClaimId#&PersonNo=#URL.PersonNo#&IndicatorCode=#URL.IndicatorCode#&ID2=#URL.ID2#" 
    name="action">

	  <tr><td height="5"></td></tr>
	  <tr><td colspan="3"><b><cfoutput>#URL.Title#</cfoutput></td></tr>	
	  <tr><td colspan="3">Please do not claim for taxi to and form airport/station and for accommodation and meals expenses here.</td></tr> 
	  <tr>		
	  
	  		<td width="110">Date: <font color="FF0000">*</font></td>
			<td>
			
			<cf_helpfile 
					code    = "TravelClaim" 
					class   = "General"
					id      = "OTHR01"
					name    = "Expense Date"
					display = "icon">
					
			</td>
			<td width="70%">	
			
			   <cf_intelliCalendarDate8
			   	   fieldname="InvoiceDate"
      		       message="Please enter a valid date"
				   Default="#dateformat(detail.InvoiceDate,CLIENT.DateFormatShow)#"
				   AllowBlank="False"
				   Class="regularH">				
						
						
		     </td>
			 
	   </tr>	
	   
	   <TR bgcolor="ffffff">
	
		    <td>Description: <font color="FF0000">*</font></td>
			
			<td> <cf_helpfile 
					code    = "TravelClaim" 
					class   = "Indicator"
					id      = "#url.indicatorCode#"
					name    = "Other Advance"
					display = "icon">
			</td>
						
			<td>
			
			    <cfinput type="Text"
			       name="Description"
			       message="Please enter a description"
			       required="Yes"
				   value="#detail.Description#"
			       visible="Yes"
			       enabled="Yes"
				   style="width:100%"
			       size="25"
			       maxlength="50">
		 
			</td>
			
	  </tr> 
	   
	   <tr>
	   
	   		<td>Additional:</td>
			<td width="20"></td>
			
			<td align="absmiddle">
			
				 <input 
			     type="text" 
				 value="<cfoutput>#detail.InvoiceNo#</cfoutput>"
				 style="width:100%"
				 name="InvoiceNo" 
				 size="30" 
				 maxlength="30">
		 
			</td>
			
		</tr>
		
		<tr>	
		
			<td>Currency: <font color="FF0000">*</font></td>
			<td width="20">
			 <cf_helpfile 
					code    = "TravelClaim" 
					class   = "General"
					id      = "Currency"
					name    = "Claim Currency"
					display = "icon">
			</td>
			<td align="absmiddle">
			
				<select name="InvoiceCurrency" style="text-align: center;width:100%">
				
					<cfset cur = Detail.InvoiceCurrency>
					<cfif cur eq "">
					  <cfset cur = "USD">
					</cfif>
					<cfoutput query="Currency">
					      <option value="#Currency#" <cfif cur eq Currency>selected</cfif>>
						  #Currency#
						  </option>
					</cfoutput>
				
				</select>
			
			</td>
			
		</tr>
		
		<tr>
		
			<td>Amount: <font color="FF0000">*</font></td>	
			<td></td>
			<td>
			
				<cfinput type="Text"
			       name="InvoiceAmount"
			       value="#numberformat(Detail.InvoiceAmount,'__,__.__')#"
			       message="Please enter a valid amount (e.g 1,202.15)"
			       validate="float"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="10"
			       maxlength="15"
			       onchange="javascript:currencyFormat('InvoiceAmount',this.value);"
			       style="text-align:left;width:100%">
	   
			</td>
			
		</tr>
		
		<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>
		
		<tr>								   
			<td align="center" height="35" colspan="3">
			
			<input type="button" value="Close" onclick="ColdFusion.Window.hide('costings')" class="button10g">
			<input type="submit" value="Save" class="button10g">			
			</td>			    
		</TR>	
		
	</cfform>		
			
	</table>			
	
</td></tr>
</table>	
