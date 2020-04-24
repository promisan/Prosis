<!--- control list data content --->


<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission WITH (NOLOCK)
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfset wclass = "Contact">
<cf_tl id="Completed" var="lblCompleted">
<cf_tl id="Process" var="lblProcess">
<cf_tl id="Revoked" var="lblRevoked">


<cfsavecontent variable="myquery">

	<cfoutput>	  
		SELECT *,
			CASE 
        		WHEN ISNULL(ParentWorkORderID,'00000000-0000-0000-0000-000000000000')='00000000-0000-0000-0000-000000000000' AND WorkActionID = FirstWorkActionID THEN
        		CASE 
        			WHEN wlaactionstatus = '8' THEN
        				'1CAU'
        			WHEN wlaactionstatus = '9' THEN
        				'1CCA'
        			ELSE
				    	'1C'
				END
			ELSE 
				CASE 
					WHEN LastServiceDomainClass = wlservicedomainclassnow THEN
						CASE
							WHEN wlaactionstatus = '8' THEN
        						'REAU'
        					WHEN wlaactionstatus = '9' THEN
        						'RECA'
        				ELSE
				    		'RE'
				    	END
				ELSE
					CASE
						WHEN wlaactionstatus = '8' THEN
        					'NPAU'
        				WHEN wlaactionstatus = '9' THEN
        					'NPCA'
        				ELSE
				    		'NP'
				    END
				END
			END as contact
		FROM     userQuery.dbo.actionListing_#Session.acc# 
		WHERE  1=1
		-- condition
		ORDER BY DatetimePlanning ASC 					
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfif url.personno eq "">
    <cfset filter = "yes"> 
	<cfset force  = "1">
<cfelse>
    <cfset filter = "hide">
	<cfset force = "0">
</cfif>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Scheduled" var = "1">				
	<cfset fields[itm] = {label       	= "#lt_text#",                    
	     				field         	= "DateTimePlanning",					
						alias         	= "",	
						filterforce   	= "#force#",	
						functionscript  = "openschedule",
						functionfield 	= "workactionid",
						align         	= "left",		
						width         	= "12",
						formatted     	= "lsdateformat(DateTimePlanning,'DD/MM/YYYY')",																	
						search        	= "date"}>
	
	<cfset itm = itm+1>					
	<cf_tl id="Day" var = "1">				
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "DateTimePlanning",					
						alias           = "",	
						filterforce     = "#force#",							
						align           = "left",		
						width           = "6",
						formatted       = "lsdateformat(DateTimePlanning,'DDD')"}>					
						
	<cfset itm = itm+1>
	<cf_tl id="Time" var = "1">				
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "DateTimePlanning",					
						alias           = "",		
						align           = "center",		
						formatted       = "timeformat(DateTimePlanning,'HH:MM')"}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Status" var = "1">						
	<cfset fields[itm] = {label         = "Status", 	
                      LabelFilter       = "#lt_text#",				
					  field             = "WorkOrderlineActionStatus",					
					  filtermode        = "3",    
					  search            = "text",
					  align             = "center",
					  formatted         = "Rating",
					  ratinglist        = "Process=Yellow,Completed=Blue,Process=Green,Revoked=Red"}>						
			
	<cfif url.personno eq "">	
					
		<cfset itm = itm+1>
		<cf_tl id="Patient" var = "1">			
		<cfset fields[itm] = {label       	= "#lt_text#",                    
		     				field         	= "CustomerName",					
							alias         	= "",	
							functionscript  = "openaction",
							functionfield 	= "workorderlineid",																						
							search        	= "text"}>	
													
	</cfif>	
	
	<cfset itm = itm+1>
	<cf_tl id="Specialist" var = "1">			
	<cfset fields[itm] = {label       		= "#lt_text#",                    
	     				field         		= "ActorLastName",					
						alias         		= "",				
						functionscript      = "openaction",
						functionfield 		= "workorderlineid",																								
						search        		= "text",
						filtermode    		= "3"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Type" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "Contact",																																								
						search              = "text",	
						width               = "8",						
						filtermode          = "3"}>												
						
	<cfset itm = itm+1>	
	<cf_tl id="Action" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "WorkOrderService",																																								
						search              = "text",						
						filtermode          = "3"}>		
						
				
	<cfset itm = itm+1>
	<cf_tl id="Unit" var = "1">				
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "OrgUnitName",					
						alias               = "",	
						display             = "0",
						displayfilter       = "Yes",						
						filtermode          = "2",																						
						search              = "text"}>			
				
	
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "Description",																	
						alias               = "",																							
						search              = "text",
						filtermode          = "2"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Plan" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "PlanOrder",																	
						alias               = "",		
						width               = "8",																					
						search              = "text",
						filtermode          = "2"}>						
																										
<cfset menu=ArrayNew(1)>	

<!--- <cfset filters=ArrayNew(1)>		
<cfset filters[1] = {field = "ActionStatus", value= "1"}>	 --->	


<cf_listing
	    header              = "billing"
	    box                 = "listing"
		link                = "#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&personno=#url.personno#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsWorkOrder"
		listquery           = "#myquery#"		
		listorderfield      = "DateTimePlanning"
		listorder           = "DateTimePlanning"	
		listgroupdir        = "DESC"	
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "#filter#"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "workflow" 
		drillargument       = "#client.height-90#;#client.widthfull-90#;false;false"	
		drilltemplate       = "workflow"
		drillkey            = "WorkActionId"
		drillbox            = "addaddress">
		
		<!---
			listgroupfield      = "DateTimePlanning"
		listgroup           = "DateTimePlanning"
		listgroupdir        = "DESC"
		--->