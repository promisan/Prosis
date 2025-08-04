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

<!--- passtru parameter  --->

<cfparam name="URL.WParam" default="EO">

<cfquery name="Parameter" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Parameter
</cfquery>

<script language="JavaScript">
		
	function show(itm){
		
	 se   = document.getElementById(itm)
	 icE  = document.getElementById(itm+"Exp")
	 icM  = document.getElementById(itm+"Min")
		
	 if (se.className == "regular") {
			 icM.className  = "hide";
			 icE.className  = "regular";
			 se.className   = "hide";
			 } else	{
			 icM.className  = "regular";
			 icE.className  = "hide";	
			 se.className   = "regular";		
			 }
			 
	  }  
		  
</script> 

<cfparam name="URL.ClaimId" default="#Object.ObjectKeyValue4#">

  <cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Claim
		WHERE    ClaimId = '#URL.ClaimId#'
  </cfquery>
    
  <cfquery name="ClaimTitle" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT C.*
		FROM   ClaimRequest C
		WHERE  ClaimRequestId = '#Claim.ClaimRequestId#'		
  </cfquery>
  
  <!--- not sure if this is still needed ---> 

  <cfquery name="DSA" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      ClaimLineDSA
		WHERE     ClaimId = '#Claim.ClaimId#'
		ORDER BY PersonNo, CalendarDate
   </cfquery>
   
   <cfset grp = 0>
   <cfset amt = "">
   
   <cfloop query="DSA">
   
   		<cfif amt neq AmountPayment>
		
		    <cfset grp = grp+1>
			<cfset amt = "#AmountPayment#">	
			
		</cfif>	
		
		<cfquery name="Update" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE  ClaimLineDSA
			SET     Grouping = #grp#
			WHERE   ClaimId = '#URL.ClaimId#'
			AND     CalendarDate  = '#CalendarDate#' 
			AND     PersonNo      = '#PersonNo#'
	    </cfquery>
		      
   </cfloop>


<tr><td colspan="2" width="99%" class="hide" id="dialog2N">
	<table width="100%" cellspacing="2" cellpadding="2"><tr><td>
	<cfinclude template="../Correction/ActionIndicator.cfm">
	</td></tr>
	</table>
	</td>
</tr>     

<tr>
<td id="dialog0" colspan="2" bgcolor="FFFFCF">
				
		<cfif URL.WParam eq "EO">
			
				<table width="99%" border="0" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="center">
				<tr><td bgcolor="silver" height="1"></td></tr>
				<tr><td>
						
						<table cellspacing="1" cellpadding="1" align="left" ><tr>
						
						<td>&nbsp;</td>
						<TD>
						
						<cf_helpfile code     = "TravelClaim" 
							 id       = "transfer" 
							 class    = "General"
							 name     = "Transfer EO"
							 display  = "Both"
							 color    = "black">
							 <!--- displayText = "Transfer to another Office" --->
						</TD>	
						
					    <TD>
								
						<cfquery name="Org" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   *
								FROM     Organization
								WHERE    Mission = '#Parameter.TreeUnit#'
								AND      OrgUnit != '#ClaimTitle.OrgUnit#'
								AND      (ParentOrgUnit = '' or ParentOrgUnit is NULL)
						  </cfquery>
						  
						  <script language="JavaScript">
						   		   
							  function prblock(v) {
							      if (v != "") {
								    blocktoggle('hide','show','hide')
									document.getElementById("embedsaveclose").className = "button10g";
										  
								  } else  {
									blocktoggle('show','show','show')
									document.getElementById("embedsaveclose").className = "hide";
								  }
							   }
							   
							  function ask() {
								if (confirm("This action can not been reverted, do you want to continue ?")) {
								  return true }
								return false
								}	
						   		   
						   </script>
						  
						   <select name="OrgUnit" onChange="prblock(this.value)">
							  <option value=""></option>
							  <cfoutput query="Org">
							  <option value="#OrgUnit#">#OrgUnitName#</option>
							  </cfoutput>
						   </select>
						  
						   <input type="submit" name="embedsaveclose" value="Transfer" class="hide" onclick="return ask()">&nbsp;
					   									
							</td>
						</TR>	
						
						</table>
					</td></tr>
					<tr><td bgcolor="silver" height="1"></td></tr>	
					</table>
								
		</cfif>
					
	</td>
</tr>	
    	
<tr>

	<td colspan="2">

	<table width="99%" border="0" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="center">

		<cfset processWF = "1">
		<tr><td><cfinclude template="../../ClaimEntry/ClaimRequest.cfm"></td></tr>
	
	</table>	
	
	</td>

</tr>	
  

<tr><td colspan="2">

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="E4E4E4" bgcolor="white">
	
	<tr><td colspan="2">
	   
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			
		 <tr><td colspan="10">
		    <cfset idclaim = "#claim.claimid#">
			<cfset processWF = "1">
			
			<!--- perform a validation upon opening --->			
			<cfinclude template="../../ClaimEntry/ClaimInfo.cfm">			
			
		</td></tr>	

	<cfoutput>
	    <input name="WParam"          type="hidden"  value="#URL.WParam#">
	    <input name="ClaimRequestId"  type="hidden"  value="#Claim.ClaimRequestId#">
		<input name="Key4"            type="hidden"  value="#Object.ObjectKeyValue4#">
		<input name="savecustom"      type="hidden"  value="#parameter.templateRoot#/Workflow/Comparison/DocumentSubmit.cfm">
	    <input name="savetext"        type="hidden"  value="0">
	</cfoutput>
   
  </table>
  
</td></tr>

</table>

</body>
</html>
