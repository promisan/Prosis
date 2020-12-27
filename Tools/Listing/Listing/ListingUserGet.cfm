
<cfparam name="attributes.modefield" default="sorting">

<cfif attributes.modefield eq "sorting">
			
	<cfquery name="check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM  UserModuleCondition
			WHERE Account = '#SESSION.acc#'
			AND   SystemFunctionId = '#attributes.systemfunctionid#'	
			AND   ConditionClass   = 'Sorting'
			AND   ConditionField   = 'listorderfield'					
	</cfquery>	
	
	<cfif check.recordcount eq "1">
		
		<cfloop index="itm" list="listorder,listorderfield,listorderalias,listorderdir">
		
			<cfquery name="check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#attributes.systemfunctionid#'	
				AND    ConditionClass   = 'Sorting'
				AND    ConditionField   = '#itm#'					
			</cfquery>	
					
			<cfset URL[itm] = check.conditionvalue>	
			
		</cfloop>
		
		<cfset accept = "0">
		
		<cfloop array="#attributes.listlayout#" index="current">
			
			  <cfif current.field eq URL.listorderfield>		     
				 <cfset accept = "1">				
			  </cfif>
			  
		</cfloop>
		
		<!--- not a valif field anymore --->
		
		<cfif accept eq "0">
		
		    <cfset URL.listorder         = "">
			<cfset URL.listorderfield    = "">
			<cfset URL.listorderalias    = "">
			<cfset URL.listorderdir      = "">
			
		</cfif>	
		
	</cfif>	
	
<cfelseif attributes.modefield eq "group">

	<cfquery name="check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM UserModuleCondition
			WHERE Account = '#SESSION.acc#'
			AND   SystemFunctionId = '#attributes.systemfunctionid#'	
			AND   ConditionClass   = 'Group'
			AND   ConditionField   = 'listgroupfield'					
	</cfquery>	
	
	<cfif check.recordcount eq "1">
			
		<cfloop index="itm" list="listgroup,listgroupfield,listgroupsort,listgroupalias,listgroupdir,listgrouptotal">
		
			<cfquery name="check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#attributes.systemfunctionid#'	
				AND    ConditionClass   = 'Group'
				AND    ConditionField   = '#itm#'					
			</cfquery>	
					
			<cfset URL[itm] = check.conditionvalue>	
			
		</cfloop>
		
		<cfset accept = "0">
		
		<cfloop array="#attributes.listlayout#" index="current">
			
			  <cfif current.field eq URL.listgroupfield>		     
				 <cfset accept = "1">				
			  </cfif>
			  
		</cfloop>
			
		<!--- revert as this is not a valid field anymore --->
		
		<cfif accept eq "0">
		
		    <cfset URL.listgroup         = "">
			<cfset URL.listgroupfield    = "">
			<cfset URL.listgroupsort     = "">
			<cfset URL.listgroupalias    = "">
			<cfset URL.listgroupdir      = "">
			<cfset URL.listgrouptotal    = "">
			
		</cfif>	
		
		<cfif url.listgroupsort eq "">
			<cfset url.listgroupsort = url.listgroupfield>
		</cfif>
		
	</cfif>	

</cfif>	