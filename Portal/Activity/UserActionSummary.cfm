
<cfoutput>

<table width="100%" height="100%">

<tr><td valign="top" height="100%" style="min-width:350px;border-bottom:1px dotted silver;border-right:1px dotted silver">
	
	<cfquery name="Summary" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT    ApplicationServer,
		      sum(SessionUser) as SessionUser,
			  sum(Session) as Session,
			  sum(SessionRecentUser) as SessionRecentUser,
			  sum(SessionRecent) as SessionRecent 
				  
	FROM (			  
	
		SELECT   S.HostName, P.ApplicationServer,
		           (SELECT count(DISTINCT Account) FROM UserStatus WHERE S.HostName = HostName and ActionTimeStamp > #diff#) as SessionUser,
				   (SELECT count(*) FROM UserStatus WHERE S.HostName = HostName and ActionTimeStamp > #diff#) as Session,
				   (SELECT count(DISTINCT Account) FROM UserStatus WHERE S.HostName = HostName) as SessionRecentUser,
				   (SELECT count(*) FROM UserStatus WHERE S.HostName = HostName) as SessionRecent 
		FROM     UserStatus S INNER JOIN Parameter.dbo.Parameter AS P 
				/*ON left(S.HostName,6) = left(P.Hostname,6)	*/
				ON left(S.hostname,CASE WHEN CHARINDEX('.',S.hostname)>1 THEN CHARINDEX('.',S.hostname)-1 ELSE LEN(S.hostname) END) 
							= 
				left(P.hostname,CASE WHEN CHARINDEX('.',P.hostname)>1 THEN CHARINDEX('.',P.hostname)-1 ELSE LEN(P.hostname) END) 
		GROUP BY S.HostName, P.ApplicationServer	
		
	) as Sub
	
	GROUP BY ApplicationServer
	ORDER BY ApplicationServer	
	</cfquery>
		
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
	
		
	<table width="329" border="0" cellspacing="0" cellpadding="0" style="padding-top:8px" valign="top" class="navigation_table">
	
	<tr class="line">
	<td align="left" valign="top" colspan="8">
		<table width="100%">
		<tr>
		<td style="height:35px;padding-top:4px;font-size:20px" class="labellarge"><cf_tl id="User activity"></td>		
		<td style="font-weight:200;padding-top:9px" class="labelit" align="right">
		   <a href="javascript:refresh()"><cf_tl id="Refresh"></a>	  
		</tr>   
		</table>   
	</td>
	</tr>
		
	<tr class="line labelmedium">
		<td height="18" rowspan="2"><cf_tl id="Host"></td>
		<td colspan="2" style="border-left:1px solid gray;padding-right:2px" align="center"><cf_UItooltip tooltip="Less than 10 minutes ago">Current</cf_UItooltip></td>
		<td colspan="2" style="border-left:1px solid gray;padding-right:2px" align="center"><cf_UItooltip tooltip="Less than 24 hours ago">24 hour</cf_UItooltip></td>
		<td colspan="1" align="center" style="width:45;border-left:1px solid gray;padding-right:2px"><cf_UItooltip tooltip="7 days">7d</cf_UItooltip></td>
		<td colspan="1" align="center" style="width:45;border-left:1px solid gray;padding-right:2px"><cf_UItooltip tooltip="30 days">30d</cf_UItooltip></td>
	</tr>	
	
	<tr class="labelmedium line">	    
		<td width="37" style="border-left:1px solid gray;padding-right:3px" align="right">Usr</td>
		<td width="37" style="padding-right:3px" align="right">Ses</td>
		<td width="37" style="border-left:1px solid gray;padding-right:3px" align="right">Usr</td>
		<td width="37" style="padding-right:3px" align="right">Ses</td>
		<td style="border-left:1px solid gray;padding-right:3px" align="right">Usr</td>	
		<td style="border-left:1px solid gray;padding-right:3px" align="right">Usr</td>	
	</tr>
	
	<cfloop query="Summary">	
	
		<!--- last 7 days --->
		<cfquery name="LastWeek" dbtype="query">
			SELECT    *
		    FROM      getLastWeek
			WHERE ApplicationServer = '#applicationserver#'	
		</CFQUERY>
		
		<!--- last 7 days --->
		<cfquery name="Last30" dbtype="query">
			SELECT    *
		    FROM      getLast30
			WHERE ApplicationServer = '#applicationserver#'	
		</CFQUERY>
		
		<tr class="labelmedium line navigation_row" style="height:24px">
		    <td style="padding-left:5px;padding-right:14px"><cfif ApplicationServer eq "">undefined<cfelse>#ApplicationServer#</cfif></td>
			<td style="border-left:1px solid gray;padding-right:2px;background-color:##f2ffff80" height="15" align="right" bgcolor="F2FFFF"><cfif sessionuser eq "0">-<cfelse>#SessionUser#</cfif></td>
			<td style="padding-right:2px" align="right"><cfif session eq "0">-<cfelse>#Session#</cfif></td>
			<td style="border-left:1px solid gray;padding-right:2px;background-color:##f2ffff80" align="right"><cfif sessionrecentuser eq "0">-<cfelse>#SessionRecentUser#</cfif></td>
			<td style="padding-right:2px" align="right"><cfif sessionrecent eq "0">-<cfelse>#SessionRecent#</cfif></td>
			<td bgcolor="ffffcf" style="background-color:##ffffaf80;border-left:1px solid gray;padding-right:2px" align="right">#LastWeek.Total#</td>
			<td bgcolor="f1f1f1" style="background-color:##f1f1f180;border-left:1px solid gray;padding-right:2px" align="right">#Last30.Total#</td>
		</tr>
		
	</cfloop>
	
	<cfquery name="Total" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     (SELECT count(DISTINCT Account) FROM UserStatus WHERE ActionTimeStamp > #diff#) as SessionUser,
				   (SELECT count(*) FROM UserStatus WHERE ActionTimeStamp > #diff#) as Session,
				   (SELECT count(DISTINCT Account) FROM UserStatus) as SessionRecentUser,
				   (SELECT count(*) FROM UserStatus) as SessionRecent 
		FROM       UserStatus S	
	</cfquery>
		
	<tr style="border-top:1px solid silver" class="labelmedium">
	
		<td><cf_tl id="Total"></td>
		<td style="border-left:1px solid gray;padding-right:2px" align="right" bgcolor="F2FFFF">#Total.SessionUser#</td>
		<td style="padding-right:2px" align="right">#Total.Session#</td>
		<td style="border-left:1px solid gray;padding-right:2px" align="right" bgcolor="F2FFFF">#Total.SessionRecentUser#</td>
		<td style="padding-right:2px" align="right">#Total.SessionRecent#</td>		
		
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
		
		<td bgcolor="ffffcf" style="border-left:1px solid gray;padding-right:2px" align="right">#LastWeek.Total#</td>
		<td bgcolor="f1f1f1" style="border-left:1px solid gray;padding-right:2px" align="right">#Last30.Total#</td>
			
	</tr>
		
	</table>
		
</td>

<td height="100%" align="right" valign="bottom" style="padding-left:4px;border-bottom:1px dotted silver">
 
	<cfquery name="Total" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
	    SELECT  *
		FROM     UserStatus
  </cfquery>	

 <cfquery name="Visits" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 		
		
		SELECT    A.Description AS Module, COUNT(*) AS Counted
		FROM      UserStatus U INNER JOIN
                  Ref_ModuleControl R ON U.SystemFunctionId = R.SystemFunctionId INNER JOIN
				  Ref_SystemModule S ON S.SystemModule = R.SystemModule INNER JOIN
				  Ref_ApplicationModule AM ON AM.SystemModule = S.SystemModule INNER JOIN
				  #Client.LanPrefix#Ref_Application A ON AM.Code = A.Code
		WHERE     A.Operational = 1
		AND       A.Usage = 'System'		  
		GROUP BY  A.Description, A.ListingOrder
		ORDER BY  A.ListingOrder
				
  </cfquery>	
    
    
  <cfset seriesColours = ["Green","Yellow","Purple","Gray"]>
  <cfset seriesColour = 1>
    
  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
  
  <cfchart  style="#chartStyleFile#" 
  		  	format="png"
           	chartheight="190"
           	chartwidth="550"
           	scalefrom="0"
		   	showborder="0"		   
		   	Title="Summary"     
			font="calibri"
			fontsize="11"     
           	seriesplacement="default"
           	labelformat="percent"
		   	show3d="no"
		   	url="javascript:_cf_loadingtexthtml='';ColdFusion.navigate('UserAction'+document.getElementById('orderselect').value+'.cfm?view='+document.getElementById('view').value+'&filter=$ITEMLABEL$&view=#url.view#','detail')"       
           	tipstyle="mouseOver"
           	showmarkers="No">	
  
		   <cfchartseries type="pyramid" colorlist="##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">
			 
			 <cfloop query="visits">   		 
			 	 <cfset tot = "#counted#">
				 <cfchartdata item="#Module#" value="#tot#">				 
			 </cfloop>
					 
		   </cfchartseries>	 
				  
	</cfchart>  	
	
</td>
</tr>	

<tr><td colspan="2" style="min-width:800px"></td></tr>
</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>
