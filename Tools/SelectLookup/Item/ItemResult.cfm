
<cfparam name="criteria" default="">

<CFSET val = evaluate("Form.Crit1_Value_#url.box#")>

<cfif val neq "">

	<CF_Search_AppendCriteria
	    FieldName = "#evaluate('Form.Crit1_FieldName_#url.box#')#"
	    FieldType = "#evaluate('Form.Crit1_FieldType_#url.box#')#"
	    Operator  = "#evaluate('Form.Crit1_Operator_#url.box#')#"
	    Value     = "#evaluate('Form.Crit1_Value_#url.box#')#">
	
</cfif>	

<CFSET val = evaluate("Form.Crit2_Value_#url.box#")>
	
<cfif val neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName = "#evaluate('Form.Crit2_FieldName_#url.box#')#"
	    FieldType = "#evaluate('Form.Crit2_FieldType_#url.box#')#"
	    Operator  = "#evaluate('Form.Crit2_Operator_#url.box#')#"
	    Value     = "#evaluate('Form.Crit2_Value_#url.box#')#">

</cfif>


<CFSET val = evaluate("Form.Crit4_Value_#url.box#")>
	
<cfif val neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName = "#evaluate('Form.Crit4_FieldName_#url.box#')#"
	    FieldType = "#evaluate('Form.Crit4_FieldType_#url.box#')#"
	    Operator  = "#evaluate('Form.Crit4_Operator_#url.box#')#"
	    Value     = "#evaluate('Form.Crit4_Value_#url.box#')#">

</cfif>

<cfset itemcondition = criteria>


<!--- lot --->

<cfset criteria = "">

<cfparam name="Form.Crit3_Value_#url.box#" default="">
<CFSET val = evaluate("Form.Crit3_Value_#url.box#")>

<cfif val neq "">

	<CF_Search_AppendCriteria
	    FieldName = "#evaluate('Form.Crit3_FieldName_#url.box#')#"
	    FieldType = "#evaluate('Form.Crit3_FieldType_#url.box#')#"
	    Operator  = "#evaluate('Form.Crit3_Operator_#url.box#')#"
	    Value     = "#evaluate('Form.Crit3_Value_#url.box#')#">
		
</cfif>		

<cfset lotcondition = criteria>
   
