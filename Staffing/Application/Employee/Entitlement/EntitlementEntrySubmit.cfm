<cf_assignId>
	 
<cfparam name="URL.entitlementId" default="#rowguid#">
	 
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfoutput>

<cfset mode = "personal">

<script language="JavaScript">

function editEntitlement(persno, no) {
   window.location = "EntitlementEdit.cfm?Status=#URL.Status#&ID=" + persno + "&ID1=" + no;
}
</script>

</cfoutput>

<cfif Len(Form.Remarks) gt 800>
  <cfset remarks = left(FORM.Remarks,800)>
<cfelse>
  <cfset remarks = FORM.Remarks>
</cfif>  

<cfparam name="Form.Terminate" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = "NULL">
</cfif>	

<cfoutput>


<cfif form.entitlement eq "">

	<table width="100%" height="90%" cellspacing="0" cellpadding="0" align="center">
	    <tr>
		<td valign="middle" align="center">
		<table>
		<tr style="padding-top:200px">
			<td align="center" height="30" class="labellarge" style="padding-top:100px">
			<font color="FF0000">You must select an item</font>
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

<cfif end lt str and end neq "NULL">

	<table width="100%" height="90%" cellspacing="0" cellpadding="0" align="center">
	    <tr>
		<td valign="middle" align="center">
		<table>
		<tr style="padding-top:200px">
			<td align="center" height="30" class="labellarge" style="padding-top:100px">
			<font color="FF0000">An incorrect effective period has been selected</font>
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

