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

<cfquery name="GroupAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  F.*, 
	        P.*, 
		    S.SelectId as Selected
	FROM    Ref_ExperienceClass P INNER JOIN
	        Ref_Experience F ON P.ExperienceClass = F.ExperienceClass LEFT OUTER JOIN
	        RosterSearchLine S ON F.ExperienceFieldId = S.SelectId AND S.SearchId = '#URL.ID#'
	WHERE   F.ExperienceClass = '#Ar#'  
	   AND  F.Status = 1
   ORDER BY F.ListingOrder, F.Description
</cfquery>
   		
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bgcolor="E9E9D1">
							
    <cfset rows = 0>
	<cfset cnt = 0>
	<cfset det = "">
					
	<cfoutput query="GroupAll">
														
	<cfif rows eq "2">
		    <TR>
			<cfset rows = 0>
			<cfset cnt = cnt+27>
	</cfif>
				
	    <cfset rows = rows + 1>
			<td width="25%">
			
			<table width="100%" cellspacing="0" cellpadding="0">
				<cfif Selected eq "">
				          <TR class="regular">
				<cfelse>  <TR class="highlight4">
				</cfif>
				
			   	<td width="90%" style="padding-left:7px" class="labelit">#Description#</font></td>
				<td width="10%" class="labelit" align="center">
				
				<cfif Parent eq "Experience" or Parent eq "Education">
				    <cfset c = 1>
				<cfelse>
				    <cfset c = 0>
				</cfif>
				
				<cfif Selected eq "">
				
					<input type="checkbox" style="height:14px;width:14px" name="#Parent#fieldid" id="#Parent#fieldid"
					value="#ExperienceFieldId#" 
					onClick="hlkw(this,this,this.checked,'#c#','#Parent#',this.value,'#ar#');">
				<cfelse>
				<cfset det = det&","&#ExperienceFieldId#>
				<input type="checkbox" style="height:14px;width:14px" name="#Parent#fieldid" id="#Parent#fieldid"
				value="#ExperienceFieldId#" checked 
				onClick="hlkw(this,this,this.checked,'#c#','#Parent#',this.value,'#ar#');">
			    </cfif>
				
				</td>
				</tr>
				
			</table>
			</td>
			<cfif GroupAll.recordCount eq "1">
 					<td width="25%"></td>
			</cfif>
		
	</CFOUTPUT>
												
</table>

<cfoutput>

<cfif det neq "">

	<script language="JavaScript">
		 se  = document.getElementById("#URL.AR#")
		 se.className = "regular";
		 icM  = document.getElementById("#URL.AR#Min");
		 icM.className = "hide";
		 // sel  = document.getElementById("cl#URL.row#");
	     // sel.value = "#det#"		 
	</script>

</cfif>

</cfoutput>
		

