
<!--- obtain the active recruitment track for this position, but we also consider prior positions under this
parent to be taken 

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

--->

<cfoutput>
<table style="width:100%">
	<tr style="height:20px">
	
	<cfparam name="hasTrack" default="1"> 
	
	<cfif hasTrack eq "0">
			
		<td style="width:100%"> 
		
		   <cf_tl id="Initiate recruitment" var="1">
	      <input title="Click to initiate a recruitment process for this position"
		  type="button" value="#lt_text#" class="button10g" onclick="javascript:AddVacancy('#PositionNo#','#url.ajaxid#')" style="border-radius:10px;width:100%;border:1px solid silver">			  
			<!---		
		    <a title="Click to initiate a recruitment process for this position" href="javascript:AddVacancy('#PositionNo#','#url.ajaxid#')"><cf_tl id="Initiate recruitment"></a> 	
			--->
		</td>		
	
	<cfelse>
	
		<cfquery name="Doc" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   D.*, DP.PositionNo
			FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
			WHERE    D.Status = '0' <!--- at the end of the track the status is set as 1 in the workflow --->
			AND      DP.PositionNo IN ( SELECT PositionNo
									    FROM   Position	P 
									    WHERE  PositionParentId = '#positionparentid#' )
			ORDER BY DocumentNo DESC		
						   
		</cfquery>
					
		<cfquery name="Position" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Position
			WHERE  PositionNo = '#Doc.PositionNo#'
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
		
		<cf_wfActive entitycode="VacDocument" objectkeyvalue1="#doc.DocumentNo#">		
		<cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#doc.DocumentNo#&IDCandlist=ZoomIn&ActionId=undefined">
			 
		<cfif wfstatus neq "closed">	
		
			<cfset hasworkflow = 1>				
			
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