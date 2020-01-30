
<cfoutput>

<cf_dialogLedger>
	
	<cfset root = "#SESSION.root#">
	
	<script language="JavaScript">
	
		var root = "#root#";
		
		function addledgertransaction(mis,per,org,jrn,src,srcno,srcid,box,dc,label,fun,amt) {
				
	    w = #CLIENT.width# - 100;
		h = #CLIENT.height# - 155;
		ptoken.open(root + "/Gledger/Application/Transaction/Standard/TransactionInit.cfm?mission="+mis+"&accountPeriod="+per+"&OrgUnitOwner="+org+"&Journal="+jrn+"&source="+src+"&sourceno="+srcno+"&sourceid="+srcid+"&amount="+amt+"&ts="+new Date().getTime(), "_blank", "toolbar=no,status=yes,height="+h+",width="+w+",scrollbars=no, center=yes, resizable=yes");	
		
	    }
		
	</script>	

</cfoutput>