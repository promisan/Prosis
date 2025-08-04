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
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Cluster Record</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.Id2" default="new">
<cfparam name="URL.Access" default="ALL">


<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ProgramActivity
		WHERE  ActivityId = '#url.activityid#'		
</cfquery>

<cfquery name="Cluster" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ProgramActivityCluster
		WHERE  ProgramCode = '#URL.ProgramCode#'
		ORDER BY ListingOrder
</cfquery>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="left">
		
	  <tr class="hide"><td id="clusterset"></td></tr>		
	  <tr>
	    <td width="100%">
		
	    <table width="100%" border="0" cellspacing="0">
		
		<tr bgcolor="ffffff" class="line">
		   <td width="20" align="center">1.</td>
		   <td width="30">
		   <cfoutput>
		   <cfif URL.access eq "ALL">		   		  
			   <input class="radiol" 
			   onclick="ColdFusion.navigate('#session.root#/ProgramREM/Application/Program/ActivityCluster/setActivityCluster.cfm?activityid=#url.activityid#&activityclusterid=','clusterset')"
			   type="radio" <cfif URL.SelClusterId eq "">checked</cfif> name="ActivityClusterId" id="ActivityClusterId" value="">
			   
		   </cfif>
		   </cfoutput>
		   </td>
		   <td width="80%" class="labelmedium"><cf_tl id="Main Project"></td>
	       <td height="18"></td>			 			 			  
		   <td></td>
			   
		</TR>	
		
		<cfoutput query="Cluster">
																				
		<cfif URL.Id2 eq ActivityClusterId 
		     and URL.Access eq "ALL">
				
			<tr bgcolor="f4f4f4" class="line labelmedium">
			<td width="20" align="center">#CurrentRow+1#.</td>
			<td>
			<input type="radio" class="radiol" name="ActivityClusterId" id="ActivityClusterId" value="#ActivityClusterId#" 
			   <cfif ActivityClusterId eq URL.SelClusterId>checked</cfif>>	
			   	
			</td>			
			<td align="center" style="padding-left:30px;height:30">
			
			    <input type="text" 
				     name="ClusterDescription" 
					 id="ClusterDescription" 
					 value="#ClusterDescription#"
					 style="width:95%"
				     size="80" 
					 class="regularxl"
					 maxlength="100">
		 
			</td>
			
			<td height="25" align="absmiddle">
			
			   <input type="text" 
			     name="ClusterListingOrder" 
				 id="ClusterListingOrder" 
				 value="#ListingOrder#"
			     size="1" 
				 class="regularxl"
				 maxlength="2">
			
		     </td>
																		   
			<td align="center">			
				<input type="button" value="Save" class="button10g" style="width:80px" onclick="clustersave('#URL.ID2#','#url.activityid#')">			
			</td>
			    
			</TR>	
			
		<cfelse>
							
			<tr bgcolor="ffffff" class="line labelmedium" style="height:35px">
			   <td width="20" align="center" style="min-width:30px">#CurrentRow+1#</td>
			   <td width="20">
			   
			     <input type="radio" class="radiol" 
				 onclick="ColdFusion.navigate('#session.root#/ProgramREM/Application/Program/ActivityCluster/setActivityCluster.cfm?activityid=#url.activityid#&activityclusterid=#activityclusterid#','clusterset')"
				  name="ActivityClusterId" id="ActivityClusterId" value="#ActivityClusterId#" 
				 <cfif ActivityClusterId eq get.ActivityClusterId>checked</cfif>>
			   </td>
			   
			   <td width="80%">#ClusterDescription#</td>
			   <td height="18">#ListingOrder#</td>			 			 			  
				
			   <td align="center" width="60">
			   
			   	<table><tr>
			   
				   <cfif URL.Access eq "ALL">
				   
				   	   <td>
				       <cf_img icon="edit" onclick="clusteredit('#ActivityClusterId#','#url.activityid#')">
					   </td>
						
						<cfquery name="Check" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM ProgramActivity
							WHERE ActivityClusterId = '#ActivityClusterId#'
						</cfquery>
						
						<cfif Check.recordcount eq "0">
						    <td style="padding-left:4px">
							<cf_img icon="delete" onclick="clusterdel('#ActivityClusterId#','#url.activityid#')">
							</td>
													
						</cfif>
					
					</cfif>
					</tr>
					</table>
				
			   </td>
			   
		    </TR>	
											
		</cfif>
						
		</cfoutput>		
									
		<cfoutput>
																			
		<cfif URL.Id2 eq "new" 
		     and URL.Access eq "ALL">
				   					
			<tr bgcolor="ffffff" class="line" style="height:35px">
												
			<td align="absmiddle" colspan="3" width="80%" style="padding-left:30px;height:35">
			
			     <input type="text" 
				     name="ClusterDescription" 
					 id="ClusterDescription"
					 value=""
					 style="width:100%"
				     size="70" 
					 class="regularxl"
					 maxlength="100">
		 
			</td>
			
			<td height="25" align="absmiddle" style="padding-left:4px">
			
				 <input type="text" 
				     name="ClusterListingOrder" 
					 id="ClusterListingOrder" 
					 value=""
				     size="1" 
					 class="regularxl" style="text-align:center"
					 maxlength="2">
			
		    </td>
															   
			<td align="center" width="20">
				<cf_tl id="Add" var="1">
				<input type="button" value="#lt_text#" class="button10s" style="height:25;width:80px" onclick="clustersave('new','#url.activityid#')">
			</td>
			    
			</TR>	
			
																			
		</cfif>	
		
		</cfoutput>		
									
	</table>
	</td>
	</tr>
							
</table>