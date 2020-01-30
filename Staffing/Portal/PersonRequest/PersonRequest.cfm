<cfparam name="url.scope" default="Portal">
<cfparam name="url.showheader" default="Yes">
<cfparam name="url.id1" default="">
<cfparam name="url.header" default="1">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<cfinvoke component="Service.Access" 
    	method="contract"  
		personno="#URL.ID#" 
		returnvariable="ContractAccess">			
					
<cfinvoke component="Service.Access"  
		method="employee"  
		owner = "Yes" <!--- 01/03/2011 check if this person is the owner of the record --->
		personno="#URL.ID#" 
		returnvariable="HRAccess"> 

<cfset mode = "view">
<cfif ContractAccess eq "EDIT" or ContractAccess eq "ALL" or HRAccess eq "EDIT" or HRAccess eq "ALL">
	 <cfset mode = "edit">
</cfif>		 

<cfajaximport tags="cfform,cfdiv">

<cf_screentop label="" jquery="Yes" height="100%" scroll="yes" html="No">
<cfoutput>

<script>	

    function getevent(trigger) {
    	mis = document.getElementById('mission');
		ColdFusion.navigate('#SESSION.root#/Staffing/Portal/PersonRequest/getEvent.cfm?triggercode='+trigger+'&requestid=&mission='+mis.value,'dCondition')
    }
    
	function requestvalidate(webapp) {
		document.requestform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {            
			ColdFusion.navigate(root + '/Staffing/Portal/PersonRequest/RequestSubmit.cfm?webapp='+webapp,'requestprocess','','','POST','requestform')
		 }   
	}	 
    
    
</script>
</cfoutput>
<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" >

	<cfif header gte "1">
		<cfif url.showheader eq "Yes">
		<tr>
		<td height="40">
						
		<table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10" style="padding-left:7px">	
				  <cfset ctr      = "yes">		
			      <cfset openmode = "show"> 
				  <cfinclude template="../../Application/Employee/PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
		</table>
	
		</td>
		</tr>
		</cfif>
		
	</cfif> 
	
<tr><td valign="top" style="padding-top:5px">
  
	<table width="98%" height="100%" align="center">
	<tr>
		<td valign="top" id="requestdetail" style="padding-left:15px;padding-right:15px">
			<cfif url.id1 eq "">
				<cfinclude template="PersonRequestDetails.cfm">
			<cfelse>
			    <!---- 
			    	cfinclude template="AddressEdit.cfm"
			    --->
			</cfif>
		
		
		</td>
	</tr>
	</table>
	
</td></tr>
</table>
