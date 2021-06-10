
<cfoutput>

	<tr class="labelmedium navigation_row line">
	
		<td style="padding-top:4px;padding-left:4px;padding-right:4px;width:50px">
		
			<cfswitch expression="#URL.Source#">					
						
				<cfcase value="ProcurementJob">
					
				   <a href="javascript:job('#OrgUnit#')" 
					  onMouseOver="document.img0_#orgunit#.src='../../../../Images/button.jpg'" 
					  onMouseOut="document.img0_#orgunit#.src='../../../../Images/view.jpg'">
				       <img src="../../../../Images/view.jpg" alt="" 
					      name="img0_#orgunit#" 
						  id="img0_#orgunit#" 
						  width="14" 
						  height="14" 
						  border="0" 
						  align="middle" 
						  onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
				    </a>
				
				</cfcase>
				
				<cfdefaultcase>
								   
				   <cf_img icon="select" navigation="Yes"
				   onclick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
						
				</cfdefaultcase>
			
			</cfswitch>
		
		</td>
		<td>#OrgUnitCode#</td>
		<TD>#OrgUnitName#</TD>
		<TD>#OrgUnitNameShort#</TD>
	
    </tr>

</cfoutput>