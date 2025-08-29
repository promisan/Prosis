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
<cfparam name="url.print"       default="0">

<cfquery name="getYears" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT DISTINCT Year(TransactionDate) AS Year
	FROM WorkOrderLineDetail D
		INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
		INNER JOIN ServiceItem AS S ON D.ServiceItem = S.Code
	WHERE L.PersonNo = '#client.personNo#'
	AND        S.Selfservice = '1' 						
	AND		   S.Operational = 1	
	AND        D.ActionStatus != '9'
	ORDER BY 1 DESC		
	
</cfquery>	

<table width="97%" border="0" cellspacing="2" cellpadding="0" align="center">	

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
					<td class="labellarge"><b>Business</b> and <b>Personal</b> Charges over </font>
						<select class="regularxl" id="selYear" name="selYear" onchange="ChartData('#url.serviceItem#',#url.width#,this);">
							<cfloop query="getYears">
								<option value="#getYears.year#">#getYears.year#</option>
							</cfloop>
						</select>
					</td>
					<td align="right">
					
					<cfoutput>
					
					<cfif url.print eq "1">
					
						    <title>Charges Statistics</title>
							<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
							<link rel="stylesheet" type="text/css"  href="#SESSION.root#/print.css" media="print">						
							
					</cfif>	

						<table cellspacing="1" cellpadding="1">
						<tr>
						<cfif url.print eq "0">
							<td height="24" valign="middle" class="labelit">
							  <a href="javascript:ColdFusion.navigate('SummaryOpen.cfm?width=#url.width#&height=#url.height#&mode=data&serviceitem=#url.serviceitem#','center')"><font face="Verdana" color="6688aa"><img src="#SESSION.root#/images/favorite.png" align="absmiddle" width="13" height="12" alt="" border="0">&nbsp;Statistics</a>		
							</td>
							<td>&nbsp;|&nbsp;</td>
							<td class="labelmedium">
								<!---<a href="javascript:printme('#url.serviceitem#')"><img src="#SESSION.root#/Images/print_small4.gif" alt="" border="0">&nbsp;Print</a>&nbsp;&nbsp;--->
								<!--- <cf_print mode="hyperlink"> --->
								<span id="printTitle" style="display:none;">Charges Statistics</span>
								<cf_tl id="Print" var="1">
								<cf_button2 
									mode		= "icon"
									type		= "Print"
									title       = "#lt_text#" 
									id          = "Print"					
									height		= "25px"
									width		= "28px"
									printTitle	= "##printTitle"
									printContent = ".clsPrintContent">
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
	
	<tr>
		<td style="padding-left:10px" class="labelit">This information is updated on a weekly basis.</td>
	</tr>

	</cfoutput>		

			
	<tr>
		<td colspan="2" style="padding:15px;" id="chartcontainer" class="clsPrintContent">
						
			<cfinclude template="SummaryChartData.cfm" >
			
		</td>	
	</tr>
	
	<tr><td colspan="2" id="detail" class="labelit" align="center" >
		<cfif url.serviceitem neq "">[Click on the graph bars to view details]</cfif>
		</td>
	</tr>

</table>	
