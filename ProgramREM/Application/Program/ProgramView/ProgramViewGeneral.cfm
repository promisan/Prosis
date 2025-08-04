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

<cfparam name="URL.Portal" default="0">

<cfif url.Portal eq "0">
	<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
<cfelse>
	<cf_screentop height="100%" scroll="No" html="No" blockevent="rightclick" jquery="Yes">
</cfif>

<!--- prepare dataset --->

<cfset client.programgroup = url.programgroup>
<cfset client.programclass = url.programclass>

<cfparam name="CLIENT.Sort"          default="OrgUnit">

<cfparam name="CLIENT.GlobalSetting" default="0">
<cfparam name="URL.Sort"             default="ListingOrder">
<cfparam name="URL.View"             default="Only">
<cfparam name="URL.Global"           default="#CLIENT.GlobalSetting#">
<cfparam name="URL.Lay"              default="Extended">
<cfparam name="URL.ID2"              default="Template">
<cfparam name="URL.ID3"      		 default="0000">
<cfparam name="URL.Mission"  		 default="#URL.ID2#">
<cfparam name="URL.Mandate"  		 default="#URL.ID3#">
<cfparam name="URL.page"     		 default="1">
<cfparam name="URL.find"     		 default="">

<cfif isDefined("URL.Mission") AND trim(URL.Mission) eq "">
	<cfset URL.Mission = URL.ID2>
</cfif>

<cfset CLIENT.GlobalSetting = URL.Global>
<cfset CLIENT.ProgramMode   = URL.Mode>

<cfset FileNo = round(Rand()*100)>

<cf_dialogREMProgram> 
<cf_dialogOrganization>
<cf_DialogProcurement>
<cf_dropdown>
<cf_listingScript>

<cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     Organization
	   WHERE    Mission   = '#URL.Mission#'
	   AND      MandateNo = '#URL.Mandate#'
	   <cfif url.id1 neq "Tree">
	   AND      OrgUnit  = '#URL.ID1#'
	   </cfif>
	   ORDER BY HierarchyCode	   
</cfquery>
  
<cfinvoke component="Service.AccessGlobal"
    Method="global"
  	Role="AdminProgram"
	ReturnVariable="ManagerAccess">	  	
	
<cfif URL.ID1 neq "Tree">
	
   <!--- get user Authorization level for adding programs --->
	
   <cfinvoke component="Service.Access"
		Method="organization"
		Mission="#URL.Mission#"
		OrgUnit="#Org.OrgUnit#"
		Period="#URL.Period#"
		Role="ProgramOfficer', 'ProgramManager', 'ProgramAuditor"
		ReturnVariable="ListingAccess">	
	
	<CFIF ListingAccess NEQ "NONE">	
	
		   <cfinvoke component="Service.Access"
			Method         = "organization"
			Mission        = "#URL.Mission#"
			OrgUnit        = "#Org.OrgUnit#"
			Period         = "#URL.Period#"
			Role           = "ProgramOfficer"
			ReturnVariable = "ProgramAccess">			
				
			<cfswitch expression="#URL.Mode#">
			
				<cfcase value="Maintain">
								
				    <cfinclude template = "ProgramViewPrepare.cfm">		
													
					<cfinclude template = "ProgramViewMaintain.cfm">
														
				</cfcase>
			
				<cfcase value="Progress">				
				   
					<cfset URL.ProgramClass = "Progress">
					<cfinclude template = "ProgramViewPrepare.cfm">													
					<cfinclude template = "../../../Reporting/Progress/Project/ProgressPrepare.cfm">
									
				</cfcase>
				
				<cfcase value="Audit">
				
				    <!--- disabled
																		
					<cfquery name="Par" 
					   datasource="AppsOrganization" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT *
					   FROM Organization
					   WHERE OrgUnit = '#URL.ID1#'
						AND MandateNo = '#URL.Mandate#'
						AND Mission = '#URL.Mission#'
					 </cfquery>
				 
				    <cfset URL.ProgramClass = "Audit">
					<cfinclude template = "../../Monitoring/MonitoringView/MonitoringListing.cfm">
					
					--->
					
				</cfcase>
				
				<cfcase value="Submission">			
				
					<cfset url.orgunit = org.orgunit>	
					<cfset url.id      = "Mission">		
					<cfinclude template="../../Indicator/Audit/IndicatorAudit.cfm">
				
				</cfcase>
			
				<cfcase value="Indicator">
											
					<cfquery name="Par" 
					   datasource="AppsOrganization" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Organization
					   WHERE  ParentOrgUnit = '#Org.OrgUnitCode#'
					   AND    MandateNo      = '#URL.Mandate#'
					   AND    Mission        = '#URL.Mission#'
					 </cfquery>
					 
					 <cfif par.recordcount neq "0">
					
						  <cf_message message = "Cumulative indicator counts are not supported <b>yet</b>. Please select a single unit in this tree."
			    			return = "No">
							
				  	 <cfelse>
					
						<cfinclude template="../../Indicator/Audit/IndicatorSummary.cfm">
					
					</cfif>
				
				</cfcase>
			
			</cfswitch>
	
		<cfelse>		
		
		     <cf_message message = "You have no access to this organization level. Operation not allowed."
		      return = "No">
		
		</cfif>

<cfelse>

		<cfswitch expression="#URL.Mode#">
		
			<cfcase value="Maintain">
			   
				<cfinvoke component="Service.Access"
					Method         = "organization"
					Mission        = "#URL.Mission#"
					OrgUnit        = ""
					Period         = "#URL.Period#"
					Role           = "ProgramOfficer"
					ReturnVariable = "ProgramAccess">															
			
			    <cfif ProgramAccess eq "xxxnone">
				
					  <cf_message message = "You have no access to this organization level. Operation not allowed."
				      return = "No">		
				
				<cfelse>

				    <cfinclude template = "ProgramViewPrepare.cfm">		
					<cfinclude template = "ProgramViewMaintain.cfm">						
					
				</cfif>	
				
			</cfcase>
		
			<cfcase value="Progress">			
			    <cfinclude template="ProgramViewPrepare.cfm">				
				<cfinclude template="../../../Reporting/Progress/Project/ProgressPrepare.cfm">				
			</cfcase>
		
			<cfcase value="Indicator">						
				<cfinclude template="../../Indicator/Score/ScoreView.cfm">			
			</cfcase>
		
		</cfswitch>

</cfif>

<!--- used for the standard listing, can not delete now
<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Program#FileNo#">  
--->
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Progress#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Activity#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Activity1#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityAll_1#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityAll#FileNo#">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityPending#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityPending1#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityPending2#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#LastProgress#FileNo#">
<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">		
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#BSCSummary#FileNo#">	
 
<!--- 
<cfif url.Portal eq "0"> 

	   <cf_screenbottom>
	   
</cfif>
--->

