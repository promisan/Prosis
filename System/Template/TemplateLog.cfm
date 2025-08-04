<!--
    Copyright © 2025 Promisan

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
 <proDes>Version Management</proDes>
 <!--- specific comments for the current change, may be overwritten --->
<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<cfparam name="URL.site" default="">
<cfparam name="URL.group" default="">
<cfparam name="URL.filter" default="0">
<cfparam name="URL.root" default="#SESSION.root#">
<cfparam name="URL.version" default="">

<cffunction name="binary" returntype="string">

	<cfargument name="name" type="string">
	
	<cfif  FindNoCase(".ico", name) or 
	  FindNoCase(".png", name) or 
	  FindNoCase(".gif", name) or 
	  FindNoCase(".jpg", name) or 
	  FindNoCase(".bmp", name)>
	  <cfreturn "Image"> 
	<cfelseif FindNoCase(".cfr", name) or 
	  FindNoCase(".rpt", name) or 
	  FindNoCase(".swf", name)>
	  <cfreturn "yes">
	<cfelse>
	  <cfreturn "no">  
    </cfif>
	
</cffunction>

<cfif url.filter eq "0">
	<div class="screen" style="overflow-x:hidden;">
</cfif>

<link rel="stylesheet" type="text/css" href="<cfoutput>#url.root#/#client.style#</cfoutput>">

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cfset version = "#dateFormat(URL.version,client.DateSQL)#">
<cfparam name="url.distribution" default="1">

<cfif url.filter eq "0">
	<cfinclude template="TemplateLogScript.cfm">
</cfif>

