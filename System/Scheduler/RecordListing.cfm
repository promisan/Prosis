
<!--- Prosis template framework --->
<cfsilent>
<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Scheduled Tasks</proDes>
 <!--- specific comments for the current change, may be overwritten --->
<proCom>Add eMail Reference</proCom>
</cfsilent>
<!--- End Prosis template framework --->

 
<cfset Page         = "0">
<cfset add          = "1">

<cfparam name="url.op"  default="1">
<cfparam name="url.svr" default="0">
<cfparam name="url.module" default="">

<cfoutput>

	<script>
	
	 function reload(op,svr,mod) {
	     Prosis.busy('yes')
		 ptoken.location('RecordListing.cfm?idmenu=#url.idmenu#&idrefer=#url.idrefer#&op='+op+'&svr='+svr+'&module='+mod)
	 }
	 
	 function recordadd(id1) {
	 
	    w = 900;
		h = 800;
	    ptoken.open('RecordEdit.cfm?id=' + id1,'schedule','left=30, top=30, width=' + w + ', height= ' + h + ', toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes')
	   
	 }
	 
	</script>

</cfoutput>

<cf_screentop html="No" jquery="Yes">

<table style="height:100%" width="100%"><tr><td height="10">
<cfinclude template="../Parameter/HeaderParameter.cfm">
</td>
</tr>

<tr><td height="100%">

<cfparam name="auto" default="1">

<!--- creates schedules if needed --->
<cfinclude template="ScheduleRegisterData.cfm">

<cfif auto eq "0">
	<table width="99%" align="center"><tr><td align="center" class="labelmedium">
	&nbsp;<b>Attention</b>, auto registration was interrupted. <b>Reason:</b> <cfoutput>#CGI.HTTP_HOST#</cfoutput> was not registered as a site.</b>
	</td></tr></table>
</cfif>

<cfajaximport tags="cfdiv">
<cfinclude template="ScheduleScript.cfm">

<cf_distributer>

<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT R.*, 
	       A.Description as Application,
	       S.Description, 
		   A.ListingOrder,
		   S.MenuOrder, 
		   (SELECT ISNULL(ScheduleName,R.ScheduleName) 
		    FROM   Schedule 
			WHERE  ScheduleId = R.ParentScheduleId) as ParentName
	FROM  Schedule R, 
	      Ref_SystemModule S,
		  Ref_ApplicationModule AM,
		  Ref_Application A		  
	WHERE R.SystemModule = S.SystemModule
	AND   S.SystemModule = AM.SystemModule
	AND   A.Code         = AM.Code
	AND   A.Usage        = 'System'
	AND   R.Operational  = '#url.op#'
	<cfif url.module neq "">
	AND   R.SystemModule = '#url.module#' 
	</cfif>
	<cfif url.svr eq "1">
	AND   R.ApplicationServer = '#CGI.HTTP_HOST#'
	</cfif>
	<cfif SESSION.isAdministrator eq "No">
	AND   (
	
			S.RoleOwner IN (SELECT ClassParameter
	                        FROM   Organization.dbo.OrganizationAuthorization A
						    WHERE  UserAccount = '#SESSION.acc#'
							AND    Role = 'AdminSystem') 
		  OR
		  
		    R.Mission IN (SELECT   Mission
		  				  FROM     Organization.dbo.OrganizationAuthorization A
						  WHERE    UserAccount = '#SESSION.acc#'
						  AND      Role  in  ('OrgUnitManager','BudgetManager')) 
						   
		  OR
		  
		    <!--- added 9/4/2012 --->
		  
		    R.SystemModule IN (SELECT SystemModule 
				               FROM   Organization.dbo.Ref_MissionModule
							   WHERE  Mission IN (SELECT Mission
								                  FROM   Organization.dbo.OrganizationAuthorization
											      WHERE  Role  in  ('OrgUnitManager','BudgetManager')
												  AND    UserAccount = '#SESSION.acc#')
							   )   
		)		   
		            					
							
	</cfif>		
	<cfif master eq "0">
	AND ScheduleName NOT IN ('Template','CMManager','DataDictionary')
	</cfif>			
	AND   S.Operational = '1'
	ORDER BY A.ListingOrder,A.Description,S.MenuOrder, S.Description, ScheduleHierarchy
</cfquery>

