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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
			
		<tr><td height="1" colspan="8" bgcolor="D2D2D2"></td></tr>
		
		<TR #stylescroll#>
		
		<td rowspan="1" align="center">
		
		<cfif Parameter.InvoiceRequisition eq "0">
		
			<img src="#SESSION.root#/Images/pointer.gif" alt="" name="img0_#currentrow#" 
			  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
			  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/pointer.gif'"
			  style="cursor: pointer;" alt="" width="9" height="9" border="0" align="middle" 
			  onClick="document.getElementById('line#purchaseno#').className='regular';ColdFusion.navigate('../../Invoice/InvoiceEntry/InvoiceEntryMatchHeader.cfm?mode=list&purchaseno=#Purchaseno#','box#purchaseno#')">	
			  	  
		<cfelse>
		
		 <img src="#SESSION.root#/Images/pointer.gif" alt="" name="img0_#currentrow#" 
			  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
			  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/pointer.gif'"
			  style="cursor: pointer;" alt="" width="9" height="9" border="0" align="middle" 
			  onClick="ProcPOEdit('#Purchaseno#','view')">
		
						
		</cfif>	  
			 							
		</td>
		
		<td align="Left" width="5%">
			&nbsp;<a href="javascript:ProcPOEdit('#Purchaseno#','view')">#PurchaseNo#</a>
		</td>
		
		<td align="center" width="70">
			<button onClick="print('#PurchaseNo#')" class="button3">
		     <img src="#SESSION.root#/Images/print_small4.gif" alt="" height="12" width="12" 
			  style="cursor: pointer;" alt=""border="0" align="absmiddle">
			</button>
		</td>
		
		<td align="left"><cfif URL.ID eq "VED">#Mission#
		
		<cfelseif OrgUnitVendor neq ""><a href="javascript:viewOrgUnit('#OrgUnitVendor#')">#Vendor#</a>
		
		<cfelseif PersonNo neq ""><a href="javascript:EditPerson('#PersonNo#')"><font color="0080FF">#Vendor#</a>
		
		</cfif></td>	
		
		<td align="left"><a href="javascript:ProcPOEdit('#Purchaseno#','view')">#ClassDescription#:<i>#TypeDescription#</a></td>						
		<td align="left">#OrgUnitName#</td>	
		
		<td align="right" style="cursor: pointer;"
		onClick="document.getElementById('line#purchaseno#').className='regular';ColdFusion.navigate('../../Invoice/InvoiceEntry/InvoiceEntryMatchHeader.cfm?mode=list&purchaseno=#Purchaseno#','box#purchaseno#')">
		#numberFormat(Amount,"_,_.__")#</td>			
		
		</tr>
		
		<tr id="line#purchaseno#" class="hide">
		<td colspan="8">	
		<cfdiv id="box#purchaseno#">		
		</td>
		</tr>		
		
</cfoutput>			