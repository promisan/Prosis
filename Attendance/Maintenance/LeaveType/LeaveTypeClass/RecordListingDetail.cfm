
<cfparam name="url.id1"  default="">
<cfparam name="url.code" default="">
	
<cfquery name="Listing" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT   * 
   FROM     Ref_LeaveTypeClass
   WHERE    LeaveType = '#url.id1#'
   ORDER BY ListingOrder
</cfquery>

<cfform  method="POST" name="mysection" onsubmit="return false">
 
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
			
    <TR height="18" class="labelmedium2 line fixrow">
  	    <TD width="8"></TD>
	    <TD width="18"><cf_tl id="C."></TD>	
		<TD><cf_tl id="Description"></TD>
		<TD><cf_tl id="Max"></TD>
		
		<TD><cf_tl id="Taken"></TD>
		<TD width="90"><cf_tl id="Stop Accrue"></TD>
		<TD width="90"><cf_tl id="Stop Ent."></TD>
		<TD style="padding-left:3px"><cf_tl id="Compensate"></TD>
		<TD align="center" width="35"><cf_tl id="S"></TD>
		<td><cf_tl id="Workflow"></td>
		<TD width="30"><cf_tl id="Op"></TD>							
		<TD width="20"><cf_tl id="Created"></TD>
		
  	    <TD width="4%" style="padding-left:5px">
			<cfoutput>
				<cfif url.code neq 'new'>
					<a title="Add new class" href="javascript:addClass()">[New]</a>
				</cfif>
			</cfoutput>
		</TD>
    </TR>	
	
	<cfif url.code eq "new">
		
		<cfoutput>
		<TR bgcolor="f4f4f4">
			<td width="8"></td>
			<!--- Field: Code --->
			<td height="20" style="padding-right:4px">
				<cf_tl id = "Please enter an element code" var = "1">
				<cfinput class="regularxl" type="Text" name="Code" value="" message="#lt_text#" required="Yes" size="2" maxlength="10">
	        </td>	
			<!--- Field: Description --->				   
			<td>
				<cf_tl id = "Please enter a description" var = "1">
				<cfinput class="regularxl" style="width:99%" type="Text" name="Description" value="" message="#lt_text#" required="Yes" size="20" maxlength="40">
			</td>
			<!--- Field: Leave Maximum --->				   
			<td>
				<cf_tl id = "Please enter a value for leave maximum" var = "1">
				<cfinput class="regularxl" style="text-align:center;" type="Text" name="LeaveMax" value="" message="#lt_text#" required="Yes" size="2" maxlength="3">
			</td>
			
			<!--- Field: Pointer Leave --->				   
			<td style="padding-left:3px">
				<cfselect name="PointerLeave" class="regularxl">
					<option value="0">0</option>
					<option value="50">50</option>
					<option value="100">100</option>
				</cfselect>
			</td>
							   
			<td style="padding-left:3px">
				<cfselect class="regularxl" name="StopAccrual">
					<option value="0">N/A</option>
					<option value="1">Stop</option>
				</cfselect>
			</td>

			<td style="padding-left:3px">
				<cfselect class="regularxl" name="stopEntitlement">
					<option value="0">N/A</option>
					<option value="1">Stop</option>
				</cfselect>
			</td>
			
			<!--- Field: Pointer Payroll --->				   
			<td style="padding-left:3px">
			<table>
				<tr><td>
				<cfselect name="CompensationPointer" class="regularxl">
					<option value="0">0</option>
					<option value="50">50</option>
					<option value="100">100</option>
				</cfselect>
				</td>
				<td style="padding-left:5px">
				
				<cfquery name="leavetypelist" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Ref_LeaveType
				   WHERE  LeaveType != '#url.id1#'
				   AND    LeaveAccrual != '0'
				   ORDER BY ListingOrder
				</cfquery>
				
				<cfselect name="CompensationLeaveType" class="regularxl" style="width:120px">
					<option value=""></option>
					<cfloop query="leavetypelist">
						<option value="#LeaveType#"> #Description#</option>
					</cfloop>
				</cfselect>
				
				</td>
				</tr>
			</table>
				
			</td>
			
			<!--- Field: ListingOrder --->				   
			<td style="padding-left:3px">
				<cf_tl id = "Please enter a listing order" var = "1">
				<cfinput type="Text" name="ListingOrder" value="" style="width:20px;text-align:center" class="regularxl" message="#lt_text#" required="Yes" size="1" maxlength="2">
			</td>
			<!--- Field: EntityClass--->
					<td style="padding-left:3px">
						<cfquery name="Workflow" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM Ref_EntityClass
							WHERE EntityCode = 'EntLve'
						</cfquery>

						<cfselect name="EntityClass" class="regularxl">
							<option value=""></option>
							<cfloop query="Workflow">
								<option value="#Workflow.EntityClass#"> #Workflow.EntityClassName#</option>
							</cfloop>
						</cfselect>

					</td>	
			<!--- Field: Operational --->				   
			<td style="padding-left:3px">
				<cfselect class="regularxl" name="Operational">
					<option value="1">Yes</option>
					<option value="0">No</option>
				</cfselect>
			</td>
			<td colspan="3" align="center" style="padding-left:3px">
				<cf_tl id = "Save" var = "1">
				<input type="button" value="#lt_text#" 	onclick="saveClass('new')"  class="button10g">
			</td>
		</tr>
		</cfoutput>
	 
	</cfif>
	
	<cfoutput query="Listing">
	
		<cfif url.code eq Code>
		
				<TR class="line labelmedium2">
					<td width="8" style="height:40px"></td>
					<!--- Field: Code --->
					<td>#Code#</td>	
					<!--- Field: Description --->				   
					<td style="width:99% padding-left:3px">
						<cf_tl id = "Please enter a description" var = "1">
						<cfinput class="regularxl" style="width:99%" type="Text" name="Description" value="#Description#" message="#lt_text#" required="Yes" size="20" maxlength="50">
					</td>
					<!--- Field: Leave Maximum --->				   
					<td style="padding-left:1px">
						<cf_tl id = "Please enter a value for leave maximum" var = "1">
						<cfinput class="regularxl" type="Text" style="text-align:center;" name="LeaveMax" value="#LeaveMaximum#" message="#lt_text#"  range = "0," required="Yes" size="2" maxlength="3">
					</td>
					
					<!--- Field: Pointer Leave --->				   
					<td style="padding-left:3px">
						<cfselect class="regularxl" name="PointerLeave">
							<option value="0" <cfif PointerLeave eq 0>selected</cfif>>0</option>
							<option value="50" <cfif PointerLeave eq 50>selected</cfif>>50</option>
							<option value="100" <cfif PointerLeave eq 100>selected</cfif>>100</option>
						</cfselect>
					</td>
																   
					<td style="padding-left:3px">
						<cfselect class="regularxl" name="StopAccrual">
							<option value="0">N/A</option>
							<option value="1" <cfif StopAccrual eq 1>selected</cfif>>Stop</option>
						</cfselect>
					</td>

					<td style="padding-left:3px">
						<cfselect class="regularxl" name="stopEntitlement">
							<option value="0">N/A</option>
							<option value="1" <cfif stopEntitlement eq 1>selected</cfif>>Stop</option>
						</cfselect>
					</td>
					
					<!--- Field: Pointer Payroll --->				   
					<td style="padding-left:3px"> 
					<table>
					<tr><td>
						<cfselect class="regularxl" name="CompensationPointer">
							<option value="0" <cfif CompensationPointer eq 0>selected</cfif>>0</option>
							<option value="50" <cfif CompensationPointer eq 50>selected</cfif>>50</option>
							<option value="100" <cfif CompensationPointer eq 100>selected</cfif>>100</option>
						</cfselect>
						</td>
						<td style="padding-left:5px">
						
						<cfquery name="leavetypelist" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Ref_LeaveType
						   WHERE  LeaveType != '#url.id1#'
						   AND    LeaveAccrual != '0'
						   ORDER BY ListingOrder
						</cfquery>
						
						<cfselect name="CompensationLeaveType" class="regularxl" style="width:120px">
							<option value=""></option>
							<cfloop query="leavetypelist">
								<option value="#LeaveType#" <cfif Listing.CompensationLeaveType eq LeaveTypeList.LeaveType> selected </cfif>> #Description#</option>
							</cfloop>
						</cfselect>
						
						</td>
						</tr>
					</table>
					</td>
					
					<!--- Field: ListingOrder --->				   
					<td style="padding-left:3px">
						<cf_tl id = "Please enter a listing order" var = "1">
						<cfinput type="Text" class="regularxl" style="width:20px;text-align:center"  name="ListingOrder" value="#ListingOrder#" message="#lt_text#" mask="99" required="Yes" size="1" maxlength="2">
					</td>
					<!--- Field: EntityClass--->
					<td style="padding-left:3px">
						<cfquery name="Workflow" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM Ref_EntityClass
							WHERE EntityCode = 'EntLve'
						</cfquery>

						<cfselect name="EntityClass" class="regularxl">
							<option value=""></option>
							<cfloop query="Workflow">
								<option value="#Workflow.EntityClass#" <cfif Listing.EntityClass eq Workflow.EntityClass> selected </cfif>> #Workflow.EntityClassName#</option>
							</cfloop>
						</cfselect>

					</td>	
					
					<!--- Field: Operational --->				   
					<td style="padding-left:3px">
						<cfselect name="Operational" class="regularxl">
							<option value="1" <cfif Operational eq 1>selected</cfif>>Yes</option>
							<option value="0" <cfif Operational eq 0>selected</cfif>>No</option>
						</cfselect>
					</td>
					<td colspan="3" align="center" style="padding-left:3px">
						<cf_tl id = "Save" var = "1">
						<input type="button" value="#lt_text#" 	onclick="saveClass('#Code#')"  class="button10g">
					</td>
				</tr>
	  		
		<cfelse>
		
			<tr class="labelmedium2 line navigation_row" style="height:20px">
	  	    <TD height="20" align="left" width="9"></TD>
			<td style="padding-right:4px">#Code#</td>	
			<td style="min-width:200px">#Description#</td>
			<td>#LeaveMaximum#</td>
			
			<td style="padding-left:3px">#PointerLeave#%</td>
			
			<td style="padding-left:3px">
				<cfif stopaccrual eq "1">
					<font color="FF0000"><cf_tl id="Stop"></font>
				<cfelse>
					<cf_tl id="N/A">
				</cfif>
			</td>

			<td style="padding-left:3px">
				<cfif stopEntitlement eq "1">
					<font color="FF0000"><cf_tl id="Stop"></font>
				<cfelse>
					<cf_tl id="N/A">
				</cfif>
			</td>
			
			<td style="padding-left:3px">
			<cfif compensationpointer gt "0">
				#CompensationPointer#% <cfif CompensationLeaveType eq "">:&nbsp;Payroll<cfelse>:&nbsp;#CompensationLeaveType#</cfif>
			<cfelse>
				<cf_tl id="Other">
			</cfif>
			</td>
			<td align="center">#ListingOrder#</td>
			<td>
				
				<cfquery name="Workflow" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						SELECT *
						FROM Ref_EntityClass
						WHERE EntityCode  = 'EntLve'
						AND   EntityClass = '#EntityClass#'
				</cfquery>
				
				<cfif Workflow.recordcount gt 0>
					#Workflow.EntityClassName#
				</cfif>
				
			</td>
			<td>
				<cfif Operational eq 1>
					<cf_tl id="Yes">
				<cfelse>
					<cf_tl id="No">
				</cfif>
			</td>	
			<!---		
			<td>#OfficerLastName#</td>
			--->
			<td style="padding-left:5px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td> 
				
			<td width="5%" style="padding-left:5px">
				<table>
				  <tr class="labelmedium">
				    <td>
				      <cf_img icon="edit" navigation="Yes" onclick="ColdFusion.navigate('LeaveTypeClass/RecordListingDetail.cfm?id1=#url.id1#&code=#code#','listing');">
				    </td>
				  
					  <cfquery name="Check" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					 		SELECT *
						    FROM   PersonLeave
							WHERE  LeaveTypeClass = '#Code#'
					   </cfquery>
				   
 				     <cfif Check.recordcount eq 0>
					     <td style="padding-left:1px;padding-top:2px">
						    <cf_img icon="delete" onclick="ColdFusion.navigate('LeaveTypeClass/RecordListingPurge.cfm?id1=#url.id1#&Code=#code#','listing')">
						 </td>
					 </cfif>
				    </tr>
				  </table>	
			   	</td>   
  		      </tr>		

  		      <cfif stopEntitlement eq "1">
	  		      <tr>
	  		      	<td colspan="2"></td>
	  		      	<td colspan="11" style="background-color:##F2F2F2; padding:5px;">
	  		      		<cfdiv id="divTriggerDetail_#code#" bind="url:#session.root#/Attendance/Maintenance/LeaveType/LeaveTypeClass/TriggerDetail.cfm?LeaveType=#LeaveType#&LeaveTypeClass=#Code#">
	  		      	</td>
	  		      </tr>
  		      </cfif>
			  	
			</cfif>		
														
	</cfoutput>
				
</table>						

</cfform>

<cfset ajaxonload("doHighlight")>
