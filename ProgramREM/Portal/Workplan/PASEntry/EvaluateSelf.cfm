<cf_screentop html="no" scroll="yes" jquery="yes">

<cfparam name="url.type" default="preparation">
<cfparam name="url.actionstatus" default="2">
<cfparam name="mode" default="view">

<cf_textareascript>

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>

<cfquery name="WorkContract" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Contract
	WHERE  ContractId = '#URL.ContractID#'
</cfquery>

<cfquery name="Evaluation" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     ContractEvaluation
	WHERE    Contractid     = '#URL.ContractId#'	
	AND      EvaluationType = '#URL.Type#'
	ORDER BY Created DESC
</cfquery>

<cfif Evaluation.recordcount eq "0">
	
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
	
	<cfquery name="Evaluation" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ContractEvaluation
		WHERE Contractid     = '#URL.ContractId#'
		AND   EvaluationType = '#URL.Type#'
	</cfquery>
		
</cfif>

<cfajaximport tags="cfmenu,cfdiv,cfwindow">
<cf_ActionListingScript>

<cfoutput>

<cfif workcontract.personNo neq client.personNo and Evaluation.ActionStatus lte "0p" and getAdministrator("*") eq "0">

	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					  
		  <tr>
		    <td height="90" align="left">				
					<table width="100%">
						<tr>					
							<td class="labellarge"><h1 style="font-size:30px;height:40px;padding:10px 25px 0;font-weight: 200;">#Section.Description#</h1></td>							
						</tr>
						<cfif section.Instruction neq "">
						<tr>					
							<td class="labellarge"><h1 style="color:6688aa;font-size:16px;height:60px;padding:10px 25px 0;font-weight: 200;">#Section.Instruction#</h1></td>																					
						</tr>
						</cfif>
					</table>				
		    </td>
		  </tr> 	
		  
		  <tr><td valign="top" style="padding-left:25px;padding-right:25px;padding-top:10px">
		  	 <table height="100%" width="100%">
			 <tr>
			 <td valign="top" bgcolor="D0FDC4" style="font-size:15px;padding:4px;border:1px solid silver">
		     #Evaluation.Evaluation#	
			 </td>
			 </tr>
			 </table>		 
			 </td>
		 </tr>
		  
		  <tr><td colspan="2" style="height:40px">
	
			 <cf_Navigation
					 Alias         = "AppsEPAS"
					 Object        = "Contract"
					 Group         = "Contract"
					 Section       = "#URL.Section#"
					 Id            = "#URL.ContractId#"
					 SetNext       = "0"
					 BackEnable    = "1"
					 HomeEnable    = "0"
					 ResetEnable   = "0"
					 ResetDelete   = "0"	
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 NextMode      = "1"
					 NextSubmit    = "0"
					 NextName      = "Next">
			 
			 </td></tr>
		  
	</table>  
	
<cfelseif Evaluation.ActionStatus gte "0p">

	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
						  
		 <tr>
		    <td height="90" align="left">				
					<table width="100%">
						<tr>					
							<td class="labellarge"><h1 style="font-size:30px;height:40px;padding:10px 25px 0;font-weight: 200;">#Section.Description#</h1></td>							
						</tr>
						<cfif section.Instruction neq "">
						<tr>					
							<td class="labellarge"><h1 style="color:6688aa;font-size:16px;height:60px;padding:10px 25px 0;font-weight: 200;">#Section.Instruction#</h1></td>																					
						</tr>
						</cfif>
					</table>				
		    </td>
		  </tr> 	
		  
		  <tr><td valign="top" style="padding-left:25px;padding-right:25px;padding-top:10px">
		  	 <table height="100%" width="100%"><tr><td valign="top" bgcolor="FEE3DE" style="padding:4px;border:1px solid silver">
		     #Evaluation.Evaluation#	
			 </td></tr></table>		 
			 </td></tr>
		 
			<tr><td colspan="2" style="height:40px">
			
			 <cf_Navigation
					 Alias         = "AppsEPAS"
					 Object        = "Contract"
					 Group         = "Contract"
					 Section       = "#URL.Section#"
					 Id            = "#URL.ContractId#"
					 SetNext       = "0"
					 BackEnable    = "1"
					 HomeEnable    = "0"
					 ResetEnable   = "0"
					 ResetDelete   = "0"	
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 NextMode      = "1"
					 NextSubmit    = "0"
					 NextName      = "Next">
					 
					 </td>
			 </tr>
			 
		</table>  	 	
	
