<cfif url.id eq "">

	<cf_screentop 
		 height="100%"
	     scroll="Yes" 
		 html="Yes" 
		 label="Portal Topics"
		 option="Add portal topic"	 
		 layout="webdialog" 
		 banner="blue">

<cfelse>

	<cf_screentop 
		 height="100%"
	     scroll="Yes" 
		 html="Yes" 
		 label="Portal Topics"
		 option="Maintain portal topic"	 
		 layout="webdialog" 
		 banner="yellow">
		 
</cfif>

<cfquery name="Get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ModuleControl
		<cfif url.id eq "">
		WHERE 1=0
		<cfelse>
		WHERE 	SystemFunctionId = '#url.id#'
		</cfif>
</cfquery>

<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">
			
<cfif url.id neq "">
	<cfset vFunctionId = get.SystemFunctionId>
</cfif>

<script>

	function validateFileFields() {	
		var controlToValidate = document.getElementById('functionPath');	 
					
		controlToValidate.focus(); 
		controlToValidate.blur(); 
		
		if (controlToValidate.value != "")
		{
			if (document.getElementById('validatePath').value == 0) 
			{ 
				alert('[' + document.getElementById('functionDirectory').value + controlToValidate.value + '] not validated!');
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}		
	}
	
</script>

<table width="90%" align="center">
	<tr><td height="10"></td></tr>
	<tr class="hide"><td><iframe name="processtopic" id="processtopic" frameborder="0"></iframe></td></tr>
	<cfform name="frmTopic" action="TopicSubmit.cfm?id=#url.id#" method="POST" target="processtopic">
	<tr>
		<td height="23" width="30%">Name:</td>
		<td colspan="2">
				<cfoutput>
				<input type="Hidden" value="#get.FunctionName#" name="FunctionNameOld" id="FunctionNameOld">
				</cfoutput>
				<cfinput type="Text" 
					name="FunctionName" 
					required="Yes" 
					message="Please, enter a valid name."
				   	class="regular"
				   	size="50"
					value="#get.FunctionName#"
				   	maxlength="40">
					
		</td>
	</tr>
	<tr>
		<td valign="top">Memo:</td>
		<td colspan="2">
			<table width="100%" align="center">						
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Mode            = "Edit"
				Name            = "FunctionMemo"
				Key1Value       = "#vFunctionId#"
				Key2Value       = ""
				Type            = "Input"
				Required        = "No"
				Message         = "Please, enter a valid memo."
				MaxLength       = "40"
				Size            = "50"
				Class           = "regular"
				Operational     = "1"
				Label           = "Yes">
			</table>
		</td>
	</tr>
	<tr>
		<td>Path:</td>
		<td>
			<input type="Hidden" value="Portal\Topics\" name="functionDirectory" id="functionDirectory">
			Portal\Topics\&nbsp;
			<cfinput type="Text" 
				name="functionPath" 
				required="no"
				message="Please, enter a valid path." 
			   	class="regular"
			   	size="52"
				value="#get.functionPath#"
				onblur= "ColdFusion.navigate('FileValidation.cfm?template='+document.getElementById('functionDirectory').value+this.value+'&container=pathValidationDiv&resultField=validatePath','pathValidationDiv')"
			   	maxlength="80">
		</td>
		<td valign="middle" align="left" width="50%">
		 	<cfdiv id="pathValidationDiv" bind="url:FileValidation.cfm?template=#get.functionDirectory##get.functionPath#&container=pathValidationDiv&resultField=validatePath">				
		</td>
	</tr>
	<tr>
		<td>Order:</td>
		<td colspan="2">
			<cfinput type="Text" 
				name="MenuOrder" 
				required="no"
				message="Please, enter a valid numeric order." 
			   	class="regular"
			   	size="1" 
				maxlength="3" 
				validate="integer"
				value="#get.menuOrder#" 
				style="text-align:center;">
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td height="1" colspan="3" bgcolor="C0C0C0"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="3" align="center">			
			<input type="Submit" class="button10g" name="save" id="save" value="  Save  " onclick="return validateFileFields();">			
		</td>
	</tr>
	</cfform>
</table>
	 

