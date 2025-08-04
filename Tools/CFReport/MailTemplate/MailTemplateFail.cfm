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


<cfset face = "arial">
<cfset size = "1">

<!--- identify distribution settings --->
<cfquery name="User" 
    datasource="AppsSystem">
	 SELECT     U.*, Usr.eMailAddress
	 FROM       UserReport U, UserNames Usr		
	 WHERE      ReportId = '#ReportId#'
	 AND        Usr.Account = U.Account
</cfquery>

<!--- identify layout --->
<cfquery name="Layout" 
     datasource="AppsSystem">
	 SELECT     L.*, R.*, O.eMailAddress
	 FROM       Ref_ReportControlLayOut L, 
	            Ref_ReportControl R, 
	 			Ref_SystemModule M, 
				Organization.dbo.Ref_AuthorizationRoleOwner O	
	 WHERE      LayoutId = '#layoutId#'
	 AND        R.ControlId = L.ControlId
	 AND        R.SystemModule = M.SystemModule
	 AND        M.RoleOwner = O.Code 
</cfquery>

<cfquery name="Log" 
		datasource="AppsSystem">
		 INSERT INTO UserReportDistribution 		
			 (ReportId, 
			  ControlId,
			  SystemModule,
			  FunctionName,
			  LayoutClass,
			  LayoutName,
			  FileFormat,
			  Account,
			  DistributionPeriod,
			  DistributionName, DistributionSubject, DistributionEMail, 
			  DistributionCategory, OfficerUserid, BatchId) 
		 VALUES ('#ReportId#', 
		     '#ControlId#',
			 '#SystemModule#',
			 '#FunctionName#',
			 '#LayoutClass#',
			 '#LayoutName#',
			 '#FileFormat#',
			 '#Account#',
			 '#DistributionPeriod#',
		     '#DistributionName#',
		     '#DistributionSubject#', 
			 '#DistributionEMail#',
			 'ERROR',
			 '#CGI.Remote_Addr#',  
			 '#BatchId#') 
</cfquery>

<cfif #User.eMailAddress# neq "">
    <cfset fail = "#User.eMailAddress#">
<cfelse>
    <cfset fail = "#Layout.eMailAddress#">
</cfif>

	<cfmail TO  = "#fail#"
	        FROM        = "Report Agent <#Layout.eMailAddress#>"
			SUBJECT     = "ERROR : #User.DistributionSubject#"
			FAILTO      = "#fail#"
			mailerID    = "Nucleus [#Layout.SystemModule#]"
			TYPE        = "html"
			spoolEnable = "Yes"
			wraptext    = "100">
			
	<cf_screentop label="#lbl#" mail="Yes" scroll="yes" banner="blue" layout="webapp" user="no">		
												
	<table width="100%" 
	         border="0" 
			 cellspacing="0" 			
			 cellpadding="0" 
			 align="center" 
			 style="border-collapse : collapse;">
		
		<tr><td colspan="2" height="1" vbgcolor="black"></td></tr>	 			     	
		<tr>
		   <td height="20" colspan="2" align="center" bgcolor="FBB5AA">
		    <b><font face="#face#" size="#size#" color="black"><b>Reporting service NON_DELIVERY notice</font></b></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="black"></td></tr>			
		<tr>
		    <td><font face="#face#" size="#size#">Report name</font></td>
		    <td><font face="#face#" size="#size#">#User.DistributionSubject#</font></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="DADADA"></td></tr>		 
		<tr>
		    <td width="200" colspan="1"><font face="#face#" size="#size#">Layout</font></td>
		    <td><font face="#face#" size="#size#">#Layout.LayoutName#</font></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="DADADA"></td></tr>
		<tr>
		    <td><font face="#face#" size="#size#">eMail TO</font></td>
		    <td><font face="#face#" size="#size#">#User.DistributioneMail#</font></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="DADADA"></td></tr>
		<cfif #User.DistributioneMailCC# neq "">
		<tr>
		    <td><font face="#face#" size="#size#">eMail CC</font></td>
		    <td><font face="#face#" size="#size#">#User.DistributioneMailCC#</font></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="DADADA"></td></tr>
		</cfif>
		<tr>
		    <td><font face="#face#" size="#size#">Mode</font></td>
		    <td><font face="#face#" size="#size#"><cfif #User.DistributionMode# neq "Hyperlink">Attachment</cfif></font></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="DADADA"></td></tr>
		<tr>
		    <td><font face="#face#" size="#size#">Format</font></td>
		    <td><cfif #Layout.TemplateReport# neq "Excel">
			<font face="#face#" size="#size#">#User.Fileformat#</font><cfelse>
			<font face="#face#" size="#size#">Excel</font></cfif></td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="black"></td></tr>	
		<tr>
			<td colspan="2" align="center" bgcolor="silver"><font face="#face#" size="#size#"><b>Criteria</font></td>
		</tr>
		<tr>	
			<td colspan="2" align="center">
				<cfquery name="Param" 
			     datasource="AppsSystem">
				 SELECT   C.*, CR.CriteriaDescription AS CriteriaDescription
	             FROM     UserReportCriteria C INNER JOIN
	                      UserReport U ON C.ReportId = U.ReportId INNER JOIN
	                      Ref_ReportControlCriteria CR ON C.CriteriaName = CR.CriteriaName INNER JOIN
	                      Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId AND CR.ControlId = L.ControlId
				 WHERE    C.ReportId = '#ReportId#'
				 AND    CR.Operational = 1
				 ORDER BY CriteriaOrder
				</cfquery>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				
				<tr><td bgcolor="E0E0E0"><font face="#face#" size="#size#">Parameter</font></td>
				    <td bgcolor="E0E0E0"><font face="#face#" size="#size#">Value</font></td>
				</tr>
				
				<tr><td colspan="2" height="1" bgcolor="black"></td></tr>	
				
				<cfloop query="Param">
				<tr>
					<td width="200">
					<font face="#face#" size="#size#">#Param.CriteriaDescription#</font>
					</td>
					<td>
					<font face="#face#" size="#size#">#Param.CriteriaValue#</font>
					</td>
				</tr>
				<tr><td colspan="2" height="1" bgcolor="DADADA"></td></tr>
				</cfloop>
				
				</table>
			</td>
		</tr>
		<tr><td colspan="2" height="1" bgcolor="black"></td></tr>	
				  	 
		</table>
	
	 <cf_screenbottom mail="Yes" layout="webapp">		
	 						  
	</cfmail>

