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
<cfquery name="Parent" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT   *
     FROM     Item I, ItemUoM U
	 WHERE    I.ItemNo = U.ItemNo
	 AND      I.Category = '#URL.Category#'
	 AND      I.ItemNo != '#URL.ItemNo#'
	 AND      I.ItemClass = 'Asset'
	 ORDER BY I.ItemDescription
</cfquery>

 
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">

<!---
<TR>
 	  	<TD width="7%" align="center" class="top3N">No</TD>
		<TD width="15%" class="top3N">Stock No</TD>
		<TD width="58%" class="top3N">Description</TD>
		<TD width="10%" class="top3N">UoM</TD>
		<TD width="10%" class="top3N"></TD>
</TR>
--->

<cfoutput query="Parent"> 
<TR bgcolor="FFFFFF" class="linedotted">
    <TD width="7%"  class="labelmedium" style="padding-left:3px">#ItemNo#</TD>
	<TD width="15%" class="labelmedium">#CommodityCode#</TD>
    <TD width="58%" class="labelmedium">#ItemDescription#</TD>
	<TD width="10%" class="labelmedium">#UoM#</TD>
    <TD width="10%">
	<input type="checkbox" name="ItemUoMId" id="ItemUoMId" class="radiol" value="'#ItemUoMId#'" onClick="hl(this,this.checked)">
	</TD>
</TR>
</cfoutput>

</table>
