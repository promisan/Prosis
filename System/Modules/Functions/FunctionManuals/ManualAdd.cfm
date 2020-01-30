<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">
<cfset vSeparator = 8>

<cf_screentop 
	 height="100%"
     scroll="Yes" 
	 html="Yes" 
	 jQuery="yes"
	 bannerheight="55"
	 label="Add #url.systemmodule# Manual"
	 layout="webAPP" 
	 banner="gray">

<cfoutput>
	<script>
	
		function validateFileFields() {	
			var controlToValidate = document.getElementById('functionPath');	 
			var _root = '';
						
			controlToValidate.focus(); 
			controlToValidate.blur(); 
			
			if (controlToValidate.value != "")
			{
				if (document.getElementById('validatePath').value == 0) 
				{ 
					_root = document.getElementById('functionHost').value;
					if (_root == '') { _root = '#session.root#'; }
					alert('[' + _root + document.getElementById('functionDirectory').value + controlToValidate.value + '] could not be validated!');
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
		
		function toggleFunctionHost(c) {
			if (c.value == 1) {
				$('##functionHostDefault').hide();
				$('##functionHost').val('#session.rootDocument#').show();
			}else {
				$('##functionHost').val('').hide();
				$('##functionHostDefault').show();
			}
		}
	
	</script>
</cfoutput>
	 
<cfform name="frmManual" 
	action="ManualSubmit.cfm?systemModule=#url.systemmodule#&functionclass=#url.functionclass#" 
	method="POST" 
	target="processmanualadd">
	
		<cfoutput>
		<table width="95%" align="center">
			<tr><td height="10"></td></tr>
			<tr>
				<td width="20%"><cf_tl id="Name">:</td>
				<td>
					<table width="100%" align="center">			
						<cf_LanguageInput
							TableCode       		= "Ref_ModuleControl" 
							Mode            		= "Edit"
							Name            		= "FunctionName"
							Key1Value       		= "#vFunctionId#"
							Key2Value       		= ""
							Type            		= "Input"
							Required        		= "Yes"
							Message         		= "Please, enter a valid name."
							MaxLength       		= "40"
							Size            		= "50"
							Class           		= "regular"
							Operational     		= "1"
							Label           		= "Yes">
					</table>
				</td>
			</tr>
			<tr><td height="#vSeparator#"></td></tr>
			<tr>
				<td><cf_tl id="Subtitle">:</td>
				<td>
					<table width="100%" align="center">			
						<cf_LanguageInput
							TableCode       		= "Ref_ModuleControl" 
							Mode            		= "Edit"
							Name            		= "FunctionMemo"
							Key1Value       		= "#vFunctionId#"
							Key2Value       		= ""
							Type            		= "Input"
							Required        		= "No"
							Message         		= "Please, enter a valid memo."
							MaxLength       		= "100"
							Size            		= "50"
							Class           		= "regular"
							Operational     		= "1"
							Label           		= "Yes">
					</table>
				</td>
			</tr>
			<tr><td height="#vSeparator#"></td></tr>
			<tr>
				<td><cf_tl id="Order">:</td>
				<td>
					<cfinput type="Text" 
						name="MenuOrder" 
						required="Yes"
						message="Please, enter a valid numeric order." 
					   	class="regular"
					   	size="1" 
						maxlength="3" 
						validate="integer"
						value="" 
						style="text-align:center;">
				</td>
			</tr>
			<tr><td height="#vSeparator#"></td></tr>
			<tr>
				<td><cf_tl id="File Path">:</td>
				<td colspan="2">
					<table>
						<tr bgcolor="FFFFCF">
							<td colspan="2">
								<table>
									<tr>
										<td class="labelit"><input type="Radio" name="hostSelect" value="0" checked onclick="toggleFunctionHost(this);"> Default:</td>
										<td rowspan="2" class="labelit" style="padding-left:10px;">
											<span id="functionHostDefault">#session.root#</span>
											<cfinput type="Text" name="functionHost" id="functionHost" value="" class="regular" size="40" maxlength="30" style="display:none;">
										</td>
									</tr>
									<tr>
										<td class="labelit"><input type="Radio" name="hostSelect" value="1" onclick="toggleFunctionHost(this);"> Dedicated:</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style="font-size:10px;"><i>Directory:</i></td>
							<td style="font-size:10px;"><i>Template:</i></td>
						</tr>
						<tr bgcolor="FFFFCF">
							<td style="padding-right:4px;">
								<cfinput type="Text" 
									name="functionDirectory" 
									required="yes" 
									message="Please, enter a valid directory."
								   	class="regular"
								   	size="35"
									value=""
								   	maxlength="80" 
									style="text-align:right; padding-right:2px;">
							</td>
							<td style="padding-right:2px;">
								<table>
									<tr>
										<td style="padding-right:2px;">
											<cfinput type="Text" 
												name="functionPath" 
												required="yes"
												message="Please, enter a valid template." 
											   	class="regular"
											   	size="35"
												value=""
												onblur= "ColdFusion.navigate('FileValidation.cfm?root='+document.getElementById('functionHost').value+'&template='+document.getElementById('functionDirectory').value+this.value+'&container=pathValidationDiv&resultField=validatePath','pathValidationDiv')"
											   	maxlength="80">
										</td>
										<td valign="middle" align="left" width="50%">
										 	<cfdiv id="pathValidationDiv" bind="url:FileValidation.cfm?template=&container=pathValidationDiv&resultField=validatePath">				
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr><td class="linedotted" colspan="2"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="2" align="center">
					<input type="Submit" class="button10s" style="width:120;height:23" name="save" id="save" value="Save" onclick="return validateFileFields();">			
				</td>
			</tr>
		</table>
		</cfoutput>
		
</cfform>

<table>
	<tr class="hide"><td><iframe name="processmanualadd" id="processmanualadd" frameborder="0"></iframe></td></tr>
</table>