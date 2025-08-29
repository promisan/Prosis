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
<cfparam name="URL.mode"    default="listing">
<cfparam name="URL.tbl"     default="PurchaseLineReceipt">
<cfparam name="URL.reqno"   default="">
<cfparam name="URL.taskid"  default="">
<cfparam name="URL.action"  default="view">

<cfoutput>

<script>

    function formvalidate(process) {
		document.entry.onsubmit() 
		if( _CF_error_messages.length == 0 ) {     
		    lnk = document.getElementById('mylink').value     
			Prosis.busy('yes')   
			ptoken.navigate('ReceiptLineEditSubmit.cfm?process='+process+'&'+lnk,'process','','','POST','entry')
		}
	}	
		
	function setstockline(box,req,uom,qty,prc,mode,wuo,cur) {			    
		_cf_loadingtexthtml='';
		ptoken.navigate('setReceiptLine.cfm?mode='+mode+'&box='+box+'&requisitionno='+req+'&uom='+uom+'&warehouseitemuom='+wuo+'&quantity='+qty+'&price='+prc+'&currency='+cur,'boxordermultiplier_'+box)	   
	}
	
	function openline(mde,req,rctid,act,tsk,tbl) {			    
	    _cf_loadingtexthtml='';
		ptoken.navigate('ReceiptLineEditForm.cfm?tbs=#tbl#&mode='+mde+'&reqno='+req+'&rctid='+rctid+'&action='+act+'&taskid='+tsk+'&tbl='+tbl,'content')	   
	}
</script>

</cfoutput>

<cf_calendarscript>

<!--- mode 

Check the status of the receipt 

if status = 1 (cleared) only view
if status = 0 (not cleared) : you may edit and remove
if ordertype.receiptentry = 0 : limit the editable fields to only price + quantity
if ordertype.receiptentry = 1 : enforce the entry of a receipt record, open contract.
--->

<cfif URL.action eq "new">

	<cfajaximport tags="cfwindow">

    <cfset tbl = "stPurchaseLineReceipt">
    <cfset URL.rctid = "00000000-0000-0000-0000-000000000000">
		    		
	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   #tbl#
		WHERE  ReceiptId = '#URL.Rctid#' 
	</cfquery>
	  
<cfelse>

  <cfset tbl = "PurchaseLineReceipt"> 
	    
	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   #tbl#
		WHERE  ReceiptId = '#URL.Rctid#' 
	</cfquery>
  
  <cfset url.reqno = Line.RequisitionNo>
  
</cfif>  

<cfquery name="Receipt" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Receipt
		WHERE  ReceiptNo = '#Line.ReceiptNo#' 
	</cfquery>

<!--- get PO --->

<cfquery name="getPO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PurchaseLine
		WHERE  RequisitionNo = '#URL.reqno#' 
	</cfquery>
	
<cfif Line.recordcount eq "0">
	<cf_screentop jQuery="yes" close="parent.Prosis.busy('yes');parent.ColdFusion.Window.hide('receiptdialog');parent.history.go()" html="no" height="100%" layout="webapp" banner="gray" user="yes" line="no" label="Register Procurement Receipt #getPo.PurchaseNo#" scroll="yes">
<cfelse>
	<cf_screentop jQuery="yes" close="parent.Prosis.busy('yes');parent.ColdFusion.Window.hide('receiptdialog');parent.history.go()" html="no" height="100%" layout="webapp" banner="green" user="yes" label="Edit receipt" option="Amend receipt and inspection report for #getPo.PurchaseNo#" scroll="yes">
</cfif>	

<cfif Line.actionStatus eq "1" or Line.ActionStatus eq "2">
	 <cfset url.action = "view">
</cfif>

<!--- the set id of the receipt line for this record --->
<cfif url.rctid eq "00000000-0000-0000-0000-000000000000">
   <cf_assignid>
   <cfset receiptid = rowguid>
<cfelse>
   <cfset receiptid = url.rctid>
</cfif>		

<cf_dialogstaffing>

<!--- action="ReceiptLineEditSubmit.cfm?mode=#url.mode#&reqno=#url.reqno#&action=#URL.action#&ID=#url.rctid#&TBL=#url.tbl#&taskid=#url.taskid#" --->

<cfform method="POST" 
	onsubmit="return false"
    name="entry" 
	id="entry"
    target="myresult">
	
	<table width="100%" cellspacing="0">
		
		<!--- -------------------------------------------------- --->
		<!--- container to save the results of the submit action ---> 
		<!--- -------------------------------------------------- --->
		
		<tr class="hide"><td id="process"></td></tr>
					
		<tr>
		  <td style="padding-top:7px" id="content">	 	    				
		    <cfinclude template="ReceiptLineEditForm.cfm">			   
		  </td>
		</tr>
			
		<tr>
		
		   <td height="30" colspan="4" align="center">
		   
			   <table class="formspacing">
			   <tr>
			   	   	   
				   <cfoutput>
				   	   				   
					   <cfif Line.Actionstatus eq "0" or Line.Actionstatus eq "" or receipt.actionStatus eq "0">	
					   		   						
							<cfif url.mode neq "entry">	 					
							<td>
								<cf_tl id="Delete" var="1">
							  	<input class="button10g" style="width:160px" type="button"  name="Delete" id="Delete" value="#lt_text#" onclick="formvalidate('delete')">
							</td>					 
							</cfif>  
							
							<cfif URL.action neq "new">
							
								<td>								
								    <cf_tl id="Save" var="1">
								    <input class="button10g" style="width:160px" type="button" name="savekeep" id="savekeep" value="#lt_text#" onclick="formvalidate('savekeep')">							    	
								</td>
							
							</cfif>
					    
						    <td>
							    <cf_tl id="Save and Close" var="1">
							    <input class="button10g" style="width:160px" type="button" name="save" id="save" value="#lt_text#" onclick="formvalidate('save')">
							</td>		
							
					   </cfif>
				   
				   </cfoutput>
			   
			   </tr>
			   
			   </table>
		   
		   </td>  
		   
		</tr>
	 
    </table>
	
 </CFFORM>  	
 
 <script>
	 parent.Prosis.busy('no')
 </script>
  	

			