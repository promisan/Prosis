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
<cfparam name="init" default="0">

<cfoutput>

<tr style="cursor: pointer;"> 

		<td width="50" align="center"><b>#Row#.</b></td>
		<td width="80">
			#SourcePostNumber#</b>
		</td>
		<td colspan="2" width="420">
			#ParentFunction# / #ParentPostType#
			
		</td>
    	<td width="60"><cfif init eq "0">(#timeformat(now(),"HH:MM")#)</cfif></td>
		<td width="60" align="right">
		
		 <cfif Mandate.MandateStatus eq "0"
	      and ((AccessPosition eq "EDIT" or AccessPosition eq "ALL") 
		  or  (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL"))>
  
	  		<img src="#SESSION.root#/Images/delete5.gif"
			     height="11" width="11"
			     alt="Remove Position and Assignments"
				 onclick="refresh('#PositionParentId#','parentdelete')"
			     border="0"
			     style="cursor: pointer;">
  
  		<cfelse>

			<b>#ApprovalReference#
		
		</cfif>
		
		&nbsp;
		
		</td>			
		<cfif ParentEffective neq Mandate.DateEffective>
			<td width="80" bgcolor="0080FF" align="center">
				<font color="FFFFFF">#DateFormat(ParentEffective,CLIENT.DateFormatShow)#</font>
			</td>
		<cfelse>
			<td></td>
		</cfif>
		
		<cfif ParentExpiration neq Mandate.DateExpiration>
		<td width="80" bgcolor="0080FF" align="center">
			<font color="FFFFFF">#DateFormat(ParentExpiration,CLIENT.DateFormatShow)#</font>
		</td>
		<cfelse>
			<td></td>
		</cfif>
		<td width="30" align="center">
		
		<img src="#SESSION.root#/Images/icon_expand.gif" alt="Show assignment history" 
			id="ass#PositionParentId#Exp" border="0" class="show" 
			align="absmiddle" style="cursor: pointer;" 
			onClick="more('ass#PositionParentId#','#PositionParentId#')">
			
		<img src="#SESSION.root#/Images/icon_collapse.gif" 
			id="ass#PositionParentId#Min" alt="" border="0" 
			align="absmiddle" class="hide" style="cursor: pointer;" 
			onClick="more('ass#PositionParentId#','#PositionParentId#')">	
		
		</td>
		<TD></TD>
				
</tr>

<tr bgcolor="white" class="hide" id="ass#PositionParentId#">
    <td bgcolor="white"></td><td colspan="7" id="iass#PositionParentId#"></td>
</tr>

</cfoutput>