
<cfparam name="URL.Mission" default="SAT">
<cfparam name="URL.MandateNo" default="P001">

<cfquery name="Clean" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM AuditIncumbency
</cfquery>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#PositionParent">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#PersonAssignment">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#PersonContract">

<cfquery name="getBaseSet" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT     PP.*
	
	INTO       UserQuery.dbo.#SESSION.acc#PositionParent
	
	FROM       PositionParent PP, 
	           Organization.dbo.Organization Org
	WHERE      Org.Mission           = '#URL.Mission#'
	AND        Org.MandateNo         = '#URL.MandateNo#' 	
	AND        PP.OrgUnitOperational = Org.OrgUnit
	AND        PP.PositionParentId IN
	              <!--- select positions that have been loaned --->
	              (SELECT      PositionParentId
	               FROM        [Position]
	               GROUP BY    PositionParentId
	               HAVING      (COUNT(*) > 1)
	               UNION
				   <!--- select positions that have more then one assignment --->
	               SELECT      [Position].PositionParentId
	               FROM        PersonAssignment INNER JOIN
	                           [Position] ON PersonAssignment.PositionNo = [Position].PositionNo
				   WHERE       PersonAssignment.AssignmentStatus IN ('0','1')			   
	               GROUP BY    [Position].PositionParentId
	               HAVING      (COUNT(*) > 1)
				   UNION
				   <!--- select position outside bounderies --->
				   SELECT     DISTINCT P.PositionParentId
				   FROM       Position P INNER JOIN
	                          PositionParent PP ON P.PositionParentId = PP.PositionParentId
				   WHERE      (PP.DateEffective > P.DateEffective) OR
	                          (PP.DateExpiration < P.DateExpiration)
				   UNION
				   <!--- select assignments outside boundery --->			  
				   SELECT     DISTINCT P.PositionParentId
				   FROM       Position P INNER JOIN
	                          PersonAssignment A ON P.PositionNo = A.PositionNo
				   WHERE     (P.DateEffective > A.DateEffective) OR
	                         (P.DateExpiration < A.DateExpiration)		  
				   )
		   
</cfquery>

<cfquery name="BaseSet" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   UserQuery.dbo.#SESSION.acc#PositionParent
</cfquery>

<!--- Position audit --->
<cfloop query="BaseSet">

	<cf_verifyPosition PositionParentId = "#PositionParentId#" current="#url.current#">

</cfloop>


<cfquery name="baseAssignments" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
		 
 	SELECT *
	
	INTO   UserQuery.dbo.#SESSION.acc#PersonAssignment
	
	FROM   PersonAssignment
	WHERE  AssignmentStatus IN ('0','1')
	AND    AssignmentType = 'Actual'
	AND    PositionNo IN (
		SELECT PositionNo
		FROM   Position
		WHERE  PositionParentId IN (
			SELECT PositionParentId
			FROM   UserQuery.dbo.#SESSION.acc#PositionParent
		)
	)
	<cfif url.current eq "true">
		AND       DateEffective <= getDate() 
		AND       DateExpiration >= getdate()
	</cfif>			

</cfquery>

<cfquery name="baseContracts" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
		 
 	SELECT *
	
	INTO   UserQuery.dbo.#SESSION.acc#PersonContract
	
	FROM   PersonContract
	WHERE  ActionStatus IN ('0','1')
	AND    PersonNo IN (
		SELECT PersonNo
		FROM   UserQuery.dbo.#SESSION.acc#PersonAssignment
	)
	-- AND  HistoricContract = '0'
</cfquery>

<cfinclude template="VerifyStaffingInconsistencies.cfm">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Error" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *, P.SourcePostNumber as SourceNo, S.*
	FROM      AuditIncumbency E
			  LEFT JOIN Position P
			   	ON E.AuditSourceNo = P.PositionNo
			  LEFT JOIN Organization.dbo.Organization Org
			   	ON P.OrgUnitOperational = Org.OrgUnit
			  LEFT JOIN Person S
			  	ON E.AuditPersonNo = S.PersonNo

	ORDER BY AuditElement
</cfquery>

<table width="100%" class="formpadding formspacing navigation_table">
<cfif Error.recordcount eq "0">
<tr><td colspan="8" class="labelit" align="center">Good, no inconsistencies were detected</td></tr>
<cfelse>

	<cfoutput group="AuditElement" query="Error">
	
		<cfif AuditElement eq "Position">
			<tr class="fixrow"><td colspan="8" style="height:40px" align="left" class="labellarge">The following positions have one or more inconsistencies</td></tr>
		<cfelseif AuditElement eq "Person">
			<tr class="fixrow"><td colspan="8" style="height:40px" align="left" class="labellarge">The following persons have one or more inconsistencies</td></tr>
		</cfif>
	
	    <tr><td colspan="8">
		<table width="100%">
		
		<cfoutput>
	
			<cfif AuditElement eq "Position">			    
			    
				<tr class="labelmedium2 line navigation_row fixlengthlist">
				    <td style="padding-left:20px;">#currentrow#.</td>
				    <td style="padding-left:4px">
					   <cf_img navigation="Yes" icon="edit"
					     onClick="ViewParentPositionDialog('#URL.Mission#','#URL.MandateNo#','#PositionParentId#','direct')">
					</td>
					<td style="padding-left:4px;padding-right:4px"><a href="javascript:ViewParentPositionDialog('#URL.Mission#','#URL.MandateNo#','#PositionParentId#','direct')">#PositionParentId#</td>
					<td style="padding-left:4px;padding-right:4px">#SourceNo#</td>
					<td style="padding-left:4px;padding-right:4px">#OrgUnitName#</td>
					<td style="padding-left:4px;padding-right:4px">#FunctionDescription#</td>
					<td style="padding-left:4px;padding-right:4px">#PostGrade#</td>
					<td title="#observation#" style="background-color:##ffffaf80;padding-left:4px;font-size:12px">#Observation#</td>
				</tr>
				
			<cfelseif AuditElement eq "Person">
				<tr class="labelmedium2 line navigation_row fixlengthlist">
				    <td style="padding-left:20px;">#currentrow#.</td>
				    <td style="padding-left:4px"> <a href="javascript:EditPerson('#AuditPersonNo#')">#AuditPersonNo#</a></td>
					<td style="padding-left:4px;padding-right:4px">#IndexNo#</td>
					<td style="padding-left:4px;padding-right:4px">#FullName#</td>
					<td style="padding-left:4px;padding-right:4px">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</td>
					<td style="padding-left:4px;padding-right:4px">#Gender#</td>
					<td style="padding-left:4px;padding-right:4px">#Nationality#</td>
					<td title="#observation#" style="background-color:##ffffaf80;padding-left:4px;font-size:12px">#Observation#</td>
				</tr>
			</cfif>
					
		</cfoutput>
		
		</table>
		</td></tr>
				
	</cfoutput>

</cfif>

</table>

<cfset ajaxonload("doHighlight")>

<!--- employee verification

1. Get employees nos that have an assignment in that mission/mandate
2. Define the employee No that have more than one assignment between the mandate period boundaries (accross missions)
3. Scan each employee for overlapping assignments (in general)
--->