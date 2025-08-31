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
<cfparam name="url.id1" default="">

<cfif url.id1 neq "">
	
	<cfif url.id1 eq "all">
	
		<cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM ScheduleLog
			WHERE ScheduleId = '#URL.ID#' 
		</cfquery> 
	
	<cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM ScheduleLog
			WHERE ScheduleRunId = '#URL.ID1#'
		</cfquery> 
		
	</cfif>	

</cfif>
 
<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	<cfif url.mode eq "embed">
	SELECT   TOP 300 *
	<cfelse>
	SELECT   TOP 16 *
	</cfif>
	FROM     ScheduleLog
	WHERE    ScheduleId = '#URL.ID#' and actionStatus != '0' 
	
</cfquery>

<cfif searchResult.recordcount gte "1">
		
	<table width="99%" align="left" class="table_navigation">
		
	<tr class="labelmedium line fixlengthlist fixrow">
	    <TD style="padding-left:3px"></TD>
	    <TD><cf_tl id="Run at"></TD>
		<TD><cf_tl id="Result"></TD>
	    <TD><cf_tl id="Duration"></TD>
		<TD>IP/Host</TD>
		<TD><cf_tl id="eMail"></TD>
		<TD align="right">
			<cfoutput>
				<cf_img icon="delete" onclick="ptoken.navigate('ScheduleLog.cfm?id=#URL.ID#&id1=all','detail#URL.ID#')">
			 </cfoutput>
		</TD>
	</TR>
		
	<cfoutput query="SearchResult">
	
	    <tr class="navigation_row labelmedium line fixlengthlist" style="height:15px;font-size:14px">
			
			<td style="padding-left:5px">#currentrow#.</td>
			
			<td class="navigation_action">
				<a href="javascript:schedulelogdetail('#ScheduleRunId#')">#DateFormat(ProcessStart,CLIENT.DateFormatShow)# #TimeFormat(ProcessStart,"HH:MM")#</a>
			</td>
			
			<td>
			
			<cfif actionStatus eq "9">
			    <font color="FF0000">Interrupted</font>	 
				<cfelseif actionStatus eq "2">
				<font color="gray">Completed with errors</font>	 
				<cfelseif actionStatus eq "0">
				<font color="FF0000">Not completed</font>	 
				<cfelse>
				<a title="open export file" href="javascript:output('#ScheduleRunId#')">
				<font color="green">Successful!</font>
				</a>
				</cfif>
				
			</td>
			
			<TD>
			
			<cftry>
			
				<cfset diff = DateDiff("s", ProcessStart, ProcessEnd)>
				<cfset min = round(diff/60)>
				<cfif diff lt 1>
				    < 1 sec
				<cfelseif min gte "1">
					#min# min #diff-(min*60)# sec
				<cfelse>
					#diff-(min*60)# sec
				</cfif>	
			
				<cfcatch></cfcatch>
			
			</cftry>
					
			</TD>
			<TD>#NodeIP#</TD>
			<TD>#EMailSentTo#</TD>
			<td align="right" style="padding:2px">
				<cf_img icon="delete" onclick="deletelog('#ScheduleId#','#ScheduleRunId#')">
			</td>
		
		</TR>
		<cfif actionStatus eq "9">
		    <tr><td class="labelit" colspan="7" bgcolor="ffffcf">#ScriptError#</td></tr>
		</cfif>
		
		<tr><td colspan="7" id="log#ScheduleRunId#" class="hide"></td></tr>
				
	</CFOUTPUT>
	
	<tr><td height="6"></tr></tr>	
	
	</TABLE>
	
</cfif>

<cfset ajaxonLoad("doHighlight")>