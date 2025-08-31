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
<cfparam name="url.formName" default="salesdetails">
<cfparam name="url.scope" default="settlement">

<cfoutput>

	/* Begining of settlement scripts - by dev , Promisan b.v. April 2012 */		
	
	function saveline(whs,cus,bat,ter,tr_d,tr_h,tr_m,addr,req,ref) {
	
	    _cf_loadingtexthtml='';	
		if (cus != '00000000-0000-0000-0000-000000000000') {
			if ($('##line_amount_number').val() + 0 != 0) {
			    var mode = $('##settlement').val()
				
			    var curr = $('##currency').val()	
				_cf_loadingtexthtml='';						
		    	ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/SettlementUpdate.cfm?scope=#url.scope#&batchid='+bat+'&warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&mode='+mode+'&currency='+curr+'&td='+tr_d+'&th='+tr_h+'&tm='+tr_m+'&addressid='+addr+'&requestno='+req+'&taxcode='+ref,'dlines','','','POST','#url.formName#');
			} else {
				 alert('Please enter an amount');
				 setFocus('##line_amount_number','yes');
			}	
		} else {
			Ext.MessageBox.alert('Information', 'Please select a valid customer');			}
					
	}	

	function deletesettlement(whs,cus,id,ter,bat,td,th,tm,mode) {
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/SettlementDelete.cfm?scope=#url.scope#&batchid='+bat+'&warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&transactionid='+id+'&td='+td+'&th='+th+'&tm='+tm+'&mode='+mode,'dlines');				
	}
	
	function postsettlement(whs,cus,inv,cur,bat,ter,td,th,tm,mode,addr,req,ref) {		    	        	    
		ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/doPosting.cfm?scope=#url.scope#&currency='+cur+'&warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&customeridinvoice='+inv+'&batchid='+bat+'&td='+td+'&th='+th+'&tm='+tm+'&mode='+mode+'&addressid='+addr+'&requestno='+req+'&referenceno='+ref,'dlines','','','POST','#url.formName#')		
	}   	

	function editCustomer(customerId){
		ptoken.open("#SESSION.root#/warehouse/application/customer/view/CustomerEditTab.cfm?drillid="+customerId, "EditCustomer");
	}
	
	/*End of settlement scripts */
	
</cfoutput>	
