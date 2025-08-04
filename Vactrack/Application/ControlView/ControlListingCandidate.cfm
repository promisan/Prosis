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
<cf_screentop html="No" jQuery="Yes">

<cfparam name = "URL.Criteria"           default = "No">
<cfparam name = "URL.SystemfunctionId"   default = "">
<cfparam name = "URL.Mode"               default="Control">
<cfparam name = "URL.HierarchyCode"      default="">
<cfparam name = "URL.HierarchyRootUnit"  default="">
<cfparam name = "URL.Parent"             default="All">
<cfparam name = "URL.Entity"             default="All">
<cfparam name = "URL.Year"               default = "#year(now())#">

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Ref_Mission
     	WHERE  Mission = '#url.mission#'
</cfquery>

<cfajaximport tags="cfform,cfdiv">
<cf_calendarscript>
<cfinclude template="../Document/Dialog.cfm">
<cf_listingscript>

<cfoutput>

	<script language="JavaScript">	
					
		 function show_box_search() {
			element = document.getElementById('img_search');
			element_row = document.getElementById('dBox');
			if (element_row.className == 'hide') {
				element_row.className = 'normal';
				element.src = '#SESSION.root#/images/arrow-up.gif';
			} else	{
				element_row.className = 'hide';
				element.src = '#SESSION.root#/images/arrow-down.gif';
			}	
		 }
		 
		function do_restrict (e) {
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	
			ptoken.navigate('ControlListingCandidateCriteria.cfm?Entity=#URL.Entity#&Mission=#URL.Mission#&HierarchyRootUnit=#URL.HierarchyRootUnit#&HierarchyCode=#URL.HierarchyCode#&Mode=#URL.Mode#&Status=#URL.Status#&Parent=#URL.Parent#&EntityCode='+e,'dCriteria'); 
		 }
		 
		function do_search () {
		 	document.fCriteria.onsubmit();
			if( _CF_error_messages.length == 0 ) {
			    _cf_loadingtexthtml='';	
				Prosis.busy('yes')	
				ptoken.navigate('ControlListingCandidateResult.cfm?systemfunctionid=#url.systemfunctionid#&Criteria=Yes&Entity=#URL.Entity#&Mission=#URL.Mission#&HierarchyRootUnit=#URL.HierarchyRootUnit#&HierarchyCode=#URL.HierarchyCode#&Mode=#URL.Mode#&Status=#URL.Status#&Parent=#URL.Parent#','dDetails','','','POST','fCriteria');
			}	 
		 }
		 
		function doResult() {		   
		    ptoken.navigate('#session.root#/vactrack/application/ControlView/ControlListingResultView.cfm','tracklistingcontent')		 
		 }
				
	    function candidatelisting(sid,mde,con,fil) {		   
		    ptoken.navigate('#session.root#/Vactrack/Application/ControlView/ControlListingCandidateContent.cfm?cfdebug=true&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&mode='+mde+'&condition='+con+'&filter='+fil,'tracklistingcontent') 			 
		}
			
	    function clickMap(e){
		    // expandArea('mainLayout', 'detailArea');		
			candidatelisting('#url.systemfunctionid#','country','',e.mapObject.id)
		}
							
	</script>

</cfoutput>

