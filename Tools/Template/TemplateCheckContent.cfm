

<!--- Template scanner, 
this template needs to be registered, like the report batch in CFAdmin to be run daily at night --->

<cfinclude template="../../Tools/CFReport/Anonymous/PublicInit.cfm">

<cfset Session.status  = 0> 

<cfquery name="Sys" 
	  datasource="AppsSystem">
      SELECT * 
	  FROM   Parameter	  
</cfquery>


<cfquery name="Master" 
	  datasource="AppsControl">
      SELECT * 
	  FROM   ParameterSite
	  WHERE  ServerRole = 'QA'
	  ORDER BY ServerRole
</cfquery>

<cfif Master.recordcount neq "1">
	No master defined
	<cfabort>
</cfif>

<!--- ------------ --->
<!--- clean master --->
<!--- ------------ --->

<cfquery name="CleanMaster" 
	  datasource="AppsControl">
		DELETE FROM Ref_TemplateContent
		WHERE   TemplateId IN (SELECT     MIN(TemplateId) AS TemplateId
								FROM      Ref_TemplateContent
								WHERE     ApplicationServer = '#Master.ApplicationServer#'
								GROUP BY  ApplicationServer, PathName, FileName, VersionDate
								HAVING    COUNT(*) > 1
							 )
</cfquery>

<cfparam name="SESSION.acc"   default="Batch">
<cfparam name="CLIENT.style" default="/Portal/Logon/Bluegreen/pkdb.css">
<cfparam name="URL.ID"       default="0">
<cfparam name="URL.Site"     default="">

<cfset filetype     = "*.cfm|*.cfc|*.css|*.cfr|*.js|*.ico|*.swf|*.rpt|*.bmp|*.png|*.gif|*.jpg">

<cffunction name="excluded" returntype="string">

	<cfargument name="dir" type="string">
	
	<!--- or
	  FindNoCase("Custom", dir) --->

	<cfif left(dir,1) is "_" or 
	  FindNoCase("\_", dir) or
	  FindNoCase("Manual", dir) or 
	  FindNoCase("CFRStage", dir) or 
	  FindNoCase("CFReport", dir) or 
	  FindNoCase("Cache", dir) or
	  FindNoCase("Deluxe", dir) or
	  FindNoCase("Setup", dir) or
	  FindNoCase("dccom", dir)>
	  <cfreturn "yes"> 
	<cfelse>
	  <cfreturn "no">  
    </cfif>
	
</cffunction>

<cffunction name="binary" returntype="string">

	<cfargument name="name" type="string">

	<cfif FindNoCase(".cfr", name) or 
	  FindNoCase(".rpt", name) or 
	  FindNoCase(".swf", name) or 
	  FindNoCase(".ico", name) or 
	  FindNoCase(".png", name) or 
	  FindNoCase(".gif", name) or 
	  FindNoCase(".jpg", name) or 
	  FindNoCase(".bmp", name)>
	  <cfreturn "yes"> 
	<cfelse>
	  <cfreturn "no">  
    </cfif>
	
</cffunction>

<cfif URL.Site eq "">

	<cfquery name="SiteName" 
	  datasource="AppsControl">
	      SELECT * 
		  FROM   ParameterSite
		  WHERE  ServerRole IN ('QA','Design')
		  ORDER BY ServerRole DESC
	</cfquery>

	<cfif SiteName.recordcount gte "1">
		
		<cfquery name="Init" 
		datasource="AppsControl">
		    UPDATE Ref_Template
			SET Operational = 0  
		</cfquery>
		
	<cfelse>
	
	   <cfabort>	
	   
	</cfif>
	
<cfelse>

	<cfquery name="SiteName" 
	  datasource="AppsControl">
	      SELECT * 
		  FROM   ParameterSite
		  WHERE  ApplicationServer = '#URL.Site#'
		  ORDER BY ServerRole
	</cfquery>
		
