<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Stock Class" 
			  option="Maintaing Stock Class - #url.id1#" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_StockClass
		WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this stock class ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
		<b>#get.Code#</b>
  	   <input type="hidden"  name="Code"    id="Code"    value="#get.Code#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden"  name="Codeold" id="Codeold" value="#get.Code#" size="20" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="please enter a description" 
		   required="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="#get.listingOrder#" 
		   message="please enter an integer order"  
		   validate="integer"
		   required="yes" 
		   size="2" 
	       maxlength="2" 
		   style="text-align:center;"
		   class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">	
		<cfquery name="CountRec" 
	      datasource="appsMaterials" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT StockClass
	      FROM   ItemWarehouseStockClass
	      WHERE  StockClass  = '#url.id1#' 
	    </cfquery>
		<cfif countRec.recordcount eq 0>
			<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		</cfif>
    	<input class="button10g" type="submit" name="Update" id="Update" value="Update">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>
	
<cf_screenbottom layout="innerbox">
