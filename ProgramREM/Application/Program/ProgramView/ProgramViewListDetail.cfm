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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfoutput>

<cfset lev = 0>
<cfset pos = 1>
<cfset row = 0>

<cfloop index="i" from="1" to="4" step="1">

    <cfset pos = Find(".", "#ProgramHierarchy#" , "#pos#")>
	<cfif pos neq "0">
	 	 <cfset lev = lev + 1>
		 <cfset pos = pos + 1>
	<cfelse> 
	     <cfset pos = "99">	
	</cfif>
	
</cfloop>

<cfif Lev eq "0">

       <cfset Per = Period>
			
	<cf_assignid>
							
	<cfif showUnit neq "" or ProgramScope eq "Global" or (showParent neq "" and ProgramScope eq "Parent")>
		<!---- JM.dev changed this from OrgUnit=URL.id1 to OrgUnit=OrgUnit January 25 2013--->
		<cfif URL.id1 eq "Tree">
			<cfset vOrgUnit = OrgUnit>
		<cfelse>
			<cfset vOrgUnit = URL.ID1>	
		</cfif>
					
		<cfset menufile = "#SESSION.root#/programrem/application/program/programview/ProgramViewListDetailMenu.cfm?ProgramId=#ProgramId#&lev=#lev#&manageraccess=#manageraccess#&programaccess=#programaccess#&Unit=#vOrgUnit#&ajaxid=mymenu">
											
		<cfset show = "1">				
		<cfset cl   = "ffffff">
		<cfset ht   = "26">
		
	<cfelse>
	
		<cfif URL.id1 eq "Tree">
			<cfset vOrgUnit = OrgUnit>
		<cfelse>
			<cfset vOrgUnit = URL.ID1>	
		</cfif>
	
		<cfset menufile = "#SESSION.root#/programrem/application/program/programview/ProgramViewListDetailMenu.cfm?ProgramId=#ProgramId#&lev=#lev#&manageraccess=#manageraccess#&programaccess=#programaccess#&Unit=#vOrgUnit#&ajaxid=mymenu">
	
		<cfset show = "0">
		<cfset cl = "fafafa">
		<cfset ht = "20">	
	
	</cfif>
	
	<!--- mechnism to show the header through jv script, if we detected values under a header / program
	after we reached the next program, ---> 
			
	<tr><td height="2"></td></tr>		
	<cfif url.view eq "Prg">
	<tr id="box#programid#" style="border-bottom:1px solid silver" class="line fixrow2" onContextMenu="cmexpand('mymenu','#rowguid#','#menufile#')">	
	<cfelse>
	
		<cfif url.programgroup eq "">		
			<tr class="hide line" style="border-bottom:1px solid silver" id="box#programid#" onContextMenu="cmexpand('mymenu','#rowguid#','#menufile#')">									
		<cfelse>
					
			<cfquery name="check" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			   	  SELECT   *
				  FROM     ProgramGroup
				  WHERE    ProgramCode  = '#ProgramCode#'
				  AND      ProgramGroup = '#url.programgroup#'	 
			</cfquery>
							
			<cfif check.recordcount eq "1">
				<tr class="line fixrow2" style="border-bottom:1px solid silver" id="box#programid#" onContextMenu="cmexpand('mymenu','#rowguid#','#menufile#')">							
			<cfelse>
				<tr class="hide line" style="border-bottom:1px solid silver" id="box#programid#" onContextMenu="cmexpand('mymenu','#rowguid#','#menufile#')">					
			</cfif>
								
		</cfif>
			
	</cfif>
	
	<td colspan="7">	
			
	<table>
	
		<tr>
		
		<td>
											
			<table>
			
				<tr>	
				
				<td valign="top" style="padding-top:12px" onclick="cmexpand('mymenu','#rowguid#','#menufile#')"><cf_img icon="open"></td>	
																
					<cfif show eq "1">	
										  									
						<cfif ProgramScope eq "Unit">
						   <td onclick="cmexpand('mymenu','#rowguid#','#menufile#')" style="height:46px;padding-top:6px;padding-bottom:6px;cursor:pointer;padding-left:3px;font-size:19px" class="labelmedium"  id="nme_#programid#">				  
						    #ProgramName#		 
						   </td>
						<cfelse>	
						    <td onclick="cmexpand('mymenu','#rowguid#','#menufile#')" style="height:46px;padding-top:6px;padding-bottom:6px;cursor:pointer;padding-left:3px;font-size:19px" class="labelmedium" id="nme_#programid#">				   		
							#ProgramName#					
							</td>							
						</cfif>				
					
					<cfelse>
					
						<cfif ProgramScope eq "Unit">
						   <td onclick="cmexpand('mymenu','#rowguid#','#menufile#')" class="labelmedium" style="height:46px;padding-top:6px;padding-bottom:6px;cursor:pointer;padding-left:3px;font-size:19px" id="nme_#programid#">				 
						    #ProgramName#				
						   </td>
						<cfelse>	
						    <td onclick="cmexpand('mymenu','#rowguid#','#menufile#')" class="labelmedium" style="height:46px;bold;padding-top:6px;padding-bottom:6px;cursor:pointer;padding-left:3px;font-size:19px" id="nme_#programid#">				    		
							#ProgramName#					
							</td>							
						</cfif>				
					
					</cfif>		
								
				</tr>
			
			</table>	
			
		</td>	
					
		</tr>
		
	</table>
	
	</td>		
	
	<cfif len(ProgramName) gt 60>	
	
	<TD height="#ht#" align="right"
	    colspan="1" id="ref_#programid#" style="height:35px;cursor:pointer;padding-top:8px;padding-right:5px" valign="top" class="labelit">	
		
	<cfelse>
	
	<TD height="#ht#" align="right"
	    colspan="1" id="ref_#programid#" style="height:35px;cursor:pointer;padding-top:8px;padding-right:5px" class="labelit">	
		
	</cfif>	
														
		<cfif currentrow lte "10">						
				<cf_space spaces="35">	
		</cfif>		
						    
		<cfif show eq "1">	
							
		    <cfif ProgramScope eq "Unit">
		    	<cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif>
			<cfelse>
				<cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif>
			</cfif>
					
		<cfelse>			
		
		    <cfif ProgramScope eq "Unit">
		   		<cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif>
			<cfelse>
				<cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif>
			</cfif>
					
		</cfif>
					
	</TD>		
					
	</TR>
	
	<tr style="position: sticky; top: 36px; z-index:99999">
		<td id="mymenu" name="mymenu">
		    <table><tr>
		     <td colspan="9" style="padding-top:2px" id="mymenu#rowguid#"></td>
			 </tr></table>
		</td>
	</tr>
												  
	<tr id="i#ProgramCode#" class="hide">
	  	  <td colspan="9" id="d#ProgramCode#"></td>
	</tr>	
		
	
	<cfset prior = programid>
	<cfset value = "">
						
