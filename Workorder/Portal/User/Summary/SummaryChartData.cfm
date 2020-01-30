<cfparam name="url.year"       	default="#year(now())#">
<cfparam name="url.serviceItem" default="">

<cfset vImagePath = "#session.rootpath#\CFRStage\user\#session.acc#\_mucStatisticsGraph">
<cfset vImageURL = "#session.root#/CFRStage/user/#session.acc#/_mucStatisticsGraph">

<table cellpadding="0" cellspacing="0" style="border:1px dotted silver" width="100%">
			
				<cfif url.serviceitem eq "">
			
				<tr><td style="padding:1px" id="summarychart">
				
				<!--- filter on service --->
				
				   <table width="100%" cellspacing="0" cellpadding="0" border="0">
				   
				   <tr><td align="center" class="labelmedium">Overall Charges</td>
				       <td align="center" class="labelmedium" style="border-left:1px dotted silver">Personal Charges</td>
				   </tr>
				   
				   <tr><td colspan="2" class="line"></td></tr>
				   
				   <tr>

					<cfquery name="Charges" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT 	S.Code,
								S.Description,
								S.ServiceColor,								
								D.Charged,
								SUM(D.Amount) AS Charges
						FROM WorkOrderLineDetail D
							INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
							INNER JOIN ServiceItem AS S ON D.ServiceItem = S.Code
						WHERE L.PersonNo = '#client.personNo#'
						AND        S.Selfservice = '1' 						
						AND        year(D.TransactionDate) = '#url.year#' 
						AND		   S.Operational   = 1		
						AND		   D.ActionStatus != '9'				
						GROUP BY   S.Code, 
						           S.Description,
								   S.ServiceColor,								   
								   D.Charged 								  
						ORDER BY   S.Code, 
						           S.Description
						
						
					</cfquery>
					
					<td width="50%" style="padding:10px" align="center" valign="bottom">
						   
						   <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
							<cfchart style = "#chartStyleFile#" format="png"
							   name = "myChart1"	
							   showLegend="yes"
					           chartheight="300"
					           chartwidth="#(url.width-400)/2#"
					           showxgridlines="yes"
					           seriesplacement="stacked"
					           font="Verdana"
					           fontsize="11"
					           labelformat="currency"					           
					           tipstyle="mouseOver"
					           tipbgcolor="D6D6D6"
					           showmarkers="yes"
					           markersize="30"				           
					           backgroundcolor="ffffff"
							   show3D ="no">
						   
						   <!--- total --->
						   
						   <cfquery name="Totals" dbtype="query">
							SELECT     Code, 
							           Description, 
									   ServiceColor,									  						  	   
									   SUM(Charges) AS Charges
							FROM       Charges
							GROUP BY   Code, 
							           Description,
									   ServiceColor
							</cfquery>								   
						 
						 	<cfset vColorList = ValueList(Totals.ServiceColor,",")>
							
						   <cfchartseries type="pie"
					             serieslabel="Total Business Charges"								 
					             colorlist = "#vColorList#"								 
					             datalabelstyle="value"					             
					             markerstyle="circle">
								 
								 <cfoutput query="Totals">
								 															
								  <cfchartdata item="#description#" 
								               value="#charges#" >	
																			   
								 </cfoutput>			   
												  
						  </cfchartseries>							
						
					</cfchart>	
					
					<cffile action="WRITE" file="#vImagePath#1.png" output="#myChart1#" nameconflict="OVERWRITE">
					<cfoutput><img src="#vImageURL#1.png" style="height:300px; width:#(url.width-400)/2#px;"></cfoutput>	
					
					</td>	
					
					<td width="50%" align="center" valign="bottom" style="padding:10px;border-left:1px dotted silver">						
					
					<cfset vColorList = ValueList(Charges.ServiceColor,",")>
					
					<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					<cfchart style = "#chartStyleFile#" format="png"
						   name = "myChart1"		
						   showLegend="yes"
				           chartheight="300"
				           chartwidth="#(url.width-400)/2#"
				           showxgridlines="yes"
				           seriesplacement="stacked"
				           font="Verdana"
				           fontsize="11"
				           labelformat="currency"				          	   
				           tipstyle="mouseDown"
				           tipbgcolor="D6D6D6"
				           showmarkers="yes"
				           markersize="30"
				           pieslicestyle="sliced"
				           backgroundcolor="ffffff"
						   show3D ="no">
					   						   
						   <cfchartseries type="bar"
					             serieslabel="Total Personal Charges"
					             colorlist = "#vColorList#"
					             datalabelstyle="value"					             
					             markerstyle="circle">
								 
								<cfoutput query="Charges">
								 
								  <cfif charged eq "2">				  
								 															
									  <cfchartdata item="#description#" 
									               value="#charges#">	
											   
								  </cfif>			   								   
											   
							   </cfoutput>		   
												  
						   </cfchartseries>	
						      
						   </cfchart>
						   
						  <cffile action="WRITE" file="#vImagePath#2.png" output="#myChart1#" nameconflict="OVERWRITE">
						  <cfoutput><img src="#vImageURL#2.png" style="height:300px; width:#(url.width-400)/2#px;"></cfoutput>	
						   
						   </td>
						   
						 </tr></table>		
			
				</td></tr>
				
				</cfif>		
												
				<tr><td class="line labellarge" style="padding-top:10px" align="center">Distribution of charges by Calendar month of use</td>
				   
				</tr>		
			
				<tr>
					<td align="center"  style="padding:4px" id="summarychart">
		
					<cfparam name="url.ServiceItem" default="">
					
					<!--- filter on service --->

					<cfquery name="Charges" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT     S.Code,
						           S.Description, 
								   D.Charged,
								   YEAR(D.TransactionDate) as ChargeYear,
								   MONTH(D.TransactionDate) AS ChargeMonth,		   
								   SUM(D.Amount) AS Charges
						FROM WorkOrderLineDetail D
								INNER JOIN WorkorderLine L on D.WorkorderId = L.WorkorderId AND D.WorkorderLine = L.WorkOrderLine
								INNER JOIN ServiceItem AS S ON D.ServiceItem = S.Code
						WHERE      L.PersonNo = '#client.personno#' 
						AND        S.Selfservice = '1' 
						AND        year(D.TransactionDate) = '#url.year#' 
						<cfif url.serviceitem neq "">
						AND        S.Code = '#url.serviceitem#'
						</cfif>
						GROUP BY   S.Code, 
						           S.Description, 
								   D.Charged, 
								   YEAR(D.TransactionDate), 
								   MONTH(D.TransactionDate) 
						ORDER BY   S.Code, 
						           S.Description, 			   
								   YEAR(D.TransactionDate), 
								   MONTH(D.TransactionDate),		   
								   D.Charged 
						
					</cfquery>

					<cfquery name="Period" dbtype="query">
						SELECT DISTINCT ChargeYear,ChargeMonth
						FROM Charges	
					</cfquery>
					
					<cfif url.serviceitem eq "">
						<cfset drill = "">
						<cfset ht = "200">
					<cfelse>
						<cfset drill = "javascript:ColdFusion.navigate('SummaryChartDetails.cfm?serviceitem=#url.serviceitem#&year=#url.year#&month=$ITEMLABEL$','detail')">
						<cfset ht = "260">
					</cfif>
															
					<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					<cfchart style = "#chartStyleFile#" format="png"
						   name = "myChart1"	
				           chartheight="#ht#"
				           chartwidth="#url.width-400#"
				           showxgridlines="yes"
				           seriesplacement="cluster"
				           font="Calibri"
				           fontsize="12"
				           tipstyle="mouseOver"
				           tipbgcolor="D6D6D6"
				           showmarkers="yes"
				           markersize="30"
				           pieslicestyle="sliced"
				           url="#drill#"
				           backgroundcolor="ffffff"
						   show3D ="no">
						 
							<cfchartseries
				             type="bar"
				             serieslabel="Total Service Charges"
				             seriescolor="6688aa"				             
					         markerstyle="circle">
								 
								 <cfoutput query="Period">
						
									<!--- total --->	
									
									<cfset mth = left(monthasstring(ChargeMonth),3)>
							
								  <cfquery name="Month" dbtype="query">
									SELECT SUM(Charges) as total
									FROM   Charges	
									WHERE  ChargeYear  = #ChargeYear#
									AND    ChargeMonth = #ChargeMonth#
									<!--- AND    Charged = '1' --->
								  </cfquery>	
								 
								 <cfif month.total eq "">
								  <cfchartdata item="#mth#" value="0.00">
								  <cfelse>			  
								  <cfchartdata item="#mth#" value="#Month.total#">
								 </cfif>			   
											   
								  </cfoutput>			   
												  
							</cfchartseries>	
						
						    		
						    <!--- personal --->
							
							<cfchartseries
						          type="bar"   
								  serieslabel="Personal Service Charges"  
						          seriescolor="yellow"									          
						          markerstyle="snow">
								  
								  <cfoutput query="Period">
							
								  <cfquery name="Month" dbtype="query">
									SELECT SUM(Charges) as total
									FROM   Charges	
									WHERE  ChargeYear  = #ChargeYear#
									AND    ChargeMonth = #ChargeMonth#
									AND    Charged     = '2'
								  </cfquery>		
								  
								  <cfif month.total eq "">
								  <cfchartdata item="#mth#" value="0.00">
								  <cfelse>
								  <cfchartdata item="#mth#" value="#Month.total#">
								  </cfif>  
								  
								  </cfoutput>
								  			  
							</cfchartseries>	
														 
					</cfchart>
					
					<cffile action="WRITE" file="#vImagePath#3.png" output="#myChart1#" nameconflict="OVERWRITE">
					<cfoutput><img src="#vImageURL#3.png" style="height:#ht#px; width:#url.width-400#px;"></cfoutput>	
					
					</td>
				</tr>
			</table>