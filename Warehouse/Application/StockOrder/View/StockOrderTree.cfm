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
<table width="99%" height="100%" cellspacing="0" border="0">
    
	<cfoutput>
	
	 <tr>
		  <td style="padding-top:10px;padding-right:2px">
		    <table width="100%">		
			<tr>
		     <td width="5%" style="padding-left:5px"><img src="#SESSION.root#/Images/select4.gif" alt="" border="0"></td>
		        <td width="45%" id="new" class="labelmediumcl" style="cursor:pointer" onclick="javascript:addrequest('#url.mission#')"
				onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''">				
				 Add a Request
				 </td>
		    </tr>				
			</table>
		  </td>
	 </tr>
	 
	  <tr>
		  <td style="padding-top:4px;padding-right:2px">
		    <table width="100%">		
			<tr>
		     <td width="5%" style="padding-left:5px"><img src="#SESSION.root#/Images/select4.gif" alt="" border="0"></td>
		        <td width="45%" class="labelmediumcl" style="cursor:pointer"
				onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" onclick="javascript:findrequest('#url.mission#','#url.systemfunctionid#')">
				 Find a Request
				 </td>
		    </tr>
			<tr><td height="7"></td></tr>		
			</table>
		  </td>
	 </tr>
	 
	</cfoutput>		
					
	<tr class="hide"><td colspan="2" width="100%" id="newentry"></td></tr>	
		
	<tr id="box1">
	<td id="contentbox1" height="100%" bgcolor="ffffff" valign="top" style="padding-top:4px;border-top:1px dotted silver">	
	   <cf_divscroll style="padding-right:10px">	
	   <cfinclude template="StockOrderTreeRequest.cfm">		
	   </cf_divscroll>
	</td>
	</tr>	
	
</table>
