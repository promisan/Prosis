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
<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     BatchNo,	
			  ActionStatus,		    
			  (SELECT  count(*) FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo) as Lines,	
			  (SELECT  count(*) FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo and ActionStatus='1') as Cleared				  			   	   			  			   
    FROM      WarehouseBatch B 
	WHERE     B.BatchNo = '#url.BatchNo#'
</cfquery>	

<cfoutput>  

<cfif get.recordcount eq "0">

<cfelseif get.ActionStatus eq "9">

	<table>
 	<tr class="labelmedium">
	   <td style="color:red;font-weight:bold" align="center"><cf_tl id="Cancelled"></td>	  
    </tr>
   </table> 

<cfelseif get.ActionStatus eq "1">

	<table>
 	<tr class="labelmedium">
	   <td style="font-size:16px;color:green;" align="center"><cf_tl id="Confirmed"></td>	  
    </tr>
   </table> 

<cfelseif get.cleared lt get.Lines>

	<table>
 	<tr class="labelmedium">
	   <td style="width:30px;font-size:16px" align="center">#get.cleared#</td>
	   <td style="font-size:16px">|</td>
	   <td align="center" style="width:30px;font-size:16px">#get.lines#</td>
    </tr>
   </table>
   
<cfelse>  

	<table>
 	<tr class="labelmedium">
	   <td style="font-size:16px;color:green" align="center"><cf_tl id="Completed"></td>	  
    </tr>
   </table> 
	
</cfif>

</cfoutput>