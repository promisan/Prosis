
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