<cfset dateValue = "">
<CF_DateConvert Value="#url.dateeffective#">
<cfset DTS = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#url.dateexpiration#">
<cfset DTE = dateValue>

<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     P.PersonNo, 
	           P.IndexNo, 
			   P.LastName, 
			   P.FirstName, 
			   PA.DateEffective, 
			   PA.DateExpiration, 
			   PA.AssignmentClass, 
			   PA.Incumbency, 
			   PA.AssignmentClass, 
               PA.OfficerLastName, 
			   PA.OfficerFirstName, 
			   PA.OfficerUserId, 
			   PA.Created
	FROM       PersonAssignment AS PA INNER JOIN
           	   Person AS P ON PA.PersonNo = P.PersonNo
	WHERE      PA.PositionNo = '#url.positionno#' 
	AND        PA.AssignmentStatus IN ('0', '1')
	AND        PA.DateExpiration >= #DTS# 
	AND        PA.DateEffective <= #DTE#
	ORDER BY PA.DateExpiration DESC
</cfquery>

<cfif Assignment.recordcount gte "1">

<table width="100%" class="navigation_table">

	<tr class="labelmedium line">
		<td><cf_tl id="IndexNo"></td>		
		<td><cf_tl id="LastName"></td>
		<td><cf_tl id="FirstName"></td>
		<td><cf_tl id="Start"></td>
		<td><cf_tl id="End"></td>
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Inc"></td>	
	</tr>

	<cfoutput query="Assignment">
	<tr class="labelmedium navigation_row line" style="height:20px">
		<td><a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#Indexno#</a></td>
		<td>#LastName#</td>
		<td>#FirstName#</td>
		<td>#dateformat(DateEffective,client.dateformatshow)#</td>
		<td>#dateformat(DateExpiration,client.dateformatshow)#</td>
		<td>#AssignmentClass#</td>
		<td>#Incumbency#</td>
	</tr>
	</cfoutput>
	
</table>

</cfif>

<cfset ajaxonload("doHighlight")>

