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
			  label="#vAction# Promotion" 
			  banner="#vBanner#"
			  menuAccess="Yes" 
			  jquery="Yes"
			  bannerheight="55"
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfform,cfdiv,cfwindow,cfinput-datefield">
<cf_calendarScript>

<cf_tl id = "The expiration date and time must be greater than the effective date and time." var = "vDateError">
<cf_tl id = "Please, enter a valid effective date." var = "effReqError">

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
			vTest = document.getElementById('DateEffective').value;
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
			var vHour = document.getElementById('TimeEffective_Hour').value;
			var vMinute = document.getElementById('TimeEffective_Minute').value;
			
			var vInitDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), parseInt(vHour), parseInt(vMinute), 0, 0);
			
			//Expiration date
			vTest = document.getElementById('DateExpiration').value;
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
			var vHour = document.getElementById('TimeExpiration_Hour').value;
			var vMinute = document.getElementById('TimeExpiration_Minute').value;
			
			var vEndDate = new Date(parseInt(vYear), parseInt(vMonth)-1, parseInt(vDay), parseInt(vHour), parseInt(vMinute), 0, 0);
			
			//Validation expiration > effective
			if (vInitDate >= vEndDate) {
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
		
		function elementEdit(promotionid,serial) {
		    
			try { ColdFusion.Window.destroy('mypromo',true) } catch(e) {}
			ColdFusion.Window.create('mypromo', 'Promotion', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    							
			ColdFusion.navigate('#session.root#/Warehouse/Maintenance/Promotion/Element/ElementView.cfm?idmenu=#url.idmenu#&promotionid=' + promotionid + '&serial=' + serial,'mypromo') 		
//
//
//			window.showModalDialog('Element/ElementEdit.cfm?idmenu=#url.idmenu#&promotionid=' + promotionid + '&serial=' + serial + '&ts=' + new Date().getTime(), window, 'dialogWidth: 800px; dialogHeight: 600px; resizable:yes');
//			ColdFusion.navigate('Element/ElementListing.cfm?idmenu=#url.idmenu#&id1=' + promotionid, 'divElementListing');
		}
		
		function elementrefresh(promotionid) {
		    ColdFusion.navigate('Element/ElementListing.cfm?idmenu=#url.idmenu#&id1=' + promotionid, 'divElementListing');
		}
		
		function elementPurge(promotionid,serial) {
			if (confirm('Do you want to remove this element and all of its details ?')) {
				ColdFusion.navigate('Element/ElementPurge.cfm?idmenu=#url.idmenu#&promotionid=' + promotionid + '&serial=' + serial, 'divElementListing');
			}
		}

	</script>
</cfoutput>

<table width="98%" align="center">
	<tr>
		<td>
			<cfdiv id="divHeader" bind="url:RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#">
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<cfdiv id="divDetail" bind="url:Element/Element.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#">
		</td>
	</tr>
</table>
	
<cf_screenbottom layout="innerbox">
