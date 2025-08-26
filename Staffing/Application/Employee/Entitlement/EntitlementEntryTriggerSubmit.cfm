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
<cf_assignId>
	 
<cfparam name="URL.entitlementId" default="#rowguid#">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script language="JavaScript">
	function editEntitlement(persno, no) {
		 window.location = "EntitlementEditTrigger.cfm?ID=" + persno + "&ID1=" + no;
	}
</script>

<cfset mode = "rate">

<cfif Len(Form.Remarks) gt 800>
  <cfset remarks = left(Form.Remarks,800)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfparam name="Form.EntitlementDate" default="">

<cfset dateValue = "">
<cfif Form.EntitlementDate neq ''>
    <CF_DateConvert Value="#Form.EntitlementDate#">
    <cfset ENT = dateValue>
<cfelse>
    <cfset ENT = STR>
</cfif>	

<cfquery name="Trigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_PayrollTrigger
	WHERE SalaryTrigger = '#Form.SalaryTrigger#'
</cfquery>

<cfif Trigger.enablePeriod eq "0">
	<cfset end = str>
</cfif>

<cfoutput>

<cfif end lt str and end neq 'NULL'>

	<table width="100%" height="90%" cellspacing="0" cellpadding="0" align="center">
	    <tr>
		<td valign="middle" align="center">
		<table>
		<tr style="padding-top:200px">
			<td align="center" height="30" class="labellarge" style="padding-top:100px">
			<font color="FF0000">An incorrect period was selected</font>
			</td>
		</tr>
		<cf_tl id="Back" var="1">
		<tr><td align="center" style="padding-top:14px">
		<input type="button" class="button10g" style="width:100;height:23" value="#lt_text#" onClick="history.back()">	
		</td></tr>
	    </table>
	    </td>
		</tr>
	</table>				
	<cfabort>
</cfif>	

</cfoutput>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#Form.PersonNo#' 
</cfquery>

<!--- verify if record exist --->

<cfquery name="VirtualEnd" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE PersonEntitlement
	SET    DateExpiration  = '01/01/2099'
	WHERE  PersonNo        = '#Form.PersonNo#' 
	AND    Status != '9'
	AND    DateExpiration is NULL 
</cfquery>

<cfparam name="Form.Terminate" default="">
<cfset term = "">
<cfloop index="itm" list="#form.terminate#">
  <cfif term eq "">
  	<cfset term = "'#itm#'">
  <cfelse>
  	<cfset term = "#term#,'#itm#'">
  </cfif>
