<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="url.refer"  default="">
<cfparam name="url.mode"   default="#url.refer#">
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

<cfif url.refer eq "workflow">

      <cfset edit = "0">	

<cfelseif (getAdministrator("#Entitlement.Mission#") eq "1" and Entitlement.Status neq "5")
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
	AND      (Operational = 1 or PayrollItem = '#Entitlement.PayrollItem#')
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

<table width="99%" align="center" class="formpadding">
  
   <tr class="line">
    
	<td style="padding:5px 2px 2px;font-size:30px;height:40px" class="labelit">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Miscellaneous.png" height="64" alt=""  border="0" align="absmiddle">
			
    	&nbsp;<cf_tl id="Edit Miscellaneous entry"> : <cfoutput>#entitlement.source#</cfoutput>
    </td>
	
  </tr> 	
       
  <tr>
    <td width="100%" class="header" style="padding-left:20px">
    <table align="center" width="100%" class="formpadding">
	
    <TR class="labelmedium2">
    <TD style="width:180px"><cf_tl id="Document date">:</TD>
    <TD>
	
		<cfif edit eq "1">
	
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="DocumentDate" 
			class="regularxl"
			message="Incorrect document date"
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
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Due date">:</TD>
    <TD>
	
		<cfif edit eq "1">
  
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="DateEffective" 
			class="regularxl"
			message="Incorrect due date"
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cfoutput>#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#</cfoutput>
		
		</cfif>
 
		
	</TD>
	</TR>	
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Payroll date">:</TD>
    <TD>
	
		<cfif edit eq "1">
  
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="PayrollStart" 
			class="regularxl"
			message="Incorrect payroll date"
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
		<td><INPUT type="radio" class="radiol" onclick="ptoken.navigate('getAdvance.cfm?currency='+document.getElementById('currency').value+'&transactionid=#Entitlement.SourceId#&class=deduction&personno=#url.id#','ledger')"
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
		
	<cfif Entitlement.EntitlementClass eq "Deduction">	  
	
		<tr>			   	  
		   <td colspan="2" id="ledger" style="padding-left:5px;padding-right:7px">	   
	       <cfset url.class = Entitlement.EntitlementClass>
		   <cfset url.transactionid = Entitlement.SourceId>
		   <cfset url.currency = Entitlement.Currency>
		   <cfinclude template="getAdvance.cfm">	   
		   </td>
		</tr>	
		
	<cfelse>
	
	     <tr>			   	  
		   <td colspan="2" id="ledger" style="padding-left:5px;padding-right:7px">	   	       
		   </td>
		</tr>	
		
		
	</cfif>

	
	</cfoutput>
	
	<TR class="labelmedium2">
	
    <TD><cf_tl id="Amount">:</TD>
	
    <TD>
	
		<table>
		<tr class="labelmedium2">
		<td>
		
		<cfif edit eq "1">
		
		  	<select name="Currency" id="currency" size="1" class="regularxl">
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
			
		</td>
		</tr>
		</table>	
			
	</TD>
	</TR>	
			
	<cfif edit eq "1">
		
		<TR class="labelmedium2">
        <td valign="top" style="padding-top:7px"><cf_tl id="Remarks">:</td>
        <TD>		
		<textarea style="width:99%;padding:3px;font-size:14px" class="regular" rows="2" name="Remarks"><cfoutput>#Entitlement.Remarks#</cfoutput></textarea> 
		</td>
		</tr>
		
	<cfelse>
		
		<cfif Entitlement.Remarks neq "">
		<tr class="labelmedium2">
	        <td><cf_tl id="Remarks">:</td>
    	    <td><cfoutput>#Entitlement.Remarks#</cfoutput></td>
		</tr>
		</cfif>
		
	</cfif>
	
	<TR class="labelmedium2">
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
	
	<cfif url.refer eq "workflow">
	   
   	<tr><td colspan="2" class="line"></td></tr> 
		 	 	
		<tr><td colspan="2" align="center" height="35">
		  <cfoutput>
	   	   <cf_tl id="Close" var="1">
		   <input type="button" name="cancel" value="#lt_text#" style="width:200px;height:25px" class="button10g" onClick="window.close()">		 
		  </cfoutput>
		  
	   </td>
	   </tr>
		
	<cfelseif edit eq "1">
	
		<tr><td colspan="2" class="line"></td></tr> 
		 	 	
		<tr><td colspan="2" align="center" height="35">
		  <cfoutput>
	   	   <cf_tl id="Back" var="1">
		   <input type="button" name="cancel" value="#lt_text#" class="button10g" style="width:200px;height:25px" onClick="history.back()">
		   <cf_tl id="Delete" var="1">	  	  
		   <input class="button10g" type="submit" name="Delete" value="#lt_text#" style="width:200px;height:25px">
	   	   <cf_tl id="Save" var="1">	  	  
		   <input class="button10g" type="submit" name="Submit" value="#lt_text#" style="width:200px;height:25px">	   
		  </cfoutput>
		  
	   </td>
	   </tr>
	   
   <cfelse>
   
   	<tr><td colspan="2" class="line"></td></tr> 
		 	 	
		<tr><td colspan="2" align="center" height="35">
		  <cfoutput>
	   	   <cf_tl id="Back" var="1">
		   <input type="button" name="cancel" value="#lt_text#" style="width:200px;height:25px" class="button10g" onClick="history.back()">		 
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
			  
			<table width="100%" align="center">
				<tr><td style="padding-left:1px;padding-right:1px" id="#url.ajaxid#"><cfinclude template="MiscellaneousWorkFlow.cfm"></td></tr>			
			</table>
			
			</cfoutput>
		
			 </td></tr>
		 
	 </cfif>
	  
</table>

</CFFORM>

</cf_divscroll>
