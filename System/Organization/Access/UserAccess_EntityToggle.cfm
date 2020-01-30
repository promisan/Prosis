
<!--- process the request to preselect --->

<cfoutput>

<script language="JavaScript">

    try {
   
	se  = document.getElementsByName('i#url.box#')
	
	cnt = 0		
	while (se[cnt]) {
			
		if (#url.action# == '1') {
		   // se[cnt].className = "regular" : disabled for access for overtime to always show 
		} else {
		   // se[cnt].className = "hide"
		}		
		
		if (#url.action# == '1') {	    
			sc  = document.getElementById('g#url.box#_'+cnt) // field in the checkboxes for access UserAccessSelectAction.cfm
		} else {
			sc  = document.getElementById('n#url.box#_'+cnt) // field in the checkbox for access UserAccessSelectAction.cfm
		}					
		sc.click() 		
		cnt++		
				
	}	
	} catch(e) {}
	
</script>

<cfif URL.action eq "0">
	<a href="javascript:showaccess('1','#url.box#')"><font color="0080C0">Grant all steps</font></a>
<cfelse>
	<a href="javascript:showaccess('0','#url.box#')"><font color="0080C0">Revoke all steps</font></a>
</cfif>

</cfoutput>


<cf_compression>
