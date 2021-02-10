
<!--- this function generate a roster status entry screen and follows the following logic

1.  Determine the current status and owner
2.  Read the next status in the table Ref_StatusCode
3.  Determnie is the next status is a roster action
4.  If roster action, determine people with access to the next next and show all other access they have or in case of roster admin all
5.  if not roster action, determine only roster admin.
--->

<cfparam name="url.CurrentStatus"  default="0">
<cfparam name="url.Owner"          default="SysAdmin">
<cfparam name="url.FunctionId"     default="">
<cfparam name="url.ApplicantNo"    default="">

<cfparam name="Attributes.CurrentStatus"  default="#url.currentstatus#">
<cfparam name="Attributes.Owner"          default="#url.owner#">
<cfparam name="Attributes.FunctionId"     default="#url.functionid#">
<cfparam name="Attributes.ApplicantNo"    default="#url.ApplicantNo#">

<!--- get the status --->

<cfquery name="StatusList" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_StatusCode
		WHERE    Owner = '#Attributes.Owner#' 
		AND      Id    = 'FUN'
</cfquery>

<cfinvoke component   = "Service.Access.Roster"  
	  method          = "RosterStep" 
	  Owner           = "#Attributes.Owner#"
	  FunctionId      = "#Attributes.FunctionId#"
	  Status          = "#Attributes.CurrentStatus#"	     		
	  returnvariable  = "AccessList">	
	  
<cfset accessarray =  ListToArray(AccessList)>
	  
<table height="26" width="350">

<cfset cnt = 1>
<cfset go  = 0>

<cfoutput query="StatusList">
		 
	<CFIF Status is Attributes.CurrentStatus>
						
			<!--- always show the current status --->
			
			<cfif cnt eq "1"><tr></cfif>
							   
				<td width="15%" 
				    height="22" 
					id="status_#currentrow#" 
					align="left" 					
					style="border:1px solid silver;border-radius:5px"
					bgcolor="yellow">
					
					<table class="formpadding">
					<tr><td style="padding-left:6px">
															
					 <cfif findNoCase(Status, AccessList)>
					 
						  <cfset go = "1">
						  
																		
					     <input type="radio" 
						        onclick="st('#Attributes.CurrentStatus#','#Status#','#Attributes.ApplicantNo#','#Attributes.FunctionId#')" 
								name="status" 
								class="radiol"
								id="status"
								value="#Status#" 
						        checked>
							
					  </cfif>		
						
					    </td>
						
						<td style="padding-left:6px;font-size:17px" class="labelmedium2"><!---#status#---> #Meaning#</td>
						
					</tr>
						
					</table>
						
				</td>		
						
			<cfif cnt eq "2"><cfset cnt=0><tr></cfif>  
			
	<cfelseif arrayFind( accessarray, Status)>
			
	      <cfset go = "1">
					 
		  <cfif cnt eq "1"><tr></cfif>
				<td width="15%" id="status_#currentrow#" align="left"
					style="padding-left:6px;border: 1px solid silver;"  class="regular"> 
					
					<cfset ruleDescription = "">
						
					 <cfquery name="GetRule" 
			 		  datasource="AppsSelection" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
							  
						SELECT R.Code, R.Description
						FROM   Ref_StatusCodeProcess  P
							   INNER JOIN Ref_Rule R ON P.RuleCode = R.Code
						WHERE  P.Owner    = '#Attributes.Owner#'
						AND    P.Status   = '#Attributes.CurrentStatus#'
						AND    P.StatusTo = '#Status#'

					 </cfquery>
						 
					<cfif GetRule.RecordCount gt 0>
					 	<cfset rule = GetRule.Code>
						<cfset ruleDescription = GetRule.Description>
					 </cfif>
					
					<table width="100%" align="left"><tr><td width="15px">
				        <input type="radio" class="radiol" onclick="st('#Attributes.CurrentStatus#','#Status#','#Attributes.ApplicantNo#','#Attributes.FunctionId#')" id="status" name="status" value="#Status#">
					 </td>
					<td style="padding-top:1px;padding-left:3px" align="left">
					    <table class="formpadding">
						<tr class="labelmedium2">						 
						 <td style="font-size:16px;padding-left:3px">#Meaning#</td>
						 <td style="padding-left:2px">
						<cfif ruleDescription neq "">
							<img src="#client.root#/images/link.gif" alt="Process rule: #ruleDescription#" style="cursor:pointer; vertical-align:middle">
						</cfif>
						</td>
						</tr>
						</table>
					</td>
					</tr>
					</table>
					
				</td>						
					 
				<cfif cnt eq "2"><cfset cnt=0><tr></cfif>   
		  	  
	</cfif>	 
	
	<cfset cnt = cnt + 1>
	
</cfoutput>

</table>

<cfoutput>
	<script>
		 document.getElementById('statusold').value = '#Attributes.CurrentStatus#'
	</script>
</cfoutput>	

<CFSET Caller.go  = go>
<CFSET Caller.cnt = cnt>