<table height="100%" width="94%" align="center">

	<cfif SESSION.isAdministrator eq "Yes">
	
	<cfoutput>
	
	<tr class="line">
	
	<td align="left" colspan="2" style="padding-left:5px;font-size:17px" class="labelmedium">
	
	<cfif url.svr eq "0">	
		 <a href="javascript:reload('#url.op#','1','')">Show this server only</a>		 
	<cfelse>	
		 <a href="javascript:reload('#url.op#','0','')">Show all servers</a>	 	
	</cfif>	
	|	
	<cfif url.op eq "0">	
		 <a href="javascript:reload('1','#url.svr#','')">Show Activated Schedules</a>		
	<cfelse>	
		 <a href="javascript:reload('0','#url.svr#','')">Show Disabled Schedules</a>		
	</cfif>
	
	</td>
	
	<td align="right" style="padding:3px">
	
		<cfquery name="Module" dbtype="query">
		    SELECT   DISTINCT MenuOrder, SystemModule, Description
			FROM     Searchresult
			ORDER BY MenuOrder
		</cfquery>
		
		<select name="module" id="module" class="regularxl" onchange="reload('#url.op#','0',this.value)">
		    <option value="">All</option>
			<cfloop query="Module">
				<option value="#SystemModule#" <cfif url.module eq systemmodule>selected</cfif>>#Description#</option>
			</cfloop>
		</select>
		
	</td>
	
	</tr>
	
	<tr class="hidden"><td height="1" class="line" colspan="3" id="process"></td></tr>
	
	</cfoutput>
	
</cfif>
 		
<cfquery name="Host" 
	datasource="AppsInit">
	SELECT *
	FROM    Parameter P 
	WHERE   P.HostName = '#CGI.HTTP_HOST#' 
