<cfparam name = "URL.Criteria" default = "No">

<cfinclude template="ControlGetTrack.cfm">

<cfinclude template = "ControlListingPrepare.cfm">


<cfoutput>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

	<tr><td colspan="3">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">		
			<tr class="labelmedium2">
		    <td style="font-size:29px;padding-left:20px" align="left"><b>#count.total#</b> Tracks at <b>#Sum.Total#</b> different stages </td>
			
			<cfif url.mode neq "Portal" and url.mode neq "Print">
			<td align="right" style="padding-right:2px"><a href="javascript:printme()"><font color="0080FF">Printable Version</font></a></td>		
			<cfelseif url.mode eq "Print">
			<td align="right" style="padding-right:2px"><a href="javascript:window.print()"><font color="0080FF">[Print]</font></a></td>				
			</cfif>
			</tr>
			</table>
	    </td>
	</tr>
	
	<cfif Summary.recordcount gte 1>
	
		<tr>
	
			<cfif Sum.Total gt 0>
							
			<cfif URL.Mode eq "Portal">
				<td align="center" class="regular">
			<cfelse>
				<td align="center" class="regular" style="border: 0pt solid silver;">
			</cfif>		
							
			<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
			
			<cfchart style = "#chartStyleFile#" format="png" 
			         chartheight="380" 
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
			             datalabelstyle="pattern"		            
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
			
				<td align="center" class="regular" style="border: 0px solid silver;">
											
					<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					
					<cfchart style = "#chartStyleFile#" format="png" 
				         chartheight="300" 
						 chartwidth="350" 
						 scalefrom="0"
						 scaleto="30" 
						 showxgridlines="yes" 
						 showygridlines="yes"
						 gridlines="6" 
						 showborder="no" 
						 fontsize="12" 
						 fontbold="no" 
						
						 fontitalic="no" 
						 xaxistitle="" 
						 yaxistitle="" 
						 show3d="no" 
						 rotated="no" 
						 sortxaxis="no" 
						 showlegend="no" 						 
						 showmarkers="yes" 
						 markersize="30" 
						 backgroundcolor="##ffffff">
						 
						 <cfif URL.Status neq "1">
				
							<cfchartseries type="bar" 
					         query="Aging" 
							 itemcolumn="Description" 
							 valuecolumn="Counted" 
							 datalabelstyle="value"	
							 seriescolor="##CCCC66" 					 
							 markerstyle="snow">
							</cfchartseries>
						
						<cfelse>
						
							<cfchartseries type="bar" 
					         query="Period" 
							 itemcolumn="Description" 
							 valuecolumn="Counted" 
							 seriescolor="gray" 					 
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
			
				<table width="99%" cellspacing="0" cellpadding="0" align="center" border="0">
				
					<tr><td style="padding-top:5px">
						
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
