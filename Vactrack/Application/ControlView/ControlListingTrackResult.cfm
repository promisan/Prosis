<!--
    Copyright © 2025 Promisan

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

<cfparam name = "URL.Criteria" default = "No">
<cfparam name = "URL.SystemfunctionId" default = "">
	
<cfinclude template = "ControlListingTrackGet.cfm">
<cfinclude template = "ControlListingTrackPrepare.cfm">

<cfif count.total eq "0">
	
	<table width="98%" align="center" border="0"><tr><td class="labelmedium2" style="padding-top:10px;font-size:20px" align="center"><cf_tl id="No records to show"></td></tr>
	<cfsavecontent variable="session.trackcontent"></cfsavecontent>

<cfelse>

	<cfoutput>
	
	<table width="98%" height="100%" border="0" align="center">
	
		<tr class="line"><td colspan="3">
			    <table width="100%">		
					<tr class="labelmedium2">
				    <td style="font-size:29px;padding-left:20px" align="left"><b>#count.total#</b> Tracks <font size="2">at <b>
					<cfif URL.Mode eq "Portal">
					<a href="javascript:tracklisting('#url.systemfunctionid#','all','#url.status#','','#url.mission#')">#Sum.Total#</a>
					<cfelse>
					<a href="javascript:parent.tracklisting('#url.systemfunctionid#','all','#url.status#','','#url.mission#')">#Sum.Total#</a>
					</cfif></b> different stages</font>
					</td>								
					<cfif url.mode neq "Portal" and url.mode neq "Print">
					<td align="right" style="padding-right:2px"><a href="javascript:printme()">Printable Version</a></td>		
					<cfelseif url.mode eq "Print">
					<td align="right" style="padding-right:2px"><a href="javascript:window.print()">[Print]</a></td>				
					</cfif>
					</tr>
				</table>
		    </td>
		</tr>	
				
		<cfif Summary.recordcount gte 1>
		
			<tr>		
	
				<cfif Sum.Total gt 0>
															
				<td align="center" valign="bottom">
				
				<table width="100%">				
							
				<cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
									
				<cfif (URL.Status neq "1" and URL.Parent eq "All")>
				
					<tr class="line"><td class="labelmedium2" style="padding-left:20px;font-size:19px"><cf_tl id="Tracks by process status"></td></tr> 
						
					<tr><td style="min-width:400px">		
					
					<cfif URL.Mode neq "Portal">
					   <cfset sc = "parent.tracklisting('#url.systemfunctionid#','status','#url.status#','$ITEMLABEL$','#url.mission#')">
					<cfelse>
					   <cfset sc = "tracklisting('#url.systemfunctionid#','status','#url.status#','$ITEMLABEL$','#url.mission#')">
					</cfif>
					
					<cf_uichart name="vacancygraph1_#mission.missionprefix#"
						chartheight="420"											
						url="javascript:#sc#">
									
					      <cf_uichartseries type="pie" 
						      query="#Summary#" 
							  itemcolumn="Description" 
							  valuecolumn="Counted" 
							  colorlist="#vColorList#"/>
						  
					  </cf_uichart>		
					  
					  </td>
					  </tr>			 
				
				<cfelse>
				
					<tr class="line"><td class="labelmedium2" style="padding-left:20px;font-size:16px"><cf_tl id="Tracks by grade"></td></tr> 
						
					<tr><td>	
										
					<cf_uichart name="vacancygraph2_#mission.missionprefix#"
						chartheight="300"						
						url="javascript:tracklisting('#url.systemfunctionid#','postgrade','#url.parent#','$ITEMLABEL$')">
									
				      <cf_uichartseries type="bar" 
					       query="#Summary#" 
						   itemcolumn="PostGradeBudget" 				   
						   valuecolumn="Counted" colorlist="##87D37C"/>		
						   
					 </cf_uichart>	 
					 
					 </td>
					 </tr>  			
				
				</cfif>	
				
				</table>			
						
				</td>
							
				<!--- ----------- --->
				<!--- aging graph --->
				<!--- ----------- --->					
				
				<cfquery name="agingTotal"
					datasource="AppsVacancy"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					    SELECT   count(*) as Counted
						FROM     (#preserveSingleQuotes(subset)#) as D
						
				</cfquery>
							
				<td align="center" valign="top">
					
					<table  width="100%">
					
					<cfif url.status eq "0" and agingtotal.counted gt 0>
													
					<tr>		
					
					<td align="center" valign="bottom">
				
						<table width="100%">	
						
							<tr class="line"><td class="labelmedium2" style="height:26px;font-size:16px"><cf_tl id="Aging Tracks w/o selection">###agingTotal.counted#</td></tr> 
							
							<tr><td>	
							
							<!--- posted date - current date for non-selected tracks. --->
														
							<cfset vColorlist = "##00FF40,##FFFF80,##FFC891,##FF8000,##FF0000">
																					
							<cfif URL.Parent eq "All">
							
								<cfif URL.Mode neq "Portal">
								   <cfset sc = "parent.tracklisting('#url.systemfunctionid#','aging','#url.status#','$ITEMLABEL$','#url.mission#')">
								<cfelse>
								   <cfset sc = "tracklisting('#url.systemfunctionid#','aging','#url.status#','$ITEMLABEL$','#url.mission#')">
								</cfif>
														
								<cf_uichart name="vacancygraph4_#mission.missionprefix#"
									chartheight="240"									
									url="javascript:#sc#">			
									
									<cf_uichartseries type="pie" query="#Aging#" itemcolumn="Description" valuecolumn="Counted" colorlist="#vColorList#"/>
																		
				      		  	</cf_uichart>
							
							<cfelse>
							
								<cf_uichart name="vacancygraph4_#mission.missionprefix#"
									chartheight="140"									
									url="javascript:tracklisting('#url.systemfunctionid#','aging','#url.parent#','$ITEMLABEL$')">			
									
									<cf_uichartseries type="pie" query="#Aging#" itemcolumn="Description" valuecolumn="Counted" colorlist="#vColorList#"/>
																		
				      		  	</cf_uichart>
							
							</cfif>
							
							</td></tr>
										
						</table>					
					
					</td>
					</tr>
					
					</cfif>
					
					<cfparam name="form.documenttype" default="">
					
					<cfif form.documenttype eq "">
					
					<tr>				
					<td align="center" valign="top">
					
					     <table width="100%">	
						
							<tr class="line"><td class="labelmedium2" style="height:25px;font-size:16px"><cf_tl id="Tracks by recruitment type"></td></tr> 
							
							<tr><td>							
					
							<cfset vColorlist = "##663399,##4DAF7C,##87D37C">
							
							<cf_uichart name="vacancygraph3_#mission.missionprefix#"
								chartheight="140"
								showlabel="No"
								showvalue="No"
								chartwidth="330">			
								
								<cf_uichartseries type="bar" query="#DocumentType#" itemcolumn="TypeDescription" valuecolumn="Counted" colorlist="#vColorList#"/>
																	
			      		  	</cf_uichart>
							
							</td></tr>
										
						</table>		
					
					</td>
					
					</tr>
					
					</cfif>
					
					</table>			
																
					</td>
								
				<cfelse>
				
					<td colspan="3" class="labelmedium" align="center" height="400">		
						<font color="gray">No recruitment tracks found for this selection</font>			
					</td>	
				
				</cfif>
			
			</tr>	
			
			<cfif URL.Status neq "1">						
												
				<cfif URL.Parent eq "All">	
				
				   <cfsavecontent variable="session.trackcontent">
				  	    <cfinclude template="ControlListingResultStep.cfm">																						
				   </cfsavecontent> 									  							  
				   
				</cfif>							
											
			</cfif>	
											
			
		</cfif>
				
	</table>
		
	</cfoutput>
	
</cfif>	

<cfset ajaxonload("doHighlight")>

<cfif url.mode neq "Portal" and url.parent eq "All">
	 <cfset ajaxonload("doResult")> 
</cfif>

<script>
	Prosis.busy('no')
</script>	
