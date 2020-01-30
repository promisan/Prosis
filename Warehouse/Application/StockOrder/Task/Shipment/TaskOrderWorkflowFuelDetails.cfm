<cfoutput>


<table width="100%">

	<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    TaskOrder
		WHERE   StockOrderId = '#Object.ObjectKeyValue4#'
	</cfquery>	
	
	<!--- get the location --->

		<cfquery name="getLocation"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
			FROM    WarehouseLocation
			WHERE   Warehouse = '#get.Warehouse#'
			AND     Location  = '#get.Location#'
		</cfquery>			
		
		<tr>
		<td colspan="3"	height="40" bgcolor="f4f4f4" align="center" class="top4n" style="padding-left:20"><font face="Verdana" size="3">
		Transfer stock to : <b>#getLocation.Description#</b>
		</font></td></tr>

<tr class="xxhide">
	<td width="100%" colspan="3" id = "dreturn" name = "dreturn">
	</td>
</tr>		
	

<tr>
<td width="30%"></td>
<td align="center">
<cf_tableround>
<cfform id="fseals">
    <input type="hidden" id = "reference1" name ="reference1">
    <input type="hidden" id = "reference2" name ="reference2">
    <input type="hidden" id = "reference3" name ="reference3">		
	
	<table width="100%"
	       border="0"
		   align="center"
	       cellspacing="0"	   
		   cellpadding="0"> 
		   

		<cfquery name="getDetails"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
			FROM    TaskOrderDetail
			WHERE   StockOrderId = '#Object.ObjectKeyValue4#'
			ORDER   BY DetailNo
		</cfquery>	
		
		<cfset cnt = 1>
			<tr height="15">
				<td width = "2%" align = "center" class = "title">
					No.
				</td>	
				<td align="center" class = "title">
					Top Hatch
				</td>
				<td align="center" class = "title">
					Issue Valves
				</td>
				<td align="center" class = "title">
					Foot Valves
				</td>

				
			</tr>
		
		
		<cfloop query="getDetails">
			<tr height="15">
				<td width = "2%" align = "center">
					#cnt#.
				</td>	
				<td align="center">
					<input type="text" name="reference1_#cnt#" id="reference1_#cnt#" size="10" maxlength="10" onchange = "saveseal('#Object.ObjectKeyValue4#')" class = "reference1" value = "#GetDetails.Reference1#">
				</td>
				<td align="center">
					<input type="text" name="reference2_#cnt#" id="reference2_#cnt#" size="10" maxlength="10" onchange = "saveseal('#Object.ObjectKeyValue4#')" class = "reference2" value = "#GetDetails.Reference2#">
				</td>
				<td align="center">
					<input type="text" name="reference3_#cnt#" id="reference3_#cnt#" size="10" maxlength="10" onchange = "saveseal('#Object.ObjectKeyValue4#')" class = "reference3" value = "#GetDetails.Reference3#">
				</td>
				
			</tr>
			<tr><td colspan="2" style="height:2px" class="linedotted"></td></tr>
			
			<cfset cnt = cnt + 1>
		</cfloop>
		
		   
		<cfloop from = #cnt# to = 10 index = i>
			<tr height="15">
				<td width = "2%" align = "center">
					#i#.
				</td>	
				<td align="center">
					<input type="text" name="reference1_#i#" id="reference1_#i#" size="10" maxlength="10" onchange = "saveseal('#Object.ObjectKeyValue4#')" class = "reference1">
				</td>
				<td align="center">
					<input type="text" name="reference2_#i#" id="reference2_#i#" size="10" maxlength="10" onchange = "saveseal('#Object.ObjectKeyValue4#')" class = "reference2">
				</td>
				<td align="center">
					<input type="text" name="reference3_#i#" id="reference3_#i#" size="10" maxlength="10" onchange = "saveseal('#Object.ObjectKeyValue4#')" class = "reference3">
				</td>

			</tr>
			<tr><td colspan="2" style="height:2px" class="linedotted"></td></tr>
		</cfloop>
	
	
	</table>
</cfform>
</cf_tableround>
</td>
<td width="30%"></td>
</tr>
</table>

</cfoutput>


<cfset AjaxOnLoad("textinit")>