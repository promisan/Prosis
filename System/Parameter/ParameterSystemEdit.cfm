<cfparam name="url.Mission" default="'ALL'">
<cfparam name="url.action" default="1">

<cf_screentop height="100%" jquery="Yes" html="No" scroll="Vertical">

<cf_systemscript> 
<cf_ParameterSystemInit>
<cf_dialoglookup>
<cfset Page         = "0">
<cfset add          = "0"> 
<cfset back         = "0"> 
<cfset option       = "">

<cfinclude template="HeaderParameter.cfm">

<script language="JavaScript">

function detail(bx,sm) {
	se   = document.getElementById(bx);					 		 
	if (se.className == "hide") {	   	
		 se.className  = "regular";
		 url = "ParameterSystemLicense.cfm?systemmodule=" + sm
		 ptoken.navigate(url,bx)				
	 } else {		   	    
    	 se.className  = "hide"
	 }				 		
}

function addLDAP(){
	alert('add');
}

function editLDAP(LDAPServer){
	ptoken.navigate('ParameterSystemEditLDAP.cfm?LDAPServer='+LDAPServer,'idLDAP');
}

function deleteLDAP(){
	ptoken.navigate('ParameterSystemEditLDAP.cfm?action=delete&LDAPServer='+LDAPServer,'idLDAP');
}

function changePwdMode(val)
{
	if (val=='Basic') {
		$('#Basic_1').show();
		$('#Basic_2').show();		
		$('#Advance_1').hide();
		$('#Advance_2').hide();		
	} else {
		$('#Basic_1').hide();
		$('#Basic_2').hide();		
		$('#Advance_1').show();
		$('#Advance_2').show();		
	}	
	
}

</script>

<cfajaximport tags="cfform">
   
<div id="fSystem" style="width:100%">
	<cfinclude template = "ParameterSystemForm.cfm">
</div>