<cfelse>

	<cfform style="height:100%" action="EvaluateSelfSubmit.cfm?Code=#URL.Code#&EvaluationId=#Evaluation.EvaluationId#&Section=#URL.Section#" method="post">
		
		<table width="99%" height="100%" align="center" cellspacing="0" cellpadding="0">
		
		<tr><td valign="top" height="100%">
					
		<cf_divscroll>
						
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
		  <tr>
		    <td height="80" align="left">				
					<table width="100%">
						<tr>					
							<td class="labellarge"><h1 style="font-size:30px;height:40px;padding:15px 15px 0;font-weight: 200;">#Section.Description#</h1></td>							
						</tr>
						<cfif section.Instruction neq "">
						<tr>					
							<td class="labellarge"><h1 style="color:6688aa;font-size:16px;height:50px;padding:15px 15px 0;font-weight: 200;">#Section.Instruction#</h1></td>																					
						</tr>
						</cfif>
					</table>				
		    </td>
		  </tr> 								  
						
			<cfquery name="Evaluate" 
				datasource="AppsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  ContractEvaluation
					WHERE Contractid     = '#URL.ContractId#'
					AND   EvaluationType = '#URL.Type#'
			</cfquery>
		 	 		   
		   <tr><td style="padding-top:20px;padding-left:30px;padding-right:20px">
		   
		    <cf_textarea name="Description"                                            
			   height         = "300"
               width          = "100%"
			   toolbar        = "basic"
			   loadscript     = "Yes"
			   resize         = "0"
			   color          = "ffffff">#Evaluation.Evaluation#</cf_textarea>
		   </td></tr>
		   		 		
		   <tr class="line"><td style="padding:10px">
		   	 <cfinclude template="TasksView.cfm">
		   </td></tr>	
		   
		   </table>
		
		</cf_divscroll>
		
		</td></tr>   
		  			      
		    <tr><td>
			
			<cfquery name="getSection" 
			datasource="AppsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   ContractSection
				WHERE  ContractId = '#url.contractid#'
				AND    ContractSection = '#URL.Section#'
			</cfquery>
									
		    <cfif Evaluate.ActionStatus eq "0" or getSection.ProcessStatus eq "0">
			 			 
				<cf_Navigation
				 Alias         = "AppsEPAS"
				 Object        = "Contract"
				 Group         = "Contract"
				 Section       = "#URL.Section#"
				 Id            = "#URL.ContractId#"
				 BackEnable    = "1"
				 HomeEnable    = "0"
				 ResetEnable   = "1"
				 ResetDelete   = "0"
				 ProcessEnable = "1"
				 ProcessName   = "Save and Next"
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
				 BackEnable    = "1"
				 HomeEnable    = "0"
				 ResetEnable   = "1"
				 ResetDelete   = "0"
				 ProcessEnable = "0"
				 ProcessName   = "Save and Next"
				 NextEnable    = "1"
				 NextMode      = "1"
				 NextSubmit    = "0"
				 SetNext       = "1">	 
			 	 
			 <cfelseif Evaluate.ActionStatus eq "2">			 
											 	  		 
				 <cf_Navigation
					 Alias         = "AppsEPAS"
					 Object        = "Contract"
					 Group         = "Contract"
					 Section       = "#URL.Section#"
					 Id            = "#URL.contractid#"
					 BackEnable    = "0"
					 HomeEnable    = "0"
					 ResetEnable   = "0"
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 ButtonWidth   = "220"
					 NextName      = "Save and Next"
					 NextMode      = "1"
					 SetNext       = "1">			 
					  
			</cfif>    
			 
			 </td>
			 
			 </tr>
		     		
		</table>
		
		     	 
	</cfform>	
	
</cfif>	 

</cfoutput>	

  <script>
  	 initTextArea();	
  </script>	 

<script>
	parent.Prosis.busy('no')
</script>