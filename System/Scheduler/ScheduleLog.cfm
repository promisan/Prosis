


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
		
	<table width="98%" align="center" class="table_navigation">
	
	<tr><td height="6"></tr></tr>	
	<tr class="labelmedium line" bgcolor="white">
	    <TD width="30"></TD>
	    <TD width="120">Run at</TD>
		<TD width="120">Result</TD>
	    <TD width="120">Duration</TD>
		<TD width="120">IP/Host</TD>
		<TD width="120">eMail</TD>
		<TD width="120" align="right">
			<cfoutput>
				<cf_img icon="delete" onclick="ColdFusion.navigate('ScheduleLog.cfm?id=#URL.ID#&id1=all','detail#URL.ID#')">
			 </cfoutput>
		</TD>
	</TR>
		
	<cfoutput query="SearchResult">
	
	    <tr class="navigation_row labelmedium line" style="height:15px;font-size:14px">
			<td style="padding-left:3px">#currentrow#.</td>
			<td class="navigation_action">
				<a href="javascript:schedulelogdetail('#ScheduleRunId#')"><font color="6688aa">
				#DateFormat(ProcessStart,CLIENT.DateFormatShow)# #TimeFormat(ProcessStart,"HH:MM")#</font>
				</a>
			</td>
			<td width="130">
			
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