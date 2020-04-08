
<cfquery name="types" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	T.*,
			LT.ClearanceMode, 
			LT.EntityClass, 
			LT.Operational,
			LT.Created as Updated
    FROM   	Ref_TransactionType T
			LEFT OUTER JOIN WarehouseTransaction LT
				ON 		T.TransactionType = LT.TransactionType
				AND 	LT.Warehouse = '#url.warehouse#'				
	WHERE  T.TransactionType NOT IN ('1','7')
	ORDER BY T.TransactionClass, T.TransactionType
</cfquery>

<cfquery name="WFClass"
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT   DISTINCT 
			 R.*,
			 (R.EntityClass + '-' + R.EntityClassName) as DisplayName
  	FROM 	 Ref_EntityClass R, 
           	 Ref_EntityClassPublish P
  	WHERE  	 R.Operational = '1'
   	AND   	 R.EntityCode   = P.EntityCode 
   	AND   	 R.EntityClass  = P.EntityClass
   	AND   	 R.EntityCode   = 'WhsTransaction'                  
  	ORDER BY R.ListingOrder              
</cfquery>

<cfset vColumns = 7>

<cfform name="frmTransaction" action="Transaction/TransactionClearanceSubmit.cfm?warehouse=#URL.warehouse#">

<table width="90%" align="center" class="navigation_table">

	<tr><td height="10" style="padding-top:10px" colspan="6" class="labelmedium">Used for scenarios where it is not defined on the storage location</td></tr>
	
	<tr class="labelmedium line">
		<td width="30"><cf_tl id="Class"></td>
		<td><cf_tl id="Transaction"></td>
		<td align="center"><cf_tl id="Clearance Mode"></td>
		<td align="center"><cf_tl id="Workflow"></td>
		<td align="center"><cf_tl id="Preparation"></td>
		<td align="center"><cf_tl id="Enabled"></td>
		<td align="center"><cf_tl id="Updated"></td>
	</tr>
		
	<cf_tl id="Batch" var="vBatch">
	<cf_tl id="Individual" var="vIndividual">	
	<cf_tl id="Workflow" var="vWorkflow">		
	<cf_tl id="None" var="vAuto">	
	<cf_tl id="Yes" var="vYes">					
	
	<cfoutput query="types" group="TransactionClass">
			
		<tr class="line">
			<td colspan="#vColumns#" class="labelmedium" style="height:40px;font-size:26px">
				<cfif TransactionClass eq "">
					[<cf_tl id="No class defined">]
				<cfelse>
					#TransactionClass#  </b><font size="2"><cfif transactionclass eq "receipt">(other than procurement receipts)</cfif> <cfif transactionclass eq "distribution">(including POS Sales)</cfif>
				</cfif>
			</td>
		</tr>
		
		<cfoutput>
		
			<tr class="navigation_row line labelmedium" bgcolor="FFFFFF">
				<td></td>
				<td>
					#Description#
					<input type="Hidden" name="TransactionType_#TransactionType#" id="TransactionType_#TransactionType#" value="#TransactionType#">
				</td>
				<td align="center" class="Label">
				
					<select name="ClearanceMode_#TransactionType#" class="regularxl" id="ClearanceMode" style="border:0px" onchange="javascript: changeWorkflow(this,'#TransactionType#');">
						<option value="1" <cfif ClearanceMode eq "1">selected</cfif>>#vBatch#</option>
						<option value="2" <cfif ClearanceMode eq "2">selected</cfif>>#vIndividual#</option>
						<!--- allow for workflow or auto clearance setting --->
						<cfif Transactionclass eq "Transfer" or TransactionClass eq "Variance">
						    <cfif wfclass.recordcount gte "1">
								<option value="3" <cfif ClearanceMode eq "3">selected</cfif>>#vWorkflow#</option>
							</cfif>
							<option value="0" <cfif ClearanceMode eq "0">selected</cfif>>#vAuto#</option>
						</cfif>
					</select>
					
				</td>
				
				<td align="center" width="120">
				    
					<cfif wfclass.recordcount gte "1">
					 
						<cfif ClearanceMode eq "3"  or TransactionType eq "2"> <!--- latter enables a workflow observation in the issuance screen approval --->
							<cfset vStyle="display:'block';">
						<cfelse>
							<cfset vStyle="display:'none';">
						</cfif>
										
						<select name="EntityClass_#TransactionType#" id="EntityClass_#TransactionType#" 										
							style="#vStyle#" class="regularxl">
							<cfif TransactionType eq "2">
							<option value="" selected>n/a</option>
							</cfif>
							<cfloop query="WFClass">
								<option value="#EntityClass#" <cfif entityclass eq types.entityclass>selected</cfif>>#DisplayName#</option>
							</cfloop>
						</select>			
															
					</cfif>
									
				</td>
				
				<td>------</td>
								
				<td align="center" class="Labelmedium">
					<table><tr><td>
					<input type="radio" class="radiol" name="Operational_#TransactionType#" id="Operational_#TransactionType#" value="0" <cfif operational eq 0>checked</cfif>>
					</td><td class="labelmedium" style="padding-left:4px">No</td>
					<td style="padding-left:4px">
					<input type="radio" class="radiol" name="Operational_#TransactionType#" id="Operational_#TransactionType#" value="1" <cfif operational eq 1 or operational eq "">checked</cfif>>
					</td><td class="labelmedium" style="padding-left:4px">#vYes#</td>
					</tr></table>
				</td>
				<td align="center" class="labelit">#dateformat(updated,client.dateformatshow)#</td>
			</tr>
			
		</cfoutput>
	</cfoutput>
	
	<tr><td colspan="<cfoutput>#vColumns#</cfoutput>" height="5" class="line"></td></tr>
	<tr>
		<td colspan="<cfoutput>#vColumns#</cfoutput>" align="center">
			<cf_tl id="Save" var="vSave">
			
			<cfoutput>
			   			   
			 <cf_button 
				mode        = "silver"
				label       = "#vSave#" 
				type        = "Submit"
				id          = "save"					
				width       = "170px" 					
				color       = "636334"
				fontsize    = "11px">   
			   				
			</cfoutput>
			
		</td>
	</tr>
	
</table>

</cfform>

<cfset ajaxonload("doHighlight")>