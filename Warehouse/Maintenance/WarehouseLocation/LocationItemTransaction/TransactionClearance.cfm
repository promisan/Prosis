
<cfquery name="types" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	T.*,
			LT.ClearanceMode, 
			LT.Source,
			LT.Notification,
			LT.EntityClass, 
			LT.Operational,
			LT.Created as Updated
    FROM   	Ref_TransactionType T
			LEFT OUTER JOIN ItemWarehouseLocationTransaction LT
				ON 		T.TransactionType = LT.TransactionType
				AND 	LT.Warehouse = '#url.warehouse#'
				AND		LT.Location = '#url.location#'
				AND		LT.ItemNo = '#url.itemno#'
				AND		LT.UoM = '#url.uom#'
	WHERE  T.TransactionType NOT IN ('1','7')
	ORDER BY T.TransactionClass, T.TransactionType
</cfquery>

<cfquery name="WFClass"
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT   DISTINCT R.*,
			 (R.EntityClass + '-' + R.EntityClassName) as DisplayName
  	FROM 	 Ref_EntityClass R, 
           	 Ref_EntityClassPublish P
  	WHERE  	 R.Operational = '1'
   	AND   	 R.EntityCode   = P.EntityCode 
   	AND   	 R.EntityClass  = P.EntityClass
   	AND   	 R.EntityCode   = 'WhsTransaction'                  
  	ORDER BY R.ListingOrder              
</cfquery>

<cfset vColumns = 8>
	
<cfform name="frmTransaction" action="../LocationItemTransaction/TransactionClearanceSubmit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">
	
<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

	<tr><td height="10"></td></tr>
	<tr>
		<td width="30" class="labelit"><cf_tl id="Class"></td>
		<td class="labelit"><cf_tl id="Transaction"></td>
		<td align="center" class="labelit"><cf_tl id="Clearance"></td>
		<td align="center" class="labelit"><cf_tl id="Source"></td>
		<td align="center" class="labelit"><cf_tl id="Mail"></td>
		<td align="center" class="labelit"><cf_tl id="Workflow"></td>
		<td align="center" class="labelit"><cf_tl id="Enabled"></td>
		<td align="center" class="labelit"><cf_tl id="Updated"></td>
	</tr>
	<tr><td class="line" colspan="<cfoutput>#vColumns#</cfoutput>"></td></tr>
		
	<cf_tl id="Batch" var="vBatch">
	<cf_tl id="Individual" var="vIndividual">	
	<cf_tl id="Workflow" var="vWorkflow">		
	<cf_tl id="None" var="vAuto">	
	<cf_tl id="Yes" var="vYes">					
	
	<cfoutput query="types" group="TransactionClass">
		
	<tr class="line">
		<td colspan="#vColumns#" style="font-size:18px" class="labelmedium">
			<cfif TransactionClass eq "">
				[<cf_tl id="No class defined">]
			<cfelse>
				#TransactionClass#  </b><font size="2"><cfif transactionclass eq "receipt">(other than vendor receipts)</cfif> <cfif transactionclass eq "distribution">(other than Sales)</cfif>
			</cfif>
		</td>
	</tr>
	
	<cfoutput>
		<tr style="height:21px" class="navigation_row labelmedium">
			<td height="24"></td>
			<td>
				#Description#
				<input type="Hidden" name="TransactionType_#TransactionType#" id="TransactionType_#TransactionType#" value="#TransactionType#">
			</td>
			<td align="center">
			
				<select name="ClearanceMode_#TransactionType#" class="regularxl" id="ClearanceMode" onchange="javascript: changeWorkflow(this,'#TransactionType#');">
					<option value="1" <cfif ClearanceMode eq "1">selected</cfif>>#vBatch#</option>
					<option value="2" <cfif ClearanceMode eq "2">selected</cfif>>#vIndividual#</option>
					<cfif Transactionclass eq "Transfer" or TransactionClass eq "Variance">
					    <cfif wfclass.recordcount gte "1">
						<option value="3" <cfif ClearanceMode eq "3">selected</cfif>>#vWorkflow#</option>
						</cfif>
						<option value="0" <cfif ClearanceMode eq "0">selected</cfif>>#vAuto#</option>
					</cfif>
				</select>
				
			</td>
			
			<td align="center" class="Labelit">
			
				<select name="Source_#TransactionType#" class="regularxl" id="Source">
					<option value="1" <cfif Source eq "1">selected</cfif>>Data entry</option>
					<option value="2" <cfif Source eq "2">selected</cfif>>Device</option>
					<option value="3" <cfif Source eq "3">selected</cfif>>PDF form</option>			
					<option value="9" <cfif Source eq "3">selected</cfif>>Any</option>					
				</select>				
			</td>
			
			<td align="center" class="Labelit">
			
				<select name="Notification_#TransactionType#" class="regularxl" id="Notification">
					<option value="0" <cfif Notification eq "0">selected</cfif>>No</option>
					<option value="1" <cfif Notification eq "1">selected</cfif>>Yes</option>						
				</select>				
			</td>
			
			<td align="center" width="120">
			    
				<cfif wfclass.recordcount gte "1">
				
				<cfif ClearanceMode eq "3" or TransactionType eq "2" or TransactionType eq "9">
					<cfset vStyle="hide">
				<cfelse>
					<cfset vStyle="regulsxl">
				</cfif>
								
				<select name="EntityClass_#TransactionType#" id="EntityClass_#TransactionType#" class="regularxl #vStyle#">
					<cfloop query="WFClass">
						<option value="#EntityClass#" <cfif entityclass eq types.entityclass or currentrow eq "1">selected</cfif>>#DisplayName#</option>
					</cfloop>					
				</select>	
				
				</cfif>		
								
			</td>
			<td align="center" class="Label">
				<table cellspacing="0" cellpadding="0">
				<tr><td>
				<input type="radio" name="Operational_#TransactionType#" id="Operational_#TransactionType#" value="0" <cfif operational eq 0>checked</cfif>></td>
				<td style="padding-left:3px" class="labelit">No</td>
				<td style="padding-left:7px">
				<input type="radio" name="Operational_#TransactionType#" id="Operational_#TransactionType#" value="1" <cfif operational eq 1 or operational eq "">checked</cfif>></td>
				<td style="padding-left:3px" class="labelit">#vYes#</td>
				</tr>
				</table>
			</td>
			<td align="center" class="labelit">#dateformat(Updated,client.dateformatshow)#</td>
		</tr>
		
	</cfoutput>
	</cfoutput>
	
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="<cfoutput>#vColumns#</cfoutput>" align="center">
			<cf_tl id="Save" var="vSave">
			<cfoutput>
			   			   
			 <input class       = "button10g"
			  		value       = "#vSave#" 
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