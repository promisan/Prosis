<cfparam name="url.contractId" 	default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.type" 		default="">

<cfif url.contractid eq "">
	<cfset url.contractid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cf_ActionListingScript>
<cf_FileLibraryScript>
 
<cfquery name="Param" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Parameter	
</cfquery>

<cfquery name="Check" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   C.PasEvaluation as ContractEvaluation, 
	         R.PasEvaluation
	FROM     Contract C, Ref_ContractPeriod R
	WHERE    C.Period = R.Code
	AND      ContractId = '#URL.ContractID#'
</cfquery>

<cfif Check.recordcount eq "1">

	<cfif (Check.ContractEvaluation gt now() and Check.ContractEvaluation neq "") and 
	      (Check.PasEvaluation gt now() and Check.ContractEvaluation eq "")>
	
		<cf_interface cde="EvaluationStop">

		<script>
			Prosis.busy('no')
		</script>
		<cf_message message="#Name#" return="No">
		
		<cfabort>
		
	</cfif>	
		
</cfif>

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ContractSection
	WHERE  Code = '#URL.Section#'
</cfquery>

<cfquery name="Contract" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Contract
	WHERE Contractid     = '#URL.ContractId#' 
</cfquery>

<!--- disable that a person can evaluate him/herself --->
<cfif client.PersonNo eq Contract.PersonNo>
	<cfset mode = "View">
<cfelse>
	<cfset mode = "Evaluate">
</cfif>

<cfquery name="Evaluate" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ContractEvaluation
	WHERE EvaluationType = '#URL.Type#'
	AND   Contractid     = '#URL.ContractId#' 
</cfquery>

<cfquery name="Prior" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     ContractEvaluation
	WHERE    Contractid     = '#URL.ContractId#'	
	AND      EvaluationType != '#URL.Type#'
	AND      ActionStatus = '2'
	AND      EvaluationId IN (SELECT EvaluationId FROM ContractEvaluationBehavior)
	ORDER BY Created DESC
</cfquery>

<cfif Prior.recordcount gte "1">
	<cfset evlist = "Prior,Evaluate">
<cfelse>
    <cfset evlist = "Evaluate">
</cfif>

<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ContractActor
		WHERE  Contractid     = '#URL.ContractId#' 
		AND    Role           = 'Evaluation'
		AND    RoleFunction   = 'FirstOfficer'
		AND    ActionStatus   = '1'
</cfquery>
	
