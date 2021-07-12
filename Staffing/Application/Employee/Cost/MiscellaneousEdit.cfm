
<cfparam name="URL.Status" default="9">
<cfparam name="URL.Header" default="1">

<cfif url.header eq "1">
	<cf_screentop height="100%" scroll="No" html="No" jquery="Yes" title="Miscellaneous entry" menuaccess="context">
</cfif>

<cf_dialogPosition>
<cf_dialogLedger>
<cf_ActionListingScript>

<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    PersonMiscellaneous P, Ref_PayrollItem R
	WHERE   P.PayrollItem = R.PayrollItem
	AND     PersonNo = '#URL.ID#'
	AND     CostId   = '#URL.ID1#'
</cfquery>

<!--- adjust to check also for the role of contract manager create --->

<cfif getAdministrator("#Entitlement.Mission#") eq "999" 
      or  Entitlement.Status eq "0" 
	  or (Status eq "2" and EntityClass eq "")>
	  
	  <cfset edit = "1">
	  
	  <cf_CalendarScript>
	  
<cfelse>

	  <cfset edit = "0">	  
	  
</cfif>	

<cfquery name="PayrollItem" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
 	SELECT   * 
	FROM     Ref_PayrollItem
	WHERE    Source IN ('Miscellaneous','Deduction')
	ORDER BY Source DESC
</cfquery>

<cf_divscroll>

<cfform action="MiscellaneousEditSubmit.cfm?Status=#URL.Status#" method="POST" name="MiscellaneousEdit">

<cfset openmode = "hide">

<cfoutput>
	<input type="hidden" name="PersonNo" value="#URL.ID#"   class="regular">
	<input type="hidden" name="CostId"   value="#URL.ID1#"  class="regular">
</cfoutput>

<table width="98%" align="center">


<tr><td><cfinclude template="../PersonViewHeaderToggle.cfm"></td></tr>

<tr><td>

