
<cf_screentop height="100%" scroll="No" html="No" jquery="Yes" menuaccess="context">

<cf_dialogPosition>
<cf_CalendarScript>

<cfparam name="URL.Status" default="9">

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

<cfquery name="PayrollItem" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
 	SELECT * 
	FROM   Ref_PayrollItem
	WHERE  Source IN ('Miscellaneous','Deduction')
	ORDER BY Source DESC
</cfquery>

<cf_divscroll>

<cfform action="MiscellaneousEditSubmit.cfm?Status=#URL.Status#" method="POST" name="MiscellaneousEdit">

<cfset openmode = "show">

<cfoutput>
<input type="hidden" name="PersonNo" value="#URL.ID#" class="regular">
<input type="hidden" name="CostId"   value="#URL.ID1#" class="regular">
</cfoutput>

<table width="98%" align="center">

<tr><td><cfinclude template="../PersonViewHeaderToggle.cfm"></td></tr>

<tr><td>

<table width="96%" align="center" class="formpadding">
  
   <tr class="line">
    
	<td style="padding:5px 10px 10px;font-size:30px;height:45px" class="labelit">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Miscellaneous.png" height="64" alt=""  border="0" align="absmiddle">
			
    	&nbsp;<cf_tl id="Edit Miscellaneous entry"> : <cfoutput>#entitlement.source#</cfoutput>
    </td>
	
  </tr> 	
       
  <tr>
    <td width="100%" class="header" style="padding-left:20px">
    <table border="0" cellpadding="0" cellspacing="0" align="center" width="100%" class="formpadding formspacing">
	
	<tr><td height="5"></td></tr>
	  
    <TR class="labelmedium">
    <TD><cf_tl id="Document date">:</TD>
    <TD>
	
		  <cf_intelliCalendarDate9
		FormName="MiscellaneousEdit"
		FieldName="DocumentDate" 
		class="regularxl"
		DateFormat="#APPLICATION.DateFormat#"
		Default="#Dateformat(Entitlement.DocumentDate, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
		
	</TD>
	</TR>
		
	<TR class="labelmedium">
    <TD width="140"><cf_tl id="Category">:</TD>
    <TD>
	
		<cfif Entitlement.Status lte "2">
		
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
	<TR class="labelmedium">
    <TD><cf_tl id="Reference">:</TD>
    <TD>
    <input type="text" name="documentReference" value="#Entitlement.DocumentReference#" class="regularxl" size="30" maxlength="30">		
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
    <TD>
  
		  <cf_intelliCalendarDate9
		FormName="MiscellaneousEdit"
		FieldName="DateEffective" 
		class="regularxl"
		DateFormat="#APPLICATION.DateFormat#"
		Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
 
		
	</TD>
	</TR>
		
	
		
	<TR class="labelmedium">
    <TD><cf_tl id="Category">:</TD>
    <TD>
	<table>
		<tr class="labelmedium">
		<td><INPUT type="radio" name="EntitlementClass" value="Deduction" <cfif Entitlement.EntitlementClass eq "Deduction">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:5px;padding-right:10px">Deduction</td>
		<td><INPUT type="radio" name="EntitlementClass" value="Payment" <cfif Entitlement.EntitlementClass eq "Payment">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:5px;padding-right:10px">Payment</td>
		<td><INPUT type="radio" name="EntitlementClass" value="Contribution" <cfif Entitlement.EntitlementClass eq "Contribution">checked</cfif>></td>
		<td class="labelmedium" style="padding-left:5px;padding-right:10px">Contribution</td>
		</tr>
	</table>
		
	</TD>
	</TR>
	
	</cfoutput>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Amount">:</TD>
    <TD>
	
		<table><tr><td>
	  	<select name="Currency" size="1" class="regularxl">
		<cfoutput query="Currency">
		<option value="#Currency#" <cfif Entitlement.Currency eq Currency>selected</cfif>>
    		#Currency#
		</option>
		</cfoutput>
	    </select>
		</td>
		<td style="padding-left:3px">
		
		<cfinput type="Text" name="Amount" value="#NumberFormat(Entitlement.Amount, ".__")#"
		    message="Please enter a correct amount" 
			validate="float" 
			required="Yes" 
			size="12" 
			maxlength="16" 
			class="regularxl"
			style="text-align: center">		
			
		</td></tr></table>	
			
	</TD>
	</TR>	
	
	<TR class="labelmedium">
    <TD><cf_tl id="Attachment">:</TD>
    <TD>		
			   	   
		<cf_filelibraryN
			DocumentPath="PersonalCost"
			SubDirectory="#entitlement.costid#" 
			Filter=""
			LoadScript="Yes"
			Insert="yes"
			Remove="yes"
			Listing="yes">
			
	</TD>
	</TR>	
	   
	<TR class="labelmedium">
        <td valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
        <TD><textarea style="width:99%;padding:3px;font-size:14px" class="regular" rows="2" name="Remarks"><cfoutput>#Entitlement.Remarks#</cfoutput></textarea> </TD>
	</TR>
	
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
      		
	<cfif Entitlement.entityClass neq "" and Entitlement.source eq "Manual">
		
			<tr><td height="1" colspan="2" class="line">
		
			<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Person
				WHERE  PersonNo = '#URL.ID#' 
			</cfquery>
	
			<cfquery name="currentContract" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT   TOP 1 L.*, 
			             R.Description as ContractDescription, 
				         A.Description as AppointmentDescription
			    FROM     PersonContract L, 
				         Ref_ContractType R,
					     Ref_AppointmentStatus A
				WHERE    L.PersonNo = '#URL.ID#'
				AND      L.ContractType = R.ContractType
				AND      L.AppointmentStatus = A.Code
				AND      L.ActionStatus != '9'
				ORDER BY L.DateEffective DESC 
		 	</cfquery>	
			
			<cfset link = "Staffing/Application/Employee/Cost/MiscellaneousEdit.cfm?id=#url.id#&id1=#Entitlement.CostId#">
			
			<cf_ActionListing 
			    EntityCode       = "EntCost"
				EntityClass      = "#PayrollItem.EntityClass#"
				EntityGroup      = "Individual"
				EntityStatus     = ""
				Mission 		 = "#currentContract.Mission#"
				PersonNo         = "#Person.PersonNo#"
				ObjectReference  = "#Entitlement.PayrollItem#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
				ObjectKey1       = "#URL.ID#"
				ObjectKey4       = "#Entitlement.CostId#"
				ObjectURL        = "#link#"
				Show             = "Yes"
				CompleteFirst    = "No">
						
			 </td></tr>
		 
	 </cfif>
	  
</table>

</CFFORM>

</cf_divscroll>
