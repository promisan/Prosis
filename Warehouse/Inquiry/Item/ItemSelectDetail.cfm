
<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
	
<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 400 I.ItemDescription, 
	    	   I.ItemNo, 
			   I.Classification, 
		       I.Category, 
		       U.UoM, 
			   U.ItemBarCode,
			   U.ItemUoMId,
		       U.UoMDescription,
		       U.StandardCost 
	FROM   #CLIENT.LanPrefix#Item I, ItemUoM U
	WHERE  I.ItemNo = U.ItemNo
	AND    I.Operational = '1'
	
	<!--- do not allow to activate stock for UoM that are not available for stock --->
	<cfif url.mission neq "">
	
	AND    EXISTS  (SELECT 'X' 
	               FROM   ItemUoMMission 
				   WHERE  Itemno = U.ItemNo 
				   AND    UoM = U.UoM 
				   AND    Mission = '#url.mission#'
				   AND    TransactionUoM is NULL)
	</cfif>			   
				   
	<cfif url.itemmaster neq "">
	AND  I.ItemMaster = '#url.itemmaster#'
	</cfif>
	<cfif url.itemclass eq "Supply">
	AND   I.ItemClass IN ('Supply','Service')
	</cfif>
	<cfif Criteria neq "">
	   AND #PreserveSingleQuotes(Criteria)# 
	</cfif>
	ORDER BY ItemDescription
</cfquery>

<cfif searchResult.recordcount eq "0">
		
	<!--- Query returning search results --->
	<cfquery name="SearchResult" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 400 I.ItemDescription, 
		    	   I.ItemNo, 
				   I.Classification, 
			       I.Category, 
			       U.UoM, 
				   U.ItemUoMId,
				   U.ItemBarCode,
			       U.UoMDescription,
			       U.StandardCost 
		FROM #CLIENT.LanPrefix#Item I, ItemUoM U
		WHERE I.ItemNo = U.ItemNo
		AND   I.Operational = '1'	
		<cfif url.itemclass eq "Supply">
		AND   I.ItemClass = 'Supply'
		</cfif>
		<cfif Criteria neq "">
		   AND #PreserveSingleQuotes(Criteria)# 
		</cfif>
		ORDER BY ItemDescription
	</cfquery>

</cfif>
	
<table width="100%" cellspacing="0" cellpadding="0" align="right" class="navigation_table">

  <tr>
   
   <td align="right">
    
	<table width="100%" border="0" cellspacing="0" cellpadding="0" frame="all">   
	
		<tr>
			<td></td>
			<td></td>
			<td class="labelit"><cf_tl id="Description"></td>
			<td class="labelit"><cf_tl id="Classification"></td>
			<td class="labelit"><cf_tl id="Barcode"></td>
			<td class="labelit"><cf_tl id="Category"></td>
			<td class="labelit"><cf_tl id="UoM"></td>
			<td class="labelit" align="right"><cf_tl id="Cost"></td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td class="linedotted" colspan="8"></td></tr>
		<tr><td height="5"></td></tr>
			
	<CFOUTPUT query="SearchResult">
	
		<cfset des = ReplaceNoCase(ItemDescription,"'",'','ALL')>
		<cfset des = ReplaceNoCase(des,'"','','ALL')>
		
		<TR class="labelit linedotted navigation_row">

			<td height="20" style="padding-left:4px;padding-top:2px;padding-right:5px">
			
			<cfif url.mode eq "cfwindow">					
		     	<cf_img icon="select" onClick="setvalue('#ItemUoMId#');" navigation="Yes">	
		    <cfelse>			
				<cf_img icon="select" onClick="Selected('#ItemNo#','#des#','#UoM#','#UoMDescription#');" navigation="Yes">	
		    </cfif>
			
			</td>
			<td style="padding-right:2px"></td>
			<TD style="padding-right:2px">#ItemDescription#</TD>
			<TD style="padding-right:2px">#Classification#</TD>
			<TD style="padding-right:2px">#ItemBarCode#</TD>
			<TD style="padding-right:2px">#Category#</TD>
			<TD style="padding-right:2px">#UoMDescription#</TD>
			<td style="padding-right:2px" align="right">#NumberFormat(StandardCost,',.__')#</td>
		
		</TR>
		
	</CFOUTPUT>
	
	</table>
		
	</td>
	
	</tr>
		
</TABLE>

<cfset ajaxonload("doHighlight")>
