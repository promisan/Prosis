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
<cfoutput>

<cfset SESSION.root = url.root>

<cfset relurl  = "#SESSION.root#/_distribution/#URL.Site#/v#DateFormat(PendingRelease.VersionDate,'YYYYMMDD')#">
<cfset relpath = "#master.replicaPath#\_distribution\#URL.Site#\v#DateFormat(PendingRelease.VersionDate,'YYYYMMDD')#">

<!--- verify if release files exist --->

<cfloop index="itm" list="Readme.pdf,SourceCode.zip,CodeComparison.zip" delimiters=",">
	
	<cfif not FileExists("#relpath#\#itm#")>
	
		<cfquery name="Delete" 
		datasource="AppsControl">
			    DELETE FROM  ParameterSiteVersion
				WHERE VersionId = '#PendingRelease.VersionId#'
		</cfquery>
		
		<script>
		   window.location = "ReleasePackagePrepare.cfm?site=#URL.site#"
		</script>

	</cfif>

</cfloop>

<p></p>
<table width="95%" align="center" bordercolor="d4d4d4" border="0" cellspacing="0" cellpadding="0" class="formpadding">
 
   <tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>
   <tr><td rowspan="4" align="left">
		<b><img src="#url.root#/Images/release.gif" alt="This release" border="0" align="absmiddle">
		</td>
	</tr>
	<tr>	
		<td colspan="1">Release:</td>
		<td><b>v#dateFormat(PendingRelease.VersionDate,"YYYYMMDD")#
		<cfif pendingRelease.actionStatus eq "0">
		&nbsp;&nbsp;<input type="button" class="button10s" name="Cancel" id="Cancel" value="Cancel this release" onClick="cancel('#URL.site#')">
		</cfif>
		</td>
	</tr>
	
	<tr>	
		<td>Directory:</td>
		<td><b><cfif pendingRelease.templategroup eq "">ALL<cfelse>#pendingRelease.templategroup#</cfif></td>
	</tr>
	
	<tr>	
	    <td height="20">Release Package:</td>
		    <td><table width="100%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" bgcolor="F4F4F4" frame="hsides" rules="rows">
						
				<tr>
					<td height="22" >
						<a href="#relurl#/Readme.pdf" target="_blank" title="Release Notes and Instructions">
						<img src="#url.root#/Images/pdf_small.jpg" alt="" border="0" align="absmiddle">
						ReadMe.pdf
						</a>
					</td>
					<td height="22">
						<a title="Source Code Files" target="_blank"
						 href="#relurl#/SourceCode.zip">
						 <img src="#url.root#/Images/zip.gif" alt="" border="0" align="absmiddle">
						 SourceCode.zip</a>
					</td>
					
					<cfif Site.EnableCodeEncryption  eq "Yes" and FileExists("#relurl#/SourceCodeEncrypted.zip")>
						<td height="22">
							<a title="Source Code Files" target="_blank"
							 href="#relurl#/SourceCodeEncrypted.zip">
							 <img src="#url.root#/Images/zip.gif" alt="" border="0" align="absmiddle">SourceCodeEncrypted.zip</a>
						</td>
					</cfif>
								 
					<td height="22">
						<a title="Detailed comparison report" target="_blank"
						href="#relurl#/CodeComparison.zip">
						<img src="#url.root#/Images/zip.gif" alt="" border="0" align="absmiddle">
						CodeComparison.zip</a>&nbsp;&nbsp;</td>
						
					<cfif FileExists("#relpath#/SQLScript.zip")>
				    <td height="22">
						<img src="#url.root#/Images/zip.gif" alt="" border="0" align="absmiddle">					
						<a title="Detailed comparison report" target="_blank"
						href="#relurl#/SQLScript.zip">SQLScript.zip</a>
					</td>
					</cfif>	
				</tr>
			  </table></td>
	</tr>
	<tr><td colspan="3">

			<cfif CGI.HTTPS EQ "on">
				<cfset link = "https://" & CGI.HTTP_HOST & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
			<cfelse>
				<cfset link = "http://" & CGI.HTTP_HOST & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
			</cfif>
				
		   <cf_ActionListing 
		    TableWidth       = "100%"
		    EntityCode       = "Release"
			EntityClass      = "Standard"
			EntityGroup      = "#URL.Site#"
			EntityStatus     = ""
			CompleteFirst    = "Yes"
			PersonEMail      = "#Site.DistributioneMail#"
			ObjectReference  = "#URL.Site#"
			ObjectReference2 = "release #dateFormat(PendingRelease.VersionDate,CLIENT.DateFormatShow)#"
			ObjectKey4       = "#PendingRelease.VersionId#"
		  	ObjectURL        = "#link#"
			DocumentStatus   = "#PendingRelease.ActionStatus#">
		
		</td>
		</tr>	
	</table>	
	

</cfoutput>	