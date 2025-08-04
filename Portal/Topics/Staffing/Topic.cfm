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

<cfoutput>

<script>

	function doChangeStaffing(link,box,cfund,cpost,ccat,caut) {			   
		_cf_loadingtexthtml='';	   			
		ptoken.navigate(link+'&fund='+cfund.value+'&postclass='+cpost.value+'&category='+ccat.value+'&authorised='+caut.value,box);											
	}		
	
	function doStaffing(mis,org,per,fnd,cls,aut,grdparent,grd,tpe) {	    
	    _cf_loadingtexthtml='';				
		ptoken.navigate('Staffing/StaffingDetail.cfm?mission='+mis+'&orgunit='+org+'&period='+per+'&fund='+fnd+'&postclass='+cls+'&authorised='+aut+'&postgradeparent='+grdparent+'&postgradebudget='+grd+'&tpe='+tpe,'StaffingDetail_'+mis);
	}		
		
</script>	

</cfoutput>		
			
<cfquery name="MissionList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserModuleCondition C
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.SystemFunctionId = '#SystemFunctionId#'  
	ORDER BY ConditionValueAttribute1, ConditionValue
</cfquery>

<cfoutput query="MissionList">
	
	<!--- define relevant periods for the mission to pass --->
	
	<cfset mission = MissionList.ConditionValue>
	
	<cfquery name="PeriodList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT M.PlanningPeriod, P.DateEffective
		FROM    Ref_MissionPeriod AS M INNER JOIN
	            Program.dbo.Ref_Period AS P ON M.PlanningPeriod = P.Period
		WHERE   M.Mission = '#mission#' 
		AND     P.DateEffective < GETDATE() + 90
		AND     P.DateEffective > GETDATE() - 1600
		ORDER BY P.DateEffective DESC	
	</cfquery>	
	
	<cfset per = "today">
		
	<cfset dte = now()>
	<cfloop index="mth" from="3" to="-12" step="-1">
		<cfset dte = dateAdd("M",mth,now())>
		<cfset dim = daysInMonth(dte)>
		<cfif month(dte) lt 10>
			<cfset per = "#per#,#year(dte)#/0#month(dte)#/#dim#">
		<cfelse>
			<cfset per = "#per#,#year(dte)#/#month(dte)#/#dim#">
		</cfif>			
	</cfloop>
	
	<cfset defunit = ConditionValueAttribute1>
	
	<cfif getAdministrator(mission) eq "0">
									 
		<cfquery name="accessglobal" 
	     datasource="AppsOrganization" 
	   	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
			   SELECT DISTINCT Mission 
	                 FROM   Organization.dbo.OrganizationAuthorization
	                       WHERE  UserAccount = '#SESSION.acc#'
			   AND    Mission     = '#mission#'
			   AND    Role IN (SELECT Role 
							   FROM   Organization.dbo.Ref_AuthorizationRole 
					           WHERE  SystemModule = 'Staffing')									   
			   AND    OrgUnit is NULL
		 </cfquery>  
									 
		 <cfif accessglobal.recordcount eq "0">	
		 							 
			  <cfquery name="accessunit" 
		     datasource="AppsOrganization" 
	    	 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">	
				   SELECT   O.OrgUnit 
	               FROM     Organization.dbo.Organization O INNER JOIN Organization.dbo.OrganizationAuthorization A ON O.OrgUnit = A.OrgUnit
	               WHERE    UserAccount = '#SESSION.acc#'
				   AND      A.Mission = '#mission#'
				   AND      A.Role IN (SELECT Role 
								       FROM   Organization.dbo.Ref_AuthorizationRole 
						               WHERE  SystemModule = 'Staffing')									   
				   AND      A.OrgUnit is not NULL
				   ORDER BY O.HierarchyCode <!--- puts the highest first --->
			 </cfquery>  
			 
			 <cfset units = valueList(accessunit.orgunit)>
					 
			 <cfif not findNoCase(ConditionValueAttribute1,units) or ConditionValueAttribute1 eq "">		
			       <cfset defunit = accessunit.orgunit>				  	
			 </cfif>		
			  								 
		 <cfelse>
		 
		 	<cfset units = "0">
			
		 </cfif>	
		 
	<cfelse>
	
		<cfset units = "0">
	
	</cfif>	 	 
								
	<cf_pane id="#currentrow#" search="No">
							
		<cf_paneItem id="Staffing_#mission#" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/Staffing/Staffing.cfm?mission=#mission#&unit=#defunit#"
				customFilter	 = "#session.root#/Portal/Topics/Staffing/CustomFilter.cfm?mission=#mission#&targetbox=#currentrow#"
				width            = "98%"
				height           = "auto"
				Mission          = "#mission#"		
				Period           = "#per#"		
				Units            = "#units#"
				UnitsMultiple    = "Yes"								
				Option           = "Parent"
				DefaultOrgUnit   = "#defunit#"
				DefaultPeriod    = "#ConditionValueAttribute2#"	
				Label            = "#Mission# Staffing"
				filterValue      = "Staffing"
				ShowPrint		 = "1">					
						
	</cf_pane>
	

</cfoutput>

