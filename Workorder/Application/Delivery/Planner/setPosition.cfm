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

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfquery name="Person"
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT     PA.PositionNo, 
	           PA.FunctionNo, 
			   PA.FunctionDescription, 
			   P.PersonNo, 
			   P.LastName, 
			   P.FirstName, 
			   PA.DateEffective, 
			   PA.DateExpiration
	FROM       Person AS P INNER JOIN
               PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
               Position AS Pos ON PA.PositionNo = Pos.PositionNo
	WHERE      PA.DateEffective <= #dts#
	AND        PA.DateExpiration >= #dts#
	AND        PA.AssignmentStatus IN ('0', '1') 
	AND        Pos.PositionNo = '#url.positionno#' 	
	
</cfquery>	

<cfoutput>

    <table align="center">
	  <tr>	   
	   <td style="height:22px;padding-left:4px" class="labellarge">
	   #person.FirstName# #person.LastName# (#Person.FunctionDescription#)
	   
	   <script>
	   	document.getElementById('personno').value   = '#Person.personno#'
		document.getElementById('positionno').value = '#Person.PositionNo#'
	   </script>
	 
	   </td>	  
	</tr>
	</table>

</cfoutput>