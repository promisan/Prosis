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

<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No" blockevent="rightclick">
	
<cfparam name="URL.ID1" default="all">
<cfparam name="URL.ID2" default="0">
   
<cf_dialogAsset>

<cfset CLIENT.search = "&ID2=#URL.ID2#">

<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.ID2#</cfoutput>">
    
<cfinclude template="LocationViewHeader.cfm">

<cfif URL.ID2 eq "0">
   <cfabort>
</cfif>

<cfif URL.ID1 eq "NULL">
  <cfset cond = "AND O.HierarchyCode is NULL">
<cfelseif URL.ID1 eq "all">
   <cfset cond = "AND (O.ParentLocation IS NULL)">
<cfelse>
   <cfset cond = "AND O.Location = '#URL.ID1#'">
</cfif>

<!--- Query returning search results --->

<cfif URL.ID1 neq "NULL">

	<cfquery name="SearchResult" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   distinct O.*, C.Description as ClassName, Org.OrgUnitName
	FROM     Location O INNER JOIN Ref_LocationClass C ON O.LocationClass = C.Code
	         LEFT OUTER JOIN Organization.dbo.Organization Org ON O.MissionOrgUnitId = Org.MissionOrgUnitId						
	WHERE    O.Mission   = '#URL.ID2#'
	         #preserveSingleQuotes(cond)#
	ORDER BY O.Mission, O.TreeOrder
	</cfquery>

