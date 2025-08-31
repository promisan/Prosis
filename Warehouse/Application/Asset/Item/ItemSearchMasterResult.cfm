<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

	
<table width="100%" align="right" class="navigation_table">

  <tr>
   
  	 <td align="right">
    
		<table width="100%">   
								
			<TR class="labelmedium2 line">
			    <td width="30" align="center" height="12"></td>
				<td width="50" style="padding-left:3px" ><cf_tl id="Code"></td>
				<TD width="40%" style="padding-left:3px"><cf_tl id="Description"></TD>
				<TD width="10%" style="padding-left:3px"><cf_tl id="Make"></TD>
				<TD width="20%" style="padding-left:3px"><cf_tl id="Model"></TD>
				<td width="10%" style="padding-left:3px"><cf_tl id="UoM"></td>
				<td width="15%" style="padding-left:3px" ><cf_tl id="Class"></td>		   
			</TR>
					
			<CFOUTPUT query="SearchResult">
			
				<cfset des = Replace(ItemDescription,'"','','ALL')>
				
				<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f5f5f5'))#" class="navigation_row line labelmedium2">
					<td height="18" align="center" valign="middle" style="padding-left:4px;padding-right:4px" class="navigation_action" 
					  onclick="Selected('#ItemNo#','#ItemUoMId#')">
					 <cf_img icon="select" onclick="Selected('#ItemNo#','#ItemUoMId#')">			
					</td>
					<TD style="padding-left:3px;padding-right:3px">#ItemNo#</TD>
					<TD style="padding-left:3px">#ItemDescription#</TD>			
					<TD style="padding-left:3px">#Make#</TD>
					<TD style="padding-left:3px">#Model#</TD>
					<TD style="padding-left:3px">#UoMDescription#</TD>
					<TD style="padding-left:3px">#CategoryDescription#</TD>			
				</TR>
				
			</CFOUTPUT>
		
		</table>
		
	</td>
		
  </tr>

</TABLE>


<cfset AjaxOnLoad("doHighlight")>