</cfquery>
	
	<tr><td colspan="3" height="100%">
	
	<cf_divscroll>
	
	<table width="99%" class="navigation_table">
	
	<tr class="labelmedium line fixrow">
	    <TD height="30" align="left"></TD>
	    <TD width="10" align="left"></TD>
		<td width="10"></td>
		<TD align="left"><cf_tl id="Name"></TD>
	    <TD align="left" width="50" style="padding-right:4px"><cf_tl id="Interval"></TD>
		<TD align="left" width="50"><cf_tl id="Start"></TD>
		<TD align="left" width="50"><cf_tl id="End"></TD>
		<TD align="left" width="100"><cf_tl id="Server"></TD>
		<TD align="left" width="100"><cf_tl id="Last Run Status"></TD>
		<TD width="80">R.</TD>
		<TD width="80"><cf_tl id="Fail To"></TD>
		<td width="30"><cf_tl id="C"></td>
		<td width="40"></td>
	</TR>
	
	<cfoutput query="SearchResult" group="Application">
		
	<tr style="cursor: pointer" class="labelmedium">	
		<td colspan="12" style="font-weight:300;font-size:27px;height:42;padding-top:3px;padding-left:3px">#Application#</td>	
	</tr>	
	
	<cfoutput group="SystemModule">
	
	<tr style="cursor: pointer" height="20" class="fixrow2 labelmedium">	
		<td colspan="13" style="font-weight:300;font-size:18px;height:30;padding-left:15px"><font color="black">#Description#</td>	
	</tr>	
	
	<cfset row = "0">
	
	<cfoutput group="ScheduleName">
	
	<cfoutput>
	
		<cfset row = row+1>
		
		<cfquery name="Last" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     TOP 1 *
			FROM       ScheduleLog R
			WHERE      ScheduleId = '#ScheduleId#'
			ORDER BY   ProcessStart DESC
		</cfquery>
				
		<tr class="navigation_row labelmedium <cfif scheduleMemo eq "">line</cfif>" id="lin#scheduleid#" style="height:22px">
		
		<td width="20"></td>	   	
		<td width="10" align="center">#currentRow#.</td>		
		<td style="padding-left:5px" width="20" align="center" id="option#scheduleid#">
				 
		    <cfset url.id  = scheduleId>
			<cfset url.row = currentrow>		
			<cfinclude template="ScheduleOption.cfm">	  	
					
		</td>	
		
		<cfset ln = replace(scheduletemplate,"\","\\","ALL")>	
		<cfif ScheduleMemo eq "">
		   <cfset t = "No information">
		<cfelse>
		   <cfset t = "<table><tr><td>#ScheduleMemo#</td></tr></table>">
		</cfif>
		
		<cfif scheduleHierarchy eq "">
			<cfset hier = "1">
		<cfelse>
			<cfset hier = scheduleHierarchy>	
		</cfif>
		
		<cfset c= -1>
			<cfloop index="itm" list="#hier#" delimiters=".">		
				<cfset c = c+1>
			</cfloop>
			
		<cf_UIToolTip tooltip="#t#">
	
			<TD style="padding-left:#(c*10)+5#px">	
			<table>
				<tr class="labelmedium"><td align="right" style="padding-right:2px;height:15px">
					<cfif c gt 1><img src="#session.root#/images/join.gif" alt="" border="0"></cfif>
				</td>
				<td class="navigation_action" style="height:20px;padding-right:2px;font-size:14px"><a href="javascript:recordadd('#ScheduleId#')"><font color="black">#ScheduleName#</a></td>
				</tr>
			</table>
			
			</TD>
			
		</cf_UIToolTip>
		
		<TD align="center" style="padding-left:4px;padding-right:4px">
		
		<cfif ScheduleInterval eq "Manual">
		-
		<cfelseif ScheduleInterval eq "3600">
		60"
		<cfelseif ScheduleInterval eq "900">
		15"
		<cfelseif ScheduleInterval eq "600">
		10"
		<cfelse>
		#ucase(left(ScheduleInterval,1))#
		</cfif>
		</TD>
		<TD>#ScheduleStartTime#</td>
		<td><cfif ScheduleInterval eq "3600" or ScheduleInterval eq "900" or ScheduleInterval eq "600">#ScheduleEndTime#</cfif></TD>
		<td>#ApplicationServer#</td>
		<td id="last#scheduleid#" width="130">
			<cfif last.actionStatus eq "9">
		    <font color="FF0000">Interrupted</font>
			<cfelseif last.actionStatus eq "0">
			<font color="FF0000">Not completed</font>	 
			<cfelseif last.actionStatus eq "2">
			<a title="Completed with errors" href="javascript:output('#Last.ScheduleRunId#')">
			<font color="FF8040">
			#dateFormat(Last.ProcessEnd,"DD/MM/YY")# - #timeFormat(Last.ProcessEnd,"HH:MM")#
			</font>
			</a>
			</font>	
			<cfelse>
			<a title="Completed" href="javascript:output('#Last.ScheduleRunId#')">
			<font color="green">		
			#dateFormat(Last.ProcessEnd,"DD/MM/YY")# - #timeFormat(Last.ProcessEnd,"HH:MM")#
			</font>
			</a>
			</cfif>
		</td>
		
		<TD align="left" id="#scheduleid#">
			
			<cfset url.init = "1">
			<cfset url.id = "#scheduleId#">
		    <cfinclude template="ScheduleStatus.cfm">
		
		</TD>
		
		<td>#ScriptFailureMail#</td>
		<td>#left(ScheduleClass,1)#</td>
		
		<td align="left" width="30">
		
			<table width="100%">
			<tr>
			<td></td>		
			<td align="right" style="padding-right:8px">
			
			<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM  ScheduleLog R	  
				WHERE ScheduleId = '#ScheduleId#'	
			</cfquery>
			
			<cfif check.recordcount gte "1">
			
					<img src="#client.virtualdir#/Images/More.png" alt="View History" 
						id="#scheduleId#Exp" border="0" class="show" height="22" width="22"
						align="absmiddle" style="cursor: pointer;" 
						onClick="schedulelog('#scheduleid#','','show')">
						
					<img src="#client.virtualdir#/Images/Minus.png" 
						id="#scheduleid#Min" alt="Hide History" border="0" height="22" width="22"
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="schedulelog('#scheduleid#','','hide')">
						
			</cfif>
						
			</td>
			</tr>
			</table>			
					
		</td>
			
		</TR>		
				
		<cfif scheduleMemo neq "">	
	
		<tr class="navigation_row_child line">
		   <td colspan="2"></td>
		   <td colspan="11" style="padding-left:7px">
			<table cellspacing="0" cellpadding="0">
			    <TR style="height:10px">
				<TD style="padding-left:50px"></TD>
				<TD STYLE="padding-left:5px"><font color="gray">#ScheduleMemo#</font></TD>
				</TR>
			</TABLE>
		</td>
		</tr>	
				
		</cfif>
			
		<tr id="log#scheduleid#" class="hide">
		    <td colspan="1"></td>
			<td></td>
			<td style="padding-bottom:5px" colspan="10" id="detail#scheduleid#" align="center"></td>
			<td></td>
		</tr>				
		
	</CFOUTPUT>	
	</CFOUTPUT>	
	</CFOUTPUT>	
	</CFOUTPUT>
	
	</TABLE>
	
	</cf_divscroll>
	
	</td>
	
</tr>

<cfoutput>
<tr style="height:10">
<td colspan="3" id="verify" style="padding-right:6px;font-size:16px" height="34" class="labelmedium">
  
   <img src="#client.virtualdir#/Images/finger.gif" alt="" border="0" align="absmiddle">
    <a href="javascript:ptoken.navigate('ScheduleCheck.cfm','verify')">
   <font color="gray">Verify registered schedules on server</font>
   </a>	
</td>
</tr>
</cfoutput>

</TABLE>

</td></tr>

