
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
	
<!--- <cfoutput>#PreserveSingleQuotes(Criteria)#</cfoutput> --->

<cfquery name="Filtered" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Category 
	FROM   WarehouseCategory 
	WHERE  Warehouse IN (SELECT Warehouse 
	                     FROM   Warehouse 
					     WHERE  Mission = '#url.mission#') 
</cfquery>						 

<!--- Query returning search results --->

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   I.*, U.UoM, U.UOMDescription, U.ItemUoMId, C.Description as CategoryDescription
    FROM   Item I, ItemUoM U, Ref_Category C
    WHERE  I.Category = C.Category
									   
	AND    I.ItemNo = U.ItemNo
	AND    I.ItemClass = 'Asset'
	
	<!--- has to be made generically based on ItemUoMMission in due course --->
	
	AND    I.ItemNo IN (SELECT ItemNo 
	                    FROM   ItemUoMMission 
						WHERE  ItemNo = I.ItemNo 
						AND    UoM = U.UoM 
						AND    Mission = '#url.mission#')
	
	<cfif criteria neq "">
	    AND   #PreserveSingleQuotes(Criteria)# 
	</cfif>	
	ORDER BY I.ItemDescription
</cfquery>

<cfif SearchResult.recordcount eq "0">
	
	<cfquery name="SearchResult" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   I.*, U.UoM, U.UOMDescription, U.ItemUoMId, C.Description as CategoryDescription
	    FROM   Item I, ItemUoM U, Ref_Category C
	    WHERE  I.Category = C.Category
										   
		AND    I.ItemNo = U.ItemNo
		AND    I.ItemClass = 'Asset'
				
		<cfif criteria neq "">
		    AND   #PreserveSingleQuotes(Criteria)# 
		</cfif>	
		ORDER BY I.ItemDescription
	</cfquery>

</cfif>

	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" class="navigation_table">

  <tr>
   
  	 <td align="right">
    
		<table width="100%" border="0" cellspacing="0" cellpadding="0"frame="all">   
								
		<TR>
		    <td width="30" align="center" height="12"></td>
			<td width="50" class="labelit" style="padding-left:3px" ><cf_tl id="Code"></td>
			<TD width="40%" class="labelit" style="padding-left:3px"><cf_tl id="Description"></TD>
			<TD width="10%" class="labelit" style="padding-left:3px"><cf_tl id="Make"></TD>
			<TD width="20%" class="labelit" style="padding-left:3px"><cf_tl id="Model"></TD>
			<td width="10%" class="labelit" style="padding-left:3px"><cf_tl id="UoM"></td>
			<td width="15%" class="labelit" style="padding-left:3px" ><cf_tl id="Class"></td>
		   
		</TR>
		<tr><td colspan="7" class="linedotted"></td></tr>
		
		<CFOUTPUT query="SearchResult">
		
			<cfset des = Replace(ItemDescription,'"','','ALL')>
			
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f5f5f5'))#" class="navigation_row line">
				<td height="18" align="center" valign="middle" style="padding-top:3px;padding-left:4px;padding-right:4px" class="navigation_action" onclick="Selected('#ItemNo#','#ItemUoMId#')">
				 <cf_img icon="select" onclick="Selected('#ItemNo#','#ItemUoMId#')">			
				</td>
				<TD class="labelit" style="padding-left:3px;padding-right:3px"><a href="javascript:Selected('#ItemNo#','#ItemUoMId#')">#ItemNo#</a></TD>
				<TD class="labelit" style="padding-left:3px">#ItemDescription#</TD>			
				<TD class="labelit" style="padding-left:3px">#Make#</TD>
				<TD class="labelit" style="padding-left:3px">#Model#</TD>
				<TD class="labelit" style="padding-left:3px">#UoMDescription#</TD>
				<TD class="labelit" style="padding-left:3px">#CategoryDescription#</TD>			
			</TR>
			
		</CFOUTPUT>
		
		</table>
		
	</td>
		
  </tr>

</TABLE>


<cfset AjaxOnLoad("doHighlight")>
