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
<cfparam name="url.mode" default="">
<cfparam name="url.templatesql" default="SQL.cfm">

<!--- receive directory in encoded format. Make it a file system format \ slash --->
<cfset reportpath = replace("#url.reportPath#","|","\","ALL")> 	

<cfif url.mode eq "create">

	<cfif url.ReportRoot neq "Report">
	   <cfset rootpath  = "#SESSION.rootpath#">
	<cfelse>
	   <cfset rootpath  = "#SESSION.rootReportPath#">
	</cfif>

	<cfdirectory 
		action    = "CREATE" 
		directory = "#rootpath#\#reportPath#">
		
	<cffile action="COPY" 
	        source="#SESSION.rootpath#\System\Modules\Reports\ReportInit\TemplateSQL.cfm"
	        destination="#rootpath#\#reportPath#">
			
	 <cffile action="RENAME"
        source="#rootpath#\#reportPath#\TemplateSQL.cfm"
        destination="#rootpath#\#reportPath#\SQL.cfm">
	 
	<cffile action="COPY" source="#SESSION.rootpath#\System\Modules\Reports\ReportInit\TemplateEvent.cfm"
	 destination="#rootpath#\#reportPath#"> 
	 
	  <cffile action="RENAME"
        source="#rootpath#\#reportPath#\TemplateEvent.cfm"
        destination="#rootpath#\#reportPath#\Event.cfm">
	
</cfif>

<table cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>

<cfif reportpath neq "">
	
	<cfif url.ReportRoot neq "Report">
	   <cfset rootpath  = "#SESSION.rootpath#">
	<cfelse>
	   <cfset rootpath  = "#SESSION.rootReportPath#">
	</cfif>
	
	<cftry>
	
		<cfif DirectoryExists("#rootpath#\#reportPath#")>					
					
			<cfset path = replace("#rootpath#\#reportPath#","\","|","ALL")> 	
			<cfset path = replace(path,"/","|","ALL")> 
			
			<tr>
			<td>&nbsp;</td>
			<td>
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
			</td>
			<td style="padding-left:7px;padding-right:4px" class="labelit"><font color="008040">Good!</font></td>
			</tr>
			<script>			
				ColdFusion.navigate('ReportInit/ReportLibrary.cfm?controlid=#url.id#&path=#path#','contentbox4')
			</script>
					
		<cfelse>		
		
			<tr>
			<td>&nbsp;</td>
			<td><img src="#SESSION.root#/Images/alert.gif" alt="" border="0"></td>
			<td style="padding-left:7px;padding-right:4px" class="labelmedium"><font color="FF0000">not&nbsp;exists</td>
			<td>
			
			<!--- create an encode format that is accepted by ajax --->
			<cfset reportpath = replace("#reportPath#","\","|","ALL")> 	
			<cfset reportpath = replace(reportpath,"/","|","ALL")> 
			
			<cfif url.templateSQL eq "SQL.cfm">
			<input type="button"
			     name="Create"
				 id="Create" 
				 class="button10s" 
				 style="width:90"
				 value="Create Dir"
				 onclick="ColdFusion.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=#url.reportroot#&reportpath=#reportpath#&mode=create','library')">
			</cfif>	 
				 
				 </td>
			</tr>
					
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td>&nbsp;</td>
			<td><img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0"></td>
			<td>Invalid directory</td>
			</tr>
				
	</cfcatch>
	
	</cftry>
	
<cfelse>

		<tr>
		<td>&nbsp;</td>
		<td><img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0"></td>
		<td>Please define directory</td>
		</tr>
			 
</cfif>

</cfoutput>

</td></tr>
</table>

