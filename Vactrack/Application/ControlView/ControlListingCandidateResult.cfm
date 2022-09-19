
<cfoutput>

<table width="98%" style="height:100%" border="0" align="center">
			
	<tr class="line"><td colspan="3">
		    <table width="100%">		
				<tr class="labelmedium2">
			    <td style="font-size:29px;padding-left:20px" align="left"><b>#count.total#</b> Tracks <font size="2">with <b><a href="javascript:parent.candidatetracklisting('#url.systemfunctionid#','all','#url.status#','')">#Countall.Total#</a></b> selections</font> </td>			
				<!---
				<cfif url.mode neq "Portal" and url.mode neq "Print">
				<td align="right" style="padding-right:2px"><a href="javascript:printme()">Printable Version</a></td>		
				<cfelseif url.mode eq "Print">
				<td align="right" style="padding-right:2px"><a href="javascript:window.print()">[Print]</a></td>				
				</cfif>
				--->
				</tr>
			</table>
	    </td>
	</tr>		
					
	<cfif getCandidate.recordcount gte 1>
	
		<tr>		
															
			<td align="center" valign="bottom">
			
			<table width="100%">				
						
			    <cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">									
						
				<tr class="line">
				<td class="labelmedium2" style="height:35px;padding-left:20px;font-size:17px"><cf_tl id="Selected candidates by Country"></td></tr> 
					
				<tr><td>											
		  			<div id="candidatemap" style="height:240px; width:530px;max-width:530px;"></div>							  
				  </td>
				</tr>						
			
			</table>			
					
			</td>		
			
			<td>
			
				<table gwidth="100%">
				
				    <tr class="line"><td class="labelmedium2" style="height:35px;padding-left:20px;font-size:17px"><cf_tl id="Gender"></td></tr> 					
					<tr><td>	
					
					<cfquery name="Summary" dbtype="query">
						SELECT     Gender, COUNT(*) as Counted
						FROM       getCandidate
						GROUP BY Gender
					</cfquery>
									
														
					<cf_uichart name="candidategraph4_#mission.missionprefix#"
						chartheight="240"
						chartwidth="220"
						showlabel="Yes"
						url="javascript:candidatelisting('#url.systemfunctionid#','gender','','$ITEMLABEL$')">
									
				      <cf_uichartseries type="pie" 
					       query="#Summary#" 
						   itemcolumn="Gender" 				   
						   valuecolumn="Counted"
						   colorlist="##E08FE0,##0B8EDD" />		
						   
					 </cf_uichart>	 
					 					 
					 </td>
					 </tr>  	
				
				</table>
			
			</td>		
			
			<td>
			
				<table gwidth="100%">
				
				    <tr class="line"><td class="labelmedium2" style="height:35px;padding-left:20px;font-size:17px"><cf_tl id="Country group"></td></tr> 					
					<tr><td>	
					
					<cfquery name="Summary" dbtype="query">
						SELECT     CountryGroup, COUNT(*) as Counted
						FROM       getCandidate
						GROUP BY CountryGroup
					</cfquery>				
														
					<cf_uichart name="candidategraph2_#mission.missionprefix#"
						chartheight="240"
						chartwidth="410"
						showlabel="No"
						url="javascript:candidatelisting('#url.systemfunctionid#','countrygroup','','$ITEMLABEL$')">
									
				      <cf_uichartseries type="bar" 
					       query="#Summary#" 
						   itemcolumn="CountryGroup" 				   
						   valuecolumn="Counted" colorlist="##87D37C"/>		
						   
					 </cf_uichart>	 
					 					 
					 </td>
					 </tr>  	
				
				</table>
			
			</td>		
							
	 <cfelse>
			
			<td colspan="3" class="labelmedium" align="center" height="400">		
				<font color="gray">No recruitment tracks found for this selection</font>			
			</td>	
			
	 </cfif>
				
	 </tr>
	 										
</table>	

</cfoutput>						