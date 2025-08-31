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
<cfparam name="Form.Crit1_FieldName" default="">
<cfparam name="Form.Crit2_FieldName" default="">
<cfparam name="Form.Crit3_FieldName" default="">
<cfparam name="Form.Crit4_FieldName" default="">
<cfparam name="URL.ItemMaster" default="">
<cfparam name="FORM.ItemMaster" default="#url.itemmaster#">

<CFSET Criteria = ''>

<cfif Form.Crit1_FieldName neq "">

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
<CF_Search_AppendCriteria
    FieldName="#Form.Crit5_FieldName#"
    FieldType="#Form.Crit5_FieldType#"
    Operator="#Form.Crit5_Operator#"
    Value="#Form.Crit5_Value#">
<CF_Search_AppendCriteria
		FieldName="#Form.Crit6_FieldName#"
		FieldType="#Form.Crit6_FieldType#"
		Operator="#Form.Crit6_Operator#"
		Value="#Form.Crit6_Value#">

</cfif>	
	
<!--- <cfoutput>#PreserveSingleQuotes(Criteria)#</cfoutput> ---> 

<cfquery name="CheckMaster" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   Item
	WHERE  ItemMaster = '#Form.ItemMaster#' 	
</cfquery>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 400 
	       I.ItemDescription, 
	       I.ItemNo, 
		   I.Classification, 
		   I.Category, 
		   U.UoM, 
		   U.UoMDescription,
		   U.ItemBarCode,
		   U.ItemUoMId,
		   U.StandardCost 
	FROM   #CLIENT.LanPrefix#Item I, ItemUoM U
	WHERE  I.ItemNo = U.ItemNo
	AND    I.Operational = '1'
	<cfif url.mission neq "">
	AND    EXISTS (SELECT 'X' FROM ItemUoMMission WHERE ItemNo = U.ItemNo and UoM = U.UoM and Mission = '#url.mission#')
	</cfif>	
	<cfif checkMaster.recordcount gte "1">	
    	AND    I.ItemMaster = '#Form.ItemMaster#'
	<cfelse>
		AND 1 = 0
	</cfif>
	<cfif Criteria neq "">
	AND    #PreserveSingleQuotes(Criteria)# 
	</cfif>
	ORDER BY ItemDescription 

</cfquery>

<cf_divscroll>
	
<table width="98%" class="navigation_table">

  <tr class="fixrow labelmedium2 line">
	  <td></td>
	  <td></td>
	  <td><cf_tl id="Description"></td>
	  <td><cf_tl id="Barcode"></td>	  
	  <td><cf_tl id="Cat"></td>
	  <!---
	  <td><cf_tl id="Classification"></td>
	  --->
	  <td><cf_tl id="UoM"></td>
	  <td align="right" style="padding-right:3px"><cf_tl id="Cost"></td>
  </tr>	
      				
  <CFOUTPUT query="SearchResult">
	
	<cfset des = ReplaceNoCase(ItemDescription,"'",'','ALL')>
	<cfset des = ReplaceNoCase(des,'"','','ALL')>
	
	<TR class="navigation_row line labelmedium2">
		<td style="width:20px;padding-left:3px;padding-top:2px;padding-right:3px">		
			<cf_img icon="select" navigation="Yes" onClick="selected('#ItemUoMId#')">				        			
		</td>
		<td style="padding-left:4px"></td>
		<TD style="padding-right:3px"><A HREF ="javascript:item('#ItemNo#','','#URL.Mission#')">#ItemDescription#</A></TD>
		<TD style="padding-right:3px">#ItemBarCode#</TD>		
		<TD style="padding-right:3px">#Category#</TD>
		<!---
		<TD style="padding-right:3px">#Classification#</TD>
		--->
		<TD style="padding-right:3px">#UoMDescription#</TD>
		<td align="right" style="padding-right:3px">#NumberFormat(StandardCost,',.__')#</td>		
	</TR>
	
  </CFOUTPUT>	
		
</TABLE>

</cf_divscroll>

<cfset AjaxOnLoad("doHighlight")>	
