
<cf_textareascript>		  
<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield">
<cf_menuscript>
<cf_dialogmaterial>
<cf_listingscript>
<cf_calendarscript>

<cfparam name="url.idmenu" default="">
<cfparam name="url.menuaccess" default="Yes">

<cf_screentop height="100%" 
			  scroll="yes" 
			  layout="webapp" 
			  bannerheight="50" 
			  banner="gray" 
			  label="Procurement Item Master #url.mission#" 
			  menuAccess="#url.menuaccess#" 
			  jquery="Yes"
			  line="no"
			  systemfunctionid="#url.idmenu#">
	
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ItemMaster
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfif Get.recordcount eq "0">
	<table cellspacing="0" cellpadding="0" class="formpadding" align="center"><tr><td height="50"><cf_tl id="Record was previously removed"></td></tr></table>
	<cfabort>
</cfif>

<cfoutput>

<script language="JavaScript">

	var LISTVALUES = 0;
	var COSTELEMENTS = 0;

	function ask() {
		if (confirm("Do you want to remove this record ?")) {
			ptoken.navigate('RecordSubmit.cfm?action=delete&code=#url.id1#','process');
		}	
	}
	
	function saveUoMEach(item,control) {
		ColdFusion.navigate('Items/UoMEachSubmit.cfm?item='+item+'&value='+control.value,'processUomEach');
		setTimeout("document.getElementById('processUomEach').innerHTML='';",2000);
	}

	function saveripple(code) {
		ColdFusion.navigate('Budgeting/RippleSubmit.cfm?id='+code+'&id1='+document.getElementById("TopicValueCode").value+'&id2='+document.getElementById("Mission").value+'&id3='+document.getElementById("RippleItemMaster").value+'&id4='+document.getElementById("RippleObjectCode").value+'&id5='+document.getElementById("BudgetMode").value+'&id6='+document.getElementById("BudgetAmount").value,'result');
	}
	
	function updateripple(code, id1,id2,id3,id4) {
		if (document.getElementById("Operational").checked == 1)
			op = 1;
		else
			op = 0;			
		ColdFusion.navigate('Budgeting/RippleUpdateSubmit.cfm?id='+code+'&id1='+document.getElementById("TopicValueCode").value+'&id2='+document.getElementById("Mission").value+'&id3='+document.getElementById("RippleItemMaster").value+'&id4='+document.getElementById("RippleObjectCode").value+'&id5='+document.getElementById("BudgetMode").value+'&id6='+document.getElementById("BudgetAmount").value+'&id7='+op+'&id11='+id1+'&id22='+id2+'&id33='+id3+'&id44='+id4,'result');
	}	
	
	function do_delete(id,id1,id2,id3,id4) {
		if (confirm("Do you want to remove this record ?")) {
			_cf_loadingtexthtml='';	
			ColdFusion.navigate('Budgeting/RippleDelete.cfm?id='+id+'&id1='+id1+'&id2='+id2+'&id3='+id3+'&id4='+id4,'result');		
		}		
	}	
	
	function do_edit(id,id1,id2,id3,id4) {
	    _cf_loadingtexthtml='';	
		ColdFusion.navigate('Budgeting/RecordRipple.cfm?mode=edit&code='+id+'&id1='+id1+'&id2='+id2+'&id3='+id3+'&id4='+id4,'ripple');		
	}	

	function define_costelements(id) {
	    _cf_loadingtexthtml='';	
		ColdFusion.navigate('Budgeting/CostElements.cfm?id'+id,'costelements');				
	}	
	
	function define_cost_details(id) {
		alert('Rate definition for'+id);
	}
	
	function set_list_values(el) {
		if (el.checked == 1)
			LISTVALUES +=1;
		else
			LISTVALUES -=1;				
		showhide("Save");
	}

	function set_cost_elements(el) {
		if (el.checked == 1)
			COSTELEMENTS +=1;
		else
			COSTELEMENTS -=1;	
		showhide("Save");			
	}	
	
	function showhide(btn) {
		save = document.getElementById(btn);
		
		if (LISTVALUES > 0 && COSTELEMENTS > 0 )
		{
			save.style.display="inline";	
			save.style.visibility ="visible";	
		} else {
			save.style.display="none";	
			save.style.visibility ="hidden";	
		}		
	
	}
	
	function new_costelement(id) {
		checkboxes = document.getElementsByName('MissionList');
		var found = 0;
		for (var i = 0; i < checkboxes.length; i++) 
			if (checkboxes[i].checked)
				found = 1;

		if (found) {
			ColdFusion.Window.show('wCostElement');
			ColdFusion.navigate('Budgeting/CostElementForm.cfm?id='+id,'wCostElement','','','POST','fMission');
		} else {
			alert('Please define one or more entities');	
			}

	}
	
	function submit_costelement() {

		checkboxes = document.getElementsByName('TopicValueCode');
		var found = 0;
		for (var i = 0; i < checkboxes.length; i++) 
			if (checkboxes[i].checked)
				found = 1;
		if (found)
			ColdFusion.navigate('Budgeting/CostElementSubmit.cfm','result','','','POST','fCostElement');
		else	
			alert('Please define one or more item list');			
	}	
	
	function delete_cost_element(id1, id2, id3, id4, id5, id6, id7) {
		if (confirm("Do you want to remove this record ?")) {
			ColdFusion.navigate('Budgeting/CostElementDelete.cfm?id1='+id1+'&id2='+id2+'&id3='+id3+'&id4='+id4+'&id5='+id5+'&id6='+id6,'result');		
		}		
	}
	
	function submitInstruction(i,c) {
		ColdFusion.navigate('Budgeting/submitInstructions.cfm?itemmaster='+i+'&code='+c,'process_'+c,null,'','POST','formBudgetingObject_'+c);
	}
	
	function toggleInstructions(code) {
		$('.clsInstructions_'+code).toggle();
	}
	