</cfif>

<cfoutput query="siteName">

	<cftransaction>

	<cfif ServerRole eq "QA">
	
		<cfset sourceroot = ReplicaPath>
		<cfset role = serverrole>

		
	<cfelse>
	
	    <cfset sourceroot = ReplicaPath>
		<cfset role = serverrole>
		
		<cfquery name="clear" 
		datasource="AppsControl">
   			DELETE FROM Ref_TemplateContent
			WHERE  ApplicationServer = '#ApplicationServer#' 
		</cfquery>
		
	</cfif>	
	
	<cfset site = ApplicationServer>
	
	<cfif ServerRole eq "QA" or ServerRole eq "Design">

			<cfset version = '#dateformat(now(),client.DateSQL)#'>
		
			<cfquery name="SiteName" 
			  datasource="AppsControl">
		      UPDATE ParameterSite
			  SET VersionDate = '#version#'
			  WHERE  ApplicationServer = '#ApplicationServer#' 
		    </cfquery>
								
			<cftry>
		
				<cfquery name="Insert" 
				datasource="AppsControl">
				    INSERT INTO Ref_TemplateVersion	(VersionDate)
					VALUES ('#version#')
				</cfquery>
				
				<cfcatch></cfcatch>		
				
			</cftry>
		
	<cfelse>
	
	    <cfif VersionDate gte "01/01/2000">
		
			<cfset version = dateformat(VersionDate,client.DateSQL)>
		
		<cfelse>
			
			<cfquery name="Version" 
			  datasource="AppsControl">
			      SELECT TOP 1 *
				  FROM Ref_TemplateVersion
				  ORDER BY Created DESC
		    </cfquery>
			
			<cfset version = '#dateformat(Version.VersionDate,client.DateSQL)#'>
			
			<cfquery name="Site" 
			  datasource="AppsControl">
			      UPDATE ParameterSite
				  SET VersionDate = '#dateformat(version,client.dateSQL)#'
				  WHERE ApplicationServer = '#site#'	
		    </cfquery>
					
		</cfif>
		
		<cfquery name="SiteName" 
		  datasource="AppsControl">
		      DELETE FROM Ref_Template
			  WHERE  Source = '#URL.Site#'
			  AND    Operational = '0'
	    </cfquery>
	
	</cfif>	
	
	<cfset Session.status = 0.1>
	
	<cfif ServerRole eq "QA" or ServerRole eq "Design">
		<cfset Session.message = "Retrieving template list from #site# [#ReplicaPath#]">
	<cfelse>
		<cfset Session.message = "Retrieving template list from #site# REPLICA on #ReplicaPath#">
	</cfif>
	
	<cfset list = "root">
	 <cfset cnt = 0>
	 
    <cfdirectory action="LIST"
            directory="#sourceroot#"
            name="Directories"
            type="dir"
            listinfo="all"
            recurse="No"/>
		 
     <cfloop query="Directories">
		 <cfif left(name,1) is "_" or name eq "Manual">
			  
		 <cfelse>
		 
		 	   <cfif Role eq "QA">
			   
			   		<!--- 29/7/2009 also for QA we take the list as defined in the table 
					so we can exclude reporting directories which are managed
					differently --->
					
			   		<cfquery name="Check" 
			  		datasource="AppsControl">
					   SELECT * 
					   FROM   ParameterSiteGroup
					   WHERE  ApplicationServer = '#Site#'
					   AND   TemplateGroup = '#name#'						 
				   </cfquery>		
				  					
				   <cfif check.recordcount eq "1" or name eq "">		
						   	
					       <cfset list="#list#,#name#">		
						   <cfset cnt = cnt+1>
					
				   </cfif>
			   
			        <!---
			   		<cfset cnt = cnt+1>
					<cfset list="#list#,#name#">		
					--->
			   
			   <cfelse>
			   
			   	  <cfquery name="Check" 
			  		datasource="AppsControl">
					   SELECT * 
					   FROM   ParameterSiteGroup
					   WHERE  ApplicationServer = '#Site#'
					   AND   TemplateGroup = '#name#'						 
				   </cfquery>		
				  					
				   <cfif check.recordcount eq "1" or name eq "">		
						   	
					       <cfset list="#list#,#name#">		
						   <cfset cnt = cnt+1>
					
				   </cfif>
					
				</cfif>	
					
		 </cfif>
	 </cfloop>
	 
	<cfset Session.status  = 0.2> 
	<cfset Session.message = "#Site# (/root/ and #cnt# directories)">
	
	<cfset step = 0.7 / cnt>
	 
	 <cfset cnt = 0>
						 
	<cfloop index="dirc" list="#list#">
					
			<cfset Session.status  = Session.status + step > 
			<cfset Session.message = "Scanning folder: #dirc#">
					
			<cfset cnt = cnt+1>		
			
			<cfif dirc eq "root">
			
					<!--- root files --->
									
					<cfdirectory action="LIST"
			             directory = "#sourceroot#"
			             name      = "Templates"
			             filter    = "#filetype#"
			             type      = "file"
			             listinfo  = "all"
			             recurse   = "No">		 
					 
			<cfelse>
			
					<!--- directory --->					
									
					<cfdirectory action="LIST"
			             directory = "#sourceroot#\#dirc#"
			             name      = "Templates"
			             filter    = "#filetype#"
			             type      = "file"
			             listinfo  = "all"
			             recurse   = "Yes">		 	
			
			</cfif>	 
			   
			<cfset Session.message = "#cnt#. #dirc#: 0 of #templates.recordcount# files.">		 
			   	   
			<cfset oVersion = "8,0,1">
			<cfset cVersion = Server.Coldfusion.ProductVersion>
			
			<cfset newerVersion = 0>
			
			<cfif ListGetAt(cVersion,1) gt ListGetAt(oVersion,1)>
				<cfset newerVersion = 1>
			<cfelseif ListGetAt(cVersion,1) eq ListGetAt(oVersion,1)>
				
				<cfif ListGetAt(cVersion,2) gt ListGetAt(oVersion,2)>
						<cfset newerVersion = 1>
				<cfelseif ListGetAt(cVersion,2) eq ListGetAt(oVersion,2)>
						
						<cfif ListGetAt(cVersion,3) gt ListGetAt(oVersion,3)>
							<cfset newerVersion = 1>
						</cfif>
						
				</cfif>
				
			</cfif>
			
			   
			 <cfloop query="Templates">
					 
					   <cfif newerVersion eq 1>
					   
					     <cfset fdate = "'#DateLastModified#'">
						 <cfset fdate = Mid(fdate, 2, len(fdate)-2)>					
						 
					   <cfelse>
					   
					     <cfset fdate = "'#DateLastModified#'">
						 
					   </cfif>
				 			 	  			 
				      <!--- <cfif CurrentRow Mod 25 eq 0> --->
				 
				 		<cfset Session.message = "#cnt#.  #dirc#: #currentRow# of #templates.recordcount# files.">					
				   
				   	  <!--- </cfif> --->
					   						 
				  
					 <cfset dir=replace("#Directory#","#sourceroot#","")>
					
					 <cfif dir eq "">
						 <cfset dir = "[root]">
					 </cfif>
					 				 				 														 
					 <cfif excluded(dir) eq "yes">	
					 
					 	<!--- skip completely --->
							 
					 <cfelse>
					 	 							
						<cfquery name="Check" 
						datasource="AppsControl">
						    SELECT *
						    FROM   Ref_Template
							WHERE  PathName = '#dir#'
							AND    FileName = '#Name#' 
						</cfquery>					
						
																
						<cfif Check.recordcount eq "0">
						
						<!--- create record if it does not exist --->
						
								<cfif binary(name) eq "yes">	
										<cfset content = "binary">
								<cfelse>	
										<cfif dir eq "[root]">
										
											<cffile action = "read" 
											  file = "#sourceroot#\#name#"
											  variable = "content">
											  
										<cfelse>
											
											<cffile action = "read" 
											  file = "#sourceroot#\#dir#\#name#"
											  variable = "content">
											  
										</cfif>  
										
								</cfif>
						
								<cfif role eq 'Design' or role eq 'QA'>
								
									<cfquery name="Insert" 
									datasource="AppsControl">
							    		INSERT INTO Ref_Template
										(PathName,FileName,LastUpdated,FileSize,Source)
										VALUES
										('#dir#','#name#',#preservesingleQuotes(fdate)#,'#Size#','#site#') 
									</cfquery>
									
									<!--- make an additional entry if needed for master as well --->
																																
									<cfinclude template="TemplateContentInsert.cfm">
									
								<cfelse>
								
									<cfquery name="Insert" 
									datasource="AppsControl">
							    		INSERT INTO Ref_Template
										(PathName,FileName,LastUpdated,FileSize,Source,Operational)
										VALUES 
										('#dir#','#name#',#preservesingleQuotes(fdate)#,'#Size#','#site#','0')
									</cfquery>
									
									<cftry>
									<cfquery name="Log" 
									datasource="AppsControl">
								   		INSERT INTO Ref_TemplateContent
										(PathName,
										 FileName,
										 ApplicationServer,
										 VersionDate,
										 TemplateOfficer,
										 TemplateGroup,
										 TemplateModified,
										 TemplateModifiedBy,
										 TemplateComments,
										 TemplateSize,
										 TemplateContent)
										VALUES
										('#dir#',
										 '#name#',
										 '#master.ApplicationServer#', 
										 '#version#',
										 '#usr#',
										 '#grp#',
										 #preservesingleQuotes(fdate)#,
										 '#nme#',
										 '#com#',
										 '#size#',
										 '#content#')
									</cfquery>
									
									<cfcatch></cfcatch>
									</cftry>
															    
									<cfinclude template="TemplateContentInsert.cfm">
																								
								</cfif>	
													
						<cfelse>
										
							<cfif Role eq 'QA'>
							
								<!--- file exists set status = 1 --->
								<!--- JM due to Linux migration PathName and FileName will be updated as well --->

								<cfset cPathName = Compare(dir,Check.PathName)>
								<cfset cFileName = Compare(Name,Check.FileName)>
								
					
								<cfquery name="Update" 
								datasource="AppsControl">
								    UPDATE Ref_Template
									SET    LastUpdated  = #preservesingleQuotes(fdate)#, 
									       FileSize     = '#Size#', 
										   VersionDateRemoved = NULL,
										   <cfif cPathName neq "0">
											   PathName='#dir#',
										   </cfif>
										   <cfif cFileName neq "0">
											   FileName='#Name#',
										   </cfif>
										   Operational  = 1
									WHERE  PathName     = '#dir#'
									AND    FileName     = '#Name#'
								</cfquery>
														
								<!--- Master compare check in content --->
								
								<cfquery name="Last" 
								datasource="AppsControl">
								    SELECT Max(Created) as LastRecord
									FROM   Ref_TemplateContent
									WHERE  PathName          = '#dir#'
									AND    FileName          = '#Name#'
									AND    ApplicationServer = '#site#' 
								</cfquery>
								
								<cfquery name="FileContent" 
								datasource="AppsControl">
								    SELECT TOP 1 *
									FROM   Ref_TemplateContent
									WHERE  PathName = '#dir#'
									AND    FileName = '#Name#'
									AND    ApplicationServer = '#site#'
									AND    Created IN (SELECT Max(Created) as LastRecord
													   FROM   Ref_TemplateContent
													   WHERE  PathName = '#dir#'
													   AND    FileName = '#Name#'
													   AND    ApplicationServer = '#site#') 
								</cfquery>
																							
								<cfset st = "0">
								
								<cfif FileContent.TemplateSize neq size>
								
									<!--- compare content last record SIZE with currently scanned content --->
																
									<cfset st = "1">									
																	
								<cfelseif DateDiff("n", FileContent.TemplateModified, fdate) neq "0">
																
									<!--- compare timestamp last record with currently scanned file --->								
								
									<cfif binary(name) neq "No">
									
										<cfset st = "1">	
									
									<cfelse>
								
										<cfif dir eq "[root]">
										
											<cffile action = "read" 
											  file = "#sourceroot#\#name#"
											  variable = "content">
											  
										<cfelse>
											
											<cffile action = "read" 
											  file = "#sourceroot#\#dir#\#name#"
											  variable = "content">
											  
										</cfif>
										
										<!---	below does not work realiably --->
										
										<cfif CompareNoCase(content, FileContent.TemplateContent) neq "0">
											<cfset st = "1">
										</cfif>
										
									</cfif>										
																				
								</cfif>		
								
								<!--- if a differences has been traced --->
																								
								<cfif st eq "1">
																	
									<cfif binary(name) eq "yes">	
										
										<cfset content = "binary">
											
									<cfelse>	
										
										<cfif dir eq "[root]">
										
											<cffile action = "read" 
											  file = "#sourceroot#\#name#"
											  variable = "content">
											  
										<cfelse>
											
											<cffile action = "read" 
											  file = "#sourceroot#\#dir#\#name#"
											  variable = "content">
											  
										</cfif>  
										
									</cfif>
																																									
									<!--- remove entry for the same date here --->
									
									<cfquery name="clear" 
									datasource="AppsControl">
							    		DELETE FROM Ref_TemplateContent
										WHERE  PathName          = '#dir#'
										AND    FileName          = '#Name#'
										AND    ApplicationServer = '#site#'
										AND    VersionDate       = '#dateformat(now(),client.DateSQL)#'
									</cfquery>
									
									<cfinclude template="TemplateContentInsert.cfm">
																	
								</cfif>
								
							<cfelse>
							
								<!--- dependent or design server, prior entries were removed and make an entry always--->
																
									<cfif binary(name) eq "yes">		
										
										<cfset content = "binary">
											
									<cfelse>	
										
										<cfif dir eq "[root]">
										
											<cffile action = "read" 
											  file = "#sourceroot#\#name#"
											  variable = "content">
											  
										<cfelse>
											
											<cffile action = "read" 
											  file = "#sourceroot#\#dir#\#name#"
											  variable = "content">
											  
										</cfif>  
										
									</cfif>
									
									<cfinclude template="TemplateContentInsert.cfm">
																	
							</cfif>	
							
						</cfif>	
							
					</cfif>
														 
			 </cfloop>  
		   
	</cfloop>	 
				
	<cfif URL.site eq ""> 
	
		<!---
		<script>
			    window.location = "#SESSION.root#/System/Template/TemplateLog.cfm?site=#URL.site#"
    	</script>
		--->
	
		<cfquery name="Update" 
			datasource="AppsControl">
			    UPDATE Ref_Template
				SET    VersionDateRemoved = '#version#'
				WHERE  Operational = 0  
				AND    VersionDateRemoved is NULL
		</cfquery>
		
	</cfif>	
	
	<cfquery name="Update" 
			datasource="AppsControl">
			UPDATE ParameterSite
			SET    ScanDate = #now()#
			WHERE ApplicationServer = '#ApplicationServer#'
		</cfquery>
	
	</cftransaction>
	
	<cfset Session.status = 1>
	
	<script>
		ColdFusion.ProgressBar.stop('pBar') ;
		ColdFusion.ProgressBar.hide('pBar') ;
	</script>
	
	Finished!
	   
</cfoutput>		   

