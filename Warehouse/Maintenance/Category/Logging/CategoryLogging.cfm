
<cfquery name="Lookup" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*,
				(SELECT DetailMode FROM Ref_AssetActionCategory WHERE ActionCategory = A.Code AND Category = '#URL.category#') as DetailMode,
				(SELECT EnableTransaction FROM Ref_AssetActionCategory WHERE ActionCategory = A.Code AND Category = '#URL.category#') as EnableTransaction,
				(SELECT ActionCategory FROM Ref_AssetActionCategory WHERE ActionCategory = A.Code AND Category = '#URL.category#') as Selected
		FROM 	Ref_AssetAction A
</cfquery>

<cf_tl id = "Logging" var = "vEnable">
<cf_tl id = "Detail" var = "vDetailMode">

<cfform action="Logging/CategoryLoggingSubmit.cfm?idmenu=#url.idmenu#&category=#url.category#" method="POST" name="categoryLogging">
	
	<table width="95%" align="center" class="formpadding" cellspacing="0" cellpadding="0">
		<tr><td height="5"></td></tr>
		<tr>
		<cfset rowCnt = 0>
		<cfoutput query="Lookup">
		
			<cfset vBGColor = "f4f4f4">
			<cfif Selected eq "">
				<cfset vBGColor = "">
			</cfif>
			
			<td id="td#Lookup.Code#" style="background-color:'#vBGColor#';" bgcolor="">
			    <table width="100%" class="formpadding">
					<tr>
						<td width="25" style="padding-left:10px">
							<input type="Checkbox" class="radiol" name="ActionCategory" id="ActionCategory" value="#Lookup.Code#" onclick="javascript: toggleEnableTransactions(this,'#Lookup.Code#');" <cfif Lookup.Selected neq "">checked</cfif>>
						</td>
						<td class="labelLARGE" style="padding-left:10px;">#Lookup.Description#
						</td>					
					</tr>
					<tr>
						<td style="height:25px" width="25"></td>
						<td>
							<table width="100%" id="div#Lookup.Code#" class="<cfif Lookup.Selected neq "">regular<cfelse>hide</cfif>">
								<tr>
									<td colspan="1" height="25" class="labelmedium">
										#vEnable#:
									</td>	
									<td class="labelmedium">
										<input type="radio" class="radiol" name="EnableTransaction_#Lookup.Code#" id="EnableTransaction_#Lookup.Code#" value="0" <cfif Lookup.EnableTransaction eq "0" or Lookup.EnableTransaction eq "">checked</cfif>>&nbsp;No
										<input type="radio" class="radiol" name="EnableTransaction_#Lookup.Code#" id="EnableTransaction_#Lookup.Code#" value="1" <cfif Lookup.EnableTransaction eq "1">checked</cfif>>&nbsp;Yes, enable entry on issuance transaction									
									</td>
								</tr>
								<tr>
									<td class="labelmedium">#vDetailMode#:</td>
									<td>
										
										<select name="DetailMode_#Lookup.Code#" id="DetailMode_#Lookup.Code#" class="regularxl">
											<option value="None" <cfif Lookup.DetailMode eq "None">selected</cfif>>None
											<option value="Standard" <cfif Lookup.DetailMode eq "Standard">selected</cfif>>Standard
											<option value="Hour" <cfif Lookup.DetailMode eq "Hour">selected</cfif>>Hour
										</select>
									</td>
								</tr>								
								<tr>
									<td style="padding-top:3px;height:25px" width="10%" valign="top" class="labelmedium"><cf_tl id="Workflow">:</td>
									<td style="padding-top:3px">
										<cfdiv id="divObservations_#code#" bind="url:Logging/CategoryWorkflowListing.cfm?category=#url.category#&code=#code#">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			
			<cfset rowCnt = rowCnt + 1>
			
			<cfif rowCnt eq 1>
				<cfset rowCnt = 0>
				</tr>				
				<tr><td colspan="2" class="line"></td></tr>
				<tr>
			</cfif>
			
		</cfoutput>
		</tr>
				
		<tr>
			<td colspan="2" align="center">
				<input class="button10g" type="submit" name="save" id="save" value="Save" style="width:120">
			</td>
		</tr>
		
	</table>

</cfform>