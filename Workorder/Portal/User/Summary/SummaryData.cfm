
<cfparam name="url.print"       default="0">
<cfparam name="url.transtype"   default="All">

<cfquery name="GetYear" 
	datasource="AppsWorkOrder">
	SELECT TOP 1 Year(DatePortalProcessing) as YearStart
	FROM serviceItemMission
	WHERE ServiceItem IN (
		SELECT code
		FROM ServiceItem
		WHERE selfservice=1
	)
	AND DatePortalProcessing IS NOT NULL
	ORDER BY DatePortalProcessing
</cfquery>

<cfset vYearStart = GetYear.YearStart>
<cfset vCurrentYear = Year(Now())>

<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
	<tr>
		<td valign="top">
			<table width="96%" cellspacing="1" cellpadding="0" align="center">
			
			<cfoutput>
			
				<cfquery name="Parameter" 
     				datasource="AppsInit">
      				SELECT * 
      				FROM Parameter
      				WHERE HostName = '#CGI.HTTP_HOST#'
    			 </cfquery>
			
				<cfif url.print eq "1" and fileExists ("#SESSION.rootpath#custom/logon/#Parameter.ApplicationServer#/printHeader.cfm")>			
					<cfinclude template="../../../../custom/logon/#Parameter.ApplicationServer#/printHeader.cfm">
				</cfif>				
				
			
				<tr><td height="10" colspan="2"></td></tr>
				<tr>
					<td colspan="2">
						<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
						<tr>
							<td class="labelmedium">
							
							<table>
							<tr>
							
							<td class="labelmedium">
							
							<select class="regularxl" id="selRecords" name="selRecords" onchange="DataDrill(this,'#url.serviceItem#',selyear);">
								<option value="All" <cfif url.transtype eq "All">selected</cfif>>All</option>
								<option value="Business" <cfif url.transtype eq "Business">selected</cfif>>Business</option>
								<option value="Personal" <cfif url.transtype eq "Personal">selected</cfif>>Personal</option>
							</select>
						
							</td>
													
							<td class="labelmedium">
							charges over calendar year :
							</td>
							<td>
							<select class="regularxl" id="selyear" name="selyear" onchange="DataDrill(selRecords,'#url.serviceItem#',this);">
								<cfloop from="#vYearStart#" to="#vCurrentYear#" index="vYear">
									<option value="#vYear#" <cfif vYear eq vCurrentYear>selected</cfif>>#vYear#</option>
								</cfloop>
							</select>													
							</td>
							
							</table>
							</td>
														
							<td align="right">
							<cfif url.print eq "1">
	
								<cfoutput>
								    <title>Charges Statistics</title>
									<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
									<link rel="stylesheet" type="text/css"  href="#SESSION.root#/print.css" media="print">									
								</cfoutput>								
								
							</cfif>	
							<cfoutput>
								<table cellspacing="1" cellpadding="1">
								<tr>
								<cfif url.print eq "0">
								<td height="24" class="labelit">								
									<a href="javascript:ColdFusion.navigate('SummaryOpen.cfm?width='+$(document).width()+'&height=#url.height#&mode=chart&serviceitem=#url.serviceitem#','center')"><font face="Verdana" color="6688aa"><img src="#SESSION.root#/images/chart_bar.png" height="12" width="15" align="absmiddle" alt="" border="0">&nbsp;Charts</a>		
								</td>								
								<td>&nbsp;|&nbsp;</td>
								<td class="labelit">
									<!---<a href="javascript:printme('#url.serviceitem#','#url.transtype#')"><font face="Verdana" color="6688aa"><img src="#SESSION.root#/Images/print_small4.gif" alt="" border="0">&nbsp;Print</a>&nbsp;&nbsp;--->
									<cf_print mode="hyperlink">
								</td>
								</cfif>
								</tr>
								</table>
							</cfoutput>							
							</td>
						</tr>
						</table>
					</td>
				</tr>
				
				</cfoutput>		
				
				<tr>
				<td style="height:24" class="labelmedium">
					<i>&nbsp;&nbsp;Non-billable calls are also included in this view if All is selected.<!---Service Activity already <b>covered under the provisioning</b> (so called zero charges) are ALSO included in this view---></font>
				</td>
				</tr>
				
				<tr>
					<td id="container1" colspan="2" valign="center" align="center">
						<cfinclude template="SummaryDataDetail.cfm">		
					</td>
				</tr>
			
			</table>
		</td>
	</tr>
</table>


