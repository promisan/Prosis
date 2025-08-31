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
<cfquery name="Position" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT C.*, P.SourcePostNumber, P.FunctionDescription, P.PostGrade
		FROM   CustomerPosition C INNER JOIN Employee.dbo.Position P ON P.PositionNo = C.PositionNo
		WHERE  CustomerId = '#url.customerid#'
</cfquery>
	
<cfoutput>
<table style="width:100%" class="navigation_table">

<tr class="line labelmedium2">
   <td><cf_tl id="Position"></td>
   <td><cf_tl id="Incumbent"></td>
   <td><cf_tl id="Start"></td>
   <td><cf_tl id="End"></td>
   <td><cf_tl id="Memo"></td>
   <td><cf_tl id="Officer"></td>
   <td><cf_tl id="Created"></td>
   <td></td>
</tr>

<cfloop query="Position">
	<tr class="labelmedium navigation_row line">
	<td>#FunctionDescription# #PostGrade#</td>
	
	     <cfquery name="per" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   PA.DateEffective, 
			          PA.DateExpiration, 
					  P.FullName, 
					  P.Gender, 
					  P.Nationality, 
					  P.IndexNo, 
					  P.PersonNo
			 FROM     PersonAssignment PA INNER JOIN
		              Person P ON PA.PersonNo = P.PersonNo
			 WHERE    PA.DateEffective <= GETDATE() 
			     AND  PA.DateExpiration >= GETDATE()
				 AND  PA.AssignmentStatus IN ('0','1')
			 	 AND  PA.PositionNo = '#PositionNo#'
		    </cfquery>
			
			<cfif per.recordcount gte "1">
			<td>#per.Fullname# #dateformat(per.dateexpiration,client.dateformatshow)#</td>
			<cfelse>
			<td><cf_tl id="Vacant"></td>			
			</cfif>
		
	<td>#dateformat(dateeffective,client.dateformatshow)#</td>
	<td>#dateformat(dateexpiration,client.dateformatshow)#</td>
	<td>#memo#</td>
	<td>#OfficerLastName#</td>
	<td>#dateformat(created,client.dateformatshow)#</td>
	<td><cf_img icon="delete" onclick="ptoken.navigate('#session.root#/Warehouse/Application/Customer/Outreach/CustomerPositionSubmit.cfm?action=delete&mission=#url.mission#&customerid=#url.customerid#&positionno=#positionno#','processcustomer')"></td>
	</tr>

</cfloop>

<tr><td style="height:30px" colspan="7" align="center"><input type="button" onclick="addposition('#url.mission#','#url.customerid#')" class="button10g" value="Add"></td></tr>
</table>

</cfoutput>

<cfset ajaxOnLoad("doHighlight")>