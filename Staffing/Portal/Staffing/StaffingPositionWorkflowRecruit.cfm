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
		
	<cfparam name="hasTrack" default="1"> 
	<cfparam name="positionno" default="">
		
	<cfif hasTrack lte "1" and positionNo neq "">
	
	    <tr style="padding-bottom:2px" class="labelmedium2">
			
		<td style="width:100%"> 
		
		  <cfif hasTrack eq "0">
			  <cf_tl id="Initiate recruitment" var="1">
		  <cfelse>
		      <cf_tl id="Initiate another recruitment" var="1">
		  </cfif>	  
	      <input title="Click to initiate a recruitment process for this position" 
		  type="button" value="#lt_text#" class="button10g" <cfif getAdministrator eq "0">disabled</cfif> onclick="javascript:AddVacancy('#PositionNo#','#url.ajaxid#')" 
		  style="border-radius:2px;width:100%;border:1px solid silver">			  
			
		</td>	
		
		</tr>
		
		<tr><td style="height:3px"></td></tr>
		
	</cfif>
	
	<cfif hasTrack gte "1">		
		
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
		
		<cfloop query="doc">
					
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
					   
			   <tr><td style="width:100%;border:1px solid silver;border-radius:6px">
	     		   <table style="width:100%" class="formpadding">
				    <tr class="labelmedium2">
			        <td><b>#doc.documenttype#</b><cf_tl id="Announcement"></td>
					
					<cfif Doc.FunctionId neq "">
		
						<cfquery name="JO" 
						datasource="appsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   FunctionOrganization
							WHERE  FunctionId = '#Doc.FunctionId#'
						</cfquery>
					
     			        <td align="right"><A href="javascript:va('#Doc.FunctionId#');">#JO.ReferenceNo#</a></td>
						
						<td style="padding-top:4px;padding-bottom:4px" align="right"><table><tr>
						<cfif Jo.DateEffective neq "">
							<cfset days = datediff("d",  JO.DateEffective,  now())>		
							<cfif days gte "90">			
								<td class="labelit" style="border-radius:10px;text-align:center;background-color:red;color:white;width:40px" title="Days since posting">#days#</td>
							<cfelseif days gte "60">								
							    <td class="labelit" style="border-radius:10px;text-align:center;background-color:FFB164;width:40px" title="Days since posting">#days#</td>
							<cfelse>
							    <td class="labelit" style="border-radius:10px;text-align:center;background-color:yellow;width:40px" title="Days since posting">#days#</td> 
							</cfif>
						<cfelse>
							<td style="width:40px"></td>
						</cfif>	
						</tr></table></td>
						
					</cfif>
					
					</tr>
					
					<cfif wfstatus neq "closed">	
			
						<cfset hasworkflow = 1>		
						
						<tr>		
						
						<td style="width:100%" colspan="3">	
													
							<cf_ActionListing 
							    ReadMode         = "read_uncommitted"     
							    TableWidth       = "100%"
							    EntityCode       = "VacDocument"
								EntityClass      = "#EntityClass#"
								EntityGroup      = "#Owner#"
								EntityStatus     = ""		
								Mission          = "#Mission#"
								OrgUnit          = "#Position.OrgUnitOperational#"
								ObjectReference  = "#FunctionalTitle#"
								ObjectReference2 = "#Mission# - #PostGrade#"
								ObjectKey1       = "#DocumentNo#"	
								AjaxId           = "#URL.ajaxId#"
							  	ObjectURL        = "#link#"
								ChatEnable       = "0"
								Show             = "Mini"
								DocumentStatus   = "#Status#">
							
						</td>	
						
						</tr>
								
					<cfelse>
					
						<td bgcolor="FFB0FF" colspan="3"
						style="padding-left:4px;background-color:FFB0FF"><cf_tl id="Selection completed"></td>
					
					</cfif>			
					
						
					<cfif Candidate.recordcount neq "0">
					
						<cfloop query="candidate">		
						<tr class="linedtted labelmedium">
						     <td colspan="3" style="padding-left:4px;font-size:14px">#Candidate.FirstName# #Candidate.LastName# <cfif IndexNo eq "">[No indexNo]<cfelse></cfif>#IndexNo#</td>
					    </tr>			
						</cfloop>
					
					</cfif>	
			
			  </table>
			   </td></tr>
			 
			  <tr><td style="height:2px"></td></tr>
						
		</cfloop>	
		
				
      	        
			
	</cfif>
	
</table>	
</cfoutput>