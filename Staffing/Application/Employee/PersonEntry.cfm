
<cf_screentop height="100%" html="no" jquery="yes" scroll="yes" title="Employee - Entry Form">

<cfparam name="url.personno" default="">
<cfparam name="url.mode" default="entry">

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfoutput>

<script language="JavaScript1.2">
			
	function validate(mode) {
		document.formperson.onsubmit() 
		if( _CF_error_messages.length == 0 ) {		    
           	ptoken.navigate('PersonEntrySubmit.cfm?personno=#url.personNo#&mode='+mode,'personresult','','','POST','formperson')
	    }   
    }
		
</script>

<cf_dialogstaffing>
<cf_calendarscript>

<table width="100%" border="0">

<tr><td height="20"></td></tr>

<tr>
    <td colpsan="2" style="font-weight:200;font-size:18px;height:40px;padding-left:20px" width="100%" align="left" valign="middle" class="labelmedium">	
    	<font color="2DA4B0"><cf_tl id="Register a natural Person that is or <u>will</u> be deployed in the organization"></font>	
    </td>
</tr> 

<tr><td height="6" colspan="2" class="line"></td></tr>	

<tr><td colspan="2">

		<cfinclude template="PersonEntryForm.cfm">
						
		</td></tr>

	</table>		

</cfoutput>
