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
<cfparam name="url.print"   default="0">


<cfquery name="CountryRates" 
	datasource="AppsWorkOrder">

	SELECT 	DISTINCT R.Nation, 
			N.[Name] as CountryName, 
			S.Description as ServiceName, 
			S.ListingOrder,
			R.RateClass, 
			R.RateCategory, 
			R.Amount as Rate, 
			(SELECT TOP 1 R1.Reference FROM stServiceItemRate R1 WHERE R1.Nation = R.Nation ORDER BY Reference ASC) AS Prefix,
			(SELECT TOP 1 R2.Amount FROM stServiceItemRate R2 WHERE R2.Nation = R.Nation AND R2.ServiceItem = R.ServiceItem  ORDER BY R2.Amount ASC) AS BestRate
	FROM stServiceItemRate R
	INNER JOIN ServiceItem S ON R.ServiceItem = S.Code
	INNER JOIN System.dbo.Ref_Nation N ON R.Nation = N.Code
	WHERE R.Nation = '#url.country#'
	AND R.Operational=1
	ORDER BY S.ListingOrder, R.RateClass, R.RateCategory

</cfquery>


<cfif url.country neq "" and CountryRates.prefix eq "">
	<script>
		alert("Country prefix not found in the database");
	</script>
</cfif>

	<cfif url.country neq "">
		<table width="97%" border="0" cellspacing="2" cellpadding="0" align="center">	
			<cfoutput>
				<cfquery name="Parameter" 
		   				datasource="AppsInit">
		    				SELECT * 
		    				FROM Parameter
		    				WHERE HostName = '#CGI.HTTP_HOST#'
		  			 </cfquery>
			
				<cfif url.print eq "1" and fileExists ("#SESSION.rootpath#custom/logon/#Parameter.ApplicationServer#/printHeader.cfm")>		
				<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
					
					<cfinclude template="../../../../custom/logon/#Parameter.ApplicationServer#/printHeader.cfm">
				</cfif>
			</cfoutput>		
			<tr><td height="15" colspan="2"></td></tr>
			<tr>
				<td colspan="2" >
					<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
						<tr>
							<td height="22px" bgcolor="e2f0ff" class="label"><font face="Verdana" size="2" color="gray">&nbsp;&nbsp;<b>International</b> Calling Rates</font></td>
							<td align="right" bgcolor="e2f0ff" class="label">
							
							<cfoutput>
							<cfif url.print eq "1">
								    <title>Charges Statistics</title>
									<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
									<link rel="stylesheet" type="text/css"  href="#SESSION.root#/print.css" media="print">						
							</cfif>	
		
								<table cellspacing="1" cellpadding="1">
								<tr>
								<cfif url.print eq "0">
								<td>
									<a href="javascript:printme()"><font face="Verdana" color="6688aa"><img src="#SESSION.root#/Images/print_small4.gif" alt="" border="0">&nbsp;Print</a>&nbsp;&nbsp;
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
			
			<cfoutput>
			<tr><td colspan="2" height="10px"></td></tr>	
			<tr>
				<td valign="top" width="60%">			
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<!---
						<tr>
							<td style="padding-right:5px">
								<font size="3" face="calibri" color="gray"><b>Note:</b></font><br>
								<font size="2" face="calibri" color="gray">
								The Landline long distance rate for Canada, Puerto Rico and domestic USA including Hawaii and Alaska is:
								<b>$ 0.07 per minute</b>
								</font>
							</td>
						</tr>
						<tr><td height="10px"></td></tr>
						--->
						<tr>
							<td style="padding-right:5px">
								<font size="3" face="calibri" color="gray"><b>Instructions:</b></font>
								<font size="2" face="calibri" color="gray" style="line-height:18px">
								<br>
								 1. Dial 9 to get outside tone <br> 
								 2. Dial prefix for international access and country code:
								&nbsp;&nbsp;<cfif mid(CountryRates.prefix,1,3) neq "011"><font size="3" color="00537e">011+</cfif><b><cfif CountryRates.prefix neq "">#CountryRates.prefix#<cfelse><font color="red" size="2">not found</font></cfif></b></font><br>														
								 3. Dial the destination number<br>
								
								 4. Dial 1 to mark the call as <b>Personal</b> or<br>
								 &nbsp;&nbsp;&nbsp;&nbsp;Dial 2 to mark the call as <b>Business</b><br><br>

								<b>The international rate for calls depend on the Service you will use (Landline, Wireless, etc)</b>
								</font>
							</td>
						</tr>
					</table>
				</td>
				<cfif url.map eq "true">
				<td width="40%" align="center" id="mapview" name="mapview"><cfinclude template="RateInquiryCenterMap.cfm"></td>
				</cfif>
			</tr>
			</cfoutput>
			
			<tr><td colspan="2" height="15px"></td></tr>
			<tr>
				<td colspan="2">
	
					<table cellpadding="0" cellspacing="0" width="100%" border="0" align="center">

						<tr>
							<td align="center">
								<font size="3" face="calibri" color="gray"><b>Attention:</b></font>								
								<font size="2" face="calibri" color="gray">The rates displayed here are provided to us by the carriers themselves as current, official rates. 
								If you experience variations between these and your actual usage charges please contact your ICT Focal Point (Support Tab) as an over/under charge may
								have ocurred.</font>
								<br><br>
							</td>
						</tr>
						
						<tr>
							<td>							
								
									<table width="96%" cellspacing="0" cellpadding="0" align="center">
										<cfif CountryRates.Recordcount neq "0">
											<tr>
												<td width="15px" bgcolor="e2f0ff" class="label" style="padding-left:3px"></td>
												<td height="18" width="25%" bgcolor="e2f0ff" class="label" style="padding-left:3px"><font face="Verdana" color="3d3d3d"><b>Rate Class</b></font></td>
												<td width="25%" bgcolor="e2f0ff" class="label" style="padding-left:3px"><font face="Verdana" color="3d3d3d"><b>Destination Type</b></font></td>
												<td align="right" width="20%" bgcolor="e2f0ff" class="label" style="padding-left:3px"><font face="Verdana" color="3d3d3d"><b>Rate</b></font></td>
												<td width="15px" bgcolor="e2f0ff" class="label" style="padding-left:3px"></td>
											</tr>
											<cfoutput query="CountryRates" group="ServiceName">							
												<tr>
													<td colspan="5" class="labelmedium line" ><font face="Verdana">#ServiceName#</font></td>
												</tr>
												<cfset vBestRate = "0">
												<cfoutput>
												<tr>
												<td width="20px" ></td>
												<td height="20" width="25%" ><font face="Verdana">#RateClass#</font></td>
												<td width="25%" ><font face="Verdana">#RateCategory#</font></td>
												<td align="right" width="10%" ><font face="Verdana">#numberformat(Rate,"__,__.__")#</font></td>
												<td width="20px" align="right"><cfif Rate eq BestRate and vBestRate eq "0"><img src="#SESSION.root#/images/checked_green.gif" alt="Best Rate" border="0"><cfset vBestRate="1"></cfif></td>
												</tr>
												</cfoutput>
											</cfoutput>
										<cfelse>
											<tr>
												<td width="100%" align="center">No rates available for this country</td>
											</tr>
										</cfif>
									</table>
								
							</td>
						</tr>
						
						<tr>
							<td align="center">		
								<br>											
								<font size="2" face="calibri" color="gray">Please note that roaming rates depend on the carriers servicing locally.</font>
								<br><br>
							</td>
						</tr>
						
						<!---
						<cfif url.print neq "1">
						<tr><td height="10px"></td></tr>
						<tr>
							<td>
								<table cellpadding="0" cellspacing="0" width="80%" height="115px" border="0" align="center">
									<tr>										
										<td width="40%">
											<table cellpadding="0" cellspacing="0" height="100%">
												<tr>
													<td width="100px" style="padding-top:5px; padding-bottom:5px">
														<cf_tableround mode="solidcolor" color="silver" totalheight="100%" valign="middle">
															<a href="http://www.wireless.att.com/coverageviewer/#?type=voice" target="_blank">
																<img src="<cfoutput>#SESSION.root#</cfoutput>Custom/portal/MUC/Images/att.png" border="0" style="display:block">
															</a>
														</cf_tableround>
													</td>
													<td style="padding-left:5px">
														<table cellpadding="0" cellspacing="0" width="200px" border="0">
															<tr>
																<td>
																	<cf_tableround mode="solidcolor" color="silver">
																		<a href="http://www.verizonwireless.com/b2c/CoverageLocatorController?requesttype=NEWREQUEST?p_url=coverage_map_demo&=CDinaBox&cm_ite=Roaming" target="_blank">
																			<img src="<cfoutput>#SESSION.root#</cfoutput>custom/portal/MUC/Images/verizon.png" border="0" style="display:block">
																		</a>
																	</cf_tableround>
																</td>
															</tr>
															<tr>
																<td style="padding-top:5px">
																	<cf_tableround mode="solidcolor" color="silver">
																		<a href="http://www.t-mobile.com/coverage/pcc.aspx" target="_blank">
																			<img src="<cfoutput>#SESSION.root#</cfoutput>custom/portal/MUC/Images/tmobile.png" border="0" style="display:block">
																		</a>
																	</cf_tableround>
																</td>
															</tr>
														</table>
													</td>
												</tr>									
											</table>
										</td>
										<td align="center" width="60%" style="font-family:calibri; font-size:18px; color:#7a7a7a; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Custom/portal/Muc/Images/world.png'); background-repeat:no-repeat; background-position:center center">
												Click on your carrier for Coverage maps
										</td>
									</tr>
								</table>
							</td>
						</tr>
						</cfif>
						--->
					</table>

				</td>
			</tr>
			<!---
			<tr><td height="15px" colspan="2"><font size="2" face="calibri" color="gray"><b>Additional Carrier Information:</b></font>
			<select id="carr" name="carr">
				<option>Select Carrier</option>
				<option>ATT</option>
				<option>T-Mobile</option>
				<option>Verizon</option>
			</select></td></tr>
			<tr><td colspan="2" height="15px" id="carrdetails" name="carrdetails"></td></tr>
			--->
			<tr>
				<td colspan="2" height="10px">
				</td>
			</tr>
		</table>
		
	<cfelse>
	
		<cfquery name="Parameter" 
			datasource="AppsInit">
				SELECT * 
				FROM Parameter
				WHERE HostName = '#CGI.HTTP_HOST#'
			</cfquery>
	
		<cfparam name="path" default="#SESSION.root#/Custom/Logon/#Parameter.ApplicationServer#/watermark.png">
		<cfoutput>
		
			<style>
				td.watermark {
					background-image:url('#path#');
					background-position:top center;
					background-repeat:no-repeat;
					width:100%;
					height:100%;
					background-color:transparent;
					padding-top:20px;
				}
			</style>	

		<cfif fileExists('#path#')>
			<table cellpadding="0" cellspacing="0" border="0" width="100%" height="80%">
				<tr>				
					<td class="watermark" style="background-image:url('#path#'); background-repeat:no-repeat; background-position:center center">
						&nbsp;
					</td>
				</tr>
			</table>
		</cfif>
		</cfoutput>
	</cfif>