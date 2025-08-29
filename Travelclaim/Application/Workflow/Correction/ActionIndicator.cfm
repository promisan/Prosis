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
<cfquery name="Section" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT R.*, ProcessProblem, ProcessProblemMemo
FROM   Ref_ClaimSection R, ClaimSection S
WHERE  R.Code = S.ClaimSection
<cfif claim.ActionStatus eq "1">
AND    S.ProcessProblem = 1
</cfif>
AND S.ClaimId = '#URL.ClaimId#'
AND  Code NOT IN ('CL01','CL07','CL08')
</cfquery>	

<cfif section.recordcount neq "0">

<script>

function hlc(box,itm){

se = document.getElementById("c"+itm)
s2=  document.getElementById(itm+"_box")
s3 = document.getElementById(itm+"_memo")

if (box.checked == true) {
   se.className = "highlight"   
   s2.className = "regular"
   s3.focus()
   } else { 
   se.className = "regular" 
   s2.className = "hide"
   }	
}

</script>

<cfoutput>

<table width="100%" frame="hsides" bordercolor="silver" border="1" cellspacing="0" cellpadding="0" align="center">
<tr><td>

<cfif claim.ActionStatus gte "2">

<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">

<cfelse>

<table width="100%" border="0" bgcolor="ffffbf" align="center" cellspacing="0" cellpadding="0">

</cfif>

	<cfif claim.ActionStatus gte "2">
	
			<tr><td height="25" align="left" bgcolor="ffffcf">
			&nbsp;&nbsp; 
			<img src="#SESSION.root#/Images/select4.gif" alt="" border="0" align="absmiddle">
			&nbsp;
			<b>Indicate in which section this claim requires corrective action:</td></tr>
			<tr><td bgcolor="C0C0C0"></td></tr>
			<tr><td>
			<table width="100%" cellspacing="1" cellpadding="1" align="center">			
		<cfelse>
			<tr><td align="center"><b><font color="FF0000">
			<img src="#SESSION.root#/Images/error.gif" 
					        alt="Correction"
							border="0" 
							align="absmiddle">
			</td>
			</tr>				
			<td height="25" align="center"><b>
			Please make the changes indicated below by accessing the corresponding data entry area(s) on the left</td></tr>
			<tr><td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		</cfif>
		
		<!--- checkboxes only for processor --->
		
		<cfif claim.ActionStatus gte "2">
		
			<tr>
			
			<cfloop query="Section">
			
				<cfif processproblem eq "1">
				    <cfset cl = "highlight">
				<cfelse>
				    <cfset cl ="regular">	
				</cfif>
				 	
				<td id="c#Code#" class="#cl#" width="140">
				<table  border="0" align="center" cellspacing="1" cellpadding="1">
					<tr><td height="22">
					
						<input <cfif processproblem eq "1">checked</cfif> 
							type="checkbox" 
							onclick="hlc(this,'#code#')"
							id="#code#"
							name="ClaimSection" 
							value="'#Code#'">&nbsp;
					
					</td>
					<td style="cursor: hand;"
   						 onClick="document.getElementById('#code#').click()">
					<cfif processproblem eq "1"><b></cfif>#Description#</td>
				    </tr>
				</table>
				</td>
				
			</cfloop>
			
		    </tr>
			
		</cfif>	
			
		<cfloop query="Section">
			
				<cfif ProcessProblem eq "1">
				 <cfset cl = "regular">
				<cfelse>
				 <cfset cl = "hide"> 
				</cfif>		
					
				<tr class="#cl#" id="#code#_box">
					<td colspan="#section.recordcount#">
						<table width="100%" cellspacing="0" cellpadding="0">
						<tr><td colspan="2" height="1" bgcolor="silver"></td></tr>
						<tr><td height="2"></td></tr>
						<tr><td valign="top" width="140">
							<table cellspacing="2" cellpadding="2">
								<tr>
								<td >#Description#:</td>
								</tr>
								</table>
							</td>			
							<td>
							<cfif claim.ActionStatus gte "2">
								<textarea style="width:99%" rows="3" class="regular" name="#Code#_Memo">#ProcessProblemMemo#</textarea>
							<cfelse>
								<font color="FF5300">#ProcessProblemMemo#</font>
							</cfif>	
							</td>
						</tr>
						</table>
					</td>
				</tr>		
			
		</cfloop>
			
		</table>
		</td></tr>
		
</table>
</td></tr>
</table>
</cfoutput>

</cfif>
	