<cf_ProsisMap 
	id="1" 
	target="candidatemap" 
	colorFrom="##E9D460"
	colorTo="##1E824C"
	showSmallMap="false"
	showexport="yes"
	autoZoom="false"
	onClick="clickMap"
	zoom="true"
	home="false">		
	
	<cfsavecontent variable="session.selectedcandidates">
			
				<cfoutput>		
				
				SELECT  P.OrgUnitOperational,		
				        P.SourcePostNumber,		
						(SELECT OrgUnitNameShort FROM Organization.dbo.Organization WHERE Orgunit = P.OrgUnitOperational) as OrgUnitNameShort,						      
						(SELECT HierarchyCode FROM Organization.dbo.Organization WHERE Orgunit = P.OrgUnitOperational) as HierarchyCode,						
						(SELECT TOP 1 Fund FROM Employee.dbo.PositionParentFunding WHERE PositionParentId = P.PositionParentId) as Fund,
						(SELECT TOP 1 FunctionalArea FROM Employee.dbo.PositionParentFunding WHERE PositionParentId = P.PositionParentId) as FunctionalArea,						 
				        G.*
				FROM (
					SELECT      D.DocumentNo, D.DocumentNoTrigger, D.DocumentType, D.Owner, D.Mission, N.Name as NationalityName,
					            <!--- 
					            D.PostNumber, D.PositionNo, 
								--->
								<!--- post of the arrival or post of the track --->
								(CASE WHEN DC.PositionNo is not NULL
								              THEN DC.PositionNo 
											  ELSE (SELECT TOP 1 PositionNo FROM DocumentPost WHERE DocumentNo = D.DocumentNo) END) as PositionNo,
								D.DueDate, 
					            D.Status, D.StatusDate, D.StatusOfficerFirstName, 
								D.FunctionNo, D.FunctionalTitle, 
								<!--- we take this from the position
								D.OrganizationCode, D.OrganizationUnit, 
								--->
								D.PostGrade, G.PostOrder as PostGradeorder, D.OccupationalGroup, D.GradeDeployment, 
								D.Remarks, D.Source, D.FunctionId, 
								(SELECT ReferenceNo   FROM Applicant.dbo.FunctionOrganization FO WHERE D.FunctionId = FO.FunctionId) as ReferenceNoExternal,
								(SELECT DateEffective FROM Applicant.dbo.FunctionOrganization FD WHERE D.FunctionId = FD.FunctionId) as DateEffective,						
								
								<!--- selection date --->
								(SELECT  TOP 1 ReviewDate
                                 FROM    DocumentCandidateReview
                                 WHERE   DocumentNo = DC.DocumentNo 
								 AND     PersonNo = DC.PersonNo 
								 AND     ReviewStatus = '2s'
								 ORDER BY Created DESC) AS SelectionDate,	
								
								
								D.Created, 
								DC.CandidateClass,
								(SELECT TOP 1 Description FROM Applicant.dbo.Ref_ApplicantClass WHERE ApplicantClass = DC.CandidateClass) as CandidateClassName,
								A.PersonNo, A.LastName, A.FirstName, A.FullName, A.Nationality, A.Gender, A.DOB, A.IndexNo, 
								A.EmployeeNo, DC.Status AS CandidateStatus, N.ISOCODE2, N.CountryGroup, 1 as Selected
					FROM        [Document] AS D INNER JOIN
					            DocumentCandidate AS DC ON D.DocumentNo = DC.DocumentNo  INNER JOIN
					            Applicant.dbo.Applicant AS A ON DC.PersonNo = A.PersonNo INNER JOIN			            
					            System.dbo.Ref_Nation N ON A.Nationality = N.Code        INNER JOIN
								Employee.dbo.Ref_PostGrade G ON G.PostGrade = D.PostGrade
					WHERE       D.Mission = '#url.mission#' 
					AND         DC.Status IN ('2s', '3') 
					AND         D.Status != '9'
				) as G LEFT OUTER JOIN Employee.dbo.Position P ON G.PositionNo = P.PositionNo
				
				-- WHERE       year(G.DateEffective) = '#url.year#' 	
				 WHERE year(G.SelectionDate) = '#url.year#'					
				
				</cfoutput>	
			
	</cfsavecontent>
	
	
<cf_layoutscript>	
	
<cfoutput>
	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	
		
	<cf_layout attributeCollection="#attrib#">	
	
	    <cf_layoutarea  position="header" name="box11" collapsible = "false">
		
		   <table height="100%" width="100%" align="center">
				
				<tr>		
			    <td style="height:10px">		
				    <table width="100%">					
						<tr>
					    <td align="left" class="labellarge" style="padding-left:20px;height:40px;font-size:34px;padding-top:4px">
									
							    <cfif url.mode neq "Print">
								<a href="javascript:show_box_search()">#URL.Mission# #url.year#<img id="img_search" src="#SESSION.root#/images/arrow-down.gif" alt="" border="0" align="top"></a>													
								<cfelse>
								#URL.Mission#
								</cfif>			
								
						<td align="right" class="fixlength" style="padding-left:20px;height:30px;font-size:26px;padding-top:4px">#url.orgunitname#</td>																		    				
						</tr>												
					</table>			
			    </td>			
				</tr>	
				
				<!--- main filter box --->
				<tr id="dBox" class="hide">		
					<td width="100%" colspan="3" id="dCriteria">	 
	                    <cfinclude template="ControlListingTrackGet.cfm">
						<cfinclude template="ControlListingCandidateCriteria.cfm">
					</td>			
				</tr>	
			
			</table>
		
		</cf_layoutarea>
			
		<cf_layoutarea  position="top" name="box" collapsible = "true">
		
		    <table height="100%" width="100%" align="center">			
			<tr>
				<td colspan="3" valign="top" id="dDetails" style="height:100%">					
				   <cfinclude template = "ControlListingCandidateResult.cfm">					
				</td>
			</tr>					
			</table>					
				
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="centerbox">				    
			 
			  <table height="100%" width="100%">
			  <td>
			  <td style="padding-left:10px;padding-right:10px">
				  <table height="100%" width="100%" class="formpadding formspacing">					  
					<tr>
						<td colspan="2" valign="top" id="tracklistingcontent" style="padding:6px;border:1px solid silver;background-color:f1f1f1;height:100%"></td>
					</tr>				
				  </table>		
			  </td></td>
			  </table>				       			
		
		</cf_layoutarea>			
			
	</cf_layout>	
	
</cfoutput>
	


