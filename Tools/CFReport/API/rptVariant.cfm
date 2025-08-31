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
<cfparam name="Attributes.SystemModule"     default="Program">
<cfparam name="Attributes.LayoutCode"       default="">
<cfparam name="Attributes.ListCriteria"     default="">
<cfparam name="Attributes.Icon"     		default="">
<cfparam name="Attributes.IconStyle"   		default="">
		
<!--- the parent code for the action --->

<cfset vShowHyperlink = 0>

<cftransaction>
		
	<cfquery name="getReport"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT    R.ControlId, L.LayoutId, L.LayoutName
		FROM      Ref_ReportControl R INNER JOIN
				Ref_ReportControlLayout L ON R.ControlId = L.ControlId
		WHERE     R.SystemModule = '#attributes.systemmodule#' 
		AND       L.LayOutCode = '#attributes.layoutcode#'	
	</cfquery>	

	<cfif getReport.recordcount gte "1">

		<!--- we remove the old variant and create a new one --->
				
		<cfquery name="resetVariant"
			datasource="AppsSystem"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			DELETE FROM UserReport
			WHERE    LayoutId = '#getReport.LayoutId#'
			AND      Account = '#session.acc#'
			AND      Status = '5'	
		</cfquery>	
		
		<cf_assignid>
		
		<cfquery name="insertVariant"
			datasource="AppsSystem"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			INSERT INTO UserReport
			( ReportId, Account, LayoutId, DistributionName, DistributionMode, FileFormat, 
						DateEffective, DateExpiration, Status, OfficerUserId, OfficerLastName, OfficerFirstName )
			VALUES
			( '#rowguid#',
			'#session.acc#',
			'#getReport.LayoutId#',
			'Context report',
			'Attachment',
			'PDF',
			'#dateformat(now(),client.dateSQL)#',
			'#dateformat(now(),client.dateSQL)#',
			'5',
			'#session.acc#',
			'#session.last#',
			'#session.first#' )
			
		</cfquery>	
		
		<cfloop array="#attributes.listcriteria#" index="fields">	
			
			<cfquery name="insertVariantCriteria"
				datasource="AppsSystem"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				
				INSERT INTO UserReportCriteria
				( ReportId, CriteriaName, CriteriaValue )
				VALUES
				( '#rowguid#',
					'#fields.criterianame#',
					'#fields.criteriavalue#' )
				
			</cfquery>	
					
		</cfloop>

		<cfset vShowHyperlink = 1>	

	</cfif>	

</cftransaction>

<cfif vShowHyperlink eq 1>
	<!--- show hyperlink --->	
	<cfoutput>
		<table>
			<tr>
				<td class="labelmedium">
					<cfif trim(Attributes.Icon) eq "">
						<a href="javascript:ptoken.open('#session.root#/Tools/cfreport/ReportSQL8.cfm?reportid=#rowguid#&mode=link&category=Dashboard&userid=#SESSION.acc#','_blank','width=1100,height=900,toolbar=no,scrollbars=no,resizable=yes')">
							<font color="0080C0">#getReport.LayoutName#</font>
						</a>
					<cfelse>
						<img 
							src="#session.root#/images/#Attributes.Icon#" 
							style="#Attributes.IconStyle#"
							title="#getReport.LayoutName#" 
							onclick="ptoken.open('#session.root#/Tools/cfreport/ReportSQL8.cfm?reportid=#rowguid#&mode=link&category=Dashboard&userid=#SESSION.acc#','_blank','width=1100,height=900,toolbar=no,scrollbars=no,resizable=yes')">
					</cfif>
				</td>
			</tr>
		</table>	
	</cfoutput>
</cfif>