<cfoutput>
		
	<cfquery name="Master" 
	  datasource="AppsControl">
	      SELECT * 
		  FROM   ParameterSite
		  WHERE  ServerRole = 'QA'
		  ORDER BY ServerRole
	</cfquery>

	<cfif Master.recordcount neq "1">
		  <cfabort>	
	</cfif>
	
	<cfif URL.site eq "">
	
		<cfquery name="Site" 
		  datasource="AppsControl">
	      SELECT * 
		  FROM   ParameterSite
		  WHERE  ApplicationServer = '#Master.ApplicationServer#'
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Site" 
			datasource="AppsControl">
			    SELECT * 
				FROM ParameterSite R
				WHERE ApplicationServer = '#url.site#'
		</cfquery>
	
		<cfquery name="Current" 
			datasource="AppsControl">
			    SELECT TOP 1 * 
				FROM Ref_TemplateVersion
				ORDER BY VersionDate DESC
		</cfquery>		
	
		<table width="99%" 
			   align="center" 	   
			   border="0" 
			   cellspacing="0" 
			   cellpadding="0"
			   class="formpadding" >
		<tr>
		 <td class="labelit">Site</td>
		 <td><!--- <b>IP---></td>
		 <td class="labelit">Role</td>
		 <td class="labelit"><cfif site.serverlocation eq "Local">Location<cfelse>Version</cfif></td>
		 <td class="labelit"><cfif Site.ServerRole eq "Production">Replica Directory<cfelse>Path</cfif></td>
		 <td class="labelit">Last scan</td>
		 <td class="labelit">Email</td>		
		</tr>
		
		<tr><td colspan="7" class="line"></td></tr>
		
		<tr>
		 <td class="labelit">#Site.ApplicationServer#</td>
		 <td><!---#Site.NodeIP#---></td>
		 <td class="labelit">#Site.ServerRole#</td>
		 <td class="labelit"><cfif site.serverlocation eq "Local">Local<cfelse>#dateFormat(Site.VersionDate,CLIENT.DateFormatShow)#</cfif></td>
		 <td class="labelit">#Site.replicaPath#</td>
		 <td class="labelit" >#dateFormat(Site.ScanDate,CLIENT.DateFormatShow)# #timeFormat(Site.ScanDate,"HH:MM")#
		 &nbsp;
		 <a href="javascript:batch('#URL.site#')" title="Scan templates from path">
		 <font color="2894FF">[Scan now]</font></a>
		 </td>
		 <td class="labelit">#Site.DistributionEMail#</td>
	 </tr> 
	 
	 <tr>
	 	<td colspan="7">
		
			<div id="divCodeScannerWaitText" style="display:none; text-align:center; margin:20%; margin-top:5%; padding:5%; font-size:28px; color:FAFAFA; background-color:rgba(0,0,0,0.7); border-radius:8px;">
			<cf_tl id="Please wait, while the scan is in progress">
			<br><br>
			<cfprogressbar name="pBar" 
			    style="bgcolor:000000; progresscolor:DB996E; textcolor:FAFAFA;"
				height="20" 
				bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
				interval="1000" 
				autoDisplay="false" 
				width="700"/>
			</div>
	
		</td>
	 </tr>
	 
		<cfset col = 7>
				
		<cfquery name="Check" 
			datasource="AppsControl">
			    SELECT count(*) as total 
				FROM   Ref_TemplateContent
				WHERE  ApplicationServer = '#url.site#'
				AND    VersionDate = '#dateformat(Site.VersionDate,client.dateSQL)#'
		</cfquery>
		
		<cfset version = "#dateFormat(Site.versionDate,client.DateSQL)#">
		
		<cfif Check.total eq "0">
		
			<tr><td colspan="#col#">
				<b>Attention</b>
			</td></tr>
			
			<tr><td colspan="#col#" align="center">
				<font color="FF0000"><b>There is no up to date information available about the currently deployed source code for #Site.ApplicationServer#. 
				<p>You must scan the replica directory first</p></b>
				<p><input type="button"
		       name="scan replica"
			   id="scan replica"
		       value="Scan replica"
		       class="button10g"
		       onClick="javascript:batch('#URL.site#')">
			   </p>
			</td></tr>
			
			<cf_waitEnd>
			<cfabort>
			
		<cfelseif Site.ServerRole eq "Design">
		
			<tr id="list"><td colspan="#col#" align="center" bgcolor="ffffcf">
			<img src="#url.root#/Images/version.gif" alt="" border="0" align="absmiddle">
			The below listed templates were modified on EITHER the master or development server and would need to be synced. 
			<p></p>
			Click on a template to review the changed content
			</td></tr>
		
		<cfelse>
		
			<cfquery name="PendingRelease" 
				datasource="AppsControl">
			    SELECT * 
				FROM ParameterSiteVersion R
				WHERE ApplicationServer = '#url.site#'
				AND ActionStatus != '1'
				ORDER BY Created DESC
			</cfquery>
			
			<tr><td colspan="#col#" class="linedotted"></td></tr>
			<cfif PendingRelease.recordcount eq "0" and Site.ServerLocation neq "Local">
		
				<tr id="list"><td colspan="#col#" align="center" bgcolor="ffffdf">
				<img src="#url.root#/Images/version.gif" alt="" border="0" align="absmiddle">
				<i>The below listed templates were modified since the last deployment and would need to be distributed.</i>
				&nbsp;				
				<a href="#SESSION.root#/_distribution/#URL.site#_patch.zip"><font color="0080FF">Click here to open files (ZIP)</a>
				<img src="#url.root#/Images/zip.gif" alt="" border="0" align="absmiddle">
				</td></tr>
				
			<cfelse>
			
			 	<tr id="list"><td colspan="#col#" align="center" bgcolor="ffffdf">
				<i>The below listed templates were modified and would need to be deployed.</i>
				</td></tr>
			
			</cfif>
		
		</cfif>
	
	</cfif>
	
	</cfoutput>
							

	<tr>
		<td id="templatescan" colspan="7">
			<cfif site.serverrole neq "QA" and 
			      site.serverrole neq "Design" and
				  PendingRelease.recordcount gte "1">	
				  
				<!---- Here a workflow will be shown --->
				<cfinclude template="TemplateLogVersion.cfm">
						
			<cfelse>
				<!---- Here a workflow will be shown --->
				<cfquery name="Server" 
				  datasource="AppsControl">
				      SELECT * 
					  FROM   ParameterSite
					  WHERE  ServerRole = '#site.serverrole#'			  
				</cfquery>
		
					
				<cfinclude template="TemplateLogPrepare.cfm">			
				<cfinclude template="TemplateLogFiles.cfm">
								
			</cfif>
		</td>
	</tr>
</div>


