
<cfoutput>

      <cf_assignid>

	  <cfif attributes.action eq "Edit">
	  	<tr style="height:20px;background-color:###attributes.color#50" class="navigation_row clsSearchrow line" onContextMenu="cmexpand('mymenu','#rowguid#','')">
	  <cfelse>
	  	<tr style="height:20px;background-color:###attributes.color#50" class="navigation_row clsSearchrow line">
	  </cfif>

		  <td style="display:none;" class="ccontent">#Attributes.OrgUnitClass# #Attributes.OrgUnitCode# #Attributes.OrgUnitName#</td>
		  <td style="padding-right:8px;padding-left:4px;min-width:250;font-size: 15px;">
			  <table>
			  <tr>
			  	<td style="font-size:15px">
				  <cfif Attributes.HierarchyCode eq "">
						  &nbsp;<font color="804040"><b>Not defined</font>
				  <cfelse>
				   		<cfloop index="itm" list="#Attributes.HierarchyCode#" delimiters=".">
					 	*&nbsp;
						</cfloop>
				  </cfif>
		  		</td>
		  		<td style="padding-left:3px">
		  			#Attributes.OrgUnitNameShort#
		  		</td>
		  		</tr>
				</table>
		  </td>

		  <td width="10">
		  
			  <table>
			  <tr>
	
			  <cfif attributes.action eq "Edit">
	
			  	 <td class="hide" id="mymenu" name="mymenu">
	
					 <table>
		
					  <tr class="labelmedium2" style="height:21px">
						<td name="mymenu#rowguid#" id="mymenu#rowguid#">
		
						  <cf_tl id="Edit" 		   var="vEdit">
						  <cf_tl id="Edit details" var="vEditDetails">
						  <cf_tl id="Add Node" 	   var="vAddNode">
						  <cf_tl id="More"   	   var="vMaintain">
						  <cf_tl id="Maintain organization information" var="vMantainOrganization">
		
					      <cf_dropDownMenu
						     name		= "menu"
					   	     headerName = "Node"
						     menuRows	= "3"
							 AjaxId		= "mymenu"
		
						     menuName1   = "#vEdit#"
						     menuAction1 = "javascript:editOrgUnit('#Attributes.OrgUnit#','','base')"
						     menuIcon1   = "#SESSION.root#/Images/edit.gif"
						     menuStatus1 = "#vEditDetails#"
		
						     menuName2   = "#vAddNode#"
						     menuAction2 = "javascript:addOrgUnit('#Attributes.Mission#','#Attributes.MandateNo#','#Attributes.OrgUnitCode#','#Attributes.OrgUnitPar#','base','#url.id4#')"
						     menuIcon2   = "#SESSION.root#/Images/org_new.gif"
						     menuStatus2 = "#vAddNode#"
		
						     menuName3   = "#vMaintain#"
						     menuAction3 = "javascript:viewOrgUnit('#Attributes.OrgUnit#')"
						     menuIcon3   = "#SESSION.root#/Images/details.gif"
						     menuStatus3 = "#vMantainOrganization#">
		
						 </td>
		
					  </tr>
		
					  </table>
	
				  </td>
	
			   <cfelse>
	
					<td width="20"></td>
	
			   </cfif>
	
			   </tr>
			   </table>
		   </td>

		   <cfif attributes.color eq "ffffff">
	       <TD style="font-weight:bold;height:30px;font-size:16px" width="70%">#Attributes.OrgUnitName#</td>
		   <cfelse>
		   <TD width="70%">#Attributes.OrgUnitName#
		   </cfif>
		   <cfif Attributes.Autonomous eq "1"><b>(^)</b></cfif>
		   </TD>

		   <cfif attributes.action neq "Edit">
			   <td width="100" style="padding-right:7px">#Attributes.OrgUnitClass#</td>
		       <td style="padding-right:4px">#Attributes.OrgUnitCode#</td>
		   <cfelse>
			   <td width="100" style="padding-right:7px">
			   	<a href="javascript:editOrgUnit('#Attributes.OrgUnit#','','base')">
				   <cfif attributes.color eq "yellow"><b></cfif>#Attributes.OrgUnitClass#
				</a>
			   </td>
			   <td style="padding-right:7px">
			   	<a href="javascript:editOrgUnit('#Attributes.OrgUnit#','','base')">
					#Attributes.OrgUnitCode#
				</a>
			   </td>
		   </cfif>

		   </td>

		   <td class="clsNoPrint" width="30" style="padding-top:2px">
			 	<cf_img icon="open" navigation="Yes" onclick="viewOrgUnit('#Attributes.OrgUnit#')">
		   </td>

	    </TR>
				
</cfoutput>		