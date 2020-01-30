<cfparam name="URL.Warehouse" default="">
<cfparam name="URL.mode" default="">

<cfquery name="GetInspection" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT *
		 FROM   WarehouseLocationInspection
		 WHERE  Warehouse = '#URL.warehouse#'
		 ORDER  BY InspectionDate
		 
</cfquery>

<cfform name="inspectionForm" id="inspectionForm" onSubmit="return false;">

<table width="100%" cellspacing="0" cellpadding="0">
  
  <cfif url.mode neq "new">
	  <tr>
  		<td align="center" colspan="7" style="padding:4px">
  			<cfoutput>
  			<input type="button" class="button10g" name="addInspection" id="addInspection" value="Record Inspection Event" style="height:30px;width:240px" onClick="addInspectionRecord('#url.warehouse#')">
  			</cfoutput>
	  	</td>
	  </tr>
  </cfif>
  
	<tr><td height="10px" colspan="7"></td></tr>
	<tr>
		<td width="30"></td>
		<td class="labelit">Inspection Date</td>
		<td class="labelit">Inspection No</td> 
		<td class="labelit">
			<cfif url.mode eq "new">
				Memo
			<cfelse>
				Status
			</cfif>
		</td>
		<td class="labelit">
			<cfif url.mode eq "new">
			    Modality
			<cfelse>
				Officer
			</cfif>
		</td>
		<td width="80" class="labelit">Recorded</td>
		<td width="30"></td>
	</tr>
		
	<tr> <td colspan="7" class="linedotted"></td> </tr>
	
			
	<cfif url.mode eq "new">
	
		<cfoutput>	
				
		<tr>
			<td></td>
			<td style="height:40"> 
				<cf_intelliCalendarDate9
					FieldName  = "InspectionDate" 
					Default    = ""
					Class      = "regularxl"
					AllowBlank = "false"> 	
			</td>
			<td><cfinput type="text" class="regularxl" maxLength="20" value="" id="reference" name="reference"></td>
			<td><cfinput type="text" class="regularxl" maxLength="100" value="" id="memo" name="memo" size="40"></td>
			<td>
			
				<cfquery name="GetEntity" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT E.EntityCode, E.EntityClass, E.EntityClassName
					FROM   Ref_EntityClass E
					WHERE  EntityCode = 'WhsInspection'
					AND    EXISTS
						(
							SELECT 'X'
							FROM   Ref_EntityClassPublish P
							WHERE  E.EntityCode = P.EntityCode
						)
					AND Operational = 1
				</cfquery>
				
				<cfselect name="Workflow" class="regularxl">
					<cfloop query="GetEntity">
						<option value="#EntityClass#"> #EntityClassName# </option>
					</cfloop>
				</cfselect>
				
			
			</td>
			<td style="padding-left:5px"><input type="button" value="Save" name="save" id="save" class="button10g" onClick="submitInspection('#url.warehouse#')"></td>			
			
			<td></td>
			
		</tr>
				
		</cfoutput>
		
		<tr><td colspan="7" height="10px"></td></tr>
		
	</cfif>
	
		<cfoutput query="GetInspection">
		
		<tr>
			<td width="20px">
				
				<cfif ActionStatus neq "2">
					<cf_img icon="expand" toggle="Yes" onclick="twistWf('#InspectionId#',0)" mode="selected">	
				<cfelse>
					<cf_img icon="expand" toggle="Yes" onclick="twistWf('#InspectionId#',1)">	
				</cfif>							
						
			</td>
			<td class="labelmedium"> <b>#DateFormat(InspectionDate,CLIENT.DateFormatShow)#</b></td>
			<td class="labelit">#Reference#</td>
			<td class="labelit">#ActionStatus#</td>
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>		
			<td class="labelit">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
			<td align="right" style="padding-right:3px">
				<cfif ActionStatus eq "0">
						<cf_img icon="delete" onclick="deleteInspection('#warehouse#','#InspectionId#')">
				</cfif>
			</td>
		</tr>
		
		<tr id="#InspectionId#_memo" <cfif ActionStatus eq "2"> class="hide"</cfif>>
			<td></td>
			<td colspan="5" style="background-color:##FFFFDF; padding:4px;">
				<img src="#SESSION.root#/images/join.gif" style="vertical-align:middle;">&nbsp;&nbsp;&nbsp;#Memo#
			</td>
			<td></td>
		</tr>
		
		<tr>
		   <td colspan="5">	
		   	   
		        <input type="hidden" 
		           name="workflowlink_#InspectionId#" id="workflowlink_#InspectionId#"
		           value="../Inspection/InspectionWorkflow.cfm"> 
			 							 
			</td>		
		</tr>  
		
		<cfif ActionStatus neq "2">
									
			<tr>
				<td></td>
				<td colspan="5" style="padding-left:10px;padding-right:0px;border: 0px solid Silver;"
				id="#InspectionId#">						
					<cfset url.ajaxid = InspectionId>							
					<cfinclude template="InspectionWorkflow.cfm">								
				</td>
				<td></td>
			</tr>		
								
		<cfelse>
		
			<tr>
				<td></td>
				<td colspan="5" style="padding-left:10px;padding-right:0px;border: 0px solid Silver;"
					id="#InspectionId#" class="hide">	
				</td>
				<td></td>
			</tr>
		
		</cfif>
		
		<tr> <td colspan="7" height="6px;"></td></tr>
		<tr> <td colspan="7" class="linedotted"></td></tr>
		<tr> <td colspan="7" height="6px;"></td></tr>	
		
		</cfoutput>
	
</table>

</cfform>

<cfset AjaxOnLoad("setSelected")> 
		

