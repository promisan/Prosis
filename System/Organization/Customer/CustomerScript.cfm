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
<cfparam name="url.portal" default="0">

<cf_actionlistingscript>

<cfoutput>

	<script>
		
		function dosearch() {				
			 if (window.event.keyCode == "13")	       
				{	document.getElementById("searchicon").click() }						
		}
						
		function addorder(customerid) {									
			ptoken.open("#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?systemfunctionid="+document.getElementById('systemfunctionid').value+"&mission=#url.mission#&customerid=" + customerid,"_blank");		
		}	
			
		function drillboxopen() {
		    ProsisUI.createWindow('adddetail','Workorder #timeformat(now(),'HH:MM:SS')#','',{x:100,y:100,height:700,width:700,resizable:true,modal:true,center:true})
		}
					
		function showcustomer(id,mode,dsn,mis) {		
		    ptoken.open('CustomerForm.cfm?mission='+mis+'&systemfunctionid='+document.getElementById('systemfunctionid').value+'&dsn='+dsn+'&customerid='+id+'&mode='+mode,'customer')
		}
						
		function customeredit(id) {
			_cf_loadingtexthtml="";						
			ptoken.navigate('CustomerData.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&dsn=#url.dsn#&customerid='+id+'&mode=view','customerbox',mycallBack,myerrorhandler)		
		}
		
		function customeradd(id) {
			ptoken.navigate('CustomerEdit.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&dsn=#url.dsn#&customerid='+id+'&mode=view','detail',mycallBack,myerrorhandler)			
			ptoken.navigate('CustomerResultNew.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&dsn=#url.dsn#&customerid='+id+'&mode=view','newentry',mycallBack,myerrorhandler)	   		 
		}			
		
		function find(mission,domain,val,mode,dsn,mid) {		    	    	
			ptoken.navigate('#SESSION.root#/system/organization/customer/CustomerSearchResult.cfm?systemfunctionid='+mid+'&mission='+mission+'&domain='+domain+'&mode='+mode+'&dsn='+dsn+'&val='+val,'findme')	
		}		
		
		function printcharges(mis,id,yr) {	    
		    window.open("#SESSION.root#/Workorder/Application/WorkOrder/ServiceDetails/Charges/ChargesCustomer.cfm?mission="+mis+"&customerid="+id+"&year="+yr+"&print=1", "_blank", "left=20, top=20, width=800, height=800, status=yes, toolbar=no, scrollbars=yes, resizable=yes");
		}
		
		function showdomain(mis,domain,ref,mode,dsn,filter) {		
		    _cf_loadingtexthtml='';	
			Prosis.busy('yes')
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineListingContent.cfm?systemfunctionid='+document.getElementById('systemfunctionid').value+'&filter='+filter+'&mission='+mis+'&domain='+domain+'&ref='+ref+'&dsn='+dsn+'&mode='+mode,'detail',mycallBack,myerrorhandler)
		}
		
		function showrequest(mis,domain,status,tpe) {
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Request/Listing/RequestListing.cfm?mission='+mis+'&domain='+domain+'&status='+status+'&requesttype='+tpe,'detail',mycallBack,myerrorhandler)
		}
			
		function mycallBack(text) { }
		  	var myerrorhandler = function(errorCode,errorMessage){
			alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
		}	
		
		/** Actions **/
		
		function twistWf(CustomerActionId, loadWF){
		
			td     = document.getElementById(CustomerActionId);
			tdMemo = document.getElementById(CustomerActionId+'_memo');
			
			if (td.className == 'hide'){
				td.className = 'regular';
				tdMemo.className = 'regular';
				
				if (loadWF == 1){
					ptoken.navigate('#SESSION.root#/system/organization/customer/Action/CustomerActionWorkflow.cfm?ajaxid='+CustomerActionId,CustomerActionId);
				}
				
			}else{
			
				td.className = 'hide';
				tdMemo.className = 'hide';
			}
		}
		
		function addActionRecord(customerId){
			ptoken.navigate('#SESSION.root#/system/organization/customer/Action/CustomerActionListingDetail.cfm?mode=new&customerId='+customerId,'contentListing');
		}
		
		function submitAction(customerId){
			document.ActionForm.onsubmit(); 
			if( _CF_error_messages.length == 0 ) { 
				ptoken.navigate('#SESSION.root#/system/organization/customer/Action/CustomerActionSubmit.cfm?customerId='+customerId+'&action=new','contentListing','','','POST','ActionForm');
			}
		}
	
		function deleteAction(customerId, CustomerActionId){
			if (confirm("Are you sure you want to delete this record?")){
				ptoken.navigate('#SESSION.root#/system/organization/customer/Action/CustomerActionSubmit.cfm?action=delete&customerId='+customerId+'&CustomerActionId='+CustomerActionId,'contentListing');
			}
		}
		
	</script>	

</cfoutput>


	