<cfif Evaluate.recordcount eq "0">
		
	<cfif Role.recordcount gte "1">
		
		<cfquery name="Insert" 
			datasource="appsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO ContractEvaluation
				  	(ContractId,
					EvaluationType,
					PersonNo, 
					RoleFunction,
					ActionStatus, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName)
	    		VALUES ('#URL.ContractId#',
					    '#URL.Type#',
					    '#Role.PersonNo#',
						'#Role.RoleFunction#',
					  	'0',
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#')
		</cfquery>
	
	</cfif>
	
</cfif>

<cfquery name="Evaluate" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ContractEvaluation
		WHERE Contractid     = '#URL.ContractId#'
		AND   EvaluationType = '#URL.Type#'
	</cfquery>

<!---

<cfif (Role.Recordcount eq "0" or Evaluate.ActionStatus lte "0p") and Evaluate.ActionStatus lt "1">

   		<cf_interface cde="EvaluationError">
		
		<script>
		parent.Prosis.busy('no')
		</script>
		
		<cf_message message="<cfoutput>#Name#</cfoutput> Rc:#Role.Recordcount# - AS:#Evaluate.ActionStatus# " return="no">
		
		
<cfelse>

--->

<cfform action="EvaluateSubmit.cfm?ContractId=#URL.ContractId#&EvaluationID=#Evaluate.EvaluationID#&type=#evaluate.evaluationtype#&Code=#URL.Code#&Section=#URL.Section#&recordstatus=#url.recordstatus#&mode=#mode#" method="post">

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td valign="top" style="padding-left:20px;padding-right:20px">
		
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">	    
		<tr>				
			<td class="labellarge" style="font-size:30px;height:10px;padding:10px 8px 0;font-weight: 200;">#Section.Description#</h1></td>							
		</tr>
		<cfif section.Instruction neq "">
		<tr>					
			<td class="labellarge" style="color:6688aa;font-size:16px;padding:10px 8px 0;font-weight: 200;">#Section.Instruction#</h1></td>																					
		</tr>
		</cfif>
	</table>				
    </td>
</tr> 		

</cfoutput>		
		
<tr><td style="padding-left:30px;padding-top:10px">
  <cfinclude template="EvaluateGeneral.cfm">
</td></tr>

<tr><td valign="top" style="padding-left:10px;">

   <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		    
	   
	<cfif Evaluate.ActionStatus gte "0">	 
	    
		 <tr><td>
		      <table width="99%" align="center">
			  <tr><td>		  
			  
			  	 <cfset wflnk = "EvaluateWorkflow.cfm">			  
			     <cfset pk = Evaluate.EvaluationId>
			  
			     <cfoutput>			  
			        <input type="hidden" id="workflowlink_#pk#" value="#wflnk#"> 				  
			     </cfoutput>	  
 
			     <cfdiv id="#pk#"  bind="url:#wflnk#?ajaxid=#pk#"/> 									
			 
			 </td></tr>
			 </table>
			 </td></tr>
				
   </cfif> 	
	
   <cfif Evaluate.ActionStatus gte "0p">
   
   <!--- we only show this once completed --->
      	   
   <cfquery name="Contract" 
	datasource="appsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Contract
		WHERE  ContractId = '#URL.ContractID#'
	</cfquery>	
   	
   <tr><td colspan="2" style="padding-right:20px">   
   	  <cfinclude template="EvaluateBehavior.cfm">	
   </td></tr>
    
    <tr><td colspan="2" style="padding-right:20px">		
      <cfinclude template="EvaluateTasks.cfm">
   </td></tr>
   	  
   <cfif Param.HideTraining eq "0">
   <tr><td colspan="2" style="padding-right:20px">
	 <cfinclude template="EvaluateTraining.cfm">
   </td></tr>   
   </cfif>
   
   </cfif>
    	
</table>

</tr>

<cfif mode eq "evaluate">
	
	<cfset rest = 0>
	
	<cfif Evaluate.ActionStatus eq "0">		
	
		<cf_Navigation
		 Alias         = "AppsEPAS"
		 Object        = "Contract"
		 Group         = "Contract"
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 BackEnable    = "1"
		 HomeEnable    = "0"
		 ResetEnable   = "#rest#"
		 ProcessEnable = "0"
		 ProcessName   = "Submit"
		 NextEnable    = "0"
		 NextMode      = "0"
		 NextSubmit    = "0"
		 SetNext       = "0">
		 
	<cfelseif Evaluate.ActionStatus eq "0p" and role.recordcount gte "1">	
	
		<cf_Navigation
		 Alias         = "AppsEPAS"
		 Object        = "Contract"
		 Group         = "Contract"
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 BackEnable    = "1"
		 HomeEnable    = "0"
		 ResetEnable   = "#rest#"
		 ProcessEnable = "1"
		 ProcessName   = "Submit"
		 NextEnable    = "1"
		 NextMode      = "1"
		 NextSubmit    = "1"
		 SetNext       = "0"> 
		 
	<cfelseif Evaluate.ActionStatus eq "1">
		
	<cf_Navigation
		 Alias         = "AppsEPAS"
		 Object        = "Contract"
		 Group         = "Contract"
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 BackEnable    = "0"
		 HomeEnable    = "0"
		 ResetEnable   = "0"
		 ProcessEnable = "0"
		 ProcessName   = "Submit"
		 NextEnable    = "0"
		 NextMode      = "0"
		 NextSubmit    = "0"
		 SetNext       = "0">
		
		<!--- no not show the navigation row --->	 		 	 		 
   
   <cfelseif Evaluate.ActionStatus eq "2">
	 	  		 
		 <cf_Navigation
			 Alias         = "AppsEPAS"
			 Object        = "Contract"
			 Group         = "Contract"
			 Section       = "#URL.Section#"
			 Id            = "#URL.ContractId#"
			 BackEnable    = "1"
			 HomeEnable    = "0"
			 ResetEnable   = "#rest#"
			 ProcessEnable = "0"
			 NextEnable    = "0"
			 NextMode      = "1"
			 NextName      = "Next"
			 SetNext       = "1">
			 				 
	 </cfif>
	 
<cfelse>

	<script>
	parent.Prosis.busy('no')
	</script>	 
	 
</cfif>	 

</table>
  
</cfform>	

<!---
</cfif>
--->
