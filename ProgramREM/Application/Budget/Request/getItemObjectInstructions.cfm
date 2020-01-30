<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
	  	FROM   	ItemMasterObject
	 	WHERE  	ItemMaster = '#url.itemmaster#'
	  	AND		ObjectCode = '#url.object#'
</cfquery>

<cfoutput>
	<table width="98%" align="center" class="formpadding">
		<tr><td height="5"></td></tr>		
		<tr>
			<td class="labelit" colspan="2" style="padding:10px; border-radius:7px;border:1px solid ##C0C0C0; background-color:##EfEfEf;">
				<cfif trim(get.BudgetEntryInstruction) neq "">
					#get.BudgetEntryInstruction#
				<cfelse>
					<table>
						<tr><td class="labelit" align="center">[<cf_tl id="No instructions recorded">]</td></tr>
					</table>
				</cfif>				
			</td>
		</tr>
	</table>

</cfoutput>
