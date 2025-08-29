<!--
    Copyright © 2025 Promisan B.V.

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
<cfsilent>
 <proUsr>administrator</proUsr>
�<proOwn>Dev van Pelt</proOwn>
 <proDes>Version Distribution Batch</proDes>
 <proCom>Made a provision for busy signal</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Template Distribution Batch</title>
</head>



<cfset session.status  = 0.1>
<cfset session.message = "Preparing">

<cffunction name="binary" returntype="string">

	<cfargument name="name" type="string">
	
	<cfif  FindNoCase(".ico", name) or 
	  FindNoCase(".png", name) or 
	  FindNoCase(".gif", name) or 
	  FindNoCase(".jpg", name) or 
	  FindNoCase(".bmp", name) or
	  FindNoCase(".cfr", name) or 
	  FindNoCase(".rpt", name) or 
	  FindNoCase(".swf", name)>
	  <cfreturn "yes">
	<cfelse>
	  <cfreturn "no">  
    </cfif>
	
</cffunction>

<cfparam name="URL.Site" default="GRIMS">
<cfparam name="URL.Group" default="">
<!--- prepare distribution package step 1

1.	Verify if there is an open entry (status=0) in ParameterSiteRelease
2.  Remove the associated directory / site / vyyyymmdd i.e v20070203
3.  Delete the entry
4.  Add a record
5.	Create a new associated directory
6.  Scan changed files 
		- add to zip list
		- make a comparison report to be saved in the associated dir and add to a zip list
7.	Generate a Database change log and save as a PDF
8.	Attach relevant SQL change files

--->

<!--- step 1 --->

<cfquery name="Master" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  TOP 1 *
  FROM    ParameterSite
  WHERE   ServerRole = 'QA' 
</cfquery>  

<cfif Master.recordcount eq "0">
   Master not found
   <cfabort>
</cfif>
		
<cfquery name="Site" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  *
  FROM    ParameterSite
  WHERE   ApplicationServer = '#URL.Site#' 
</cfquery>  

<cfif Site.recordcount eq "0">
   Site not found
   <cfabort>
</cfif>

<cfquery name="Open" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  *
  FROM    ParameterSiteVersion
  WHERE   ApplicationServer = '#URL.Site#' 
  AND     ActionStatus = 0
</cfquery>  

<cfloop query="Open">

	<!--- step 2 --->

	<cfif DirectoryExists("#Master.ReplicaPath#\_distribution\#URL.Site#\v#DateFormat(VersionDate,'YYYYMMDD')#")>

	    <cftry>
		<cfdirectory action="DELETE"
             directory="#Master.ReplicaPath#\_distribution\#URL.Site#\v#DateFormat(VersionDate,'YYYYMMDD')#"
             recurse="Yes">
		<cfcatch></cfcatch>	 
		</cftry>
				 
	</cfif>			 
				 
	<!--- step 3 --->			 

	<cfquery name="DeleteMe" 
	  datasource="AppsControl" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE  ParameterSiteVersion
	  WHERE   ApplicationServer = '#URL.Site#' 
	  AND     VersionDate = '#dateformat(VersionDate,Client.DateSQL)#'
	</cfquery>  

</cfloop>

<cfset session.status  = 0.1>
<cfset session.message = "Preparing">

<cfset output = "#master.replicaPath#\_distribution\#URL.site#\v#DateFormat(Master.VersionDate,'YYYYMMDD')#">

<!--- step 4 --->

<cfif not DirectoryExists("#output#")>
  <cfdirectory action="CREATE" directory="#output#">
</cfif>		

<cfif not DirectoryExists("#output#\Compare")>
  <cfdirectory action="CREATE" directory="#output#\Compare\">
</cfif>					 

<!--- prepare list of templates called : listing --->

<!--- step 5 --->

<cfset url.distribution = "1">

<cfinclude template="TemplateLogPrepare.cfm">

