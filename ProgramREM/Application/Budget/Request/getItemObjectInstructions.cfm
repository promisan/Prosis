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
	<table width="99%" align="center" class="formpadding">		
		<tr>
			<td class="labelit" colspan="2" style="padding:10px; border:1px solid ##d0d0d0; background-color:##f1f1f1;">
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
