			
<cfparam name="URL.header" default="0">

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Claim R
    WHERE ClaimId = '#URL.ClaimId#' 
</cfquery>

<cfquery name="Indicator" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Ref_Indicator
    WHERE Code = '#URL.IndicatorCode#' 
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
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="new">   
</cfif>

<table width="740" align="center" border="0" cellspacing="0" cellpadding="2">	    

	<cfif Claim.ActionStatus gte "2" and Detail.recordcount eq "0">
	    <tr><td></td><td height="1" bgcolor="d8d8d8"></td></tr>
		<tr><td></td><td><font color="0080C0">No expenses recorded</td></tr>
		<tr><td></td><td height="1" bgcolor="d8d8d8"></td></tr>			
	</cfif>
	
	<!--- disabled 
		
	<cfif URL.Header eq "1">
	
    <TR>
	   <td width="200">
	   <table border="0" cellspacing="0" cellpadding="0">		   
		   <tr>
		   <td>Description <font color="#FF0000">(required)</font></td>
		   <td>  <cf_helpfile 
					code    = "TravelClaim" 
					class   = "Indicator"
					id      = "#url.indicatorCode#"
					name    = "Other Advance"
					display = "icon">
   		  </td>
		  </tr>
	  </table>
	   </td>
	   <td width="110">Date <font color="FF0000">(required)</font></td>
	   <td width="120">Additional Info</td>
	   <td width="80" align="left">
	   <table cellspacing="0" cellpadding="0"><tr><td>Curency</td>
	   <td>
	   <cf_helpfile 
					code    = "TravelClaim" 
					class   = "General"
					id      = "Currency"
					name    = "Claim Currency"
					display = "icon">
	   </td>
	   </tr>
	   </table>
	   </td>
	   <td width="100">Amount <font color="#FF0000">(required)</font></td>
	   <td width="100">
	   				
	   </td>
    </TR>
	<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
	<tr><td height="2"></td></tr>
		
	</cfif>
	
	--->
	
	
 <cfinvoke component="Service.Presentation.Presentation" 
	           method="highlight" 
			   returnvariable="stylescroll">
	 </cfinvoke>
				
	<cfoutput query="Detail">				
							
		<tr bgcolor="ffffff" #stylescroll#>
		   <td width="200"><cfif Description eq ""><b>Not submitted</b><cfelse>#Description#</cfif></td>
		   <td width="110" height="18">&nbsp;&nbsp;&nbsp;#DateFormat(InvoiceDate, CLIENT.DateFormatShow)#</td>
		   <td width="120"><cfif InvoiceNo eq ""><cfelse>#InvoiceNo#</cfif></td>
		   <td width="80" align="center">#InvoiceCurrency#</td>
		   <td width="100" align="right"><cfif InvoiceAmount lt 0><font color="red"></cfif>#numberFormat(InvoiceAmount,",__.__")#</td>			  
		   <td width="120" align="left">&nbsp;
		   
		   <cfif Claim.ActionStatus lte "1" and editclaim eq "1">
		   
		        <a href="javascript:insertcost('#indicator.description#','#url.editclaim#','#url.claimid#','#url.personno#','#URL.IndicatorCode#','#CostLineNo#')" title="Add Entry">
		    	<font color="0080FF">Edit</font>&nbsp;</a>
				|&nbsp;						   
			    <A href="javascript:deletecost('#url.editclaim#','#url.claimid#','#url.personno#','#URL.IndicatorCode#','#CostLineNo#')">
				<font color="0080FF">Delete</font></a>
				&nbsp;
				
			</cfif>
			
			<input type="hidden" name="inv#currentrow#" value="#InvoiceAmount#">
							
		  </td>
		   
	    </TR>	
		
		 <tr><td height="1" colspan="6" bgcolor="e4e4e4"></td></tr>
		
	</cfoutput>		
									
	<cfif Claim.ActionStatus lte "1" and editclaim eq "1">

		<cfoutput>		
		 <tr>
		  <td height="1" colspan="6">
		     <a name="add#url.indicatorcode#" 
		       id="add#url.indicatorcode#" 
			   href="javascript:insertcost('#indicator.description#','#url.editclaim#','#url.claimid#','#url.personno#','#URL.IndicatorCode#','new')" title="Add Entry"><font color="0080FF">Add #indicator.description#</font></a></td>
		 </tr>
		</cfoutput>
	
	 <tr><td height="1" colspan="6" bgcolor="e4e4e4"></td></tr>
	
	</cfif>
						
</table>
			
