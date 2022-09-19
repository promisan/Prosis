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
			
			SELECT *
			FROM (
			SELECT      D.DocumentNo, D.DocumentNoTrigger, D.DocumentType, D.Owner, D.Mission, 
			            D.PostNumber, D.PositionNo, 
						D.DueDate, 
			            D.Status, D.StatusDate, D.StatusOfficerFirstName, 
						D.FunctionNo, D.FunctionalTitle, D.OrganizationCode, D.OrganizationUnit, 
						D.PostGrade, G.PostOrder as PostGradeorder, D.OccupationalGroup, D.GradeDeployment, 
						D.Remarks, D.Source, D.FunctionId, 
						(SELECT ReferenceNo   FROM Applicant.dbo.FunctionOrganization FO WHERE D.FunctionId = FO.FunctionId) as ReferenceNoExternal,
						(SELECT DateEffective FROM Applicant.dbo.FunctionOrganization FD WHERE D.FunctionId = FD.FunctionId) as DateEffective,						
						D.Created, 
						A.PersonNo, A.LastName, A.FirstName, A.FullName, A.Nationality, A.Gender, A.DOB, A.IndexNo, 
						A.EmployeeNo, DC.Status AS CandidateStatus, N.ISOCODE2, N.CountryGroup, 1 as Selected
			FROM        [Document] AS D INNER JOIN
			            DocumentCandidate AS DC ON D.DocumentNo = DC.DocumentNo INNER JOIN
			            Applicant.dbo.Applicant AS A ON DC.PersonNo = A.PersonNo INNER JOIN			            
			            System.dbo.Ref_Nation N ON A.Nationality = N.Code INNER JOIN
						Employee.dbo.Ref_PostGrade G ON G.PostGrade = D.PostGrade
			WHERE       D.Mission = '#url.mission#' 
			AND         DC.Status IN ('2s', '3') 
			AND         D.Status != '9'
			) as G
			
			WHERE       year(DateEffective) = '#url.year#' 
			<!---			
			<cfif vCondition neq "">
				#PreserveSingleQuotes(vCondition)#						
				</cfif>
				--->
				
			
			</cfoutput>	
		
</cfsavecontent>

<cfquery name="getCandidate"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
    #preservesingleQuotes(session.SelectedCandidates)#	
</cfquery>

<cfquery name="getMapData" dbtype="query">
	SELECT   ISOCODE2,
		   	 COUNT(DISTINCT PersonNo) AS CountPersons
	FROM	 getCandidate
	GROUP BY ISOCODE2 
</cfquery>
	
<cfquery name="Count" dbtype="query">
	SELECT     COUNT(DISTINCT DocumentNo) as Total
	FROM       getCandidate
</cfquery>

<cfquery name="CountAll" dbtype="query">
	SELECT     COUNT(DocumentNo) as Total
	FROM       getCandidate
</cfquery>
	
<cfset vDataList = "">

<cfoutput query="getMapData">
	<cfset vDataList = vDataList & "{id:'#ISOCODE2#', value:#CountPersons#}">
	<cfif currentrow neq recordCount>
		<cfset vDataList = vDataList & ", ">
	</cfif>
</cfoutput>		

<cfquery name="getMax" dbtype="query">
	SELECT 	MAX(CountPersons) as MaxValue
	FROM 	getMapData
</cfquery>

<cfquery name="getTotal" dbtype="query">
	SELECT 	SUM(CountPersons) as Total
	FROM 	getMapData
</cfquery>

<cfoutput>
<script>

    function clickMap(e){
	    // expandArea('mainLayout', 'detailArea');		
		candidatelisting('#url.systemfunctionid#','country','',e.mapObject.id)
	}
		
	var vData =	[#vDataList#];
	loadMapData_1(vData);
		
</script>
</cfoutput>
	
<cfif count.total eq "0">
	
	<table width="98%" align="center" border="0"><tr><td class="labelmedium2" style="padding-top:10px;font-size:20px" align="center"><cf_tl id="No records to show"></td></tr>
	<cfsavecontent variable="session.trackcontent"></cfsavecontent>

<cfelse>

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
			 
			  <table height="100%" width="100%"><td><td style="padding-left:10px;padding-right:10px">
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
			
</cfif>	



