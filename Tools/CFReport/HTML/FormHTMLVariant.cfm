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
<!--- ----------------------------------------- --->
<!--- ------- set report initial values ------- --->
<!--- ----------------------------------------- --->

<cfparam name="SelLayoutId"              default="">
<cfparam name="SelFileFormat"            default="PDF">
<cfparam name="SelDistributionPeriod"    default="Manual">
<cfparam name="SelDateEffective"         default="#dateFormat(now(), CLIENT.DateSQL)#">
<cfparam name="SelDateExpiration"        default="#dateFormat(now()+180, CLIENT.DateSQL)#">
<cfparam name="SelDistributionName"      default="#SESSION.first# #SESSION.last#">
<cfparam name="SelDistributionSubject"   default="">
<cfparam name="SelDistributionEMail"     default="#CLIENT.eMail#">
<cfparam name="SelDistributionEMailCC"   default="">
<cfparam name="SelDistributionReplyTo"   default="">
<cfparam name="SelDistributionMode"      default="Attachment">
<cfparam name="SelDistributionDOW"       default="">
<cfparam name="SelDistributionDOM"       default="1">
<cfparam name="h"                        default="172">
<cfparam name="URL.Option"               default="All">
<cfparam name="url.portal"				 default="0">
<!--- verify if user selected report or his/her save report --->

<cfloop index="day" from="1" to="7">
	<cfparam name="SelDistribution#Day#" default="0">
</cfloop>
					 		
<!--- user must have selected his variant --->

<cfquery name="Report" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   U.*, R.* 
 FROM     UserReport U INNER JOIN
          Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
          Ref_ReportControl R ON L.ControlId = R.ControlId
 WHERE    U.ReportId = '#URL.ReportId#' 
</cfquery>

	
<cfif Report.recordcount eq "1">
			
	<cfset controlid              = "#Report.ControlId#">
	<cfset reportId               = "#URL.reportid#">						
	<cfset SelLayoutId            = "#Report.LayoutId#">	
	<cfset SelFileFormat          = "#Report.FileFormat#">	
	<cfset SelDistributionPeriod  = "#Report.DistributionPeriod#">
	<cfset SelDistributionDOW     = "#Report.DistributionDOW#">
	<cfset SelDistributionDOM     = "#Report.DistributionDOM#">
	<cfloop index="no" list="#Report.DistributionDOW#" delimiters="|">
	    <cfparam name="SelDistribution#no#" default="1"> 
	</cfloop>
	
	<cfloop index="day" from="1" to="7">
		<cfparam name="SelDistribution#Day#" default="0">
	</cfloop>
	
	<cfset SelDateEffective       = "#dateFormat(Report.DateEffective, CLIENT.DateSQL)#">
	<cfset SelDateExpiration      = "#dateFormat(Report.DateExpiration, CLIENT.DateSQL)#">
	
	<cfset SelDistributionName    = "#Report.DistributionName#">
	<cfset SelDistributionMode    = "#Report.DistributionMode#">
	<cfset SelDistributionEmail   = "#Report.DistributionEMail#">
	<cfset SelDistributionEmailCC = "#Report.DistributionEMailCC#">
	<cfset SelDistributionreplyTo = "#Report.DistributionreplyTo#">
	<cfset SelDistributionSubject = "#Report.DistributionSubject#">
		
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Crit">
	
	<cfquery name="VariantDefaults" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 INTO   userQuery.dbo.#SESSION.acc#Crit
	 FROM   UserReportCriteria 
	 WHERE  ReportId = '#URL.ReportId#' 
	</cfquery>
	
<cfelse>
	
	<cfquery name="Report" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM Ref_ReportControl
	 WHERE ControlId = '#URL.controlid#' 
	</cfquery>
				
	<cfset controlId = "#URL.controlid#">
	<cfset reportId  = "00000000-0000-0000-0000-000000000000">
	
	<cfset SelDistributionSubject = "#Report.FunctionName#">		
			
</cfif>

<cfquery name="Parameter" 
    datasource="AppsSystem"
	username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     Parameter 
</cfquery>
 
<cfset AnonymousUserid = "#Parameter.AnonymousUserid#">
 
<!--- ---- end initial setting as in select.cfm --- --->

<cfform action   = "#SESSION.root#/tools/CFreport/ReportSQL8.cfm?mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML"
		method   = "POST"
		autocomplete="off"
        target   = "report"		
		onsubmit = "validation();return false;"
        name     = "selection">  	
								
		<table width="99%" border="0" align="center" cellspacing="0" cellpadding="0">	
		
		<!---
		<tr>
	  	<td style="padding-top:8px;height:34px;color: ##003578; font-size: 18px; padding-left: 16px; font-variant: small-caps; font-weight: bold;">
			<u>Selection Criteria
		</td>
		</tr>
		--->	
		
		<tr><td style="padding-left:20px" id="messagebox"></td></tr>	  
												
		<tr><td valign="top" style="padding-left:6px">			 
						 			
			 <table width="100%" align="center" cellspacing="0" cellpadding="0">	
										
					<cfquery name="Layout" 
					 datasource="AppsSystem" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT *
						 FROM  Ref_ReportControlLayout R
						 WHERE ControlId = '#url.ControlId#'
						 AND Operational = 1
						 AND LayoutName != 'Export Fields to MS-Excel' 
						 <cfif url.portal eq "1">
						 	AND UserScoped = 1
						 </cfif>						 
						 UNION
						 SELECT *
						 FROM  Ref_ReportControlLayout R
						 WHERE ControlId = '#url.ControlId#'
						 AND Operational = 1
						 AND LayoutName = 'Export Fields to MS-Excel'
						 AND ControlId IN (SELECT ControlId FROM Ref_ReportControlOutput)
						 <cfif url.portal eq "1">
						 	AND UserScoped = 1
						 </cfif>						 						 
						 ORDER BY ListingOrder 
					</cfquery>	

					<cfset initLayoutClass = Layout.LayoutClass>								
										
					<cfset class = "'Selection','Layout'">		  
										
					<tr>
					   <td>		
					   			  
			  		 <cfinclude template="FormHTMLCriteria.cfm"> 					  
					   </td>					
					</tr>
					
					<!---				
										 		
					<tr><td height="7"></td></tr>					
					<tr><td colspan="1"  STYLE="font-size:21px;HEIGHT:40" class="labelmedium"><b><cf_tl id="Layout and Format"></td></tr>					
					<tr>
					<tr><td colspan="1" class="linedotted"></td></tr>  	 
					
					--->
			 	 	<tr>
						<td>	
						
						 <table width="100%" cellspacing="0" cellpadding="0">
						 <tr><td id="mylayout">
						   	<cfinclude template="FormHTMLLayout.cfm">	
						 </td></tr>
						 </table>										
											 	
						</td>
					</tr>		
						
					<tr><td height="7"></td></tr>		
							
					<cfif SESSION.acc neq AnonymousUserId>	
								
					<tr class="line">
					<td class="labelmedium" style="font-weight:200;height:45px;padding-left:5px;font-size:25px"><cf_tl id="Variant Subscription"></td>
					</tr>																 								
					<tr><td><cfinclude template="FormHTMLSchedule.cfm"></td></tr>
					
					</cfif>
									 		 
			 </table>	
						 
			 </td></tr>
		
		</table> 
				
		</cfform>
		
</cfoutput>		

<script>
	Prosis.busy('no')
</script>