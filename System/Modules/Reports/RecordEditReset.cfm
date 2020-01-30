<cf_distributer>

<cfif master eq "1">
	
	<cfif FileStatus eq "Changed" 
	      and Line.Operational eq "1">
							
		 <cfquery name="Flow" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_EntityClassPublish
				WHERE     EntityCode = 'SysReport' 
				AND       EntityClass = '#Line.SystemModule#' 
		</cfquery>
		 	 
		 <cfif Flow.Recordcount gte "1">
		 
			  <cfquery name="SaveOldFlow" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE OrganizationObject
					SET    Operational = '0'
					WHERE  ObjectKeyValue4 = '#URL.ID#' 
			  </cfquery>
			 
			  <!--- create new instance --->
			  <cfinclude template="RecordSubmitInstance.cfm">			  
					 	 
		 <cfelse>
		 
			  <cfquery name="Reset" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_ReportControl
					SET    Operational = 0 
					WHERE  ControlId = '#URL.ID#'  
			  </cfquery>
				 
		 </cfif>
							
	</cfif>
		
	<cfquery name="Line" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT L.*
	    FROM Ref_ReportControl L
		WHERE ControlId = '#URL.ID#'
	</cfquery>

</cfif>