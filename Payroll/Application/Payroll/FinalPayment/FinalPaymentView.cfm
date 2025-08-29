<!--
    Copyright © 2025 Promisan B.V.

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
<cf_actionListingScript>
<cf_FileLibraryScript>	

<cfquery name="get"
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT     *
      FROM       Payroll.dbo.EmployeeSettlement ES
	  WHERE      SettlementId = '#url.settlementid#'	           
</cfquery> 

<cfif get.RecordCount lte 0>

	<cfoutput>
	  <table align="center"><tr class="labelmedium"><td style="font-size:20px;height:40px">
		This record was removed, please refresh your selection.
		</td></tr></table>
	</cfoutput>

	<cfquery name="get"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Organization.dbo.OrganizationObject
			WHERE ObjectKeyValue4 = '#url.settlementid#'
			AND EntityCode = 'FinalPayment'
	</cfquery> 

	<cfabort>
	
</cfif>

<cfquery name="person"
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT     *
      FROM       Person
	  WHERE      PersonNo = '#get.PersonNo#'	           
</cfquery> 

<cfinvoke component="Service.Access"
	Method="PayrollOfficer"
	Role="PayrollOfficer"
	Mission="#get.mission#"
	ReturnVariable="PayrollAccess">		
	
<cfif PayrollAccess neq "NONE">
		
	<cf_screenTop height="100%" jquery="Yes" 
	    html="yes" band="no" scroll="yes" menuaccess="context" layout="webapp" label="Final Payment #Person.FullName#" actionobject="Person"
		actionobjectkeyvalue4="#get.settlementid#">	
	
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
		   <tr><td height="10" style="padding-left:7px">	
				  <cfset ctr      = "1">		
			      <cfset openmode = "open"> 
				  <cfset url.id = get.PersonNo>
				  <cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
				 </td>
		   </tr>	
			
		   <cfquery name="get"
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT     *
			      FROM       Payroll.dbo.EmployeeSettlement
				  WHERE      SettlementId = '#url.settlementid#'	           
		   </cfquery> 
	
		   <cfoutput>	   
		   <tr><td style="padding-left:31px;padding-right:15px" class="labellarge">
		   <table width="100%"><tr>
		   <td class="labellarge"><font color="808080"><cf_tl id="Process Final Payment adjustments and corrections"></font>:&nbsp;#dateformat(get.PaymentDate,client.dateformatshow)# #get.Mission# #get.SalarySchedule#&nbsp;<cfif get.ActionStatus eq "0"><cf_tl id="On hold"><cfelseif get.ActionStatus eq "3"><cf_tl id="Off cycle"></cfif></td>
		   <td align="right" class="labellarge" style="padding-right:7px">
		   <a href="javascript:EditPerson('#url.id#','','leave')">[<cf_tl id="Shortcut Employee Profile">]</a>
		   </td>		   
		   </tr></table>
		   </td></tr> 	    		  	   
		   </cfoutput>
		   
		   <tr><td colspan="1" class="line"></td></tr> 
		  
		   <tr><td height="20" valign="top">	
		   
			   <table width="98%" cellspacing="0" cellpadding="0" align="center">	   
			   <tr>				   
			   <td style="padding-left:15px;padding-right:15px">		
			   
			       <cfoutput>	   
				   <cfset wflnk = "FinalPaymentWorkflow.cfm">		   
				   
			    	<input type="hidden" 
		    	      id="workflowlink_#get.SettlementId#" 
		        	  value="#wflnk#">  
					  
			       <cfdiv id="#get.SettlementId#" bind="url:#wflnk#?ajaxid=#get.SettlementId#"/>	
				   
				   </cfoutput>
				   		   	   			   
			   </td>	   		   
		       </tr>
			   </table> 	
			 	
			 </td>
		   </tr>	 
		   
		</table>

</cfif>
	