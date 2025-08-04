<!--
    Copyright Â© 2025 Promisan

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

<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>CM sniffer</proDes>
 <!--- specific comments for the current change, may be overwritten --->
 <proCom></proCom>
 <proCM>[ObservationNo]</proCM>
</cfsilent>

<!--- End Prosis template framework --->

<!--- check all observations that have development wf step OPEN (0) and have associated templates --->

<cfquery name="Site" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM ParameterSite
	  WHERE ServerRole = 'QA'	
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Retrieving Pending Actions">

<cfquery name="Master" 
	  datasource="AppsOrganization">
SELECT     Topic.ObservationId, 
           Topic.Owner, 
		   Topic.ObservationNo, 
		   Topic.Reference, OA.ActionCode, 
		   C.PathName, 
           C.FileName,
		   C.OfficerUserId,
		   C.OfficerLastName,
		   C.OfficerFirstName
FROM       OrganizationObject O INNER JOIN
           OrganizationObjectAction OA ON O.ObjectId = OA.ObjectId INNER JOIN
           Ref_EntityActionPublishDocument R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode INNER JOIN
           Ref_EntityDocument RD ON R.DocumentId = RD.DocumentId INNER JOIN
           Control.dbo.Observation Topic ON O.ObjectKeyValue4 = Topic.ObservationId INNER JOIN
           Control.dbo.ObservationTemplate C ON Topic.ObservationId = C.ObservationId AND 
           OA.ActionCode = C.ActionCode
WHERE     (O.EntityCode = 'SysChange') AND (RD.DocumentTemplate = 'template') AND (OA.ActionStatus = '0')
ORDER BY O.Created DESC
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "#Master.recordcount# development actions pending">
	
	<cfset fnd = 0>

<cfloop query="Site">

	<cfif PathName eq "[root]">
											
		<cffile action = "read" 
		  file = "#SESSION.rootpath#\#filename#"
		  variable = "content">
			  
	<cfelse>
			
		<cffile action = "read" 
		  file = "#SESSION.rootpath#\#PathName#\#FileName#"
		  variable = "content">
			  
	</cfif>
	
	<cfset grp = "[root]">
	<cfloop index="itm" list="#pathname#" delimiters="\">
	   <cfif grp eq "[root]">
	     <cfset grp = "#itm#">
	   </cfif>
	</cfloop>
		
	<cfif pathName eq "[root]">
		
			<cfdirectory action="LIST" 
		 directory="#SESSION.rootpath#\" 
		 name="myfile" 
		 filter="#filename#">	
		
	<cfelse>
				
			<cfdirectory action="LIST" 
		 directory="#SESSION.rootpath#\#pathname#" 
		 name="myfile" 
		 filter="#filename#">	
		 
	 </cfif>
	 
	<cfset usr = "#officerUserid#">		
	<cfset nme = "#OfficerFirstName# #OfficerLastName#">
	<cfset com = "">
	<cfset des = "Changed content"> 
	 	 
	<cfset posUS = Find("<proUsr>",  content)>
	<cfset posUE = Find("</proUsr>", content)>					
	<cfset posNS = Find("<proOwn>",  content)>
	<cfset posNE = Find("</proOwn>", content)>
	<cfset posCS = Find("<proCom>",  content)>
	<cfset posCE = Find("</proCom>", content)>
	<cftry>
	     <cfset usr = Mid(content, posUS+8, posUE-PosUS-8)>
		 <cfset nme = Mid(content, posNS+8, posNE-PosNS-8)>
		 <cfset com = Mid(content, posCS+8, PosCE-PosCS-8)>
	 <cfcatch></cfcatch>
	</cftry>								
	
					 
	 <cfoutput query="myfile">
												
			<cfif Server.Coldfusion.ProductVersion gt "8,0,1">
			     <cfset fdate = "'#DateLastModified#'">
				 <cfset fdate = Mid(fdate, 2, len(fdate)-2)>					
			<cfelse>
			     <cfset fdate = "'#DateLastModified#'">
			</cfif>		
			
			<cfquery name="Check" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT * FROM Ref_TemplateContent
			  WHERE ObservationId  =  '#master.observationid#'
			  AND   ActionCode  = '#master.actionCode#'
			  AND   PathName = '#master.PathName#' 
			  AND   FileName = '#master.FileName#' 
			  AND   TemplateModified =  #preservesingleQuotes(fdate)#  
			</cfquery>							
			
			<cfif check.recordcount eq "0">
			
				<cfset fnd=fnd+1>
			
				<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Recording #master.Reference# - #master.PathName#/#master.FileName#">
									
				<cfquery name="Log" 
					datasource="AppsControl">
				   		INSERT INTO Ref_TemplateContent
							(ApplicationServer,
							ObservationId, 
						    ActionCode, 
							PathName, 
							FileName, 
							TemplateModified, 
							TemplateOfficer, 
							TemplateGroup, 
							TemplateModifiedBy, 
							TemplateComments, 
				            TemplateSize, 
							TemplateContent)
						VALUES	('#Site.ApplicationServer#',
								 '#master.observationid#',
							     '#master.actionCode#',
								 '#master.PathName#',
								 '#master.FileName#',
								 #preservesingleQuotes(fdate)#,
								 '#usr#',
								 '#grp#',
								 '#nme#',
								 '#des#',
								 '#size#',
								 '#content#') 
				</cfquery>
			
			</cfif>
		
	</cfoutput>  
	
</cfloop>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "#fnd# updated templates have been scanned and logged">


<!--- check each file from the ObservationTemplate, by reading it and saving it if needed --->








