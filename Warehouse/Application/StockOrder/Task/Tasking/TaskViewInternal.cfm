<!--
    Copyright © 2025 Promisan

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

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Request R, Item I
	  WHERE  RequestId = '#URL.RequestId#'
	  AND    R.ItemNo = I.ItemNo
</cfquery>

<cfquery name="Current" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT  * 
	  FROM    RequestTask			  
	  WHERE   RequestId    = '#URL.RequestId#'
	  AND     TaskSerialNo = '#URL.SerialNo#'
</cfquery>

<cfset url.taskedwarehouse = current.sourceWarehouse>

<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td colspan="1" height="35">
<table cellspacing="0" cellpadding="0">
<tr>
	<td class="labelmedium" style="font-size:25px"><cf_tl id="Ship from internal stock">:</td>
	<td style="padding-left:4px"></td>
</tr>
</table>

</td></tr>

<tr><td id="internaldetail">

	<cfinclude template="TaskViewInternalDetail.cfm">
	
</td></tr>

</table>


<cfoutput>
<script>
	Prosis.busy('no')
	parent.taskrefresh('#url.requestid#')
</script>
</cfoutput>