
<cf_dialogREMProgram>

<cfoutput>

<script language="JavaScript">

function resetfrom() {
    try {
    ed = document.getElementById('editionid').value
	} catch(e){ ed = "" }
	pe = document.getElementById('period').value
	rs = document.getElementById('resource').value	 
	cl = document.getElementById('actionclass').value
	pr = document.getElementById('program').value
	_cf_loadingtexthtml='';	
	ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&actionclass='+cl+'&direction=from&editionid='+ed+'&period='+pe+'&resource='+rs+'&program='+pr,'linesfrom') 
}

function resetto() {

     try {
     ed = document.getElementById('editionid').value
	 } catch(e){ ed = "" }
	 pe = document.getElementById('period').value
	 rs = document.getElementById('resource').value	 	 
	 pr = document.getElementById('program').value
	 cl = document.getElementById('actionclass').value
	 _cf_loadingtexthtml='';		
	 ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&actionclass='+cl+'&direction=to&editionid='+ed+'&period='+pe+'&resource='+rs+'&program='+pr,'linesto') 
	
}

function amount(dir,val,prg) {
	
	 ed = document.getElementById('editionid').value
	 pe = document.getElementById('period').value
	 cl = document.getElementById('actionclass').value
	 rs = document.getElementById('resource').value
	 
	 if (prg == "") {
	 	 pr = document.getElementById('programcode'+dir).value	
	 } else { pr = prg }	 
	 try {
	 	fd = document.getElementById('fundcode'+dir).value	
		ob = document.getElementById('objectcode'+dir).value
		_cf_loadingtexthtml='';				
		ptoken.navigate('AmountSelect.cfm?actionclass='+cl+'&status='+val+'&direction='+dir+'&editionid='+ed+'&period='+pe+'&resource='+rs+'&programcode='+pr+'&fund='+fd+'&objectcode='+ob,val+dir)
		if (val == 'cleared') {			    	
	        ptoken.navigate('AmountEntry.cfm?actionclass='+cl+'&status='+val+'&direction='+dir,'entry'+dir)			
	       }	    
	 } catch(e) {}
	 	 	
}

function unit(dir,prg) {
    ed = document.getElementById('editionid').value
	pe = document.getElementById('period').value
	 if (prg == "") {
	 	 pr = document.getElementById('programcode'+dir).value	
	 } else { pr = prg }	 	
	_cf_loadingtexthtml='';		 
	ptoken.navigate('FieldSelect.cfm?direction='+dir+'&field=unit&editionid='+ed+'&period='+pe+'&programcode='+pr,'unit'+dir)	
}

function fundsel(dir,prg,fd,ob) {  
	ed = document.getElementById('editionid').value
	pe = document.getElementById('period').value
	rs = document.getElementById('resource').value	
	cl = document.getElementById('actionclass').value
	_cf_loadingtexthtml='';		
	ptoken.navigate('FieldSelect.cfm?actionclass='+cl+'&direction='+dir+'&field=fund&period='+pe+'&resource='+rs+'&editionid='+ed+'&programcode='+prg+'&fund='+fd,'Fund'+dir)
}

function objectsel(dir,prg,fd,ob) {   
    ed = document.getElementById('editionid').value
	pe = document.getElementById('period').value
	rs = document.getElementById('resource').value	
	cl = document.getElementById('actionclass').value
	_cf_loadingtexthtml='';		
	ptoken.navigate('FieldSelect.cfm?actionclass='+cl+'&direction='+dir+'&field=object&period='+pe+'&resource='+rs+'&editionid='+ed+'&programcode='+prg+'&objectcode='+ob,'Object'+dir)
}

</script>

</cfoutput>
