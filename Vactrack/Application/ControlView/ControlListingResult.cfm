<cfparam name = "URL.Criteria" default = "No">

<cfinclude template="ControlGetTrack.cfm">
<cfinclude template = "ControlListingPrepare.cfm">

<cfoutput>

<table width="98%" border="0">

	<tr class="line"><td colspan="3">
		    <table width="100%">		
			<tr class="labelmedium2">
		    <td style="font-size:29px;padding-left:20px" align="left"><b>#count.total#</b> Tracks at <b>#Sum.Total#</b> different stages </td>
			
			<cfif url.mode neq "Portal" and url.mode neq "Print">
			<td align="right" style="padding-right:2px"><a href="javascript:printme()">Printable Version</a></td>		
			<cfelseif url.mode eq "Print">
			<td align="right" style="padding-right:2px"><a href="javascript:window.print()">[Print]</a></td>				
			</cfif>
			</tr>
			</table>
	    </td>
	</tr>
	
	<cfif URL.Mode eq "Portal">
		<cfset format = "PNG">
	<cfelse>
		<cfset format = "PNG">
	</cfif>
	
	
	<cfif Summary.recordcount gte 1>
	
		<tr class="line">
	
			<cfif Sum.Total gt 0>
							
			<td align="center" valign="bottom">
										
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			
			<cfchart style = "#chartStyleFile#" format="#format#" 
			         chartheight="340" 
					 chartwidth="770" 
					 scalefrom="0"
					 scaleto="50" 
					 showxgridlines="yes" 
					 showygridlines="yes"
					 gridlines="6" 
					 showborder="no" 
					 fontsize="13" 
					 fontbold="no" 
					 font="calibri"
					 fontitalic="no" 					 
					 show3d="no" 					 
					 xaxistitle="" 		
					 showlegend="yes" 		 
					 yaxistitle="Tracks" 
					 rotated="no" 
					 sortxaxis="no" 				 
					 tipbgcolor="##000000" 
					 showmarkers="yes" 
					 markersize="30" 
					 backgroundcolor="##ffffff">
					 
					 <cfif (URL.Status neq "1" and URL.Parent eq "All")>
			
						<cfchartseries
			             type="pie"
			             query="Summary"
			             itemcolumn="Description"
			             valuecolumn="Counted"
			             seriescolor="##00CCC6"
			             datalabelstyle="value"		            
			             markerstyle="diamond"						 
			             colorlist="##3399FF,##CCCC66,##FD7E00,##66CC66,##999999,##9966FF,##FF7777,##674172,##336E7B,##ABB7B7">
	
						</cfchartseries>
					
					<cfelse>
					
						<cfchartseries type="bar" 
				         query="Summary" 
						 itemcolumn="PostGradeBudget" 
						 valuecolumn="Counted" 
						 datalabelstyle="value"
						 seriescolor="##CCCC66" 					
						 markerstyle="snow"
						 colorlist="##3399FF,##CCCC66,##FD7E00,##66CC66,##999999,##9966FF,##FF7777,##674172,##336E7B,##ABB7B7"></cfchartseries>
					
					</cfif>				
					
			</cfchart>
	
			</td>
						
			<!--- ----------- --->
			<!--- aging graph --->
			<!--- ----------- --->
			
			<cfif URL.Mode neq "Portal" and URL.Mode neq "Dashboard"> 
			
				<td align="center"  valign="bottom">
											
					<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					
					<cfchart style = "#chartStyleFile#" format="#format#" 
				         chartheight="280" 
						 chartwidth="300" 
						 scalefrom="0"
						 scaleto="30" 
						 showxgridlines="yes" 
						 showygridlines="yes"
						 gridlines="6" 
						 showborder="no" 
						 fontsize="13" 
						 fontbold="no" 						
						 fontitalic="no" 
						 xaxistitle="" 
						 yaxistitle="" 
						 show3d="no" 
						 rotated="no" 
						 sortxaxis="no" 
						 showlegend="yes" 						 
						 showmarkers="yes" 
						 markersize="30" 
						 backgroundcolor="##ffffff">
						 
						 <cfif URL.Status neq "1">
				
							<cfchartseries type="bar" 
					         query="Aging" 
							 itemcolumn="Description" 
							 valuecolumn="Counted" 
							 datalabelstyle="value"	
							 seriescolor="green" 					 
							 markerstyle="snow">
							</cfchartseries>
						
						<cfelse>
						
							<cfchartseries type="bar" 
					         query="Period" 
							 itemcolumn="Description" 
							 valuecolumn="Counted" 
							 seriescolor="##a0a0a0" 					 
							 markerstyle="snow">
							 </cfchartseries>
							
						</cfif>	
						
					</cfchart>
															
				</td>
									
			</cfif>
			
			<cfelse>
			
				<td colspan="3" class="labelmedium" align="center" height="400">		
					<font color="gray">No recruitment tracks found for this selection</font>			
				</td>	
			
			</cfif>
		
		</tr>
						
		<tr><td colspan="3">
			
				<table width="99%" align="center">
				
					<tr><td>
						
						<cfif URL.Status neq "1">
							
							<cfif URL.Parent eq "All" or URL.Mode eq "Portal">																									
							 	<cfinclude template="ControlListingResultStep.cfm">					
							<cfelse>									
							    <cfinclude template="ControlListingResultStepGrade.cfm">
							</cfif>	
									
						<cfelse>		
							
						 	<cfinclude template="ControlListingResultGrade.cfm">		
							
						</cfif>
					
					</td></tr>
				
				</table>
			
			</td>
		</tr>
		
	</cfif>
			
</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>


<script>
	Prosis.busy('no')
</script>	
