
<cfform name="webdialog" id="webdialog">
		
	<table width="100%" align="center">
		
		<cfoutput>
		
		<tr id="unit" class="regular">
	
			<td class="labelmedium">				
				
				<img src="#SESSION.root#/Images/add2.png" 
					title="Select OrgUnit"
					style="cursor: pointer;" 
					height="20px" 
					align="absmiddle" 
					onClick="selectImplementer('#url.mission#', '#url.MandateNo#');">
				
				<a href="javascript:selectImplementer('#url.mission#', '#url.MandateNo#');" style="color:4A81F7;">
					<cf_tl id="Add Implementer">
				</a>
				
				<input type="hidden" 	name="orgunitname" 	id="orgunitname" 	value="" class="regular" size="80" maxlength="60" readonly>
				<input type="hidden" 	name="orgunit" 		id="orgunit"      	value="">
				<input type="hidden" 	name="orgunitcode" 	id="orgunitcode"  	value="">
				<input type="hidden" 	name="mission2" 	id="mission2"      	value="">
				<input type="hidden" 	name="orgunitclass" id="orgunitclass"	value="" class="disabled" size="20" maxlength="20" readonly>
									
			</td> 
		</tr>
		
		<tr><td height="5"></td></tr>
		
		<tr>
			<td class="labelit" style="padding-left:8px;">
			   <table>
			   <tr>
			   <td><input type="checkbox" id="rollover" name="rollover" style="height:14px;width:14px" checked="checked"> <label for="rollover"></td>
			   <td class="labelmedium" style="padding-left:5px"><font color="808080"><cf_tl id="Roll selection over children nodes"></td>
			   </tr>
			   </table>
			</td>
		</tr>
		
		<tr><td height="5"></td></tr>
		<tr><td class="line"></td></tr>
		<tr><td height="5"></td></tr>
		
		<tr>
			<td>
				<cf_securediv id="divImplementerTree" bind="url:#session.root#/workorder/Application/WorkOrder/Implementer/ImplementerListContent.cfm?orgUnitImplementer=&WorkOrderId=#url.WorkOrderId#&mission=#url.mission#&mandateNo=#url.mandateNo#&rollover=">
			</td>
		</tr>
		
		</cfoutput>		
				
	</table>

</cfform>