</cfif>

<!--- Sublevel --->

<cfif (lev eq "1" or lev eq "2" or lev eq "3" or lev eq "4")>
				
		<cfset row = row+1>
		
        <cfset cls = ProgramClass>	 
		<cfset Per = Period>	
										
		<cfif url.view eq "only" and showunit eq "" and ProgramScope eq "unit">	
						
		<!--- hide --->
		
		<cfelse>					
							 
				   <cfset col = "8">
				   
				   <cfif URL.id1 eq "Tree">
						<cfset vOrgUnit = OrgUnit>
				   <cfelse>
						<cfset vOrgUnit = URL.ID1>	
				   </cfif>
				   
				   <cf_assignid>
				   <cfset menufile = "#SESSION.root#/programrem/application/program/programview/ProgramViewListDetailMenu.cfm?ProgramId=#ProgramId#&lev=#lev#&manageraccess=#manageraccess#&programaccess=#programaccess#&Unit=#vOrgUnit#&AjaxId=mymenu">
				   		
				   <cfif ProgramScope eq "Global">
				   
				    	<cfset add = "show">
						<cfset cl = "transparent">
						<td></td>
						<cfset ftstyle = "height:25px;font-weight: bold;">
								   
				   <cfelseif showUnit neq "" or ProgramScope neq "Unit">
				   				   
				   		<cfset show = "1">
				        <cfif lev eq "4">						
						  	<cfset add = "hide">
							<cfset cl = "ffffef">
							<cfset ftstyle = "height:17px;">
						<cfelseif lev eq "3">						
						    <cfset add = "hide">
							<cfset cl = "ffffcf">
							<cfset ftstyle = "height:20px;">
						<cfelseif lev eq "2">										
						   	<cfset add = "show">							
							<cfset cl = "F8D789">
							<cfset ftstyle = "height:22px;">
						<cfelse>							   		
							<cfset add = "show">
							<cfset cl = "D5EDF7">
							<cfset ftstyle = "height:25px;">						   
						</cfif> <!--- additional space --->
						
						<cfset ht = "18">
						
						<cfset ftstyleb = ftstyle>
																		
						<cfset value = programid>							
															
				   <cfelse>
				   
					   	<cfset value = programid>	
				   			
						<cfset show     = "0">
						<cfset cl       = "f8f8f8">
						<cfset ht       = "14">
						<cfset ftstyle  = "border:0px solid gray;background-color:##eaeaea80;height:16px;font-variant: normal;font-size:#ht#">
						<cfset ftstyleb = "height:16px;font-variant: normal;font-size:#ht#">
								
				   </cfif>					   
				  				   
				    <tr class="navigation_row labelmedium2" style="border-bottom:1px dotted silver">
				   			        																	
				        <td colspan="1" style="padding-left:20px;padding-right:4px">								
						<cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">&nbsp;<b>.&nbsp;</cfloop>					
						</td>
						
						<td width="20" style="padding-left:3px">
																								
							<table width="100%" cellspacing="0" cellpadding="0">
							<tr>
																										
								<cftry>
							    
									<cfif Status eq "0">
									  
									  <td style="padding-top:2px;padding-left:5px"><img src="#SESSION.root#/Images/pending.gif" 
									    alt="Pending" width="15" height="15" border="0" align="absmiddle"></td>
								    </cfif>
								
									<cfcatch></cfcatch>
									
								</cftry>
								
								<cfif ProgramScope neq "Unit">								
																
								    <!--- not used for global and parent --->
								
								<cfelse>
																	
									<cfif Parameter.EnableIndicator eq "1" and ProgramClass neq "Project">
									
										<cfif Indicator eq "">
										  <td><img src="#SESSION.root#/Images/caution.gif" alt="No indicators have been defined" border="0" align="middle"></td>
									    </cfif>
									
									<cfelse>
										
										<cfif Output eq "" and ProgramScope eq "Unit">
										  <td><img src="#SESSION.root#/Images/caution.gif" alt="No activities have been defined" border="0" align="middle"></td>
									    </cfif>							
															
									</cfif>
													
														
								</cfif>
							
							</tr>
							</table>
				 
					    </td>
																
					   	<td class="line labelmedium2" style="min-width:130px;border:1px solid gray;padding-left:5px;height:15px;" id="ref_#programid#" 
						onclick="javascript:cmexpand('mymenu','#rowguid#','#menufile#')" bgcolor="#cl#">
						
						   <table width="100%">
						
							<cfif recordstatus eq "9">
							<tr><td style="height:8px;background-color:red;border:1px solid gray"></td></tr>
							<cfelseif recordstatus eq "8">
							<tr><td style="height:8px;background-color:orange;border:1px solid gray"></td></tr>
							</cfif>
												
						    <tr class="labelmedium2"><td style="#ftstyle#">																										
																
							<cfif ProgramScope eq "Unit" and show eq "1">	  
								
								<cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif>
								
							<cfelse>	
							    			
								<cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif>
								
							</cfif>
							
							</td></tr>
							
						   </table>								
													
						</td>
						
						<td style="#ftstyle#;padding-left:2px" colspan="3">
						
												
							<table width="100%">
							<tr>
							
								<td id="mymenu" name="mymenu" class="hide">
								<table cellspacing="0" cellpadding="0">
									<tr><td id="mymenu#rowguid#"></td></tr>
								</table>
								</td>
							
								<td class="labelit">		
								
								    <cfparam name="show" default="1">										
																						
								    <cfif ProgramClass eq "Project">						     
										 
										 <table width="100%" cellspacing="0" cellpadding="0">
										 										     
											 <cfif show eq "1">
										      <tr>
												  <td colspan="3">											 											  
												 
												  <table width="100%" cellspacing="0" cellpadding="0">
												  
												  <tr class="labelmedium2">
												  <td style="padding-left:5px;height:10px;padding-top:1px"><font color="gray"><cfif OrgUnitName neq "">#OrgUnitName#<cfelse>#OrgUnitNameLong#</cfif></td>
												  <cfif url.reviewCycleId eq "">
												  <td style="padding-right:4px;height:10px;padding-top:1px" align="right"><font color="gray">#left(ProgramManager,50)#</td>
												  <cfelse>
												  <td style="padding-right:4px;height:10px;padding-top:1px" align="right"><cfif ReviewCycleStatus eq "3"><font color="008080"><cf_tl id="Completed"></font><cfelse><font color="FF0000"><cf_tl id="Pending"></cfif></td>												 
												  </cfif>
												  </tr>
												  </table>
												  </td>
											  </tr>											  
											 </cfif>	
											 	
											 <tr><td><cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">&nbsp;&nbsp;</cfloop></td>
											 <cfif ProgramScope eq "Unit" and show eq "1">	
											 <td><cf_img icon="edit" navigation="Yes" onclick="EditProgram('#ProgramCode#','#Period#','#ProgramClass#')"></td>
											 </cfif>											 
											 <td width="97%" class="labelmedium2" id="nme_#programid#" style="padding-top:1px;#ftstyle#;padding-left:8px">#ProgramName#</td>
											 </tr>
										 </table>
																				 
									<cfelse>
									
										  <table cellspacing="0" width="100%"  cellpadding="0">
										  										  										 
										      <cfif show eq "1">
										      <tr>
												  <td colspan="3">
												  <table width="100%">
												  <tr>
												  <td colspan="3" class="labelmedium2" style="padding-left:5px;padding-top:1px"><font color="gray"><cfif OrgUnitName neq "">#OrgUnitName#<cfelse>#OrgUnitNameLong#</cfif> </td>
												  <td class="labelmedium2" style="padding-right:4px;height:10px;padding-top:1px" align="right"><font color="gray">#ProgramManager#</td>
												  </tr>
												  </table>
												  </td>
											  </tr>											  
											  </cfif>											  
											  <tr>
											  <td><cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">&nbsp;&nbsp;</cfloop></td>
											  <td><cf_img icon="edit" navigation="Yes" onclick="EditProgram('#ProgramCode#','#Period#','#ProgramClass#')"></td>
											  <td width="97%" class="labelmedium2" id="nme_#programid#" style="padding-top:1px;padding-left:8px;#ftstyle#">#ProgramName#</td>
											  </tr>
										  </table> 
																				 
									</cfif>
									
									<cfif row eq "1">																
										<cf_space spaces="80">
									</cfif>
																
								</td>								
												
							</tr>
							</table>
						
						</td>
																	 
						 <cfif ProgramClass eq "Project" and WeightActivity gt "0">
						 
						     <cfif WeightPending eq "">
							   <cfset pen = "0">
							 <cfelse>
							   <cfset pen = "#WeightPending#">
							 </cfif>
							 					
							 <!--- due versus total activities --->	
						     <cfset tact = WeightActivity*100/WeightActivityTotal>
							 <cfset diff = WeightActivityTotal-WeightActivity>
							 
							 <!--- pending in total --->
							 <cfset penT = pen + diff>
							 <!--- progress versus total activities --->
							 <cfset tprg = (WeightActivityTotal-penT)*100/WeightActivityTotal>
							 <!--- relative progress --->
							 <cfset rprg = (WeightActivity-pen)*100/WeightActivity>
							 <cfif rprg lt "30">
							   <cfset color = "FFAC59">
							 <cfelseif rprg lt "50">
							   <cfset color = "orange"> 
							 <cfelseif rprg lt "70">
							   <cfset color = "silver">
							 <cfelseif rprg lt "100">
							   <cfset color = "yellow">
							 <cfelse>
							   <cfset color = "lightgreen">  
							 </cfif>
							 
							 <td align="center" colspan="2" bgcolor="#color#">
							 
								  <table width="100%" cellspacing="0" cellpadding="0">
								  <tr>
									  <td width="48%" class="labelmedium" align="center" style="#ftstyleb#">
										  <a href="##" title="Progress per #dateformat(now(), CLIENT.DateFormatShow)#">
										  	#numberFormat(tprg,"_")#%
										  </a>									  
									  </td>
									  <td align="center">:</td>
									  <td class="labelmedium" width="48%" align="center" style="#ftstyleb#"> 
									  <a href="##" title="#WeightActivity# out of #WeightActivityTotal# activities (weight) are due">
									  #numberFormat(tact,"_")#%
									  </a>
									  </td>
								  </tr>
								  </table>
								  
							 </td>
							 
						<cfelseif WeightStarted gt "0" and ProgramClass eq "Project">
						
							<td colspan="2" align="center" bgcolor="F8D789" class="labelit" style="#ftstyle#">#tStarted#</td>	
						
						<cfelseif ProgramClass eq "Project" and WeightActivityTotal gt "0">
						
							<td colspan="2" align="center" bgcolor="FBFCDA" class="labelit" style="#ftstyle#">#tNotStarted#</td>	 
						
						<cfelseif ProgramScope eq "Unit">
						
							<td class="labelmedium" colspan="2" align="center" bgcolor="f4f4f4" style="#ftstyle#;padding-right:1px"><font color="black"><!--- <cf_tl id="Ongoing"> ---></font></td>
											 
						</cfif>
						 
						<td></td>
						<td></td>
				  </tr>
				  
				  <cfif ProgramClass eq "Project">
				  							   
					   <cfif clusterDescription neq "">
					  				   
				   	   <tr>
						   <td colspan="1"></td>
						   <td class="cellcontent" colspan="8" bgcolor="F6f6f6" style="#ftstyle#;padding:left:30px;padding-right:30px"><font size="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#tCluster#:<font size="2">&nbsp;#ClusterDescription#</td>
					   </tr>
						   
					  </cfif>  
			  
				  </cfif>
				  
				  <tr id="i#ProgramCode#" class="hide">			  
				  	  <td colspan="10" id="d#ProgramCode#"></td>			  
				  </tr>			  
				  
		  </cfif>	
			
    </cfif>		
				
	<cfif value neq "" or resultListing.recordcount lte "5">				
	   <script language="JavaScript">
			document.getElementById('box#prior#').className = "regular fixrow2"
	   </script>	  
	</cfif>
			
</cfoutput>   