<table width="100%">
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*) as Total
    FROM   Item
	WHERE  Operational = 1
	
	<cfif itemcondition neq "">
	AND    #preserveSingleQuotes(itemcondition)# 	
	</cfif>
	
	<cfif lotcondition neq "">	
	AND   ItemNo IN (SELECT ItemNo FROM ItemTransaction WHERE Warehouse = '#filter1value#' AND #preserveSingleQuotes(lotcondition)#)	
	</cfif>
	
	<cfif filter1 eq "Warehouse">
	
	   AND   ItemNo IN (
	                     SELECT ItemNo 
						 FROM   Item 
						 WHERE  Category IN (SELECT Category 
	                                         FROM   WarehouseCategory 
										     WHERE  Warehouse = '#filter1value#')
					   )
					   
	<cfelseif filter1 eq "Category">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#') 
	<cfelseif filter1 eq "ItemClass">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#')	
	</cfif>
		
	<cfif filter2 eq "Asset">
		<!--- filter based on the asset which is selected to ItemSupply --->	
		<!--- Kristhian Herrera - 07/11/2011 - For warehouse, items stock levels --->
	<cfelseif filter2 eq "ItemClass">
		<cfset vItemClass = ListQualify(filter2value,"'")>
		AND   ItemClass   IN (#preserveSingleQuotes(vItemClass)#)		
	<cfelseif filter2 eq "Destination">	
	    <cfset vItemClass = ListQualify(filter2value,"'")>
		AND   Destination IN (#preserveSingleQuotes(vItemClass)#)		
	</cfif>		

</cfquery>

<cfif url.stock eq "1">

	<cf_pagecountN show="14" 
          count="#Total.Total#">
			   
<cfelse>

	<cf_pagecountN show="13" 
          count="#Total.Total#">

</cfif>			   
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *
    FROM Item
	WHERE 1=1
	<cfif itemcondition neq "">
	AND #preserveSingleQuotes(itemcondition)# 	
	</cfif>
	
	<cfif lotcondition neq "">	
	AND   ItemNo IN (SELECT ItemNo FROM ItemTransaction WHERE Warehouse = '#filter1value#' AND #preserveSingleQuotes(lotcondition)#)	
	</cfif>
	
	<cfif filter1 eq "Warehouse">
	   AND   ItemNo IN (
	                     SELECT ItemNo 
						 FROM   Item 
						 WHERE  Category IN (SELECT Category 
	                                         FROM   WarehouseCategory 
										     WHERE  Warehouse = '#filter1value#')
	
				   )	
				   
				   				   
	<cfelseif filter1 eq "Category">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#')
	<cfelseif filter1 eq "ItemClass">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#')
	</cfif>
		
	<cfif filter2 eq "Asset">
	<!--- filter based on the asset which is selected to ItemSupply --->
	
	<cfelseif filter2 eq "Destination">
	    <cfset vItemClass = ListQualify(filter2value,"'")>
		AND   Destination in (#preserveSingleQuotes(vItemClass)#)		
	<!--- Kristhian Herrera - 07/11/2011 - For warehouse, items stock levels --->
	<cfelseif filter2 eq "ItemClass">
		<cfset vItemClass = ListQualify(filter2value,"'")>
		AND   ItemClass in (#preserveSingleQuotes(vItemClass)#)
	</cfif>
	
ORDER BY ItemNo
</cfquery>

<table width="100%" class="navigation_table">

<tr><td height="14" colspan="7">
						 
	 <cfinclude template="ItemNavigation.cfm">
	 				 
</td></tr>

<cfinvoke component="Service.Presentation.Presentation" 
     		   method="highlight"  returnvariable="stylescroll"/>			

<cfif searchresult.recordcount eq "0">
	<tr><td height="26" colspan="7" align="center" class="labelmedium"><font color="FF0000">No items to show in this view</font></td></tr>
<cfelse>

<tr class="line labelmedium" style="height:18px">
    <td></td>
    <td><cf_tl id="Item"></td>
	<td><cf_tl id="External"></td>
	<td><cf_tl id="Name"></td>
	<cfif url.stock eq "0" or url.filter1 neq "warehouse">
		<td><cf_tl id="UoM"></td>
		<td align="right"><cf_tl id="Standard Cost"></td>
	</cfif>
</tr>

</cfif>

<!--- convert any jv conversion in the link --->

<!--- determine values on the fly in { } --->
	
<cfset start = "1">
<cfset new   = link>

<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>			
			<cfset fld = Mid(new, str, end-str)>									
			<cfif fld eq "height">			
				<cfset qry = "'+document.body.clientHeight+'">									
			<cfelseif fld eq "width">			
				<cfset qry = "'+document.body.clientWidth+'">				
			<cfelse>			
			<cfset qry = "'+document.getElementById('#fld#').value+'">						
			</cfif>			
			<cfset new = replace(new,"{#fld#}","#qry#")>  			
			<cfset start = end>			
		<cfelse>		
			<cfset start = len(new)+1>	
		</cfif> 
	
</cfloop>	

<cfset link   = new>	

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<cfif url.stock eq "0" or url.filter1 neq "warehouse">
			
		<cfset link    = replace(url.link,"||","&","ALL")>

		<tr class="navigation_row line labelmedium" style="height:22px">
		
		  <td width="30" class="navigation_action" style="padding-left:4px;padding-top:2px" onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#itemNo#','#url.box#');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>"><cf_img icon="select"></td>
			<td>#ItemNo#</td>
			<td>#ItemNoExternal#</td>
			<TD style="width:50%">#ItemDescription#</TD>
											
			<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 3 *
			    FROM   ItemUoM
				WHERE  ItemNo = '#itemno#'	
			</cfquery>
			
			<cfloop query="UoM">
			
				<cfif currentrow neq "1">
				<tr>
				<td></td>
				<td></td>
				<td></td>
				</cfif>
						
				<td>#UoMDescription#</td>
				<td align="right">#numberformat(UOM.standardcost,",.__")#</td>		
				</tr>
				
		   </cfloop>
		
		</tr>
	  
	 <cfelse>
	 	 			 	 
	     <cfset setlink = "#SESSION.root#/Tools/SelectLookup/Item/ItemStock.cfm?link=#link#&close=#url.close#&filter1value=#url.filter1value#">	
			 
		 <tr class="navigation_action navigation_row line labelmedium"		    
			onclick="_cf_loadingtexthtml='';ptoken.navigate('#setlink#&action=insert&des1=#url.des1#&#url.des1#=#itemno#&box=#url.box#','dlist')">
		 
		   <td width="30" style="padding-left:4px;padding-top:3px"><cf_img icon="select"></td>
		   <td style="min-width:80">#ItemNo#</td>
		   <TD width="85%">#ItemDescription#</TD>
			
		</tr>
	 		 
	 </cfif> 
	 	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="14" colspan="7">						 
	 <cfinclude template="ItemNavigation.cfm">	 				 
</td></tr>

</TABLE>
 
</td>
 
</table>

<cfset AjaxOnLoad("doHighlight")>
