

<cftry>

       <cfquery name="Module" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO REF_SystemModuleDatabase (SystemModule,DatabaseName,MissionTable)
		VALUES ('Staffing','Employee','Ref_ParameterMission')
	   </cfquery>
	   
	   <cfcatch></cfcatch>	


</cftry>

<cftry>

       <cfquery name="Module" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO REF_SystemModuleDatabase (SystemModule,DatabaseName,MissionTable)
		VALUES ('Accounting','Accounting','Ref_ParameterMission')
	   </cfquery>
	   
	   <cfcatch></cfcatch>	


</cftry>

<cftry>

       <cfquery name="Module" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO REF_SystemModuleDatabase (SystemModule,DatabaseName,MissionTable)
		VALUES ('Procurement','Purchase','Ref_Mission')
	   </cfquery>
	   
	   <cfcatch></cfcatch>	

</cftry>

<cftry>

       <cfquery name="Module" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO REF_SystemModuleDatabase (SystemModule,DatabaseName,MissionTable)
		VALUES ('Warehouse','Materials','Ref_ParameterMission')
	   </cfquery>
	   
	   <cfcatch></cfcatch>	

</cftry>