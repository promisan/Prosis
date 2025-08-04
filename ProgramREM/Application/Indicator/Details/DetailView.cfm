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

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     P.*, Pe.*, PI.IndicatorCode
	FROM  Program P, ProgramPeriod Pe, ProgramIndicator PI
	WHERE PI.TargetId   = '#URL.TargetId#'
	AND PI.ProgramCode  = Pe.ProgramCode
	AND PI.Period       = Pe.Period
	AND Pe.ProgramCode  = P.ProgramCode
</cfquery>

<cfquery name="Indicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Indicator
	WHERE IndicatorCode = '#Program.IndicatorCode#'
</cfquery>

<cfparam name="URL.Period" default="#Program.Period#">
<cfparam name="URL.Date" default="">
<cfparam name="URL.AuditId" default="">

<cf_screentop height="100%" scroll="No" border="1" layout="innerbox" html="Yes" title="Indicator measurement details #Indicator.IndicatorDescription#">

<cfoutput>

<cfajaximport tags="cftree,cfform">
	
<cfif Indicator.IndicatortemplateAjax eq "1">

	<script>

	function showindicator(audit) { 
		se = document.getElementById("hidetop").checked
		parent.window.right.location = "DetailViewBase.cfm?ID=PRG&Targetid=#URL.TargetId#&AuditId="+audit+"&hidetop="+se
	}  

	</script>
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
		<tr>
		<td valign="top" width="175" bgcolor="f4f4f4" style="border: 1px solid Gray;">
		
		<cfdiv bind="url:DetailViewTree.cfm?TargetId=#URL.TargetId#&Period=#Program.Period#&Indicator=#Program.IndicatorCode#"/>
		
		</td>
				
		<td style="padding-left:4px;border: 1px solid Gray;">
		
			<iframe src="DetailViewBase.cfm?TargetId=#URL.TargetId#&Auditid=#url.auditId#&Date=#URL.Date#&Period=#URL.Period#"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
				
		</td></tr>
	
	</table>

<cfelse>

	<script>

	function showindicator(audit) { 
		parent.window.right.location = "DetailViewBasePrior.cfm?ID=PRG&Targetid=#URL.TargetId#&AuditId="+audit
	}  

	</script>
	
	<table width="100%" height="100%" background="1">
		<tr>
			<td valign="top" width="160">
				<cfset url.Indicator = Program.IndicatorCode>
				<cfinclude template="DetailViewTree.cfm">
			
			</td>
			<td style="border-left: 1px solid Silver;">
			
				<iframe src="DetailViewBasePrior.cfm?TargetId=#URL.TargetId#&Auditid=#url.auditId#&Date=#URL.Date#&Period=#URL.Period#"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
				
			</td>
		</tr>
	</table>

</cfif>
 
<cf_screenbottom layout="innerbox">

</cfoutput>
