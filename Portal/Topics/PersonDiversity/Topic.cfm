
<cfoutput>
	<script>

		function doChangeFilter(link,box,cstf,cpost,ccat,caut,cinc) {			    
			_cf_loadingtexthtml='';	
			ptoken.navigate(link+'&cstf='+cstf.value+'&postclass='+cpost.value+'&category='+ccat.value+'&authorised='+caut.value+'&SystemFunctionId=#SystemFunctionId#',box);											
		}

		function showDetail(type, mis, orgunit, cstf, postclass, category, authorised, period, id1, id2, target) {
			ptoken.navigate('#session.root#/Portal/Topics/PersonDiversity/StaffingDetail.cfm?systemFunctionId=#systemFunctionId#&type='+type+'&mission='+mis+'&orgunit='+orgunit+'&cstf='+cstf+'&postclass='+postclass+'&category='+category+'&authorised='+authorised+'&period='+period+'&id1='+id1+'&id2='+id2, target);
		}

		function showFundingDetail(type, mis, orgunit, cstf, postclass, category, authorised, period, target) {
			ptoken.navigate('#session.root#/Portal/Topics/PersonDiversity/ContractLevelDetail.cfm?systemFunctionId=#systemFunctionId#&type='+type+'&mission='+mis+'&orgunit='+orgunit+'&cstf='+cstf+'&postclass='+postclass+'&category='+category+'&authorised='+authorised+'&period='+period, target);
		}

		function doToggleParent(){
			if ($('.clsParent').first().is(':visible')) {
				$('.clsParent').hide();
			} else {
				$('.clsParent').show();
			}
		}
			
	</script>
</cfoutput>		

<cf_dialogStaffing>	


<cf_ProsisMap 
	id="1" 
	target="mymap" 
	colorFrom="##E9D460"
	colorTo="##1E824C"
	showSmallMap="false"
	autoZoom="false"
	zoom="true"
	home="false">
			
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
		AND     P.DateEffective < GETDATE() 
		AND     P.DateEffective > GETDATE() - 1600
		ORDER BY P.DateEffective DESC	
	</cfquery>	
	
	<cfset per = "today">
					
	<cfset dte = now()>
	<cfloop index="mth" from="0" to="-28" step="-1">
		<cfset dte = dateAdd("M",mth,now())>
		<cfif month(dte) lt 10>
			<cfif per eq "">
			<cfset per = "#year(dte)#/0#month(dte)#">
			<cfelse>
			<cfset per = "#per#,#year(dte)#/0#month(dte)#">
			</cfif>
		<cfelse>
		    <cfif per eq "">
			<cfset per = "#year(dte)#/#month(dte)#">
			<cfelse>
			<cfset per = "#per#,#year(dte)#/#month(dte)#">
			</cfif>
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
							
		<cf_paneItem id="diversity_#mission#" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/PersonDiversity/Staffing.cfm?mission=#mission#&unit=#defunit#&SystemFunctionId=#SystemFunctionId#"
				customFilter	 = "#session.root#/Portal/Topics/PersonDiversity/CustomFilter.cfm?mission=#mission#&targetbox=#currentrow#&SystemFunctionId=#SystemFunctionId#"
				width            = "98%"
				height           = "100%"
				Mission          = "#mission#"		
				Units            = "#units#"	
				UnitsMultiple    = "Yes"	
				Period           = "#per#"		
				Option           = "Parent"
				DefaultOrgUnit   = "#defunit#"
				DefaultPeriod    = "#ConditionValueAttribute2#"	
				Label            = "#Mission# Staff diversity"
				filterValue      = "Staffing"
				ShowPrint		 = "1"
				PrintCallback	 = "$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
						
	</cf_pane>
	

</cfoutput>

