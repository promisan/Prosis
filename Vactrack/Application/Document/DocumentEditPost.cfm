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

<cfoutput>

<cf_dialogPosition>

<script>
  
function maintain(org,mis,man) {   
	ptoken.open('#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?ID=ORG&ID1=' + org + '&ID2='+mis+'&ID3='+man, 'maintain'+org)
}  

</script>

</cfoutput>

<!--- retrieve positions --->

<cfquery name="Post" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT P.*
FROM      Employee.dbo.Position P, 
          DocumentPost S
WHERE     P.PositionNo = S.PositionNo
AND       S.DocumentNo = '#URL.ID#'
ORDER BY  P.SourcePostNumber 
</cfquery>

  <table width="100%" cellpadding="0" align="center">
    	  
	  <tr><td>
	  
	  <table width="99.5%" align="center" class="formpadding">
	  
	  <TR class="labelmedium line fixlengthlist">
	    <td width="33"></td>
	    <TD><cf_tl id="Post">##</TD>
	    <TD><cf_tl id="Function"></TD>
	    <TD><cf_tl id="Grade"></TD>		
		<TD><cf_tl id="Unit"></TD>
		<TD><cf_tl id="Expiration"></TD>		
		<TD><cf_tl id="Incumbent"></TD>		
	  </TR>
	  
	  <cfif Post.recordcount eq "0">
	   <tr><td height="1" colspan="9" align="center" class="labelmedium" bgcolor="red"><font color="FFFFFF">Problem: Recruitment track is not associated to a valid position (anymore)</font></td></tr>	  
	  </cfif>
	  
	  <cfset pos = "">
	
	  <cfoutput query="Post"> 
	  	  	  
		<cfquery name="Person" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     PersonAssignment A, Person P
			WHERE    A.PositionNo = '#PositionNo#'
			AND      A.PersonNo   = P.PersonNo
			AND      A.AssignmentStatus IN ('0','1')
			AND      A.AssignmentType = 'Actual'
			AND      A.DateExpiration >= getDate()
			ORDER BY A.DateExpiration DESC 
		</cfquery>
		
		<cfquery name="Org" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     Organization
			WHERE    OrgUnit = '#OrgUnitOperational#'		
		</cfquery>
		
		<cfloop query="Person">	
	
			<cfif Person.DateExpiration lt now()>
			     <tr class="regular line labelmedium fixlengthlist">
			<cfelse>
			     <tr class="highLight4 line labelmedium fixlengthlist">
			</cfif> 
			
			<td height="18"></td>  	 		  
		    <TD><a href="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#PositionNo#')"><cfif Post.sourcePostNumber eq "">#Post.PositionParentId#<cfelse>#Post.SourcePostNumber#</cfif></a></TD>
			<TD><cfif pos neq positionno>#Post.FunctionDescription#</cfif></TD>
			<TD><cfif pos neq positionno>#Post.PostGrade#</cfif></TD>
			<cfif Org.recordcount eq 1>
			<td><a href="javascript:maintain('#Org.orgunitCode#','#Org.mission#','#Org.MandateNo#')"><cfif pos neq positionno>#Org.OrgUnitName#</cfif></td>
			<cfelse>
			<td>Unit not defined</td>		
			</cfif>		
		    <TD><cfif pos neq positionno>#Dateformat(Post.DateExpiration, CLIENT.DateFormatShow)#</cfif></TD>
			<TD><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a> #FirstName# #LastName# #Dateformat(DateExpiration, CLIENT.DateFormatShow)# #Incumbency#%</TD>
	
			</TR>
			
			<cfset pos = positionno>
			
		</cfloop>	

	</CFOUTPUT>
	
	</table>
	
	</td>
	</tr>

</table>
