<cfparam name="url.idmenu" default="">

<cfset vAction = "Maintain">
<cfset vBanner = "Yellow">
<cfif url.id1 eq "">
	<cfset vAction = "Add">
	<cfset vBanner = "Gray">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#vAction# Review Cycle" 
			  banner="#vBanner#"
			  menuAccess="Yes" 
			  bannerheight="55"
			  jQuery="yes"
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfform,cfdiv">
<cf_calendarScript>

<cf_tl id = "The expiration date must be greater than the effective date" var = "vDateError">
<cf_tl id = "Please, enter a valid effective date" var = "effReqError">

<cfoutput>
	<script>
		function validateFields() {
			var vDay = '';
			var vMonth = '';
			var vYear = '';
			var vMessage = '';
			var vTest = '';
			var vFirstError = '';
			
			//Effective date
			vTest = $('##DateEffective').val();
			if ('#APPLICATION.DateFormat#' == 'EU') {
				vDay = vTest.substring(0,2);
				vMonth = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			else {
				vMonth = vTest.substring(0,2);
				vDay = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			var vInitDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay));
			
			//Expiration date
			vTest = $('##DateExpiration').val();
			if ('#APPLICATION.DateFormat#' == 'EU') {
				vDay = vTest.substring(0,2);
				vMonth = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			else {
				vMonth = vTest.substring(0,2);
				vDay = vTest.substring(3,5);
				vYear = vTest.substring(6,10);
			}
			var vEndDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay));
			
			//Validation expiration > effective
			if (vInitDate > vEndDate) {
				vMessage = vMessage + '#vDateError#\n';
				if (vFirstError == '') vFirstError = 'DateExpiration';
			}

			//Return error
			if (vMessage != '' && vFirstError != ''){
				alert(vMessage);
				document.getElementById(vFirstError).focus();
				return false;
			}
			
			//Success
			return true;
		}

	</script>
</cfoutput>

<table width="100%" align="center" style="height:100%">
	<tr>
		<td style="height:100%">
		  <cf_divscroll style="height:100%">
			<cf_securediv id="divHeader" bind="url:RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#">
		  </cf_divscroll>	
		</td>
	</tr>
</table>
	
<cf_screenbottom layout="innerbox">
