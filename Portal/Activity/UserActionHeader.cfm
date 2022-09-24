
<cfoutput>

<table width="100%" height="100%">

	<tr class="fixlengthlist">
	<td height="100%" align="center" style="border-right:1px solid silver;width:60%">
		
		<cfquery name="Summary" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			
			SELECT    S.ApplicationServer,
			           (SELECT count(DISTINCT Account) FROM UserStatus WHERE S.ApplicationServer = ApplicationServer and ActionTimeStamp > #diff#) as SessionUser,
					   (SELECT count(*)                FROM UserStatus WHERE S.ApplicationServer = ApplicationServer and ActionTimeStamp > #diff#) as Session,
				       (SELECT count(*)                FROM UserError  WHERE S.ApplicationServer = HostServer        and ErrorTimeStamp > #diff#) as Error,
					   (SELECT count(DISTINCT Account) FROM UserStatus WHERE S.ApplicationServer = ApplicationServer) as SessionRecentUser,
					   (SELECT count(*)                FROM UserStatus WHERE S.ApplicationServer = ApplicationServer) as SessionRecent,
					   (SELECT count(*)                FROM UserError  WHERE S.ApplicationServer = HostServer        and ErrorTimeStamp > #day#) as ErrorRecent 
			FROM      UserStatus S 
			WHERE     Account <> ''
			GROUP BY  ApplicationServer			
		
		</cfquery>
		
		<!--- attention the table UserActionModule 
		     does not contain the field Application server to identify a box and not a domain --->
			
		<!--- ----------- --->	
		<!--- last 7 days --->
		
		<cfquery name="getLastWeek" datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    ApplicationServer,
			      sum(Total) as Total
				 				  
		FROM (			  
		
			SELECT    P.ApplicationServer, COUNT(DISTINCT S.Account) AS Total
		    FROM      UserActionModule AS S INNER JOIN Parameter.dbo.Parameter AS P ON S.HostName = P.ApplicationServer
					OR left(S.hostname,CASE WHEN CHARINDEX('.',S.hostname)>1 THEN CHARINDEX('.',S.hostname)-1 ELSE LEN(S.hostname) END) 
								= 
					left(P.hostname,CASE WHEN CHARINDEX('.',P.hostname)>1 THEN CHARINDEX('.',P.hostname)-1 ELSE LEN(P.hostname) END) 
		    WHERE     S.ActionTimestamp > GETDATE() - 8
		    GROUP BY  S.HostName, P.ApplicationServer	
			
			) as Sub
		
		GROUP BY ApplicationServer
		ORDER BY ApplicationServer	
		</CFQUERY>
			
		<!--- ------------ --->
		<!--- last 30 days --->
		
		<cfquery name="getLast30" datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    ApplicationServer,SUM(Total) as Total
					  
		FROM (			  
		
			SELECT    P.ApplicationServer, COUNT(DISTINCT S.Account) AS Total
		    FROM      UserActionModule AS S INNER JOIN Parameter.dbo.Parameter AS P ON S.HostName = P.ApplicationServer 
				OR left(S.hostname,CASE WHEN CHARINDEX('.',S.hostname)>1 THEN CHARINDEX('.',S.hostname)-1 ELSE LEN(S.hostname) END) 
								= 
					left(P.hostname,CASE WHEN CHARINDEX('.',P.hostname)>1 THEN CHARINDEX('.',P.hostname)-1 ELSE LEN(P.hostname) END) 
		    WHERE     S.ActionTimestamp > GETDATE() - 32
		    GROUP BY  S.HostName, P.ApplicationServer	
			
			) as Sub
		
		GROUP BY ApplicationServer
		ORDER BY ApplicationServer	
		
		
		</CFQUERY>
				
		<table style="width:95%" valign="top" class="navigation_table">
						
		<tr class="labelmedium2 line fixlengthlist">
			<td style="font-size:27px;min-width:120px;" rowspan="2"><cf_tl id="Host"><font size="1"><a href="javascript:refresh()"><br><cf_tl id="Refresh"></a></td>
			<td colspan="3" style="border-left:1px solid gray;" align="center">
			<input type="hidden" id="mode" value="current">
			<cf_tl id="Current">
			<!---
			<input type="button" style="border:1px solid silver;width:73px;height:22px" class="button10g" id="btncurrent" value="Current" onclick="reloadForm('current','ses')">		
			--->
			</td>
			<td colspan="3" style="border-left:1px solid gray;" align="center">		
			<cf_tl id="24 hours">
			<!---
			<input type="button" style="border:1px solid silver;width:73px;height:22px"  class="button10g" id="btn24hour" value="24hour" onclick="reloadForm('24hour','ses')">
			--->
			
			</td>
			<td colspan="1" align="center" style="width:45;border-left:1px solid gray;padding-right:2px" title="7 days">7d</td>
			<td colspan="1" align="center" style="width:45;border-left:1px solid gray;padding-right:2px" title="30 days">30d</td>
		</tr>	
		
		<tr class="labelmedium2 line fixlengthlist" style="height:28px">	    
			<td align="center">
			<input type="button" style="width:100%;height:23px" class="button10g" id="btncurrent" value="Usr" onclick="reloadForm('current','usr','action')">						
			</td>
			<td align="center">
			<input type="button" style="width:100%;height:23px" class="button10g" id="btncurrent" value="Ses" onclick="reloadForm('current','ses','action')">								
			</td>
			<td align="center">
			<input type="button" style="width:100%;height:23px" class="button10g" id="btncurrent" value="Err" onclick="reloadForm('current','ses','error')">										
	<!---		<input type="button" style="border:1px solid silver;width:100%;height:22px" class="button10g" id="btncurrent" value="Err" onclick="reloadForm('current','ses')">  --->								
			</td>
			
			<td align="center">
			<input type="button" style="width:100%;height:23px" class="button10g" id="btncurrent" value="Usr" onclick="reloadForm('24hour','usr','action')">						
			</td>
			<td align="center">
			<input type="button" style="width:100%;height:23px" class="button10g" id="btncurrent" value="Ses" onclick="reloadForm('24hour','ses','action')">								
			</td>	
			<td align="center">
			<input type="button" style="width:100%;height:23px" class="button10g" id="btncurrent" value="Err" onclick="reloadForm('24hour','ses','error')">								
		
		<!---		<input type="button" style="border:1px solid silver;width:100%;height:22px" class="button10g" id="btncurrent" value="Err" onclick="reloadForm('current','ses')">  --->								
			</td>	
			<td style="min-width:37px;border-left:1px solid gray;padding-right:3px" align="right">Usr</td>	
			<td style="min-width:37px;border-left:1px solid gray;padding-right:3px" align="right">Usr</td>	
		</tr>
		
		<cfloop query="Summary">	
		
			<!--- last 7 days --->
			<cfquery name="LastWeek" dbtype="query">
				SELECT    *
			    FROM      getLastWeek
				WHERE     ApplicationServer = '#applicationserver#'	
			</CFQUERY>
			
			<!--- last 7 days --->
			<cfquery name="Last30" dbtype="query">
				SELECT    *
			    FROM      getLast30
				WHERE     ApplicationServer = '#applicationserver#'	
			</CFQUERY>
			
			<tr class="labelmedium linedotted navigation_row fixlengthlist" style="height:21px">
			    <td style="padding-right:14px"><cfif ApplicationServer eq "">undefined<cfelse>#ApplicationServer#</cfif></td>
				<td style="border-left:1px solid gray;background-color:##f2ffff80" height="15" align="right" bgcolor="F2FFFF"><cfif sessionuser eq "0">-<cfelse>#SessionUser#</cfif></td>
				<td align="right"><cfif session eq "0">-<cfelse>#Session#</cfif></td>
				<td align="right"><cfif error eq "0">-<cfelse>#Error#</cfif></td>
				<td style="border-left:1px solid gray;background-color:##f2ffff80" align="right"><cfif sessionrecentuser eq "0">-<cfelse>#SessionRecentUser#</cfif></td>
				<td align="right"><cfif sessionrecent eq "0">-<cfelse>#SessionRecent#</cfif></td>
				<td align="right"><cfif errorrecent eq "0">-<cfelse>#ErrorRecent#</cfif></td>
				<td bgcolor="ffffcf" style="background-color:##ffffaf80;border-left:1px solid gray" align="right">#LastWeek.Total#</td>
				<td bgcolor="f1f1f1" style="background-color:##f1f1f180;border-left:1px solid gray" align="right">#Last30.Total#</td>
			</tr>
			
		</cfloop>
		
		<cfquery name="Total" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     (SELECT count(DISTINCT Account) FROM UserStatus WHERE ActionTimeStamp > #diff#) as SessionUser,
					   (SELECT count(*)                FROM UserStatus WHERE ActionTimeStamp > #diff#) as Session,
					   (SELECT count(DISTINCT Account) FROM UserStatus) as SessionRecentUser,
					   (SELECT count(*)                FROM UserStatus) as SessionRecent 
			FROM       UserStatus S	
		</cfquery>
			
		<tr class="linedotted labelmedium2 fixlengthlist">
		
			<td><cf_tl id="Total"></td>
			<td style="border-left:1px solid gray" align="right" bgcolor="F2FFFF">#Total.SessionUser#</td>
			<td align="right">#Total.Session#</td>
			<td align="right"></td>
			<td style="border-left:1px solid gray" align="right" bgcolor="F2FFFF">#Total.SessionRecentUser#</td>
			<td align="right">#Total.SessionRecent#</td>		
			<td align="right"></td>
			
			<!--- last 7 days --->
			<cfquery name="LastWeek" dbtype="query">
				SELECT    sum(Total) as Total
			    FROM      getLastWeek		
			</cfquery>
			
			<!--- last 7 days --->
			<cfquery name="Last30" dbtype="query">
				SELECT    sum(Total) as Total
			    FROM      getLast30		
			</cfquery>
			
			<td bgcolor="ffffcf" style="border-left:1px solid gray" align="right">#LastWeek.Total#</td>
			<td bgcolor="f1f1f1" style="border-left:1px solid gray" align="right">#Last30.Total#</td>
				
		</tr>
			
		</table>
			
	</td>
	
	<td height="100%" align="right" style="width:40%;padding-left:4px">
	 
		<cfquery name="Total" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
		    SELECT  *
			FROM     UserStatus
			WHERE ActionTimeStamp > #diff#
	  </cfquery>	
	
	 <cfquery name="Visits" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 		
			
			SELECT    A.Description AS Module, COUNT(*) AS Counted
			FROM      UserStatus U 
			          INNER JOIN Ref_ModuleControl R ON U.SystemFunctionId = R.SystemFunctionId 
					  INNER JOIN Ref_SystemModule S ON S.SystemModule = R.SystemModule 
					  INNER JOIN Ref_ApplicationModule AM ON AM.SystemModule = S.SystemModule 
					  INNER JOIN #Client.LanPrefix#Ref_Application A ON AM.Code = A.Code
			WHERE     A.Operational = 1
			AND       A.Usage = 'System'		
			AND       ActionTimeStamp > #diff#  
			GROUP BY  A.Description, A.ListingOrder
			ORDER BY  A.ListingOrder
					
	  </cfquery>	
	  	 
	  <cfset vColor = "##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
	  
	  <cf_uichart name="divUsage1"
			chartheight="160"			
			showlabel="No"
			showvalue="No"
			url="javascript:_cf_loadingtexthtml='';ptoken.navigate('UserActionContent.cfm?systemfunctionid=#url.systemfunctionid#&mode='+document.getElementById('mode').value+'&filter=$ITEMLABEL$','content')">
				
		<cf_uichartseries type="bar"
		    query="#visits#" 
			itemcolumn="Module" 
			valuecolumn="counted" 
			colorlist="#vColor#"/>
			
  	  </cf_uichart>
	
		
	</td>
	</tr>	

</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>
