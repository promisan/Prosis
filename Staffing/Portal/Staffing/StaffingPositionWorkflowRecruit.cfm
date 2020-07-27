
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT P.*, C.Description as VacancyActionClassName
	 FROM  Position	P INNER JOIN Ref_VacancyActionClass C ON P.VacancyActionClass = C.Code
	 WHERE P.PositionParentId = '#positionparentid#'	
	 ORDER BY P.PositionNo DESC 
</cfquery>

<cfquery name="Active" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   D.DocumentNo, DP.PositionNo
	FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
	WHERE    D.Status = '0' 
	AND      DP.PositionNo IN ( SELECT PositionNo
							    FROM   Position	P 
							    WHERE  PositionParentId = '#positionparentid#' )
	ORDER BY DocumentNo DESC		
				   
</cfquery>

<cfif Active.recordcount eq "0">

	<cfoutput>
	<table width="100%" height="100%">
	<tr class="labelmedium" style="height:100%;"><td style="background-color:ffffaf" align="center">#Parent.VacancyActionClassName#</td>
	<td style="padding-left:4px" align="center"> 
	<a href="javascript:AddVacancy('#Parent.PositionNo#','#url.ajaxid#')"><cf_tl id="Initiate recruitment"></a> 	
	</td></tr></table>
	</cfoutput>

<cfelse>
	
	<cfquery name="Doc" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Document
		WHERE DocumentNo = '#Active.DocumentNo#'
	</cfquery>
	
	<cfquery name="Position" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Position
		WHERE PositionNo = '#Doc.PositionNo#'
	</cfquery>
	
	<cfquery name="Candidate" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  A.IndexNo, DC.LastName, DC.FirstName, A.DOB, A.PersonNo, A.EmployeeNo
		FROM    DocumentCandidate AS DC LEFT OUTER JOIN
	            Applicant.dbo.Applicant AS A ON DC.PersonNo = A.PersonNo
		WHERE   DocumentNo = '#Doc.DocumentNo#'
		AND     Status = '2s'
		
	</cfquery>
	
	<table width="100%">
	
	<cf_wfActive entitycode="VacDocument" objectkeyvalue1="#Doc.DocumentNo#">
	
	<cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#url.ajaxid#&IDCandlist=ZoomIn&ActionId=undefined">
		 
	<cfif wfstatus neq "closed"> 
	
		<tr> 	
		<td style="padding-left:4px;padding-right:4px">	
						
			<cf_ActionListing 
			    ReadMode         = "read_uncommitted"     
			    TableWidth       = "100%"
			    EntityCode       = "VacDocument"
				EntityClass      = "#Doc.EntityClass#"
				EntityGroup      = "#Doc.Owner#"
				EntityStatus     = ""		
				Mission          = "#Doc.Mission#"
				OrgUnit          = "#Position.OrgUnitOperational#"
				ObjectReference  = "#Doc.FunctionalTitle#"
				ObjectReference2 = "#Doc.Mission# - #Doc.PostGrade#"
				ObjectKey1       = "#Doc.DocumentNo#"	
				AjaxId           = "#URL.ajaxId#"
			  	ObjectURL        = "#link#"
				Show             = "Mini"
				DocumentStatus   = "#Doc.Status#">
			
		</td>	
		</tr>
		
	<cfelse>
	
		<tr class="line"><td align="center" bgcolor="FFB0FF" style="background-color:#FFB0FF"><cf_tl id="Selection completed"></td></tr>	
	
	</cfif>
	
	<cfif Candidate.recordcount neq "0">
	
		<cfoutput query="candidate">
	
		<tr style="<cfif currentrow neq '1'>border-top:1px solid silver</cfif>;padding-top:2px"><td align="center">#Candidate.FirstName# #Candidate.LastName# (<cfif IndexNo eq "">No indexNo<cfelse></cfif>#IndexNo#)</td></tr>
		
		</cfoutput>
	
	</cfif>	
	
	</table>		

</cfif>

 	
 		
	
	
	