</script>

</cfoutput>

<cfwindow center="true"
	modal="true"
	width="1000" 
	height="750"
	name="wCostElement" 
	title="New Cost Element"
	initshow="false" 
	draggable="true" 
	resizable="true"
	closable="true"/>

<cf_divscroll>

<table width="95%"
       border="0"
	   height="100%"
	   align="center"
	   cellspacing="0"
       cellpadding="0">
	   
	<!--- <tr><td height="25" style="font-size:15px;"><font face="Calibri" size="3"><cfoutput>#get.description#</cfoutput></td></tr> --->
	
	<tr><td height="2" id="process"></td></tr>
	<tr>
		<td align="center" valign="top">
		
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
				<tr>
				<cfset wd = "64">
				<cfset ht = "64">
				
				<cfset itm = "1">
				<cf_tl id="Details" var="vDetails">
				
				<cf_menutab item  = "#itm#" 
			       iconsrc    = "Detail.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight1"
				   name       = "#vDetails#"
				   source     = "RecordEditForm.cfm?mission=#url.mission#&id1=#url.id1#&idMenu=#url.idmenu#">
				   
				   <cfset itm = itm+1> 
				
				<cf_tl id="Budgeting" var="vBudgeting">  
				 
				<cf_menutab item  = "#itm#" 
			       iconsrc    = "Budget.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "#vBudgeting#"
				   source     = "Budgeting/Associations.cfm?mission=#url.mission#&id1=#url.id1#&idMenu=#url.idmenu#">
				 
				  <cfset itm = itm+1> 
				  
				  <cf_tl id="Cost Elements" var="vCost"> 
				    
				  <cf_menutab item  = "#itm#" 
			       iconsrc    = "Price.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "#vCost#"
				   source     = "Budgeting/StandardCost.cfm?mission=#url.mission#&id1=#url.id1#&idMenu=#url.idmenu#">
				   
				 <cf_verifyOperational 
			         datasource= "appsSystem"
			         module    = "Warehouse" 
					 Warning   = "No">
				 		 		 
				 <cfif Operational eq "1">
				 
				 	 <cfset itm = itm+1> 
					
					 <cf_tl id="Warehouse Items" var="vWarehouseItems">
					 
					 <cf_menutab item  = "#itm#" 					 
				       iconsrc    = "Warehouse.png" 
					   iconwidth  = "#wd#" 
					   iconheight = "#ht#" 
					   targetitem = "1"
					   name       = "#vWarehouseItems#"
					   source     = "Items/WarehouseListing.cfm?mission=#url.mission#&id1=#url.id1#&idMenu=#url.idmenu#">
				 
				 </cfif>  
				 
				 <cfset itm = itm+1> 
				 
				 <cf_tl id="Vendor Roster" var="vVendors">
				 
			  	 <cf_menutab item  = "#itm#" 
			       iconsrc    = "Vendors.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "#vVendors#"
				   source     = "Vendors/VendorEntry.cfm?idMenu=#url.idmenu#&id=#get.code#">
				   
				 <cfset itm = itm+1>   
				 
				 <cf_tl id="Statistics" var="vStatistics">
			     <cf_menutab item  = "#itm#" 
			       iconsrc    = "Statistics.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "#vStatistics#"
				   source     = "Statistics/RecordUsage.cfm?idMenu=#url.idmenu#&id=#get.code#">
				   
				
				 </tr>
			 </table>
		
		<td>
	</tr>
	<tr><td class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	<tr>
	<td height="100%" valign="top">
	   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<cf_menucontainer item="1" class="regular">
			 <cfdiv bind="url:RecordEditForm.cfm?mission=#url.mission#&id1=#url.id1#&idMenu=#url.idmenu#"> 
	 	</cf_menucontainer>	
	   </table>	
	</td>
	</tr>
	<tr><td height="1"></td></tr>
</table>
</cf_divscroll>