<cfelse>

	<cfquery name="SearchResult" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   distinct O.*, C.Description as ClassName, Org.OrgUnitName
	FROM     Location O INNER JOIN Ref_LocationClass C ON O.LocationClass = C.Code
	         LEFT OUTER JOIN Organization.dbo.Organization Org ON O.MissionOrgUnitId = Org.MissionOrgUnitId	
	WHERE     (O.Mission = '#URL.ID2#') 
	 AND (HierarchyCode IS NULL) 
	 AND (ParentLocation NOT IN
	                          (SELECT     Location
	                            FROM       Location
	                            WHERE      Mission = '#URL.ID2#') 
	ORDER BY Mission, O.TreeOrder
	</cfquery>

</cfif>
  
<cfset access = "ALL">

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">

  <tr>
    <td height="30">&nbsp;<b>	
	
	<CFIF Access EQ "ALL"> 
	
		<cfoutput>
	      <input type="button" value="Add location" class="button10s" style="width:130;height:23"
		      onclick="javascript:addLocation('#URL.ID2#','#SearchResult.Location#','#SearchResult.Location#')">
	    </cfoutput>
	
	</cfif>
		
	</td>	
	<td align="right">&nbsp;</TD>
	
  </tr>
  
  <tr><td colspan="2" height="1" class="line"></td></tr>  
  
  <tr><td colspan="2">
  
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    
	  <tr>  
	  
	  <td width="100%" colspan="2">
	
		<table border="0" class="navigation_table formpadding" width="100%">
		
		<TR class="line labelmedium">
		    <td height="20" width="3">&nbsp;</td>
		    <td height="20" width="0"></td>		
		    <TD><cf_tl id="Code"></TD>
			<TD><cf_tl id="Description"></TD>
			<TD><cf_tl id="Price"></TD>
			<td height="20"><cf_tl id="Class"></td>
			<td height="20"><cf_tl id="Unit"></td>
		</TR>
					
		<cfoutput query="SearchResult" group="TreeOrder">
		
		<cfoutput>
		
		<tr class="navigation_row cellcontent line" onContextMenu="cmexpand('mymenu','#client.dropdownno#','')" bgcolor="f5f5f5" onclick="cmclear('mymenu')">
		
		   <td></td>
		   
		   <td bgcolor="white">
		   <table cellspacing="0" cellpadding="0">
		     <tr>
		      <td class="hide" id="mymenu#client.dropdownno#" name="mymenu#client.dropdownno#">
		  	          
		     <CFIF Access EQ "ALL"> 
		   	  				 	 
		      <cf_dropDownMenu
			     name="menu"
		   	     headerName="Location"
			     menuRows="2"
				 AjaxId="mymenu#client.dropdownno#"
								 
			     menuName1="Edit location"
			     menuAction1="javascript:editLocation('#Location#')"
			     menuIcon1="#SESSION.root#/Images/edit.gif"
			     menuStatus1="Edit location"
			  
			     menuName2="Add Child location"
			     menuAction2="javascript:addLocation('#URL.ID2#','#SearchResult.Location#','#SearchResult.Location#')"
			     menuIcon2="#SESSION.root#/Images/zoomin.jpg"
			     menuStatus2="Add Child Location">
							 
			<cfelse>
			
			   <img src="#SESSION.root#/Images/view.jpg" alt="" alt="" width="12" height="14" 
			   border="0" align="middle">
			  			 
			 </cfif>	
			 </td>
			 </tr>
			 </table>
			</td> 
				 		
		    <td width="10%" class="labelmedium"><b>#LocationCode#</td>
		    <TD width="50%" class="labelmedium">#LocationName#</TD>
			<TD width="5%"  class="labelmedium"><cfif StockLocation eq "1">Yes</cfif></TD>
			<TD width="15%" class="labelmedium">#ClassName#</TD>
			<td width="30%" class="labelmedium">#OrgUnitName#</td>
		    </TR>
									
			<cfif URL.ID1 neq "NULL">
			
		   <cfquery name="Level02" 
		    datasource="appsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		  SELECT   distinct O.*, C.Description as ClassName, Org.OrgUnitName
		    FROM     Location O INNER JOIN Ref_LocationClass C ON O.LocationClass = C.Code
		         LEFT OUTER JOIN Organization.dbo.Organization Org ON O.MissionOrgUnitId = Org.MissionOrgUnitId
			WHERE     (O.Mission = '#URL.ID2#') 		
			AND    O.ParentLocation = '#SearchResult.Location#'		
			ORDER BY O.Mission, O.TreeOrder
		   </cfquery>
		   
		    <cfloop query="Level02">
		   
		     <tr class="navigation_row cellcontent line" onContextMenu="cmexpand('mymenu','#client.dropdownno#','')" onclick="cmclear('mymenu')">
		
		       <td></td>	
			   		
			   <td bgcolor="FFFFFF" height="17">
			   
				   <table cellspacing="0" cellpadding="0">
				      <tr>
				      <td class="hide" id="mymenu#client.dropdownno#" name="mymenu#client.dropdownno#">
					  		   
					   <CFIF Access EQ "ALL"> 
					  			  			 	 
					      <cf_dropDownMenu
						     name="menu"
					   	     headerName="Location"
						     menuRows="2"
							 AjaxId="mymenu#client.dropdownno#"
											 
						     menuName1="Edit location"
						     menuAction1="javascript:editLocation('#Level02.Location#')"
						     menuIcon1="#SESSION.root#/Images/edit.gif"
						     menuStatus1="Edit details"
						  
						     menuName2="Add Child location"
						     menuAction2="javascript:addLocation('#URL.ID2#','#Level02.Location#','#SearchResult.Location#')"
						     menuIcon2="#SESSION.root#/Images/zoomin.jpg"
						     menuStatus2="Add Child Location">	
						 			 	 
				     <cfelse>
					
					   <img src="#SESSION.root#/Images/view.jpg" alt="" alt="" width="12" height="14" 
					   border="0" align="middle">		 
						 
					 </cfif>	
					 </td>
					 </tr>
				 </table>
			     </td>				 
				 
			     <td style="padding-left:15px"><a href="javascript:editLocation('#Level02.Location#')"><font color="0080C0">#Level02.LocationCode#</a></td>
			     <TD>#Level02.LocationName#</TD>
				 <TD><cfif Level02.StockLocation eq "1">Yes</cfif></TD>
				 <TD>#Level02.ClassName#</font></TD>
				 <td>#Level02.OrgUnitName#</td>
			     </TR> 
				 				
				<cfquery name="Level03" 
			      datasource="appsMaterials" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				     SELECT    Distinct O.*, C.Description as ClassName, Org.OrgUnitName
					 FROM      Location O INNER JOIN Ref_LocationClass C ON O.LocationClass = C.Code
		        	      	   LEFT OUTER JOIN Organization.dbo.Organization Org ON O.MissionOrgUnitId = Org.MissionOrgUnitId	
					 WHERE     O.Mission = '#URL.ID2#' 				
					 AND       ParentLocation = '#Level02.Location#'		      
				     ORDER BY  O.Mission, O.TreeOrder
			    </cfquery>
		
				    <cfloop query="Level03">
				   
				    <tr class="navigation_row cellcontent line" onContextMenu="cmexpand('mymenu','#client.dropdownno#','')" onclick="cmclear('mymenu')">
		
				       <td></td>			
					   <td bgcolor="FFFFFF" height="17">
			   
					   <table cellspacing="0" cellpadding="0">
					      <tr>
				    	  <td class="hide" id="mymenu#client.dropdownno#" name="mymenu#client.dropdownno#">
					   
					   <CFIF Access EQ "ALL"> 
				    					  			 	 
						      <cf_dropDownMenu
							     name="menu"
						   	     headerName="Location"
							     menuRows="2"
								 AjaxId="mymenu#client.dropdownno#"
												 
							     menuName1="Edit"
							     menuAction1="javascript:editLocation('#Level03.Location#')"
							     menuIcon1="#SESSION.root#/Images/edit.gif"
							     menuStatus1="Edit details"
							  
							     menuName2="Add Child location"
							     menuAction2="javascript:addLocation('#URL.ID2#','#Level03.Location#','#SearchResult.Location#')"
							     menuIcon2="#SESSION.root#/Images/zoomin.jpg"
							     menuStatus2="Add Child location">	
						 
				        <cfelse>
					
							   <img src="#SESSION.root#/Images/view.jpg" alt="" alt="" width="12" height="14" 
							   border="0" align="middle">		 
						 
						 </cfif>	
						 </td>
						 </table>
						 </td>		 
					   			   	     
				         <td style="padding-left:30px"><a href="javascript:editLocation('#Level03.Location#')"><font color="0080C0">#Level03.LocationCode#</a></td>
				         <TD>#Level03.LocationName#</TD>
						 <TD><cfif Level03.StockLocation eq "1">Yes</cfif></TD>
						 <TD>#Level03.ClassName#</font></TD>
						 <td>#Level03.OrgUnitName#</td>
				     </TR> 
					 
					 	  <cfquery name="Level04" 
				      datasource="appsMaterials" 
				      username="#SESSION.login#" 
				      password="#SESSION.dbpw#">
				       SELECT   distinct O.*, C.Description as ClassName, Org.OrgUnitName
					   FROM     Location O INNER JOIN Ref_LocationClass C ON O.LocationClass = C.Code
					            LEFT OUTER JOIN Organization.dbo.Organization Org ON O.MissionOrgUnitId = Org.MissionOrgUnitId	
						WHERE   O.Mission = '#URL.ID2#' 					
					    AND     ParentLocation = '#Level03.Location#'			       
					   ORDER BY O.Mission, O.TreeOrder
				    </cfquery>
				
				    <cfloop query="Level04">
					
					<tr class="navigation_row cellcontent line" onContextMenu="cmexpand('mymenu','#client.dropdownno#','')" onclick="cmclear('mymenu')">
		
				       <td></td>			
					   <td bgcolor="FFFFFF" height="17">
			   
					   <table cellspacing="0" cellpadding="0">
					      <tr>
				    	  <td class="hide" id="mymenu#client.dropdownno#" name="mymenu#client.dropdownno#">			   
				   
							 <CFIF Access EQ "ALL"> 
						    					  			 	 
						      <cf_dropDownMenu
							     name="menu"
						   	     headerName="Location"
							     menuRows="1"
								 AjaxId="mymenu#client.dropdownno#"
												 
							     menuName1="Edit"
							     menuAction1="javascript:editLocation('#Level04.Location#')"
							     menuIcon1="#SESSION.root#/Images/edit.gif"
							     menuStatus1="Edit details">
							
						     <cfelse>
							
							   <img src="#SESSION.root#/Images/view.jpg" alt="" alt="" width="12" height="14" 
							   border="0" align="middle">		 
								 
							 </cfif>	
							 
						 </td>
						 </tr>
					  </table>
					  </td>			 				 
					 
					  <td style="padding-left:45px"><a href="javascript:editLocation('#location#')"><font color="0080C0">#Level04.LocationCode#</a></td>
				      <TD>#Level04.LocationName#</font></TD>
					  <TD><cfif Level04.StockLocation eq "1">Yes</cfif></TD>
					  <TD>#Level04.ClassName#</font></TD>
					  <td>#Level04.OrgUnitName#</td>
				    
					</TR> 
					 
					</cfloop> 
					   
				</cfloop>
			     
		      </cfloop> 
			
			</cfif>
			
			</cfoutput>
		     
		</CFOUTPUT>
		
		</TABLE>
		   
		</td></tr>
				   
	</table>

</td></tr>
   
</table>