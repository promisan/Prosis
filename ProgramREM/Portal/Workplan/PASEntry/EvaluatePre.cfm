
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

<cfquery name="WorkContract" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Contract
	WHERE  ContractId = '#URL.ContractID#'
</cfquery>

<cfquery name="Check" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   C.PasEvaluation as ContractEvaluation, 
	         R.PASEvaluation
	FROM     Contract C, Ref_ContractPeriod R
	WHERE    C.Period = R.Code
	AND      ContractId = '#URL.ContractID#'
</cfquery>

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>


<cfif Check.recordcount eq "1">

	<cfif Check.ContractEvaluation eq "" and Check.PasEvaluation lte now()>
	
		<!--- go ahead --->
	
	<cfelseif Check.ContractEvaluation neq "" and Check.ContractEvaluation lte now()>	
	 
	 	<!--- go ahead --->
		 		 
	<cfelse>	
			
	<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td valign="top">
			
		<table width="100%" border="0" align="center" class="formpadding">
		
		<cf_interface cde="EvaluationStop">
		
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
		
		<tr><td align="center" style="padding-top:70px;color:red;font-size:18px;font-weight: 200;">#Name#</td></tr>
		
		</cfoutput>  	
		
		<script>
			Prosis.busy('no')
		</script>
				
		<cfabort>

	</cfif>
	
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
		
		<cfset per = role.personno>
	
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

<!--- embed validation if the action can be performed already or if this is too early 

	<cfif Evaluate.ActionStatus lte "0p">
	
	   		<cf_interface cde="EvaluationError">
			<cf_message message="<cfoutput>#Name#</cfoutput> Rc:#Role.Recordcount# - AS:#Evaluate.ActionStatus#" return="no">
			<script>
			Prosis.busy('no')
			</script>
			
	<cfelse>
	
	--->
	
	<cf_divscroll>
			
	<table width="97%" height="100%" align="center">
	
	<tr><td valign="top" height="100%" style="padding-bottom:5px">
		
		<table width="100%" border="0" align="center" class="formpadding">
		
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
					
	    <cfset mode = "PreEvaluate">    <!--- does not show the scoring --->
		<cfset url.recordstatus = "2">  <!--- take updated action to be shown --->	

	   <tr><td colspan="2" style="padding-left:30px"><cfinclude template="EvaluateGeneral.cfm"></td></tr>	   
			      	   
	   <cfquery name="Contract" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Contract
			WHERE  ContractId = '#URL.ContractID#'
		</cfquery>	
		
	    <tr><td colspan="2">
	       <cfinclude template="TasksView.cfm">
	    </td></tr>
		
		<!---	   
		<cfif cwf eq "1" and Evaluate.ActionStatus gte "0">
		--->
		 <cfset per = evaluate.PersonNo>	
		 <!--- generate fly access to the workflow --->				
		 <cfinclude template="../PASView/CreateEvaluationAccessWorkflow.cfm">		
		 
		  <tr>						
			<td width="99%" class="labelit">					
				<table>
				<tr>
					<td class="labelmedium" style="height:40px;font-size:20px;padding-left:6px">
					<h1 style="font-size:30px;height:30px;padding:5px 15px 0;font-weight: 200;">
					<cf_tl id="Midterm review discussion"></h1></td>
				</tr>
				</table>						 
			</td>						 
		  </tr>		 
	     
		 <tr><td style="padding-left:30px">
		      <table width="99%" align="center">
			  <tr><td>		
			  
			  	 <cfset wflnk = "EvaluatePreWorkflow.cfm">			  
			     <cfset pk = Evaluate.EvaluationId>
			  
			     <cfoutput>			  
			        <input type="hidden" id="workflowlink_#pk#" value="#wflnk#"> 				  
			     </cfoutput>	  
 
			     <cfdiv id="#pk#"  bind="url:#wflnk#?ajaxid=#pk#"/> 	
			 
			 </td></tr>
			 </table>
			 </td>
		 </tr>
				 
		<!---		 
					
		</cfif> 	
		
		--->
			       	
		</table>
		
	
	</td>
	
	</tr>
	
	<tr><td style="padding-bottom:10px">
						
		<cfif SESSION.isAdministrator eq "Yes">
			<cfset rest = 1>
		<cfelse>
			<cfset rest = 0>
		</cfif>					
		
		<cfif Evaluate.ActionStatus lte "1">
				
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
			 NextMode      = "1"
			 NextName      = "Next"
			 NextSubmit    = "0"
			 SetNext       = "0">
			 
		<cfelseif Evaluate.ActionStatus gte "2">
													
		<cf_Navigation
			 Alias         = "AppsEPAS"
			 Object        = "Contract"
			 Group         = "Contract"
			 Section       = "#URL.Section#"
			 Id            = "#URL.ContractId#"
			 BackEnable    = "1"
			 HomeEnable    = "0"
			 ResetEnable   = "0"
			 ProcessEnable = "0"
			 ProcessName   = "Submit"
			 NextEnable    = "1"
			 NextMode      = "1"
			 NextName      = "Next"
			 NextSubmit    = "0"
			 SetNext       = "1">
					 				 
		 </cfif>
		 
		 </td></tr>
			
	</table>
		
	</cf_divscroll>
	

<!---			
	</cfif>
	--->
	
