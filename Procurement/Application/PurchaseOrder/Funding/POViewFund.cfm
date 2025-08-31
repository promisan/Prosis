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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->
  
<cfquery name="CustomFields" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_CustomFields
	WHERE HostSerialNo = '#CLIENT.HostNo#'
</cfquery>
 
<cfquery name="ToBeFunded" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   POLine.PurchaseNo, 
           ReqFund.Fund, 
		   ReqFund.ProgramCode, 
		   ReqFund.ObjectCode, 
       	   SUM(POLine.OrderAmountBase * ReqFund.Percentage) AS AmountToBeFunded, 
		   PF.Amount AS AmountFunded,
		   FundingReference1,
		   FundingReference2,
		   FundingReference3,
		   FundingReference4
     FROM     PurchaseLine POLine INNER JOIN
              RequisitionLineFunding ReqFund ON POLine.RequisitionNo = ReqFund.RequisitionNo LEFT OUTER JOIN
              PurchaseFunding PF ON POLine.PurchaseNo = PF.PurchaseNo 
		              AND ReqFund.Fund        = PF.Fund 
					  AND ReqFund.ProgramCode = PF.ProgramCode 
					  AND ReqFund.ObjectCode  = PF.ObjectCode
     WHERE    POLine.PurchaseNo = '#URL.ID1#' 
  GROUP BY POLine.PurchaseNo, 
	 	   ReqFund.Fund, 
		   ReqFund.ProgramCode, 
		   ReqFund.ObjectCode, 
		   PF.Amount,
		   FundingReference1,
		   FundingReference2,
		   FundingReference3,
		   FundingReference4	
  ORDER BY POLine.PurchaseNo, 
		   ReqFund.Fund, 
		   ReqFund.ProgramCode, 
		   ReqFund.ObjectCode, 
		   PF.Amount	   
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" bgcolor="F4F2D0" class="formpadding">
  
    <tr>
    <td width="100%" class="regular">
  		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		 
	 <cfset rw = 0>
	 
	 <cfoutput query="ToBeFunded">
	 
	 <cfset row = #CurrentRow#>
	 
	 <tr>
	 	<td colspan="7">
		<table width="100%">
		    <!---
		    <tr><td height="1" colspan="4" bgcolor="gray"></td></tr>
			--->
		    <tr>
				<td width="40"><b>#Fund#</b></td>
				<td width="40"><b>#ObjectCode#</td>
				
					<cfquery name="Object" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT  *
			 FROM    Ref_Object
		     WHERE   Code = '#ObjectCode#' 
		   	  </cfquery>
								
				<td width="30%"><b>#Object.Description#</b></td>
			    <td width="10%"><b>#ProgramCode#</b></td>
	    		<td width="10%" align="right"><b>#NumberFormat(AmountToBeFunded,",__.___")#</b>&nbsp;</td>
			</tr>
		</table>
		</td>
	 </tr>
	 
	 <cfif #Fd# eq "1">
	 
		 <cfquery name="Lines" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT  POLine.*, POLine.OrderAmountBase * ReqFund.Percentage AS AmountToBeFunded
		 FROM    PurchaseLine POLine INNER JOIN
	             RequisitionLineFunding ReqFund ON POLine.RequisitionNo = ReqFund.RequisitionNo
	     WHERE   (POLine.PurchaseNo   = '#ToBefunded.PurchaseNo#') 
	   	   AND   (ReqFund.Fund        = '#ToBeFunded.Fund#') 
		   AND   (ReqFund.ProgramCode = '#ToBeFunded.ProgramCode#') 
		   AND   (ReqFund.ObjectCode  = '#ToBeFunded.ObjectCode#')
		 </cfquery>
	 		 			
		<cfloop query="Lines">
			
			<cfif #OrderAmountBase# lte "0">
							
			<tr bgcolor="D3FAFA" id="#requisitionno#_1">
			
			<cfelse>
			
			<tr bgcolor="f6f6f6" id="#requisitionno#_1">
			
			</cfif>
										
	        <td rowspan="1" align="center" width="4%" class="regular">
									
			<img src="#SESSION.root#/Images/view.jpg"
		     name="img1_#row#_#currentrow#"
		     width="12"
		     height="14"
		     border="0"
			 bordercolor="silver"
		     align="middle"
		     style="cursor: pointer;"
		     onClick="javascript:ProcLineEdit('#requisitionNo#','view');"
		     onMouseOver="document.img1_#row#_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
		     onMouseOut="document.img1_#row#_#currentrow#.src='#SESSION.root#/Images/view.jpg'">
			 					 
	        </td>
			<td class="regular" width="40%">#OrderItem#</td></td>
   		    <td align="right" class="regular">#OrderQuantity#</td>
		    <td class="regular" align="center">#OrderUoM#</td>
	        <td align="right" class="regular">#NumberFormat(AmountToBeFunded,",__.__")#</td>
	        <td rowspan="1" align="center"></td>
			<td align="left"class="regular">
			
		    </td>  
           	</tr>
			
			<tr><td height="1" colspan="7" class="line"></td></tr>
						
		</cfloop>
		
	</cfif>
		
	<!--- check access --->
		
	<cfif #Fd# eq "1">
		
		<cfinvoke component="Service.Access"
	    Method="procacc"
	    OrgUnit="#PO.OrgUnit#"
	    fund="#Fund#"
	    ReturnVariable="AccAccess">	
		
		<cfinvoke component="Service.Access"
	    Method="procaccmanager"
	    OrgUnit="#PO.OrgUnit#"
	    fund="#Fund#"
	    ReturnVariable="AccManAccess">	
	   
	   <cfif #AccAccess# eq "EDIT" or #AccAccess# eq "ALL" or #AccManAccess# eq "EDIT" or #AccManAccess# eq "ALL">
	   
	          <cfset rw = #rw# + 1>
	   		  <input type="hidden" name="Fund_#row#" id="Fund_#row#"        value="#Fund#">
			  <input type="hidden" name="ProgramCode_#row#" id="ProgramCode_#row#" value="#ProgramCode#">
			  <input type="hidden" name="ObjectCode_#row#" id="ObjectCode_#row#"  value="#ObjectCode#">
			  <input type="hidden" name="Amount_#row#" id="Amount_#row#"      value="#AmountToBeFunded#">
				
			  <tr>
			    <td valign="top" bgcolor="FFFFFF">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
			 	<td colspan="6">
				<table width="100%" border="0" align="left" bgcolor="EBEBD8">
				    				    
					<tr><td height="5"></td></tr>
				    <tr>
					  <td width="5%"></td>
					  <td width="20%">&nbsp;#CustomFields.FundingReference1#:</td>
					  <td width="75%"><textarea cols="50" class="regular" rows="2" name="FundingReference1_#row#">#FundingReference1#</textarea></td>
					</tr>
					<tr>
					  <td width="5%"></td>
					  <td>&nbsp;#CustomFields.FundingReference2#:</td>	
					  <td><textarea cols="50" class="regular" rows="2" name="FundingReference2_#row#">#FundingReference2#</textarea></td>
					</tr>
					<tr>	
					  <td width="5%"></td>
					  <td>&nbsp;#CustomFields.FundingReference3#:</td>
					  <td><textarea cols="50" class="regular" rows="2" name="FundingReference3_#row#">#FundingReference3#</textarea></td>
					</tr>
					<tr>
					  <td width="5%"></td>
					  <td>&nbsp;#CustomFields.FundingReference4#:</td>  
					  <td><textarea cols="50" class="regular" rows="2" name="FundingReference4_#row#">#FundingReference4#</textarea></td>
					</tr>
					<tr><td height="5"></td></tr>
				</table>
				</td>
			  </tr>
		
		</cfif>
				
	<cfelse>
	
			  <tr>
			    <td valign="top" bgcolor="EBEBD8">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
			 	<td colspan="6">
				<table width="100%" border="0" align="left" bgcolor="EBEBD8">
				    				    
					<tr><td height="5"></td></tr>
				    <tr>
					  <td width="2%"></td>
					  <td width="5%" align="right">&nbsp;#CustomFields.FundingReference1#:</td>
					  <td width="85%" bgcolor="f4f4f4">#FundingReference1#</td>
					  <td width="2%"></td>
					</tr>
					<tr>
					  <td></td>
					  <td  align="right">&nbsp;#CustomFields.FundingReference2#:</td>	
					  <td bgcolor="f4f4f4">#FundingReference2#</td>
					  <td width="2%"></td>
					</tr>
					<tr>	
					  <td></td>
					  <td  align="right">&nbsp;#CustomFields.FundingReference3#:</td>
					  <td bgcolor="f4f4f4">#FundingReference3#</td>
					  <td width="2%"></td>
					</tr>
					<tr>
					  <td></td>
					  <td  align="right">&nbsp;#CustomFields.FundingReference4#:</td>  
					  <td bgcolor="f4f4f4">#FundingReference4#</td>
					  <td></td>
					</tr>
					
					<tr><td height="5"></td></tr>
				</table>
				</td>
			  </tr>
	
	</cfif>
	
	</cfoutput>
	
	<input type="hidden" name="rows" id="rows" value="<cfoutput>#row#</cfoutput>">
					
	</table>
	
	</td></tr>
	
</table>

</BODY></HTML>
