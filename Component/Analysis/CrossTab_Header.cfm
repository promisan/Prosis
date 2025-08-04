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
<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/component/analysis/crosstab.css">
<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">

<tr>

	<cfset frm = "#Formula.recordcount#"> 
	<cfset sp  = "19">  
	
	<td height="20" style="min-width:300px;font-size:26px;height:40px;font-weight:200;border-top: 1px solid Silver;padding-left:8px">	
	<table>
	<tr class="labelmedium">
	<td style="font-size:20px">Set:&nbsp;#node#</td>
	<td style="padding-top:5px;padding-left:20px">
	
	<table>
	<tr class="labelmedium"><td style="min-width:55px;color:gray"><cf_tl id="Filter">:</td>
	
	        <cfquery name="filter" 
				datasource="appsSystem">
				SELECT       ControlId, FilterMode, FilterSerialNo, FieldName, FilterOperator, FilterValue, Created
				FROM            UserPivotFilter
				WHERE ControlId = '#controlid#'
			</cfquery>
		<td style="color:gray;font-size:15px;padding-left;3px">
		<cfloop query="filter"><cfif currentrow neq "1">&nbsp;|&nbsp;</cfif><a title="#FieldName#">#FilterValue#</a></cfloop>
		</td>
	</tr></table>
	</td>
	</tr>
	
	</table>
	
	</td>
			
	<cfset box = "#node#_header">
	<cfloop query="Xax">
		<cfif len(fieldHeader) gt "6">
		   <cfset hdr = "#left(fieldHeader,6)#..">
		<cfelse>
		   <cfset hdr = "#fieldHeader#">	
		</cfif>
		<td colspan="#frm#" 
		    align="center" 
			class="ctTop labelmedium" style="font-size:14px;border-top: 1px solid Silver;">
		<cfif node eq "1">
			<cfif format eq "HTML">
				<a href="##" style="cursor: help;" title="#fieldHeader#">&nbsp;#hdr#</a>
			<cfelse>
			   &nbsp;#hdr#
			</cfif>   
		</cfif>	   	  
		</td>
	</cfloop>	
		
	<td colspan="#frm#" align="center" height="5" class="ctTop labelmedium" 
	  style="font-size:14px;border-top: 1px solid Silver;border-right: 1px solid Silver;">
	<cfif node eq "1"><b><cf_tl id="Total"></b></cfif>
	</td>

</tr>

<tr>

	<cfset frm = "#Formula.recordcount#">
	<td class="ctTopSub" align="right" style="padding-top:3px;padding-bottom:3px">
	
		<cfif format eq "HTML">
				
			<cfquery name="fields" 
				datasource="appsSystem">
				SELECT  DISTINCT *
				FROM     UserReportOutput
			    WHERE    OutputId = '#URL.OutputId#' 
				AND      UserAccount = '#SESSION.acc#'
				AND      FieldName LIKE '%_dim'	
				AND      FieldName NOT IN (SELECT U.FieldName
											FROM   UserPivotDetail U INNER JOIN
								                   UserPivot UP ON U.ControlId = UP.ControlId
											WHERE  UP.OutputId    = '#url.outputid#'
											AND    UP.Node        = '#node#'
											AND    UP.Account     = '#SESSION.acc#'
											AND    U.Presentation != 'Drilldown'
										  )	
			</cfquery>
							
			<select id="drillfield_#node#" name="drillfield_#node#" class="regularxl">
				<cfloop query="fields">
					<option value="#OutputHeader#">#OutputHeader#</option>
				</cfloop>		
			</select>
		
		</cfif>			
	
	</td>
	<cfset box = "#node#_header">
	<cfloop query="Xax">
		
		<cfloop query="Formula">
			<td class="ctTopSub labelit" style="border-right: 1px solid d7d7d7; word-break: break-all; word-wrap: break-word;">
				
				<cfif node eq "1">
				<cf_space spaces="#sp#" label="#fieldHeader#">		
				<cfelse>
				<cf_space spaces="#sp#">	
				</cfif>		
			</td>
		</cfloop>  
		
	</cfloop>
	
	<cfloop query="Formula">
		<cfif currentrow lt formula.recordcount>
			<td class="ctTopSub labelit">
		<cfelse>
			<td class="ctTopSub labelit" style="border-right: 1px solid d7d7d7;">
		</cfif>
		
		<cfif node eq "1">
				<cf_space spaces="#sp#" label="#fieldHeader#">		
				<cfelse>
				<cf_space spaces="#sp#">	
				</cfif>			
		</td>
		</cfloop>  

</tr>
</cfoutput>	
