
<cfoutput>

      <cf_assignid>

	  <cfif attributes.action eq "Edit">
	  	<tr style="height:20px;background-color:###attributes.color#50" class="navigation_row clsSearchrow line fixlengthlist" onContextMenu="cmexpand('mymenu','#rowguid#','')">
	  <cfelse>
	  	<tr style="height:20px;background-color:###attributes.color#50" class="navigation_row clsSearchrow line fixlengthlist">
	  </cfif>

		  <td style="display:none;" class="ccontent">#Attributes.OrgUnitClass# #Attributes.OrgUnitCode# #Attributes.OrgUnitName#</td>
		  <td style="font-size: 15px;">
			  <table>
			  <tr class="fixlengthlist">
			  	<td style="font-size:15px">
				  <cfif Attributes.HierarchyCode eq "">
						  &nbsp;<font color="804040"><b>Not defined</font>
				  <cfelse>
				   		<cfloop index="itm" list="#Attributes.HierarchyCode#" delimiters=".">
					 	*&nbsp;
						</cfloop>
				  </cfif>
		  		</td>
		  		<td>#Attributes.OrgUnitNameShort#</td>
		  	  </tr>
			  </table>
		  </td>

		  <td>
		  
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
	       <TD title="#attributes.OrgUnitName#" style="font-weight:bold;height:30px;font-size:16px">#Attributes.OrgUnitName#
		   <cfelse>
		   <TD title="#attributes.OrgUnitName#">#Attributes.OrgUnitName#
		   </cfif>
		   <cfif Attributes.Autonomous eq "1"><b>(^)</b></cfif>
		   </TD>

		   <cfif attributes.action neq "Edit">
			   <td>#Attributes.OrgUnitClass#</td>
		       <td>#Attributes.OrgUnitCode#</td>
		   <cfelse>
			   <td>
			   	<a href="javascript:editOrgUnit('#Attributes.OrgUnit#','','base')">
				   <cfif attributes.color eq "yellow"><b></cfif>#Attributes.OrgUnitClass#
				</a>
			   </td>
			   <td>
			   	<a href="javascript:editOrgUnit('#Attributes.OrgUnit#','','base')">
					#Attributes.OrgUnitCode#
				</a>
			   </td>
		   </cfif>


		   <td class="clsNoPrint" style="padding-top:2px">
			 	<cf_img icon="open" navigation="Yes" onclick="viewOrgUnit('#Attributes.OrgUnit#')">
		   </td>

	    </TR>
				
</cfoutput>		