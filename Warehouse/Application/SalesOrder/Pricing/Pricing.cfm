
<cfif isDefined("form.currency")>

	<cfset url.category = form.category>
	<cfset url.programcode = form.ProgramCode>
	<cfset url.currency = form.currency>
	<cfset url.SelectionDate = form.SelectionDate>
	
<cfelse>

	<table width="100%" height="300" align="center">
	<tr><td class="label" align="center"><font color="808080">No sales pricing was defined for this facility and category. <br>Please define this under  Maintain Warehouse Category - Set Price Schedule.</font></td></tr>	
	<cfabort>
	
</cfif>

<cfajaximport tags="cfform,cfdiv">

<cf_menuscript>

<table width="100%" height="100%" align="center">
	
	<tr class="hide"><td height="1" id="process2"></td></tr>	 
	
	<tr>
	
		<td colspan="2" height="100%" valign="top">
			
		<table width="100%" height="100%">
		
				<cf_menucontainer item="1" class="regular">
					<cfdiv id="divPriceMenu" style="height:100%" bind="url:../../SalesOrder/Pricing/Listing/ControlListData.cfm?mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&currency=#url.currency#&category=#url.category#&programcode=#url.programcode#&selectionDate=#url.SelectionDate#">
				</cf_menucontainer>
							
		</table>
		</td>
	</tr>	

</table>