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
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_DialogProcurement>
<cf_DialogStaffing>

<cfoutput>

<script>

function hl(itm,fld,reqno){

     ln1 = document.getElementById(reqno+"_1");
	 ln2 = document.getElementById(reqno+"_2");
	 ln3 = document.getElementById(reqno+"_3");
	 	 	 		 	
	 if (fld != false){
		 ln1.className = "highLight2";
		 ln2.className = "highLight2";
		 ln3.className = "highLight2";
	 }else{
	 ln1.className = "header";		
	 ln2.className = "header";
	 ln3.className = "header";
	 }
  }
  
function mail2(mode,id) {
	  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=900, height=800, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
}	  

</script>

</cfoutput>

	<table width="100%" align="center">
	    
	  <tr>
	    <td width="100%" >
	    <table width="100%" class="formpadding navigation_table">
			
	    <TR class="labelmedium2 line fixlengthlist">
		   <td height="19"></td>
		   <td></td>
		   <td><cf_tl id="Description"></td>
		   <td><cf_tl id="Date"></td>
		   <td align="right"><cf_tl id="Quantity"></td>
		   <td align="center"><cf_tl id="UoM"></td>
		   <td align="right"><cf_tl id="Price"></td>
		   <td align="right"><cf_tl id="Amount"></td>
		   <td align="right"></td>
	    </TR>
						
		<cfif Requisition.recordcount eq "0">
		
			<tr><td height="6" colspan="9"></td></tr>			
			<tr><td colspan="9" align="center" class="labelmedium"><b><cf_tl id="REQ014"></b></td></tr>
			<tr><td height="5" colspan="9"></td></tr>
			
		</cfif>	
		
		<cfoutput query="RequisitionLine" group="Reference">
		
			<cfif reference neq "">
				
				<cfquery name="Header" 
				datasource="appsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT * 
					FROM   Requisition
					WHERE  Reference = '#Reference#' 
				</cfquery>
					
				<cfquery name="Sum" 
				datasource="appsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT COUNT(*) as Counted,
					       SUM(RequestAmountBase) as Total
					FROM   RequisitionLine
					WHERE  Reference = '#Reference#'
				</cfquery>
				
				<tr><td height="4"></td></tr>
				
				<TR bgcolor="white">
				   <td height="20" colspan="7" class="labelmedium" style="font-size:22px;padding-left:10px">#Reference#
				   
				   <img src="#SESSION.root#/Images/print_small4.gif" 
					    align   = "absmiddle" 
						style   = "cursor: pointer;height:17px"
						alt     = "Print Requisition" 
						border  = "0" 					
						onclick = "mail2('print','#Reference#')">
					
				   </td>			 
				   <td align="right" colspan="2" style="font-size:20px;padding-right:10px" class="labelmediumcl">(#Sum.Counted#)
				   <b>#NumberFormat(Sum.Total,",.__")#</td>
				   
		 	    </TR>
						
			</cfif>		
		
		<cfoutput group="ActionDescription">
		
		<tr><td height="7"></td></tr>
		<tr><td height="24" colspan="9" class="labellarge" style="padding-left:20px;border-top:1px dotted silver">
		#ActionDescription#</b></td></tr>							
		<cfoutput>		
		<tr><td height="1" colspan="9" class="line"></td></tr>

		<cfquery name="qItem" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT * 
			FROM   Item
			WHERE  ItemNo = '#WarehouseItemNo#' 
		</cfquery>
		
		<cfquery name="Fund" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    SUM(Percentage) AS Funding
			FROM      RequisitionLineFunding
			WHERE     RequisitionNo = '#RequisitionNo#'
		</cfquery>
		
		<cfif actionStatus eq "9">
		 	 <cfset color = "FCCFC9">
		<cfelse>
			 <cfset color = "transparent"> 
		</cfif>
												
		<tr class="labelmedium2 line navigation_row fixlengthlist" bgcolor="#color#">
		
		   <td rowspan="2" align="left"></td>
    	   <td></td>		  
		   <td><cfif qItem.ItemNoExternal neq "">#qItem.ItemNoExternal# - </cfif>#RequestDescription# </td>
		   <td></td>
    	   <td align="right">#RequestQuantity#</td>
		   <td align="center">#QuantityUoM#</td>
		   <td align="right">#NumberFormat(RequestCostprice,",.__")#</td>
		   <td align="right" style="padding-right:4px">#NumberFormat(RequestAmountBase,",.__")#</td>		   
		   <td align="center" style="padding-left:5px;padding-right:5px;padding-top:1px">		   
		         <cf_img icon="open" onClick="javascript:ProcReqEdit('#requisitionno#','dialog');">		 								   
		   </td>
		</tr>
		
		<tr class="labelmedium2 navigation_row_child fixlengthlist" id="#requisitionno#_2" bgcolor="#color#">
		
		<td></td>
		<td><b>#Description#</b></td>
		<td>#DateFormat(RequestDate, CLIENT.DateFormatShow)#</td>
		<td>#OrgUnitName#</td>
		<td>#RequestPriority#</td>
		<td colspan="3" style="padding-right:20px" align="right">#OfficerLastName#, #OfficerFirstName#</td>
		
		<cfset Per = Period>
		<cfset Amt = RequestAmountBase>
		
		</tr>
		
		<!--- validation --->
		
		<cfquery name="hasFunding" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     RequisitionNo, ProgramCode
			FROM       RequisitionLineFunding 														
			WHERE      RequisitionNo = '#RequisitionNo#'
		</cfquery>		
		
		<cfquery name="checkProgram" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     RL.RequisitionNo
			FROM       RequisitionLineFunding RL INNER JOIN Program.dbo.Program A ON  RL.ProgramCode = A.ProgramCode 															
			WHERE      RL.RequisitionNo = '#RequisitionNo#' 
		</cfquery>		
		
		<cfif (checkprogram.recordcount lt hasFunding.recordcount) and hasFunding.ProgramCode neq "Default" and hasFunding.ProgramCode neq "">
		
		<tr><td height="4"></td></tr>
		<tr><td></td><td></td><td height="20"
		     align="center" 
			 bgcolor="red" style="border:1px solid silver"  colspan="6" class="labelmedium2">
			 Invalid Program/Project code assigned to this Requisition line</td></tr>			 	
		</cfif>
		
		<cfquery name="checkMandate" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     Mission, MandateNo
			FROM       Ref_MissionPeriod
			WHERE      Mission = '#Mission#'			
			AND        Period  = '#Period#'
		</cfquery>		
		
		<cfquery name="checkOrgUnit" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     Mission, MandateNo
			FROM       Organization.dbo.Organization
			WHERE      Orgunit = '#Orgunit#'			
		</cfquery>		
						
		<cfif checkMandate.MandateNo neq MandateNo>
		
		<tr><td height="4"></td></tr>
		<tr  class="labelmedium2"><td></td><td></td><td height="20" align="center" bgcolor="red" colspan="6" style="border:1px solid silver">
			 <font color="gray">OrgUnit assigned belong to different mandate. Correct: #checkMandate.MandateNo# This line: #MandateNo#</td></tr>
			 	
		</cfif>	
		
		<tr><td height="0" colspan="9"></td></tr>
				
		<cfswitch expression="#fun#">

			<cfcase value="funding">
			
			   <cfquery name="Funding" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    F.*, O.CodeDisplay, 
					          O.Description as ObjectDescription
					FROM      RequisitionLineFunding F, Program.dbo.Ref_Object O
					WHERE     F.RequisitionNo = '#RequisitionNo#'	
					AND       F.ObjectCode = O.Code
    			</cfquery>
				
				<cfif funding.recordcount eq "0">
				
				<tr id="#requisitionno#_4">
				<td colspan="2"></td>
				<td bgcolor="ffffcf" style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;" 
				colspan="6" align="center"><font size="4">No funding defined</td>
				
				</cfif>
				
				<cfloop query="Funding">
				
					<cfquery name="Program" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    P.*, Pe.Reference
						FROM      Program P, ProgramPeriod Pe
						WHERE     P.ProgramCode = '#ProgramCode#'	
						AND       P.ProgramCode = Pe.ProgramCode
						AND       Pe.Period     = '#Per#'
	    			</cfquery>
					
					<tr><td height="1"></td></tr>
							
					<tr id="#requisitionno#_4">
						<td colspan="2"></td>											
						<td colspan="6" align="center" bgcolor="EEFDF1" style="border:1px solid silver;">
							<table width="100%">
							<tr class="labelmedium2 fixlengthlist">							  
							   <td style="padding-left:3px" width="10%">#Fund#</td>
							   <td style="padding-left:3px" width="10%">#ProgramPeriod#</td>
							   <td width="10%">
							   <a href="javascript:ViewProgram('#ProgramCode#','#Per#','#Program.ProgramClass#')">
							   <cfif Program.reference neq "">#Program.Reference#<cfelse>#ProgramCode#</cfif>
							   </a>
							   </td>
							   <td width="15%">#Program.ProgramName#</td>
							   <td width="35%">#CodeDisplay# #ObjectDescription#</td>							  
							   <td width="10%">#Percentage*100#%</td>
							   <td style="padding-right:3px" width="15%" align="right">#numberFormat(Percentage*amt,",.__")#</td>							   
							</tr>
							</table>
							
						</td>	  
						
	            	</tr>
					
					<tr><td height="1"></td></tr>
							
				</cfloop>
						
			</cfcase>
			
			<cfcase value="job">
						
				<cfquery name="Vendor" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    Q.*, Org.OrgUnitName
					FROM      RequisitionLineQuote Q INNER JOIN
	                	      Organization.dbo.Organization Org ON Q.OrgUnitVendor = Org.OrgUnit
					WHERE     Q.RequisitionNo = '#RequisitionNo#'	
					ORDER BY  Q.QuoteAmountBase 		
				</cfquery>
				
				<cfloop query="Vendor">
				
				<cfif QuoteAmountBase lte "0">
								
				<tr bgcolor="D3FAFA" id="#requisitionno#_4">
				
				<cfelse>
				
				<tr bgcolor="f6f6f6" id="#requisitionno#_4">
				
				</cfif>
				
				<td align="center"><cfif Selected eq "1"><img src="#SESSION.root#/Images/check.gif" alt="" width="10" height="12" border="0"></cfif></td>	  
					
		        <td rowspan="1" align="center">
				
				<cf_img icon="edit" onClick="javascript:ProcQuoteEdit('#quotationid#');">
										 
		        </td>
			   <td>#OrgUnitName#</td>
    		   <td align="center">#QuotationQuantity#</td>
			   <td align="center">#QuotationUoM#</td>
		       <td align="right">#NumberFormat(QuoteAmountBase/QuotationQuantity,",.__")#</td>
		       <td align="right" style="padding-right:5px">#NumberFormat(QuoteAmountBase,",.__")#</td>
		   
		       <td rowspan="1" align="center">
		      		<!--- 
			       <input type="checkbox" name="QuotationId" value="#QuotationId#" onClick="javascript:hl(this,this.checked,'#QuotationId#')">
				   --->		 				   
		        </td>
            	</tr>
							
				</cfloop>
						
			</cfcase>
			
		</cfswitch>			
		
		</cfoutput>
		
		</cfoutput>
		
		</cfoutput>
				
		</table>
		
		</td>
		</tr>
		
	</table>	
	
	<cfset ajaxonload("doHighlight")>
