<cfparam name="url.idmenu" default="">

<cfquery name="Get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ServiceitemDomain
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfquery name="VerifyServiceItem" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	ServiceItem
	WHERE  	ServiceDomain = '#URL.ID1#'
	AND		ServiceMode = 'WorkOrder'
	AND		Operational = 1
</cfquery>

<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	ServiceDomain
      FROM  	Request
      WHERE 	ServiceDomain  = '#URL.ID1#' 
	  UNION
	  SELECT 	ServiceDomain
      FROM  	ServiceItem
      WHERE 	ServiceDomain  = '#URL.ID1#' 
	  UNION
	  SELECT 	ServiceDomain
      FROM  	WorkOrderService
      WHERE 	ServiceDomain  = '#URL.ID1#' 
</cfquery>

<cf_screentop height="100%" 
	  label="Domain" 
	  option="Service Item Domain Maintenance [#get.Description#]" 
	  scroll="Yes" 
	  layout="webapp" 
	  banner="yellow" 
	  menuAccess="Yes" 
	  jquery="yes"
	  systemfunctionid="#url.idmenu#">
			  
<cfajaximport tags="cfform">
<cf_dialogOrganization>
<cf_dialogMaterial>

<script language="JavaScript">

	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}	
	
	function showDomainClass(id1, id2) {
		var vWidth = $(window).width() - 50;
	   	var vHeight = $(window).height() - 50;
	   
	   	try { ColdFusion.Window.destroy('mydialog'); } catch(er) {}
	   	ColdFusion.Window.create('mydialog', 'Edit Domain', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    
	   	ColdFusion.Window.show('mydialog'); 				
	   	ptoken.navigate("DomainClass/DomainClassEdit.cfm?id1=" + id1 + "&id2=" + id2 + "&ts=" + new Date().getTime(),'mydialog'); 
	}
	
	function showWorkorderService(id1, id2) {
		var vWidth = $(window).width() - 50;
	   	var vHeight = $(window).height() - 50;
		
		if ($.trim(id2) == '') {
			vWidth = 600;
			vHeight = 300;
		}
	   
	   	try { ColdFusion.Window.destroy('mydialog'); } catch(er) {}
	   	ColdFusion.Window.create('mydialog', 'Edit Workorder Service', '',{x:30,y:30,height:vHeight,width:vWidth,modal:false,center:true});    
	   	ColdFusion.Window.show('mydialog'); 				
	   	ptoken.navigate("WorkOrderService/WorkOrderServiceEdit.cfm?id1=" + id1 + "&id2=" + id2 + "&ts=" + new Date().getTime(),'mydialog'); 
	}
	
	function showOrgUnitMission(ct, mission) {
		if (ct.checked) {
			setOrgUnit('', '-1', mission);
		} else {
			setOrgUnit('', '', mission);
		}
	}
	
	function setOrgUnit(fld, org, scope) {
		ptoken.navigate('WorkOrderService/setOrgUnit.cfm?mission='+scope+'&orgUnit='+org,'implementer_'+scope);
	}
	
	function validateOrgUnits() {
		var vMessage = '';
		$('.orgunit').each(function(){
			if ($.trim($(this).val()) == '') {
				vMessage = vMessage + 'Please select a valid implementer for ' + $(this).attr('data-value') + '\n';
			}
		});
		
		if ($.trim(vMessage) != '') {
			alert(vMessage);
			return false;
		}
		
		return true;
	}
	
	function addItem(itemuomid, scope) {
	    _cf_loadingtexthtml='';	
		ptoken.navigate('WorkOrderService/WorkOrderServiceItemAdd.cfm?itemuomid='+itemuomid+'&scope='+scope,'itemContainer');
	}

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" style="height:100%" method="POST" enablecab="Yes" name="dialog">

<table width="95%" height="100%" class="formpadding" align="center">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR height="20">
    <TD width="20%" class="labelmedium"><cf_tl id="Code">:</TD>
    <TD class="labelmedium">
	   <cfif CountRec.recordcount eq "0">	
		   	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
	   <cfelse>
	   		#get.Code#
			<input type="hidden" name="Code" id="Code" value="#get.Code#">
	   </cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	 <TR height="20">
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR height="20">
    <TD class="labelmedium"><cf_tl id="Display format reference">:</TD>
    <TD>
  	   <cfinput type="Text" name="displayFormat" value="#get.displayFormat#" message="Please enter a display format" required="No" size="40" maxlength="30" class="regularxl">
    </TD>
	</TR>
	
	<TR height="20">
    <TD class="labelmedium"><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" required="Yes" size="2" validate="integer" maxlength="3" style="text-align:center" class="regularxl">
    </TD>
	</TR>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Allow Line concurrency">:</td>
		<td class="labelmedium">
		<table><tr class="labelmedium">
		<td style="padding-left:0px"><input type="radio" name="AllowConcurrent" id="AllowConcurrent" class="radiol" value="0" <cfif get.AllowConcurrent eq "0">checked</cfif>></td><td style="padding-left:4px">No</td>
		<td style="padding-left:4px"><input type="radio" name="AllowConcurrent" id="AllowConcurrent" class="radiol" value="1" <cfif get.AllowConcurrent eq "1">checked</cfif>></td><td style="padding-left:4px">Yes</td>
		</td></tr></table> 
		</td>
	</tr>	
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr height="20">
		
	<td align="center" colspan="2" height="40">
	<cfif CountRec.recordcount eq "0"><input class="button10g" type="submit" style="width:120;height:25" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>	
    <input class="button10g" type="submit" style="width:120;height:25;" name="Update" id="Update" value="Update">
	</td>	
	
	</tr>
	
	<tr><td height="10"></td></tr>
	
	<tr><td class="labellarge"><cf_tl id="Domain Class"></td></tr>
	<tr><td height="1" colspan="2"  class="line">
	<tr height="<cfif VerifyServiceItem.recordCount gt 0>30%<cfelse>100%</cfif>">
	<td colspan="2">
	    <cf_divscroll>
		    <cfinclude template="DomainClass/DomainClassListing.cfm">
		</cf_divscroll>
	</td></tr>
	
	<cfif VerifyServiceItem.recordCount gt 0>
		<tr><td height="10"></td></tr>
		<tr><td class="labellarge"><cf_tl id="Workorder Service"></td></tr>
		<tr><td height="1" colspan="2"  class="line">
		<tr height="70%">
		<td colspan="2">
		    <cf_divscroll>
			    <cfinclude template="WorkOrderService/WorkOrderServiceListing.cfm">
			</cf_divscroll>
		</td></tr>
	</cfif>
			
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
	