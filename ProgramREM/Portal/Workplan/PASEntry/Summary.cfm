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
<cf_screentop html="no" scroll="no" jquery="yes">

<cfparam name="url.type" default="preparation">

<cfquery name="Param" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Parameter	
</cfquery>

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>

<cfajaximport tags="cfmenu,cfdiv,cfwindow">
<cf_ActionListingScript>

<cfset url.personno = client.personno>
<cfinclude template="../PASView/CreatePASAccessWorkflow.cfm">

<cfparam name="Evaluate.EvaluationId" default="{00000000-0000-0000-0000-000000000000}">

<cfoutput>

	<cfform width="100%" height="100%" action="SummarySubmit.cfm?Code=#URL.Code#&ContractID=#URL.ContractID#&Section=#URL.Section#" method="post">
	
	<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
	
		<tr><td height="100%" style="padding-bottom:5px">
	
		<cf_divscroll>
			
			<table width="100%" align="center" cellspacing="0" cellpadding="0">
							
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
			
			<cfset mode = "View">
			<cfparam name="evlist" default="Evaluate">
			
			<tr><td style="padding-left:30px;padding-top:20px">
			
				  <cfinclude template="EvaluateGeneral.cfm">
			
			    </td>
			</tr>
			  		 		
			<tr class="line"><td style="padding:5px">					 	 
			   	 <cfinclude template="TasksView.cfm">				
			   </td>
		   </tr>
			   
		   <!---		   
		   <tr><td style="padding:5px">
			  	 <cfinclude template="EvaluateBehavior.cfm">
			   </td>
		   </tr>		   
		   --->
			   
		   <cfif Param.HideTraining eq "0">
			   
			   <tr><td style="padding:5px">
				 <cfinclude template="EvaluateTraining.cfm">
			   </td></tr>
			   
		   </cfif> 
			   
		   <cfquery name="Contract" 
			datasource="AppsEPAS" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
				FROM     Contract C LEFT OUTER JOIN Ref_ContractPeriod R ON C.Period = R.Code
				WHERE    ContractId = '#URL.ContractID#'
		   </cfquery>
		   
		   <cfif Contract.ActionStatus lte "3">
		   
			 <cfset wflnk = "SummaryWorkflow.cfm">
			 
			 <input type="hidden" 
	          id="workflowlink_#URL.ContractID#" 
    	      value="#wflnk#"> 
			  
			 <cfset processlnk = "ptoken.navigate('applySubmission.cfm?contractid=#URL.ContractID#&section=#url.section#','process')">
			 		 
			 <tr class="line">
			 <td style="padding-left:30px;padding-right:20px"> 
			 
			  <input type="hidden" 
		          id="workflowlinkprocess_#URL.ContractID#" 
	        	  onclick="#processlnk#"> 
			 
		 		  <cfdiv id="#URL.ContractID#"  bind="url:#wflnk#?ajaxid=#URL.ContractID#"/>
			 
			 </td></tr>
			 
		   </cfif>	 
						
			</table>
			
			</cf_divscroll>
		
		</td></tr>		
		
		<tr><td id="process">		
		
												
		    <cfif Contract.ActionStatus eq "0">
			
				<cfif getAdministrator("#Contract.Mission#") eq "1">
					<cfset reset = "1">
				<cfelse>
					<cfset reset = "0">	
				</cfif>
						 			 
				<cf_Navigation
				 Alias         = "AppsEPAS"
				 Object        = "Contract"
				 Group         = "Contract"
				 Section       = "#URL.Section#"
				 Id            = "#URL.ContractId#"
				 BackEnable    = "1"
				 HomeEnable    = "0"
				 ResetEnable   = "#reset#"
				 ResetDelete   = "0"
				 ProcessEnable = "0"				 
				 NextEnable    = "0"
				 NextMode      = "0"
				 NextSubmit    = "0"
				 SetNext       = "1">
				 				 
			 <cfelseif Contract.ActionStatus eq "1">			 
			 					
				<cfif getAdministrator("#Contract.Mission#") eq "1">
					<cfset reset = "1">
				<cfelse>
					<cfset reset = "0">	
				</cfif>
			 	 			 
				<cf_Navigation
				 Alias         = "AppsEPAS"
				 Object        = "Contract"
				 Group         = "Contract"
				 Section       = "#URL.Section#"
				 Id            = "#URL.ContractId#"
				 BackEnable    = "1"
				 HomeEnable    = "0"
				 ResetEnable   = "#reset#"
				 ResetDelete   = "0"
				 ProcessEnable = "0"				
				 NextEnable    = "0"
				 NextMode      = "0"
				 NextSubmit    = "0"
				 SetNext       = "1">	 
				
			 	 
			 <cfelseif Contract.ActionStatus eq "2">			 
						 
				<cfif Contract.PasEvaluation gt now()>
				
					<table width="100%">
					   <tr ><td class="labellarge" align="center"><font color="0080C0"><cf_tl id="You may not yet submit your EPAS for evaluation"></td></tr>
			  	    </table>
					
				<!--- as the date has not be reached yet, you can no further process it --->
				   
				<cfelse>				
								
				<cfif getAdministrator("#Contract.Mission#") eq "1">
					<cfset reset = "1">
				<cfelse>
					<cfset reset = "0">	
				</cfif>
				 	  		 
				 <cf_Navigation
					 Alias         = "AppsEPAS"
					 Object        = "Contract"
					 Group         = "Contract"
					 Section       = "#URL.Section#"
					 Id            = "#URL.contractid#"
					 BackEnable    = "0"
					 HomeEnable    = "0"
					 ResetEnable   = "#reset#"
					 ResetDelete   = "0"
					 ProcessEnable = "0"
					 NextEnable    = "1"
					 ButtonWidth   = "220"
					 NextName      = "Continue"
					 NextMode      = "1"
					 SetNext       = "1">			 
					  
				</cfif>  
				
			</cfif>	  
									 
			 </td>
			 
			 </tr>	
		
		</table>
		     	 
	</cfform>	 

</cfoutput>	

<script>
	parent.Prosis.busy('no')
</script>