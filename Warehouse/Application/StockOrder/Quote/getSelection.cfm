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
<cf_divscroll>

<table style="width:96%" align="center" class="formpadding">

    <tr><td style="height:10px"></td></tr> 

   	    <tr class="labelmedium2 line"><td colspan="2" style="font-size:16px;font-weight:bold"><cf_tl id="Filter by"></td></tr>
			
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Stock On hand"></td>
			  <td><input type="checkbox" name="SettingonHand" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Reserved stock"></td>
			  <td><input type="checkbox" name="SettingReservation" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Promotions"></td>
			  <td><input type="checkbox" name="SettingPromotion" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="Recently shipped"></td>
			  <td><input type="checkbox" name="SettingReceipt" class="radiol" value="1" onclick="search()"></td>
	    </tr>
		
		<tr class="labelmedium" style="height:23px">
		      <td style="font-size:14px"><cf_tl id="#url.mission# recommended"></td>
			  <td><input type="checkbox" name="SettingRecommend" class="radiol" value="1" onclick="search()"></td>
	    </tr>
						
		<tr><td colspan="2" class="line"></td></tr>
						
		<cfparam name="url.category" default="">
	
		<tr><td id="boxcategory" colspan="2" style="padding:6px">
	
		    <cfif url.category neq "">	
			    <cfinclude template="getSelectionCategory.cfm">		
			</cfif>
	
		</td>
		</tr>
		
</table>

</cf_divscroll>