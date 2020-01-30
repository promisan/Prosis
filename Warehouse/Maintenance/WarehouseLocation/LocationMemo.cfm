
<cfparam name="url.location"      default="">
<cfparam name="url.warehouse"     default="">
<cfparam name="url.memoid"        default="">
<cfparam name="form.LocationMemo" default="">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.LocationMemo neq "">

	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   WarehouseLocationMemo
		WHERE  MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO WarehouseLocationMemo
			(Warehouse,Location,MemoId, LocationMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.warehouse#','#url.location#','#memoid#','#form.LocationMemo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE WarehouseLocationMemo
			SET    LocationMemo = '#form.LocationMemo#'
			WHERE  MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseLocationMemo
	WHERE  Warehouse = '#URL.Warehouse#'
	AND    Location  = '#url.location#'
	ORDER BY Created DESC
</cfquery>

<cfinvoke component="Service.Presentation.Presentation"
	       method="highlight" class="highlight4"
	    returnvariable="stylescroll"/>

<cfform name="memoform" id="memoform">
	
	<table width="95%" 
	  align="center" 	 
	  border="0" 
	  class="formpadding navigation_table"	  
	  cellspacing="0" 
	  cellpadding="0">
	  
	 <tr><td height="5"></td></tr> 
	
	<tr class="line">
	    <td height="24" width="20"></td>
		<td class="labelit" width="70%"><cf_tl id="Memo"></td>
		<td class="labelit"><cf_tl id="Officer"></td>
		<td class="labelit"><cf_tl id="Date">/<cf_tl id="Time"></td>
		<td align="center"></td>	
	</tr>
		
	<cfoutput query="Memo">
	
	<cfif url.memoid eq memoid and form.LocationMemo eq "" and SESSION.acc eq OfficerUserId>
	
		<tr bgcolor="ffffff">
		    <td valign="top" style="padding-top:4px" height="20">#currentrow#.</td>
			<td colspan="4" align="center" height="80">
			<textarea name="LocationMemo" class="regular" style="padding:3px;font-size:13px;width:98%;height:120">#LocationMemo#</textarea>
			</td>
		</tr>
		<tr><td height="3"></td></tr>
		<tr><td colspan="5" align="center">
		
		<input type  = "button" 
		  name       = "Save" 
		  id         = "Save"
		  value      = "Save" 
		  class      = "button10g" 
		  style      = "width:100px" 
		  onclick    = "ColdFusion.navigate('LocationMemo.cfm?warehouse=#url.warehouse#&location=#url.location#&memoid=#memoid#','contentbox2','','','POST','memoform')">
		  
		</td></tr>
		<tr><td height="3"></td></tr>
	
	<cfelse>
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="navigation_row line labelmedium" onclick="ColdFusion.navigate('LocationMemo.cfm?warehouse=#url.warehouse#&location=#url.location#&memoid=#memoid#','contentbox2')">
		<cfelse>
		<tr class="cellcontent labelmedium">
		</cfif>
		    <td valign="top" style="padding-top:3px;padding-left:3px" height="20">#currentrow#.</td>
			<td width="70%" style="padding-top:4px;padding-bottom:4px">#paragraphformat(LocationMemo)#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center" style="padding-top:3px">			
			<cf_img icon="edit" onclick="ColdFusion.navigate('LocationMemo.cfm?warehouse=#url.warehouse#&location=#url.location#&memoid=#memoid#','contentbox2')">
			</td>
		</tr>
	
	</cfif>
	
	</cfoutput>
	
	<cfif url.memoid eq "">
	
	<cf_assignId>
	<cfset memoid = rowguid>	
			
	<tr bgcolor="ffffff">
	<td valign="top" style="padding-top:4px"> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
	<td colspan="4" align="center" style="padding:4px">
		<textarea name="LocationMemo" style="padding:3px;font-size:12px;width:98%;height:120" visible="Yes" class="regular"></textarea>
	</td>
	</tr>
	<tr><td height="3"></td></tr>
	<tr><td colspan="5" align="center">
	    <cfoutput>
			<cf_tl id="Save" var = "vSave">
			
			<input type="button" 
			    name="Save" 
				id="Save"
				value="#vSave#" 
				style="width:120px" 
				class="button10s" 
				onclick="ColdFusion.navigate('LocationMemo.cfm?warehouse=#url.warehouse#&location=#url.location#&memoid=#memoid#','contentbox2','','','POST','memoform')">
				
		</cfoutput>
	</td></tr>
	<tr><td height="3"></td></tr>

	</cfif>

</table>

</cfform>

<cfset ajaxonload("doHighlight")>