<!--- step 6a create ZIP --->

	<!--- create file list --->
	
	<cfset strFileToZip="">
	<cfset strCompareToZip="">
	
	<cfloop query="Listing">
	
	    <cfset session.status = 0.1 + (currentrow/recordcount*0.8)>
		<cfset session.message = "Processing template #currentrow# of #recordcount#">
			
	    <cfif pathname eq "[root]">
		  <cfset path = "">
		<cfelse>
		  <cfset path = pathname>
		</cfif>
		
		<cfif FileExists("#master.replicaPath#\#path#\#filename#") and operational eq "1">
			
		    <!--- copy file to temp location --->
			
			<cftry>
				<cfif not DirectoryExists("#output#\#URL.Site#\#path#")>
				  <cfdirectory action="CREATE" directory="#output#\sourceCode\#path#\">
				</cfif>	
				<cfcatch></cfcatch>
			</cftry>	
						
			<cffile action="COPY" 
			source="#master.replicaPath#\#path#\#filename#" 
			destination="#output#\sourceCode\#path#\#filename#">
			
			<!--- prepare zip file string --->
		
			<cfset strFileToZip=listappend(strFileToZip,SESSION.rootPath & path & "\" & filename)>
							 		
			<!--- make comparison if the file exists --->
			
			<cfif len(currentrow) eq "1">
			  <cfset row = "00#currentrow#">
			<cfelseif len(currentrow) eq "2">
			  <cfset row = "0#currentrow#">
			<cfelse>
			  <cfset row = "#currentrow#">  
			</cfif>
			
			<cfset compname = "#row#_#filename#">
			<!--- set output as HTML file --->
			<cfset compname = "#replace(compname,".","_",'ALL')#.html">						
			<!--- GENERATE comparison --->
			
			<cfif FileExists("#site.replicaPath#\#path#\#filename#")>
			
			    <cfif binary(filename) eq "yes">
				
				    <cffile action="WRITE" 
					      file="#output#\Compare\#compname#" 
						  output="Binary File" 
						  addnewline="Yes" 
						  fixnewline="No">
					 
					<cfset strCompareToZip=listappend(strCompareToZip,"#output#\Compare\#compname#")>
				
				<cfelse>									
													
					<cf_TemplateCompare 
					 left    = "#site.replicaPath#\#path#\#filename#"
					 right   = "#master.replicaPath#\#path#\#filename#"
					 output  = "#output#\compare\#compname#"
					 script  = "#output#\compare\#currentrow#.txt"
					 bat     = "#output#\compare\#currentrow#.bat"
					 delete = "no">
					
					<cfset strCompareToZip=listappend(strCompareToZip,"#output#\Compare\#compname#")> 
					
				</cfif>	
				
		    <cfelse>
			
				   <cffile action="WRITE" 
					      file="#output#\Compare\#compname#" 
						  output="New Template/File" 
						  addnewline="Yes" 
						  fixnewline="No">
			
				   <cfset strCompareToZip=listappend(strCompareToZip,"#output#\Compare\#compname#")>		
				
			</cfif>	
						
		</cfif>
	
	</cfloop>
	
	<cfset session.status  = 0.80>



	<cfif Site.EnableCodeEncryption  eq "No">
	
			<cf_Zip filelist            = "#strFileToZip#" 
				recursedirectory    = "No" 
				savepath            = "Yes"
				output              = "#output#\SourceCode.zip"
				encryption          = "Yes"
				encryptiondirectory = "#output#">				
				
	<cfelse>
			<cf_Zip filelist        = "#strFileToZip#" 
				recursedirectory    = "No" 
				savepath            = "Yes"
				output              = "#output#\SourceCode.zip"
				encryption          = "Yes"
				encryptiondirectory = "#output#">				
	
			<cf_DirEncrypt 
				Directory   = "#output#"
				Origin      = "SourceCode"
				Destination = "SourceCodeEncrypted"
				Zip         = "Yes">
	</cfif>					
	
	
	<cfset session.status  = 0.95>
	<cfset session.message = "Finishing">
		
	<cfif strCompareToZip neq "">


	<cftry>

		<cf_zip filelist         = "#strCompareToZip#" 
				recursedirectory = "No" 
				savepath         = "No"
				output           = "#output#\CodeComparison.zip">
				
		<cfdirectory action="DELETE" directory="#output#\compare" recurse="Yes">		
		
	<cfcatch></cfcatch>			
	</cftry>
		
	</cfif>		
		
<!--- step 7.  Generate a Database change log and save as a PDF --->

<cfdocument 
         name="SQL"
         filename="#output#\readme.pdf"
         format="PDF"
         pagetype="letter"
         margintop="0.35"
         marginbottom="0.35"
         marginright="0.25"
         marginleft="0.25"
         orientation="portrait"
         unit="in"
         encryption="none"
         fontembed="Yes"
         scale="80"
         backgroundvisible="Yes"
         overwrite="Yes">
		 
		 <cfoutput>
		 <link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#">
		 </cfoutput>
			  
	<cfdocumentitem type="header">
	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td><font size="1">Release Documentation for #URL.Site#</td></tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</table>
	</cfoutput>
	</cfdocumentitem>		
	
	<cfdocumentitem type="footer">
	<cfoutput>
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
			<tr><td height="3"></td></tr>
			<tr><td><font size="1">#SESSION.welcome# release management tool (v2.0)</td></tr>
		</table>
	</cfoutput>
	
	</cfdocumentitem>	
	 
	
	<cfoutput>	
	<table width="100%">
	
	<tr>
		<td>Site</td>
		<td><b>#URL.Site#</b></td>
	</tr>
	<tr>
		<td>Release date</td>
		<td><b>v#DateFormat(Master.VersionDate,'YYYYMMDD')#</b></td>
	</tr>
	<tr>
		<td>Prepared by</td>
		<td><b>#SESSION.first# #SESSION.last#</b></td>
	</tr>
	<tr>
		<td>Prepared on</td>
		<td><b>#DateFormat(now(),'#CLIENT.DateFormatShow#')# #TimeFormat(now(),'HH:MM:SS')# </b></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	<tr bgcolor="f1f1f1">
		<td><b>Release files</td>
		<td><b>Instruction</td>
	</tr>
	
	<tr>
		<td>SourceCode.zip</td>
		<td>Add or replace the templates in this archive to your installation.</td>
	</tr>
	
	<tr>
		<td>CodeComparison.zip</td>
		<td>Detailed template comparison report for non-binary source files for your reference.</td>
	</tr>
	
	<tr>
		<td>SQLScript.zip</td>
		<td>SQL Scripts for action listed below that require adding new tables (optional).</td>
	</tr>
	
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	<tr><td height="3" colspan="2"></td></tr>
	
	<tr>
		<td colspan="2">The following templates must be removed from your installation:</td>
	</tr>
		
	<tr><td colspan="2">
		
			<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<cfset row = 0>
			<cfloop query="Listing">
			
			<cfif operational eq "0">
			
				<cfset row = row+1>
				<TR bgcolor="#IIf(row Mod 2, DE('FFFFFF'), DE('f2f2f2'))#">
				    <td>#PathName#</td>
				    <td>#FileName#</td>
					<td>#TemplateComments#</td>
					<td>#NumberFormat(TemplateSize/1024,"_._")#Kb</td>
				</tr>
				
			</cfif>
				
			</cfloop>
			
			</table>
		</td>
	</tr>
		
    </cfoutput>	
	
		<cfquery name="db" 
		  datasource="AppsControl" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT  *
		  FROM    stDBChange
		  WHERE   (Created >= '#dateformat(Site.VersionDate,client.dateSQL)#' 
		          OR VersionDate >= '#DateFormat(Site.VersionDate,Client.dateSQL)#')		 
		  ORDER BY DatabaseName, ApplyDirect,SerialNo
		</cfquery>  
		

		<cfoutput>
			<tr><td height="3"></td></tr>
			<tr><td colspan="2">The following changes will need to be performed MANUALLY onto the database server.</td></tr>
	
	
		<tr>
		<td colspan="2">
		
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			   
			    <tr>
				    <td width="2%">No.</td>
					<td>Apply</td>
					<td><!--- <b>Database</b> ---></td>
					<td>Table</td>
					<td>Action</td>
					<td>Position</td>
					<td>Field</td>
					<td>Type</td>
					<td>Allow&nbsp;NULL</td>
					<td>Default</td>
				</tr>
				
				<tr><td height="1" colspan="10" bgcolor="C0C0C0"></td></tr>
		</cfoutput>							
		
				<cfset strFileToZip="">
					
				<cfoutput query="db" group="DatabaseName">
				
				    <tr><td height="4" colspan="10"></td></tr>

					<tr>
					<td height="1" colspan="10" style="padding-left:4px"><font face="Verdana" size="3"><b>#DatabaseName#</td>
					</tr>					
					
					<tr><td height="1" colspan="10" class="line"></td></tr>
					
					<tr><td height="4" colspan="10"></td></tr>
							
					<cfoutput>
					
						<TR>
							<td width="40">#db.SerialNo#</td>
							<td width="60"><cfif ApplyDirect eq "0">Delay update<cfelse>Direct</cfif></td>
							<td><!--- #db.DatabaseName# ---></td>
							<td>#db.TableName# </td>
							<td width="80">#db.TableAction#</td>
							<cfif fieldname neq "">
								<td>#db.FieldPosition#</td>
								<td>#db.FieldName#</td>
								<td>#db.FieldType# <cfif db.FieldLength neq "">(#db.FieldLength#)</cfif></td>
								<td><cfif db.FieldNULLAllowed eq "1">YES</cfif></td>
								<td>#db.FieldDefault#</td>
							</cfif>
						</tr>	
						
						<cfif db.TableActionMemo neq "">
						
							<tr><td colspan="3"></td>
							    <td bgcolor="ffffdf" colspan="7" align="left">#db.TableActionMemo#</td></tr>
							
						</cfif>
						
						<cfif FileExists("#Master.ReplicaPath#\_distribution\SQLScript\change#db.SerialNo#.sql")>			
							<cfset strFileToZip=listappend(strFileToZip,"#Master.ReplicaPath#\_distribution\SQLScript\change#db.SerialNo#.sql")> 	
						</cfif>
								
					</cfoutput>
				
				</cfoutput>
				
				<cfif strFileToZip neq "">			
							
					<cf_zip filelist     = "#strFileToZip#" 
						recursedirectory = "No" 
						savepath         = "No"
						output           = "#output#\SQLScript.zip">
											
				</cfif>	
	<cfoutput>
				<tr><td height="1" colspan="10" bgcolor="C0C0C0"></td></tr>
				
			</table>
		
		</td></tr>
			
	</table>
	</cfoutput>							

</cfdocument>

<cfoutput>

<!--- now is the time to record the version --->				 

<cfquery name="Check" 
  datasource="AppsControl" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  *
  FROM    ParameterSiteVersion
  WHERE   ApplicationServer = '#URL.Site#' 
  AND     VersionDate = '#DateFormat(Master.VersionDate,Client.dateSQL)#'
</cfquery>  

<cfif check.recordcount eq "0">

	<cfquery name="Insert" 
	  datasource="AppsControl" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO ParameterSiteVersion
	  (ApplicationServer, 
	   VersionDate, 
	   <cfif url.group neq "">
	   TemplateGroup,
	   </cfif>
	   OfficerUserId, 
	   OfficerLastName, 
	   OfficerFirstName)
	  VALUES
	  ('#URL.Site#',
	   '#DateFormat(Master.VersionDate,Client.dateSQL)#',
	    <cfif url.group neq "">
	   '#url.group#',
	   </cfif>
	   '#SESSION.acc#',
	   '#SESSION.last#',
	   '#SESSION.first#') 
	</cfquery>  

</cfif>
	
<!--- create a bat file for later copy --->
	
<cfsavecontent variable="script">
xcopy #output#\sourceCode\*.* #Site.ReplicaPath# /s /e /y
</cfsavecontent>

<cfset session.status  =  1.0>
<cfset session.message = "Completed">

<cffile action="WRITE" file="#output#\SyncVersion.bat"
	       output="#script#"
	       addnewline="Yes" 
		   fixnewline="No">	

<script language="JavaScript">
  
   try {
    ColdFusion.ProgressBar.stop('pBar', true)	
	} catch(e){}	
   window.location = "TemplateLog.cfm?site=#URL.site#"
</script>

</cfoutput>


