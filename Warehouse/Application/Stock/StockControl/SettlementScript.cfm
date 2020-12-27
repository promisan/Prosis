<cfparam name="url.formName" default="salesdetails">
<cfparam name="url.scope" default="settlement">

<cfoutput>

	/* Begining of settlement scripts - by Armin , Promisan b.v. April 2012 */		
	
	function saveline(whs,cus,bat,ter,tr_d,tr_h,tr_m,addr,req) {
	
	    _cf_loadingtexthtml="";	 
		if (cus != '00000000-0000-0000-0000-000000000000') {
			if ($('##line_amount_number').val() + 0 != 0) {
			    var mode = $('##settlement').val()
				
			    var curr = $('##currency').val()	
				_cf_loadingtexthtml='';						
		    	ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/SettlementUpdate.cfm?scope=#url.scope#&batchid='+bat+'&warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&mode='+mode+'&currency='+curr+'&td='+tr_d+'&th='+tr_h+'&tm='+tr_m+'&addressid='+addr+'&requestno='+req,'dlines','','','POST','#url.formName#');
			} else {
				 alert('Please enter an amount');
				 setFocus('##line_amount_number','yes');
			}	
		} else {
			Ext.MessageBox.alert('Information', 'Please select a valid customer');			}
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";		
			
	}	

	function deletesettlement(whs,cus,id,ter,bat,td,th,tm,mode) {
	    _cf_loadingtexthtml="";
		ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/SettlementDelete.cfm?scope=#url.scope#&batchid='+bat+'&warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&transactionid='+id+'&td='+td+'&th='+th+'&tm='+tm+'&mode='+mode,'dlines');		
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
	}
	
	function postsettlement(whs,cus,inv,cur,bat,ter,td,th,tm,mode,addr,req) {	        	    
		ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/pos/settlement/saleposting.cfm?scope=#url.scope#&currency='+cur+'&warehouse='+whs+'&terminal='+ter+'&customerid='+cus+'&customeridinvoice='+inv+'&batchid='+bat+'&td='+td+'&th='+th+'&tm='+tm+'&mode='+mode+'&addressid='+addr+'&requestno='+req,'dlines','','','POST','#url.formName#')		
	}   	

	function editCustomer(customerId){
		ptoken.open("#SESSION.root#/warehouse/application/customer/view/CustomerEditTab.cfm?drillid="+customerId, "EditCustomer");
	}
	
	/*End of settlement scripts */
	
</cfoutput>	