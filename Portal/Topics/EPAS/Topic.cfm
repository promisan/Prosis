
<cfoutput>
<script>

	function doChangePAS(link,box,cstf,cpost,ccat,caut) {				
		_cf_loadingtexthtml='';	   			
		ptoken.navigate(link+'&cstf='+cstf.value+'&postclass='+cpost.value+'&category='+ccat.value+'&authorised='+caut.value,box);											
	}		
	
	function broadcastpas(mis,per,sta) {	     
		  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastEPAS.cfm", "broadcast", "status=yes, height=850px, width=1020px, center=yes, scrollbars=no, toolbar=no, resizable=no");
	}
			
</script>	

</cfoutput>

<cf_dialogstaffing>	
			
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
	
	<cfset defunit = ConditionValueAttribute1>
									 
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
		 
		 <cfif accessunit.recordcount gte "1">	 		 
			 <cfset units = valueList(accessunit.orgunit)>
		 <cfelse>
		 	<cfset units = "0">
		 </cfif>	 
		 	
				 
		 <cfif not findNoCase(ConditionValueAttribute1,units) or ConditionValueAttribute1 eq "">		
		       <cfset defunit = accessunit.orgunit>				  	
		 </cfif>		
		  								 
	 <cfelse>
	 
	 	<cfset units = "0">
		
	 </cfif>		
	 
		
	<cfquery name="PeriodList" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_ContractPeriod
		WHERE  Mission = '#mission#'				
	</cfquery>	
	
										
	<cf_pane id="#currentrow#" search="No">
							
		<cf_paneItem id="EPas_#mission#" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/ePas/ePas.cfm?mission=#mission#"
				customFilter	 = "#session.root#/Portal/Topics/ePas/CustomFilter.cfm?mission=#mission#&targetbox=#currentrow#"
				width            = "99%"
				height           = "auto"
				Mission          = "#mission#"		
				Period           = "#valueList(PeriodList.Code)#"		
				Units            = "#units#"								
				Option           = "Parent"				
				DefaultOrgUnit   = "#defunit#"
				DefaultPeriod    = "#ConditionValueAttribute2#"	
				Label            = "#Mission# Performance Appraisal Status"
				filterValue      = "EPas"
				ShowPrint		 = "1">					
						
	</cf_pane>
		
</cfoutput>
