<cfquery name="Criteria" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM Ref_ReportControlCriteria C
	 WHERE ControlId = '#Attributes.ControlId#'
	 ORDER BY CriteriaOrder, CriteriaCluster 
	</cfquery>
	
	<!--- analyse criteria --->
	<cfset box = 1>
	<cfset cnt = 0>
	<cfset cluster = "">
	
	<cfloop query="Criteria">
	
	    <cfset cnt = cnt + 1>
		
		<cfif #LookupMultiple# eq "1">
		    <cfif cnt gt 1>
				<cfset box = box + 1>
				<cfset cnt = "1">
			</cfif>
		    <cfinclude template="UIUpdateQuery.cfm">
			<cfset box = box + 1>
			<cfset cnt = 0>
					
		<cfelse>
		
		    <cfif #CriteriaCluster# neq "" 
			      AND #CriteriaCluster# neq "#Cluster#">
				<cfif cnt gt 1>
					<cfset box = box + 1>
					<cfset cnt = "1">
				</cfif>
			    <cfinclude template="UIUpdateQuery.cfm">	  
		
			<cfelseif #CriteriaCluster# eq "#Cluster#" 
			     and #CriteriaCluster# neq "">
				  <cfset cnt = cnt - 1>
				 <cfinclude template="UIUpdateQuery.cfm">
				 <cfset box = box + 1>
				<cfset cnt = 0>
				
			<cfelse>
			
			    <cfif cnt lt 5>
				   <cfinclude template="UIUpdateQuery.cfm">
				   
				<cfelse>
				   <cfset box = box + 1>  
				   <cfset cnt = 1>
				   <cfinclude template="UIUpdateQuery.cfm">
			   
			    </cfif>
				
			</cfif>
			
		</cfif>
			
		<cfset Cluster = #CriteriaCluster#> 
					
	</cfloop>