<!--- verify if record exist --->

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#Form.PersonNo#' 
</cfquery>

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
	SELECT *
	FROM   PersonEntitlement
	WHERE  PersonNo       = '#Form.PersonNo#' 
	AND    PayrollItem    = '#Form.Entitlement#' 
	AND    PayrollItem IN (SELECT PayrollItem FROM Ref_PayrollItem WHERE AllowOverlap = 0)
	AND    (
	      	(DateExpiration >= #STR# AND DateEffective <= #STR#) OR 
		 	(DateEffective <= #END#  AND DateExpiration >= #END#) OR
		    (DateExpiration is NULL  OR  DateExpiration = '')
		   ) 	
	AND Status != '9'
	<cfif form.terminate neq "">
	AND EntitlementId NOT IN (#preservesinglequotes(term)#)
	</cfif>
</cfquery>

<cfparam name="Entitlement.RecordCount" default="0">

<cfquery name="Allow" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT PayrollItem, AllowOverlap
	FROM   Ref_PayrollItem 
	WHERE  PayrollItem    = '#Form.Entitlement#' 
</cfquery>

<cfif Entitlement.recordCount gte 1 and Allow.AllowOverLap eq "0"> 
	
	<cfoutput>
	
	<cfparam name="URL.ID" default="#Entitlement.PersonNo#">
	<cfinclude template="../PersonViewHeader.cfm">
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr>
	<td align="center" height="30">
	<font face="Verdana" size="2" color="FF0000"><b>An entitlement with an overlapping period is found</font></b></p>
	</td></tr>
	<tr><td align="center">
	<input type="button" class="button10g" style="width:100;height:23" value="Edit" onClick="editEntitlement('#Entitlement.PersonNo#','#Entitlement.EntitlementId#');">	
	</td></tr>
	</table>
	
	</cfoutput>

<CFELSE>
	
	
	<cftransaction>
	
	<cfset entid = URL.entitlementId> 	
	
      <cfquery name="InsertEntitlement" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO PersonEntitlement 
         (PersonNo,
		 EntitlementId,
		 DateEffective,
		 DateExpiration,
		 DependentId,
		 SalarySchedule,
		 DocumentReference,
		 EntitlementClass,
		 PayrollItem,
		 Currency,
		 Amount,
		 Period,
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#Form.PersonNo#',
	      '#entid#',
	       #STR#,
		  #END#,
		  <cfif form.dependentId neq "">
		  '#Form.dependentId#',
		  <cfelse>
		  NULL,
		  </cfif>
		  '#Form.SalarySchedule#',
		  '#Form.DocumentReference#',
		  'Amount',
		  '#Form.Entitlement#',
		  '#Form.Currency#',
		  '#Form.Amount#',
		  '#Form.Period#',
		  '#Remarks#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
    </cfquery>
	
	<cfset action = "3061">			
	<cfset mode = "personal">
	<cfset ripple1 = "">
	<cfset ripple9 = "">
	
	<cfloop index="itm" list="#form.terminate#" delimiters=",">
	
		 <!--- define the old as archive under "9" abd create a new entry in conjunction --->
		 
		 <!--- insert new for remainer status = 2" --->
		 
		<cf_assignId>
		 
		<cfquery name="Insert" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 INSERT INTO PersonEntitlement (
			      
				  PersonNo, 
				  EntitlementId,
				  DependentId, 
				  EntitlementDate, 
				  DateEffective, 
				  DateExpiration, 
				  SalarySchedule, 
				  EntitlementClass, 
				  SalaryTrigger, 
                  EntitlementGroup, 
				  EntitlementSalaryDays, 
				  PayrollItem, 
				  Period, 
				  Currency, 
				  Amount, 
				  DocumentReference, 
				  Remarks, 			   
                  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)

			 SELECT  PersonNo, 
			         '#rowguid#',
				     DependentId, 
				     EntitlementDate, 
				     DateEffective, 
				     #STR#-1, 
				     SalarySchedule, 
				     EntitlementClass, 
				     SalaryTrigger, 
                     EntitlementGroup, 
				     EntitlementSalaryDays, 
				     PayrollItem, 
				     Period, 
				     Currency, 
				     Amount, 
				     DocumentReference, 
				     Remarks, 			   
                     '#SESSION.acc#',
		    	     '#SESSION.last#',		  
	  			     '#SESSION.first#'
				  
			 FROM    PersonEntitlement
			 WHERE   EntitlementId = '#itm#'		
			 AND     DateEffective <= #STR#
			 AND     (DateExpiration > #STR# or DateExpiration is NULL or DateExpiration = '') 	
			 
		</cfquery>
		 
		<cfquery name="get" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   PersonEntitlement			 
			 WHERE  EntitlementId = '#rowguid#'
		</cfquery>
		 
		<cfif get.recordcount eq "1">
		 	<cfif ripple1 eq "">
				<cfset ripple1 = "#rowguid#">
			<cfelse>
			    <cfset ripple1 = "#ripple1#,#rowguid#">
			</cfif>	
		</cfif>
		 
		<cfquery name="revoke" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   PersonEntitlement			 
			 WHERE  EntitlementId = '#itm#'			
		</cfquery>
		 
		<cfif revoke.recordcount eq "1">
		 		 
			 <!--- update the old one to status = 9" --->
		
			 <cfquery name="CancelEntitlement" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				 UPDATE PersonEntitlement
				 SET    Status = '9'
				 WHERE  EntitlementId = '#itm#'			
			 </cfquery>
		 		 
			<cfif ripple9 eq "">
				<cfset ripple9 = "#itm#">
			<cfelse>
			    <cfset ripple9 = "#ripple9#,#itm#">
			</cfif>	
					 
		</cfif>	 
			
	</cfloop>
	
	<!--- create the action --->
	<cfinclude template="EntitlementActionSubmit.cfm">
				
	</cftransaction>
			
	<cfquery name="OnBoard" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM      PersonAssignment
		WHERE     PersonNo = '#Form.PersonNo#' 
		AND       DateEffective < #STR#
		AND       DateExpiration >= #STR#
		AND       AssignmentStatus IN ('0','1') 
		ORDER BY  DateExpiration DESC
	</cfquery>

	<cfquery name="currentContract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT TOP 1 L.*, 
		           R.Description as ContractDescription, 
			       A.Description as AppointmentDescription
		    FROM   PersonContract L, 
			       Ref_ContractType R,
				   Ref_AppointmentStatus A
			WHERE  L.PersonNo = '#Form.PersonNo#'
			AND    L.ContractType = R.ContractType
			AND    L.AppointmentStatus = A.Code
			AND    L.ActionStatus != '9'
			ORDER BY L.DateEffective DESC 
	</cfquery>		
		
	<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEdit.cfm?ID=#Form.PersonNo#&ID1=#entid#">

	<cf_ActionListing 
	    EntityCode       = "EntEntitlement"
		EntityClass      = "Standard"
		EntityGroup      = "Individual"
		EntityStatus     = ""
		Mission			 = "#currentContract.Mission#"		
		OrgUnit          = "#OnBoard.OrgUnit#"
		PersonNo         = "#Person.PersonNo#"
		ObjectReference  = "#Form.Entitlement#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#"
	    ObjectKey1       = "#Form.PersonNo#"
		ObjectKey4       = "#entid#"
		ObjectURL        = "#link#"
		Show             = "No"		
		CompleteFirst    = "No">
			    
     <cfoutput>
	 
	<cf_SystemScript>
	
    <script LANGUAGE = "JavaScript">
	     ptoken.location("EmployeeEntitlement.cfm?ID=#Form.PersonNo#&Status=#URL.Status#");
    </script>	
	
	</cfoutput>	   
	
</cfif>	

