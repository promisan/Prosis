
<cfparam name="Object.ObjectKeyValue4"    default="">
<cfparam name="url.ObservationId"    default="#Object.ObjectKeyValue4#">

<cfquery name="System" 
	  datasource="AppsInit">
		SELECT  *
		FROM    Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'
</cfquery>	

<cfquery name="CM" 
	  datasource="AppsControl">
		SELECT  *
		FROM    Observation
		WHERE ObservationId = '#url.ObservationId#'
</cfquery>	

<cfquery name="AppServer" 
	  datasource="AppsControl">
		SELECT  DISTINCT SourcePath
		FROM    ParameterSite
		WHERE   ServerLocation = 'Local'
		AND     ServerRole     = 'Production'	
		AND     Operational    = 1
		AND     Sourcepath > ''		
</cfquery>	

<cfquery name="templates" 
	  datasource="AppsControl">
SELECT     *
FROM         ObservationTemplate
WHERE ObservationId = '#url.ObservationId#'
</cfquery>

<cfloop query="AppServer">

	<!--- 1. remove directory on destination 
    	  2. copy directory from source
    --->	
	
	<cfset destpath = sourcePath>	
	
	<!---
	<cfset cos = "<!---">
	<cfset coe = "--->">
	
	<cfoutput>
	
	<cfsavecontent variable="info">
	
	#cos#
	
	---------------------------------------------------------------
	This template was deployed by the #SESSION.welcome# CM tool
	---------------------------------------------------------------
	Owner : #CM.Owner#
	ObservationNo : #CM.Reference#
	Date : #dateformat(now(),CLIENT.DateFormatShow)# #timeformat(now(),"HH:MM")#
	Officer : #SESSION.first# #SESSION.last# 
	---------------------------------------------------------------
	
	#coe#
				
	</cfsavecontent>
	
	</cfoutput>
	--->
	
	<cfloop query="templates">
		
	<cfif PathName neq "[root]">
	
		<cffile action="READ" 
		     file="#SESSION.RootPath#/#PathName#/#FileName#" 
			 variable="myfile">
		
		<!---
		<cffile action="WRITE" 
		file       = "#SESSION.RootPath#/#PathName#/#FileName#" 
		output     = "#info#<br>#myfile#" 
		addnewline = "Yes" 
		fixnewline = "No">
		--->
		
		<cfif not directoryExists("#destPath#/#PathName#")>
			<cfdirectory action="CREATE" directory="#destPath#/#PathName#">
		</cfif>
			
		<cffile action="COPY"
	    source="#SESSION.RootPath#/#PathName#/#FileName#"
	    destination="#destPath#/#PathName#">
		
		<!---
		
		<cfset ax = '"'>
		
		<cfexecute name="#system.cfrootpath#\bin\cfencode.exe" 
		arguments="#destPath#/#PathName#/#FileName# /h #ax#ObservationNo : #CM.Reference##ax#  /v #ax#2#ax#">
		</cfexecute>
		
		--->
			
		
	<cfelse>
	
		<cffile action="READ" file="#RootPath#/#FileName#" variable="myfile">
		
		<!---
		<cffile action="WRITE" 
		file="#SESSION.RootPath#/#FileName#" 
		output="#info# #myfile#" 
		addnewline="Yes" 
		fixnewline="No">
		--->
		
		<cffile action="COPY"
	    source="#SESSION.RootPath#/#FileName#"
	    destination="#destPath#">
		
		<!---
		
		<cfset ax = '"'>
		
		<cfexecute name="#system.cfrootpath#\bin\cfencode.exe" 
		arguments="#destPath#/#FileName# /h #ax#ObservationNo : #CM.Reference##ax#  /v #ax#2#ax#">
		</cfexecute>
		
		--->
					
	</cfif>	
		
	</cfloop>

</cfloop>



