
<cfoutput>
					
<table width="95%" align="center" class="navigation_table formpadding">

<tr class="line">
   <td></td>
   <td width="140">Name</td>
   <td>Path</td>
   <td><b>set as Keyfield</b></td>
</tr>

<tr><td height="4"></td></tr>
<tr><td class="labellarge" colspan="2">Program & Project</td></tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">

      <cfset v = "ProgramREM/Application/Program/ProgramView.cfm?ProgramId=">
      <td width="34">
	  
	  <cf_img icon="select" onClick="closeme('#v#')" navigation="Yes">
	  	  
	  </td>
      <td><a href="javascript:closeme('#v#')">Program/Project</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>ProgramId</td>
</tr>


<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">

  <cfset v = "ProgramREM/Application/Budget/Allotment/AllotmentInquiry.cfm?caller=external&programid=">
      <td width="34">
	  
	  <cf_img icon="select" onClick="closeme('#v#')" navigation="Yes">
	  	  
	  </td>
      <td><a href="javascript:closeme('#v#')">Program Allotment Execution</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>ProgramId</td>
</tr>

<tr><td height="4"></td></tr>
<tr><td class="labellarge" colspan="2">Human Resources</td></tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">

  <cfset v = "Staffing/Application/Employee/PersonView.cfm?id=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Employee</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>PersonNo</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">

  <cfset v = "Staffing/Application/Position/PositionParent/PositionView.cfm?id2=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Position</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>PositionNo</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">

  <cfset v = "Staffing/Application/Position/PositionParent/PositionView.cfm?box=&id2=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Position Parent</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>PositionNo</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
     <cfset v = "Roster/Candidate/Details/PHPView.cfm?ID=">
     <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
     <td><a href="javascript:closeme('#v#')">Candidate</a></td>
     <td><font size="2"  color="gray">#v#</td>
	 <td>PersonNo</td>
	 
</tr>

<tr><td height="4"></td></tr>
<tr><td class="labellarge" colspan="2">Operations</td></tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Warehouse/Application/Stock/Batch/batch/BatchView.cfm?drillid=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">POS sale</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>BatchNo</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?header=1&id=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Procurement Requisition</a></td>
      <td style="word-wrap: break-word; word-break: break-all;"><font size="2"  color="gray">#v#</td>
	  <td>RequisitionNo</td>	  
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Procurement/Application/PurchaseOrder/Purchase/POViewGeneral.cfm?ID1=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Purchase Order</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>PurchaseNo</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Roster/RosterSpecial/CandidateView/FunctionViewLoop.cfm?IDFunction=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Roster Bucket</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>FunctionId</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Procurement/Application/Invoice/Matching/InvoiceMatch.cfm?ID=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Invoice</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>InvoiceId</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Workorder/Application/WorkOrder/WorkorderView/WorkOrderView.cfm?workorderid=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Workorder</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>WorkorderId</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Workorder/Application/WorkOrder/WorkorderView/WorkOrderView.cfm?workorderlineid=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Workorder</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>WorkorderLineId</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "workorder/Application/Shipping/Shipment/ShipmentEntry.cfm?mode=listing&workorderlineid=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Workorder Receipt</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>WorkorderId</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Workorder/Application/WorkOrder/ServiceDetails/ServiceLineDetail.cfm?drillid=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Workorder Line</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>WorkorderLineId</td>
</tr>

<tr><td height="4"></td></tr>
<tr><td class="labellarge" colspan="2">Financials</td></tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "Gledger/Application/Transaction/View/TransactionView.cfm?ID=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">Ledger Transaction</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>TransactionId</td>
</tr>

<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "System/Access/User/UserDetail.cfm?ID=">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">System User</a></td>
      <td><font size="2"  color="gray">#v#</td>
	  <td>Account</td>
</tr>

<cfquery name="GetCustom" datasource="AppsSystem">
	SELECT * FROM Ref_ModuleControl
	Where SystemModule = 'Portal'
	AND FunctionClass = 'Custom'
</cfquery>

<cfloop query="GetCustom">
	<tr class="fixlengthlist navigation_row line labelmedium2" style="height:15px">
      <cfset v = "#GetCustom.FunctionPath#">
      <td><cf_img icon="select" onClick="closeme('#v#')" navigation="Yes"></td>
      <td><a href="javascript:closeme('#v#')">#GetCustom.FunctionName#</a></td>
	  <td><font size="2"  color="gray">#v#</td>
	  <td>#GetCustom.ScriptVariable1#</td>
	</tr>
	
</cfloop>	

</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>

