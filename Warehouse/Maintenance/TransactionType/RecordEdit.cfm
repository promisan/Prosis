<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *,
			(SELECT Description FROM Ref_TransactionClass WHERE Code = T.TransactionClass) as TransactionClassDescription,
			(SELECT Description FROM Ref_AreaGLedger WHERE Area = T.Area) as AreaDescription
	FROM   Ref_TransactionType T
	WHERE  TransactionType = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	TransactionType
      FROM  	ItemTransaction
      WHERE 	TransactionType  = '#URL.ID1#'
	  UNION
	  SELECT 	TransactionType
      FROM  	ItemWarehouseLocationTransaction
      WHERE 	TransactionType  = '#URL.ID1#' 	 
	  UNION
	  SELECT 	TransactionType
      FROM  	WarehouseBatch
      WHERE 	TransactionType  = '#URL.ID1#' 	 
    </cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

function validate(){
	validation = document.getElementById('templateVal');
	
	if (validation.value == 0){
		alert('Report template not valid: File does not exist');
		return false;
	}else{
		return true;
	}
	
}

</script>

<cf_screentop height="100%" 
			  label="Transaction Type" 			 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog" onSubmit="return validate();">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR >
    <TD class="labelit" width="20%">Transaction type:</TD>
    <TD class="labelmedium">
	  <!---  <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.TransactionType#" message="Please enter a code" required="Yes" size="1" maxlength="2" class="regular" style="text-align:center;">
	   <cfelse> --->
	   		#get.TransactionType#
			<input type="hidden" name="Code" ID="Code" value="#get.TransactionType#">
	   <!--- </cfif> --->
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.TransactionType#">
    </TD>
	</TR>
	
	<TR class="labelit">
    <TD>Description:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="No" size="20" maxlength="30" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Class:</TD>
    <TD class="labelmedium">
		
		<!--- <cfquery name="LookUpClass" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_TransactionClass
			ORDER BY ListingOrder
		</cfquery>
		
		<select name="TransactionClass">
			<option value="" <cfif get.TransactionClass eq "">selected</cfif>></option>
			<cfloop query="LookUpClass">
				<option value="#LookUpClass.Code#" <cfif get.TransactionClass eq LookUpClass.Code>selected</cfif>>#LookUpClass.Description#</option>
			</cfloop>
		</select> --->
		
		#get.TransactionClassDescription#
		<input type="hidden" name="TransactionClass" id="transctionClass" value="#get.TransactionClass#">
  	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Area:</TD>
    <TD class="labelmedium">
  	   
	   <!--- <cfquery name="LookUpArea" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_AreaGLedger
			ORDER BY ListingOrder
		</cfquery>
		
		<select name="Area">
			<option value="" <cfif get.Area eq "">selected</cfif>></option>
			<cfloop query="LookUpArea">
				<option value="#LookUpArea.Area#" <cfif get.Area eq LookUpArea.Area>selected</cfif>>#LookUpArea.Description#</option>
			</cfloop>
		</select> --->
	   
	   #get.AreaDescription#
		<input type="hidden" name="Area" id="Area" value="#get.Area#">
	   
    </TD>
	</TR>
	
	<tr>
		<td  class="labelit" valign="top" style="padding-top:4px;padding-right:9px">Report&nbsp;Template:</td>
		<td>
			<table>
				<tr>
					<td>
						<input class="regularxl" type="text" name="reportTemplate" id="reportTemplate" value="#get.ReportTemplate#" size="35"> 
					</td>
					<td>
						<cfdiv id="pathValidationDiv" bind="url:ValidateTemplate.cfm?template={reportTemplate}&container=pathValidationDiv&resultField=templateVal">
					</td>
				</tr>
				<tr><td class="labelit"><font color="808080">Applies only of the Batch class has NO report defined</td></tr>
			</table>
		</td>
	</tr>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<!--- <cfif CountRec.recordcount eq "0"><input class="button10g" type="submit" style="width:80" name="Delete" value="Delete" onclick="return ask()"></cfif> --->	
    <input class="button10g" type="submit" style="width:100" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>	
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	