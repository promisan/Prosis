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
<cfoutput>
	
	<cfset Str = (URL.Page*show)-show+1>
	<cfset End = URL.Page*show>	
	
	<cfif End gt Total.Total>
	  <cfset End = Total.Total>
	</cfif>  
	<cfset last = ceiling(Total.total/show)>
						
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
	<td>
		<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr class="labelit">			
			<td width="37"><cf_tl id="Record"></td>
			<td align="center" class="labelit" bgcolor="white" style="padding-left:5px"><b>#str#</b> <cf_tl id="to"> <b>#End#</b></td>
			<td width="16" align="center" class="labelit" style="padding-left:5px"><cf_tl id="of"></td>
			<td align="center" class="labelit" bgcolor="white" style="padding-left:5px"><b>#Total.Total#</b></td>
			<td width="120" style="padding-left:5px"><cf_tl id="matching"><cf_tl id="records"></td>			
			</tr>
		</table>		
	</td>	
		
	<td align="right">
		
		<table cellspacing="0" class="formpadding">
		<tr>			
				
		<cfif Str gt "1">
			<td align="center" width="25">
			<button name="back2" type="button" id="back2" class="button3" onClick="combosearch('1','#url.par#','#url.cur#','#url.fly#','#url.shw#')">
			<img src="#SESSION.root#/Images/first_blue.png" title="Home" border="0">
			</button>
			</td>
			<td align="center" width="25">
			<button name="back2" type="button" id="back2" class="button3" onClick="combosearch('#url.page-1#','#url.par#','#url.cur#','#url.fly#','#url.shw#')">
			<img src="#SESSION.root#/Images/previous_blue.png" title="Back" border="0">
			</button>
			</td>
		</cfif>
		
		<cfif No lt Total.Total>
		    <td align="center" width="25">
			<button name="back2" type="button" id="back2" class="button3" onClick="combosearch('#url.page+1#','#url.par#','#url.cur#','#url.fly#','#url.shw#')">
			<img src="#SESSION.root#/Images/next_blue.png" title="Next" border="0">
			</button>
			</td>
			<td align="center" width="25">
			<button name="back2" type="button" id="back2" class="button3" onClick="combosearch('#last#','#url.par#','#url.cur#','#url.fly#','#url.shw#')">
			<img src="#SESSION.root#/Images/last_blue.png" title="Last" border="0">
			</button>
			</td>
		</cfif>
		
		</tr>
		
		</table>
		
		</td>
	
	</tr>
			
	</table>
			
</cfoutput>