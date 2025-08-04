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


<cf_ajaxRequest>

<script>
	
	function update(id,per) {
	 	
		url = "ExportListUpdate.cfm?claimid="+id+"&AccountPeriod="+per
			 
		 	AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 									
			 },
						
	        'onError':function(req) { 
			
				document.getElementById("ln"+id).innerHTML = req.responseText;
			
				}	
	         }
		 );	
		
	 }	
 
 </script>

<cfquery name="Parameter" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Parameter 
</cfquery>

<cfquery name="Last" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT Max(Created) as Created
FROM   stExportFile 
WHERE ActionStatus != '9'
</cfquery>

<cfquery name="Export" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     C.*, 
           R.Description AS Description, 
		   CR.Mission AS Mission, 
		   CR.DocumentNo AS RequestNo, 
		   stPerson.IndexNo AS IndexNo, 
           stPerson.LastName AS LastName, 
		   stPerson.FirstName AS FirstName
FROM       Claim C INNER JOIN
           Ref_Status R ON C.ActionStatus = R.Status INNER JOIN
           ClaimRequest CR ON C.ClaimRequestId = CR.ClaimRequestId INNER JOIN
           stPerson ON C.PersonNo = stPerson.PersonNo
WHERE      C.ExportNo IS NULL 
AND        R.StatusClass = 'TravelClaim'
AND        C.ActionStatus IN ('3')
ORDER BY C.DocumentNo
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="1" align="center" bordercolor="silver" bgcolor="ffffff" frame="hsides"  rules="none">
   
	<td height="24" colspan="2"><b>Export</td>
	<td><b>TVRQ</td>
	<td><b>TCP</td>
	<td><b>Claimant</td>
	<td><b>eMail</td>
	<td><b>Claim Date</td>
	<td><b>PAP</td>
	<td><b>Express</td>
	<td><b>Incomplete</td>
	</tr>
	<tr><td height="1" colspan="10" bgcolor="C0C0C0"></td></tr>
		<cfoutput query="Export">
		<cfif claimException eq "1">
			<cfset col = "ffffcf">
		<cfelse>
			<cfset col = "ffffff">
		</cfif>
		<tr bgcolor="#col#">
		<td>#currentrow#.</td>
		<td><input type="checkbox"
	       name="select"
	       value="'#claimId#'"
	       checked
	       tabindex="999"></td>
		<td><a tabindex="999" href="javascript:showclaim('#personno#','#ClaimId#','#ClaimRequestId#')">#RequestNo#</a></td>
		<td><a tabindex="999" href="javascript:showclaim('#personno#','#ClaimId#','#ClaimRequestId#')">#DocumentNo#</a></td>
		<td>#FirstName# #LastName#</td>
		<td>#eMailAddress#</td>
		<td>#dateformat(claimdate,CLIENT.DateFormatShow)#</td>
		<cfif accountPeriod eq "">
		 <cfset cl = "red">
		<cfelse>
		 <cfset cl = "transparent">
		</cfif>  
		<td bgcolor="#cl#">
		<input type="text"
	       name="AccountPeriod"
	       value="#AccountPeriod#"
	       size="7"
	       maxlength="8"
	       class="regular"
	       style="text-align:center"
	       onChange="update('#claimid#',this.value)">
		</td>
		<td><cfif claimasIs eq "1">Yes</cfif></td>
		<td><cfif claimException eq "1">Yes</cfif></td>
		</tr>	
		<tr><td></td><td colspan="9" id="ln#claimid#">
		<cfinclude template="ExportListClaimValidation.cfm">
		</td></tr>			
		</cfoutput>
		
		<tr><td colspan="10">						
		
		  <cfoutput>
		    
		  <cfif Export.recordcount gte "1">
		    	
				<table width="100%" cellspacing="1" cellpadding="1">
				
					<tr>
					  <td bgcolor="white" height="30" align="center" style="border-top: 1px solid Silver;">
					  <cfif #dateFormat(Last.Created,CLIENT.DateFormatShow)# eq #dateFormat(now(),CLIENT.DateFormatShow)#>
					  <img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
			  			<b><font color="red">Attention:</font></b> You may export the claims with status [READY FOR EXPORT] only the NEXT business day
					  <cfelse>
					  <input type="button" class="button10g" name="Prepare" value="Export" onclick="exportfile()">
					  </cfif>
					  </td>
					</tr>
							
				</table>
			
		  </cfif>
		  
		  </cfoutput>
		
		</td></tr>
		
</table>