</cfloop>

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    PersonEntitlement
	WHERE   PersonNo        = '#Form.PersonNo#' 
	AND     SalaryTrigger   = '#Form.SalaryTrigger#' 
	AND     (
	      	(DateExpiration >= #STR# AND DateEffective <= #STR#) OR 
		 	(DateEffective <= #END#  AND DateExpiration >= #END#) OR
		    (DateExpiration is NULL  OR  DateExpiration = '')
		    ) 	
	AND     Status != '9'
	<cfif form.terminate neq "">
	AND     EntitlementId NOT IN (#preservesinglequotes(term)#)
	</cfif>
</cfquery>

<cfquery name="Reset" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  PersonEntitlement
	SET     DateExpiration  = NULL
	WHERE   PersonNo        = '#Form.PersonNo#'  
	AND     DateExpiration  = '01/01/2099' 
	AND     Status != '9'
</cfquery>

<cfparam name="Entitlement.RecordCount" default="0">
<cfparam name="allowOverlap" default="1">

<!--- added by dev dev as per devs request 
there are people who will have more than one entitlement in one month.
June 2007
--->

<cfif Entitlement.recordCount gte 1 and allowOverlap eq "0"> 
	
	<cfoutput>
	
	<cfparam name="URL.ID" default="#Entitlement.PersonNo#">
	<cfinclude template="../PersonViewHeader.cfm">
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr>
	<td align="center">
		<font face="Verdana" size="2" color="FF0000"><b>An entitlement with an overlapping period is found</font></b>
	</td></tr>
	<tr><td align="center">
	<input type="button" class="button10g" style="width:100;height:23" value="Entitlement" onClick="editEntitlement('#Entitlement.PersonNo#','#Entitlement.EntitlementId#');">
	</td></tr>
	</table>
	</cfoutput>

<CFELSE>
	
	 <cfset entid = URL.entitlementId>

     <cftransaction>
	 
	  <cfif Trigger.EnableAmount eq "1">	  
		  <cfset amt  = replace("#Form.Amount#",",","","ALL")>	  
	  </cfif>
	 
      <cfquery name="InsertEntitlement" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PersonEntitlement 
		         (PersonNo,
				 EntitlementId,
				 EntitlementDate,
				 DateEffective,
				 DateExpiration,
				 SalarySchedule,
				 EntitlementClass,
				 EntitlementGroup,
				 SalaryTrigger,
				 DocumentReference,		
				 <cfif Trigger.EnableAmount eq "1">
				 Currency,
				 Amount,
				 </cfif>	 
				 Remarks,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	      VALUES ('#Form.PersonNo#',
			      '#entid#',
				  #ENT#,
			      #STR#,
				  #END#,
				  '#Form.SalarySchedule#',
				  '#Trigger.EntitlementClass#',
				  '#Form.EntitlementGroup#',
				  '#Form.SalaryTrigger#',
				  '#Form.DocumentReference#',
				   <cfif Trigger.EnableAmount eq "1">
				   '#Form.Currency#',
				   '#amt#',
				   </cfif>
				  '#Remarks#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	    </cfquery>
		
		<cfset action = "3061">	
		<cfset mode = "trigger">		
		<cfinclude template="EntitlementActionSubmit.cfm">
		
		<!--- check if there is a need to record dependents --->
		
		<cfparam name="form.dependents" default="">
						
		<cfif trigger.salarytrigger eq trigger.triggerdependent 
		    and Trigger.TriggerCondition eq "Dependent">
		
			<cfloop index="itm" list="#form.dependents#">	
			
				<cfquery name="check" 
			     datasource="AppsPayroll" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT  *
					 FROM    PersonDependentEntitlement 
					 WHERE   PersonNo      = '#Form.PersonNo#'
					 AND     DependentId   = '#itm#'
					 AND     SalaryTrigger = '#Form.SalaryTrigger#'
					 AND     DateEffective =  #STR#
				</cfquery>
				
				<cfif check.recordcount eq "0">
				
					  <cfquery name="Group" 
					     datasource="AppsPayroll" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     SELECT  *
							 FROM    Ref_PayrollTriggerGroup 
							 WHERE   SalaryTrigger = '#Form.SalaryTrigger#'
							 ORDER BY ListingOrder					
					  </cfquery>
											
					  <cfquery name="InsertEntitlement" 
					     datasource="AppsPayroll" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO PersonDependentEntitlement 
						        (PersonNo,
								 DependentId, 		
								 ParentEntitlementId,				
								 DateEffective,
								 DateExpiration,
								 SalaryTrigger,
								 EntitlementGroup,
								 Status,						 
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
					      VALUES ('#Form.PersonNo#',
							      '#itm#',		
								  '#entid#',			     
							      #STR#,
								  #END#,						 
								  '#Form.SalaryTrigger#',
								  '#Group.EntitlementGroup#',
								  '2',
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
						</cfquery>		
						
				  </cfif>		
		
			</cfloop>
						
		</cfif>
		  
		<cfloop index="itm" list="#form.terminate#" delimiters=",">
	
			 <cfquery name="CancelEntitlement" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 UPDATE  PersonEntitlement
				 SET     Status = '9'
				 WHERE   EntitlementId       = '#itm#'
				 AND     DateEffective      <= #STR#
				 AND     DateExpiration      > #END# 
			 </cfquery>
			 
			  <cfquery name="UpdateEntitlement" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 UPDATE  PersonEntitlement
				 SET     DateExpiration      = #STR#-1
				 WHERE   EntitlementId       = '#itm#'
				 AND     DateEffective      <= #STR#
				 AND     (DateExpiration     > #STR# OR DateExpiration is NULL OR DateExpiration = '') 
			 </cfquery>
			 
			 <!--- added 16/11/2017 update associated dependent records --->
			 
			  <cfquery name="UpdateEntitlementDependent" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 UPDATE  PersonDependentEntitlement
				 SET     DateExpiration      = #STR#-1
				 WHERE   PersonNo            = '#Form.PersonNo#'				
				 AND     ParentEntitlementId = '#itm#'			 
			 </cfquery>		 
	
	</cfloop>
			
	</cftransaction>  	  
		 	
	<cfquery name="OnBoard" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM      PersonAssignment
		WHERE     PersonNo       = '#Form.PersonNo#' 
		AND       DateEffective  < #END#
		AND       DateExpiration >= #STR#
		AND       AssignmentStatus IN ('0','1') 
		ORDER BY  DateExpiration DESC
	</cfquery>		  
		
	<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEditTrigger.cfm?ID=#Form.PersonNo#&ID1=#rowguid#">

	<cf_ActionListing 
	    EntityCode       = "EntEntitlement"
		EntityClass      = "Standard"
		EntityGroup      = "Rate"
		EntityStatus     = ""
		OrgUnit          = "#OnBoard.OrgUnit#"
		PersonNo         = "#Person.PersonNo#"
		ObjectReference  = "#Entitlement.SalaryTrigger#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#"
	    ObjectKey1       = "#Form.PersonNo#"
		ObjectKey4       = "#rowguid#"
		ObjectURL        = "#link#"
		Show             = "No"
		CompleteFirst    = "No">  	  
		     	    
     <cfoutput>
	 
	 <cf_SystemScript>
	
     <script language = "JavaScript">
	      ptoken.location("EmployeeEntitlement.cfm?ID=#Form.PersonNo#");
      </script>	
	 
	</cfoutput>	   
	
</cfif>	

