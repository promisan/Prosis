
<!--- obtain the active recruitment track for this position, but we also consider prior positions under this
parent to be taken --->

<cfquery name="Active" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   D.DocumentNo, DP.PositionNo
	FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
	WHERE    D.Status = '0' <!--- at the end of the track the status is set as 1 in the workflow --->
	AND      DP.PositionNo IN ( SELECT PositionNo
							    FROM   Position	P 
							    WHERE  PositionParentId = '#positionparentid#' )
	ORDER BY DocumentNo DESC		
				   
</cfquery>

<cfoutput>
<table style="width:100%">
	<tr style="height:20px">
	
	<cfif Active.recordcount eq "0">
			
		<td style="padding-left:24px;width:100%"> 
		    <a href="javascript:AddVacancy('#PositionNo#','#url.ajaxid#')"><cf_tl id="Initiate recruitment"></a> 	
		</td>		
	
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
			WHERE PositionNo = '#Active.PositionNo#'
		</cfquery>
		
		<cfquery name="Candidate" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT  A.IndexNo, DC.LastName, DC.FirstName, A.DOB, A.PersonNo, A.EmployeeNo
			FROM    DocumentCandidate AS DC LEFT OUTER JOIN
		            Applicant.dbo.Applicant AS A ON DC.PersonNo = A.PersonNo
			WHERE   DocumentNo = '#Active.DocumentNo#'
			AND     Status = '2s'
			
		</cfquery>
		
		<cf_wfActive entitycode="VacDocument" objectkeyvalue1="#Active.DocumentNo#">		
		<cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#Active.DocumentNo#&IDCandlist=ZoomIn&ActionId=undefined">
			 
		<cfif wfstatus neq "closed">		
			
			<td style="width:100%">	
							
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
					
		<cfelse>
		
			<td align="center" bgcolor="FFB0FF" style="background-color:FFB0FF"><cf_tl id="Selection completed"></td>
		
		</cfif>
		
		</tr>
		
		<cfif Candidate.recordcount neq "0">
		
			<cfloop query="candidate">
		
			<tr class="line" style="padding-top:2px"><td align="center">#Candidate.FirstName# #Candidate.LastName# (<cfif IndexNo eq "">No indexNo<cfelse></cfif>#IndexNo#)</td></tr>
			
			</cfloop>
		
		</cfif>	
			
	</cfif>
	
</table>	
</cfoutput>