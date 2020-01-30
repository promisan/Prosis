
<cf_CalendarScript>

<script>

  function salarytrigger()

  if (document.getElementById('payment').checked == true) {
  	 document.getElementById('trigger').className = "regular"
  } else {
     document.getElementById('trigger').className = "hide"
  }

</script>

<!--- added 18/9/2013 to ensure access --->
<cfparam name="url.refer"               default="">
<cfparam name="url.mode"                default="#url.refer#">
<cfparam name="client.width"            default="800">
<cfparam name="SESSION.isAdministrator" default="No">

<cfquery name="GetOvertime" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonOvertime
	WHERE  OvertimeId = '#URL.ID1#'
</cfquery>

<cfif url.mode eq "workflow">
	<cf_screentop height="100%" scroll="Yes" jquery="Yes" label="Overtime - Clearance" banner="yellow" layout="webapp">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" jquery="Yes" html="no">
</cfif>

<cfajaximport tags="cfform, cfdiv">

<cf_dialogPosition>
<cf_filelibraryscript>
<cf_actionListingScript>

<cf_tl id="The overtime must be greater than 0" var="vLblError1">
<cf_tl id="The total overtime must match the detailed amounts" var="vLblError2">

<cfoutput>

<script language="JavaScript">

	function check(act) {
		if (validateSubmission()) {
			if (document.getElementById('status').value == '1' && act != 'delete') { 
				if (confirm("This record will need to be reviewed again, continue ?")) {
				  Prosis.busy('yes')
				  ptoken.navigate('#session.root#/payroll/application/overtime/OvertimeEditSubmit.cfm?mode=standard&action='+act,'process','','','POST','overtimeedit')
				}		
			 } else { 
			 Prosis.busy('yes')
			 ptoken.navigate('#session.root#/payroll/application/overtime/OvertimeEditSubmit.cfm?mode=standard&action='+act,'process','','','POST','overtimeedit')
			 }
		}
	}

	function setInitDetailValue() {
	
		var vTotalDetailMinutes = 0;
		var vTotalDetailHours = 0;
		var vTotalDetailMinutes = 0;

		$('.clsDetailHours').each(function(){
			var vThisVal = parseInt($(this).val());
			if (vThisVal && $.trim(vThisVal) != '') {
				vTotalDetailHours = vTotalDetailHours + vThisVal;
			}
		});

		$('.clsDetailMinutes').each(function(){
			var vThisVal = parseInt($(this).val());
			if (vThisVal && $.trim(vThisVal) != '') {
				vTotalDetailMinutes = vTotalDetailMinutes + vThisVal;
			}
		});

		vTotalMinutesDetail = vTotalDetailHours * 60 + vTotalDetailMinutes;
		_cf_loadingtexthtml=''  
		ptoken.navigate('setTotal.cfm?minutes='+vTotalMinutesDetail,'total')	
		
	}


	function salarytrigger() {
		if ($('##payment').is(':checked')) {
			_cf_loadingtexthtml=''  
		    ptoken.navigate('setOvertime.cfm?payment=1&personno=#GetOvertime.PersonNo#&overtimeid=#url.id1#','overtimecontent')		
		} else {
			_cf_loadingtexthtml=''  
			ptoken.navigate('setOvertime.cfm?payment=0&personno=#GetOvertime.PersonNo#&overtimeid=#url.id1#','overtimecontent')	
		}
	}

	function compareDetailHeaderMinutes() {
		var vTotalMinutesHeader = parseInt($('##OvertimeHours').val()) * 60 + parseInt($('##OvertimeMinutes').val());
		var vTotalMinutesDetail = 0;
		var vTotalDetailHours = 0;
		var vTotalDetailMinutes = 0;

		$('.clsDetailHours').each(function(){
			var vThisVal = parseInt($(this).val());
			if (vThisVal && $.trim(vThisVal) != '') {
				vTotalDetailHours = vTotalDetailHours + vThisVal;
			}
		});

		$('.clsDetailMinutes').each(function(){
			var vThisVal = parseInt($(this).val());
			if (vThisVal && $.trim(vThisVal) != '') {
				vTotalDetailMinutes = vTotalDetailMinutes + vThisVal;
			}
		});

		vTotalMinutesDetail = vTotalDetailHours * 60 + vTotalDetailMinutes;

		return (vTotalMinutesHeader == vTotalMinutesDetail);
	}

	function validateSubmission() {
		
		    hr = $('##OvertimeHours').val()			
			mn = $('##OvertimeMinutes').val()		
							
			if (hr == '0') { 			
			    if (mn == '0') {				  
			       alert('#vLblError2#');
				   return false	
				} else {
				return true
				}					
		    } else {
			  return true
			}
		 
		 }

</script>

</cfoutput>

<cfset url.id = getOvertime.PersonNo>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 = '#GetOvertime.Overtimeid#'	
	AND      Operational =  1
</cfquery>

<cfif GetOvertime.recordcount eq "0">

	<table align="center"><tr><td height="40" class="labellarge" align="center"><b>Attention : </b>Document no longer exists</td></tr></table>
	<cfabort>
	
</cfif>

<cf_divscroll width="99%"  height="100%">

<table cellpadding="0" cellspacing="0" width="99%" align="center">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "hide"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	

	<tr><td height="100%" valign="top">
	
		<table height="100%" width="99%">
			<tr>
				<td style="padding-left:15px" id="edit_#GetOvertime.OverTimeId#">				  
					<cfdiv bind="url:OvertimeEditStandardForm.cfm?id1=#GetOvertime.OverTimeId#&id=#url.id#&mode=#url.mode#&refer=#url.refer#"/>
				</td>
			</tr>
			
			<tr class="hide"><td id="process"></td></tr>
			<tr><td height="15"></td></tr> 
			<cfif getOvertime.Status eq "5" and Object.recordcount eq "0">
				<!--- nada --->
			<cfelse>
			<tr><td style="padding-left:35px;padding-right:25px" align="center">		
				<cfdiv id="#GetOvertime.OverTimeId#" 
				    bind="url:OvertimeWorkflow.cfm?id=#GetOvertime.OverTimeId#&ajaxid=#GetOvertime.OvertimeId#&mission=#Object.Mission#&mode=#url.mode#&refer=#url.refer#&id2=#url.id#"/>   					
				</td>
			</tr>
			</cfif>
		</table>
	
	</td></tr>
</table>

</cf_divscroll>

<cfif url.mode eq "workflow">
	<cf_screenbottom layout="webapp">
</cfif>