<table width="96%" align="center" class="formpadding">
  
   <tr class="line">
    
	<td style="padding:5px 2px 2px;font-size:30px;height:40px" class="labelit">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Miscellaneous.png" height="64" alt=""  border="0" align="absmiddle">
			
    	&nbsp;<cf_tl id="Edit Miscellaneous entry"> : <cfoutput>#entitlement.source#</cfoutput>
    </td>
	
  </tr> 	
       
  <tr>
    <td width="100%" class="header" style="padding-left:20px">
    <table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" class="formpadding formspacing">
	
	<tr><td height="5"></td></tr>
	  
    <TR class="labelmedium2">
    <TD><cf_tl id="Document date">:</TD>
    <TD>
	
		<cfif edit eq "1">
	
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="DocumentDate" 
			class="regularxl"
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(Entitlement.DocumentDate, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cfoutput>#Dateformat(Entitlement.DocumentDate, CLIENT.DateFormatShow)#</cfoutput>
		
		</cfif>
		
	</TD>
	</TR>
		
	<TR class="labelmedium2">
    <TD width="140"><cf_tl id="Category">:</TD>
    <TD>
	
		<cfif edit eq "1">
		
		  	<select name="Entitlement" size="1" class="regularxl">
			<cfoutput query="PayrollItem">
			<option value="#PayrollItem#" <cfif Entitlement.PayrollItem eq PayrollItem>selected</cfif>>
    			#PayrollItemName#
			</option>
			</cfoutput>
		    </select>
		
		<cfelse>
		
			<cfoutput>
		
			#Entitlement.PayrollItemName#
			<input type="hidden" name="Entitlement" value="#entitlement.PayrollItem#">
			
			</cfoutput>
		
		</cfif>
		
	</TD>
	</TR>
		
	<cfoutput>
	<TR class="labelmedium2">
    <TD><cf_tl id="Reference">:</TD>
    <TD>
	<cfif edit eq "1">
	    <input type="text" name="documentReference" value="#Entitlement.DocumentReference#" class="regularxl" size="30" maxlength="30">		
	<cfelse>
	     <cfoutput>#Entitlement.DocumentReference#</cfoutput>
	</cfif>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Due date">:</TD>
    <TD>
	
		<cfif edit eq "1">
  
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="DateEffective" 
			class="regularxl"
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cfoutput>#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#</cfoutput>
		
		</cfif>
 
		
	</TD>
	</TR>	
	
	
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Payroll date">:</TD>
    <TD>
	
		<cfif edit eq "1">
  
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="PayrollStart" 
			class="regularxl"
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(Entitlement.PayrollStart, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cfoutput>#Dateformat(Entitlement.PayrollStart, CLIENT.DateFormatShow)#</cfoutput>
		
		</cfif>
 
		
	</TD>
	</TR>	
		
	<TR class="labelmedium2">
    <TD><cf_tl id="Category">:</TD>
    <TD>
	
	<cfif edit eq "1">

		<table>
		<tr class="labelmedium2">
		<td><INPUT type="radio" class="radiol" onclick="ptoken.navigate('showAdvance.cfm?transactionid=#Entitlement.SourceId#&class=payment&personno=#url.id#','ledger')"		
		name="EntitlementClass" value="Payment" <cfif Entitlement.EntitlementClass eq "Payment">checked</cfif>></td>
		<td style="padding-left:5px;padding-right:10px"><cf_tl id="Payment"></td>
		<td><INPUT type="radio" class="radiol" onclick="ptoken.navigate('showAdvance.cfm?transactionid=#Entitlement.SourceId#&class=deduction&personno=#url.id#','ledger')"
		name="EntitlementClass" value="Deduction" <cfif Entitlement.EntitlementClass eq "Deduction">checked</cfif>></td>
		<td style="padding-left:5px;padding-right:10px"><cf_tl id="Deduction">
				
		<cfif Entitlement.Source eq "Ledger" and entitlement.SourceId neq "">
		
			<cfquery name="Advance" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT    *
				FROM      TransactionHeader AS H
				WHERE     Transactionid = '#Entitlement.SourceId#' 			           
			</cfquery>
			
			<cfif advance.recordcount eq "1">
			
			:&nbsp;<a href="javascript:ShowTransaction('#Advance.journal#','#Advance.journalserialNo#','','tab','')">#Advance.Journal#-#Advance.journalSerialNo#</a>
			
			</cfif>
		
		</cfif>
		
		</td>		
		<td><INPUT type="radio" class="radiol" onclick="ptoken.navigate('showAdvance.cfm?transactionid=#Entitlement.SourceId#&class=contribution&personno=#url.id#','ledger')"
		name="EntitlementClass" value="Contribution" <cfif Entitlement.EntitlementClass eq "Contribution">checked</cfif>></td>
		<td style="padding-left:5px;padding-right:10px"><cf_tl id="Contribution"></td>
		</tr>
		</table>
		
	<cfelse>
	
		<cfoutput>#Entitlement.EntitlementClass#</cfoutput>
	
	</cfif>	
		
	</TD>
	</TR>
	
	
	<tr>			   	  
	   <td colspan="2" id="ledger" style="padding-left:10px;padding-right:10px">
	   <cfif Entitlement.EntitlementClass eq "Deduction">	  
	       <cfset url.class = Entitlement.EntitlementClass>
		   <cfset url.transactionid = Entitlement.SourceId>
		   <cfinclude template="showAdvance.cfm">	   
	   </cfif>
	   </td>
	</tr>
	
	
	</cfoutput>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Amount">:</TD>
    <TD>
	
		<table><tr><td>
		
		<cfif edit eq "1">
		
		  	<select name="Currency" size="1" class="regularxl">
			<cfoutput query="Currency">
			<option value="#Currency#" <cfif Entitlement.Currency eq Currency>selected</cfif>>
	    		#Currency#
			</option>
			</cfoutput>
		    </select>
			
		<cfelse>
		
			<cfoutput>#Entitlement.Currency#</cfoutput>
		
		</cfif>	
		</td>
		<td style="padding-left:3px">
		
		<cfif edit eq "1">
		
		<cfinput type="Text" name="Amount" value="#NumberFormat(Entitlement.Amount, ".__")#"
		    message="Please enter a correct amount" 
			validate="float" 
			required="Yes" 
			size="12" 
			maxlength="16" 
			class="regularxl"
			style="text-align: center">		
			
		<cfelse>
		
			<cfoutput>#NumberFormat(Entitlement.Amount, ".__")#</cfoutput>
		
		</cfif>	
			
		</td></tr></table>	
			
	</TD>
	</TR>	
			
		<cfif edit eq "1">
		
		<TR class="labelmedium2">
        <td valign="top" style="padding-top:7px"><cf_tl id="Remarks">:</td>
        <TD>
		
		<textarea style="width:99%;padding:3px;font-size:14px" class="regular" rows="2" name="Remarks"><cfoutput>#Entitlement.Remarks#</cfoutput></textarea> 
		
		<cfelse>
		
		<TR class="labelmedium2">
        <td><cf_tl id="Remarks">:</td>
        <TD>
		
		<cfoutput>#Entitlement.Remarks#</cfoutput>
		
		</cfif>
		
		</TD>
				
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Attachment">:</TD>
    <TD>		
	
		<cfif edit eq "1">
			   	   
			<cf_filelibraryN
				DocumentPath="PersonalCost"
				SubDirectory="#entitlement.costid#" 
				Filter=""
				LoadScript="Yes"
				Insert="yes"
				Remove="yes"
				Listing="yes">
			
		<cfelse>
		
			<cf_filelibraryN
				DocumentPath="PersonalCost"
				SubDirectory="#entitlement.costid#" 
				Filter=""
				LoadScript="Yes"
				Insert="no"
				Remove="no"
				Listing="yes">
		
		</cfif>	
			
	</TD>
	</TR>	
		
	<cfif edit eq "1">
	
		<tr><td colspan="2" class="line"></td></tr> 
		 	 	
		<tr><td colspan="2" align="center" height="35">
		  <cfoutput>
	   	   <cf_tl id="Back" var="1">
		   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="history.back()">
		   <cf_tl id="Delete" var="1">	  	  
		   <input class="button10g" type="submit" name="Delete" value="#lt_text#">
	   	   <cf_tl id="Save" var="1">	  	  
		   <input class="button10g" type="submit" name="Submit" value="#lt_text#">	   
		  </cfoutput>
		  
	   </td>
	   </tr>
   
   </cfif>
      		
	<cfif Entitlement.entityClass neq "" and Entitlement.source neq "SUN">
		
			<tr><td height="1" colspan="2" class="line">
						
			<cfset url.ajaxid = Entitlement.CostId>
			
			<cfoutput>
			
			<cfset wflnk = "#session.root#/Staffing/Application/Employee/Cost/MiscellaneousWorkFlow.cfm">
			
			
			<input type="hidden" 
		          id="workflowlink_#url.ajaxid#" 
        		  value="#wflnk#">  
			  
			<table width="99%" align="center">
				<tr><td style="padding-left:1px;padding-right:1px" id="#url.ajaxid#"><cfinclude template="MiscellaneousWorkFlow.cfm"></td></tr>			
			</table>
			
			</cfoutput>
		
			 </td></tr>
		 
	 </cfif>
	  
</table>

</CFFORM>

</cf_divscroll>
