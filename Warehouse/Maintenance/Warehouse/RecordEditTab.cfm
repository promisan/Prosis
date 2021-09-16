
<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Warehouse 
	WHERE    Warehouse = '#URL.ID1#'
</cfquery>


<cf_tl id = "Stock Point Settings" var = "vTitle">
<cf_tl id = "Do you want to remove this record ?" var = "msg1">

<cfparam name="url.idmenu" default="">
<cfparam name="url.search" default="0">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  html="Yes" 
			  layout="webapp" 
			  label="#get.Mission# #get.WarehouseName#" 
			  banner="gray" 
			  jQuery="Yes"
			  line="no"			 
			  menuAccess="yes" 
			  systemfunctionid="#url.idmenu#">

<cf_dialogOrganization>
<cf_menuscript>
<cf_dialogAsset>
<cf_presentationScript>
<cf_listingscript>

<cfif client.googleMAP eq "1">
	<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#"> 
</cfif>

<cf_textareascript>
<cfajaximport tags="cfdiv,cfform">

<style type="text/css">

     td.stat {
     	height: 30px;
     	padding: 5px;
     	font: Verdana;
     }
	 
</style>

<cfoutput>
	
	<script language="JavaScript">
	
		function ask(id,idmenu) {
			if (confirm("#msg1#")) {	
				ptoken.navigate('RecordPurge.cfm?id1='+id+'&idmenu='+idmenu,'processWH');
			}	
			return false	
		}
		
		function applyunit(orgunit) {
			ptoken.navigate('setUnit.cfm?orgunit='+orgunit,'processunit')
		}
		
		function editCategory(wh,cat) {
		
			var vWidth = 670;
		   	var vHeight = 500;    
		   
		   	ProsisUI.createWindow('mydialog', 'Category', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    		   	
		   	ptoken.navigate("Category/CategoryEditTab.cfm?idmenu=#url.idmenu#&id1=" + wh + "&id2=" + cat,'mydialog'); 
			
		}
		
		function purgeCategory(wh,cat) {
			if (confirm('Do you want to remove this category ?')) {
				ptoken.navigate('Category/CategoryPurge.cfm?warehouse=' + wh + '&category=' + cat, wh + '_list');
			}
		}
		
		function editProject(wh,prog) {
		
			var vWidth = 500;
		   	var vHeight = 250;	   		   	
		   	ProsisUI.createWindow('mydialog', 'Edit Project', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    		   			
		   	ptoken.navigate("Program/ProgramEdit.cfm?warehouse=" + wh + "&programcode=" + prog + "&ts=" + new Date().getTime(),'mydialog');
		}
		
		function addProject(wh,prog) {
		
			var vWidth = $(window).width() - 100;
		   	var vHeight = $(window).height() - 100;		   		   
		   	ProsisUI.createWindow('mydialog', 'Add Projects', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    		   			
		   	ptoken.navigate("Program/ProgramAddMultiple.cfm?warehouse=" + wh + "&ts=" + new Date().getTime(),'mydialog'); 
		}
		
		function purgeProject(wh,prog) {
			if (confirm('#msg1#')) {
				ptoken.navigate('Program/ProgramPurge.cfm?warehouse=' + wh + '&programcode=' + prog, 'contentbox2');
			}
		}
				
		function printStatistics(wh,loc,divToGet) {
			ptoken.open('../WarehouseLocation/LocationStatistics/PrintableVersion.cfm?warehouse='+wh+'&location='+loc+'&divToGet='+divToGet+'&ts='+new Date().getTime(), 'LocationStatistics', 'left=100, top=100, width=1000, height=700, toolbar=no, status=no, scrollbars=no, resizable=no');
		}
		
		function selectWHA(w,c) {
			if ($('##cb_'+w).is(':checked')) {
				$('##td_'+w).css('background-color',c);
			}else {
				$('##td_'+w).css('background-color','');
			}
		}
		
		function toggleElementByControl(c,sel) {
			if ($.trim(c.value) == '""' || $.trim(c.value) == '') { 
				$(sel).css('display','none'); 
			} else { 
				$(sel).css('display',''); 
			}
		}
		
		function validateJournalTemplates() {	
			var vReturn = false;
			var vMessage = "";
			
			$('.clsTransactionTemplate').each(function() {
				if ($.trim($(this).val()) != '') {
					var vId = $(this).attr('id').replace(/TemplateMode1_/gi, '');
					vId = vId.replace(/TemplateMode2_/gi, '');
					if ($('##validatePathMode1_'+vId).val() == 0) { vMessage = 'All template paths should be valid!'; }
					if ($('##validatePathMode2_'+vId).val() == 0) { vMessage = 'All template paths should be valid!'; }
				}
			});
			
			if (vMessage != "") {
				alert(vMessage);
				return false;
			}
			else{
				return true;	
			}
		}

		function removeBlankSpaces(el) {
			$(el).val($(el).val().replace(/\s/g,''));
		}
						
		function addLocation(){
		    ProsisUI.createWindow('mydialog', 'Add Location', '',{x:30,y:30,height:360,width:600,modal:true,center:true});
			ptoken.navigate('../WarehouseLocation/LocationAdd.cfm?warehouse=#url.id1#&systemfunctionid=#url.systemfunctionid#','mydialog');
		}
		
		function locationsave() {
		
			document.locationform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {	            	          
			   ptoken.navigate('../WarehouseLocation/LocationAddSubmit.cfm?id2=new&warehouse=#url.id1#&systemfunctionid=#url.systemfunctionid#','addlocation','','','POST','locationform')
		    }   
				
		}
					
   </script>
	
</cfoutput>

<table style="min-width:1200px" width="100%" height="100%" align="center">
	<tr class="hide"><td height="1" id="process2"></td></tr>	 
	
	<tr><td>
	
		<table width="100%" align="center">
		<tr>
		
				<cfset wd = "50">
				<cfset ht = "50">		
				<cfset itm="1">	
						
				<cf_tl id = "Settings" var = "vName1">
				
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Information.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"							
							class      = "highlight1"
							name       = "#vName1#">
							
				<cfset itm=itm+1>							
				<cf_tl id = "Storage Locations" var = "vName2">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Address.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2"							
							name       = "#vName2#"
							source     = "../WarehouseLocation/RecordListing.cfm?idmenu=#url.idmenu#&warehouse=#URL.ID1#&box=contentbox2">		
										
				<cfset itm=itm+1>							
				<cf_tl id = "Transaction Clearance" var = "vName1a">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Transaction.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"												
							name       = "#vName1a#"
							source     = "Transaction/TransactionClearance.cfm?idmenu=#url.idmenu#&warehouse=#URL.ID1#&box=contentbox2">
							
				<cfset itm=itm+1>							
				<cf_tl id = "Ledger Journal" var = "vName4">							
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Accounting-Journal.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2"							
							name       = "#vName4#"
							source     = "Journal/Journal.cfm?ID1=#URL.ID1#&box=contentbox2">				
							
				<cfset itm=itm+1>								
				<cf_tl id = "Association" var = "vName1c">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Association.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"													
							name       = "#vName1c#"
							source     = "Association/AssociationListing.cfm?idmenu=#url.idmenu#&warehouse=#URL.ID1#&box=contentbox2">													
				
				<cfset itm=itm+1>					
				<cf_tl id = "Projects" var = "vName3">							
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Projects.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2"							
							name       = "#vName3#"
							source     = "Program/ProgramListing.cfm?warehouse=#URL.ID1#&box=contentbox2">
					
				<cfset itm=itm+1>					
				<cf_tl id = "Strategic Stock" var = "vStock">
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Warehouse.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "2"													
							name       = "#vStock#"
							source     = "StockLevels/StockLevelsListing.cfm?idmenu=#url.idmenu#&warehouse=#URL.ID1#&box=contentbox2">						
				
				<cfset itm=itm+1>	
				<cf_tl id = "Statistics" var = "vName5">							
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Statistics.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#"
							targetitem = "2"							
							name       = "#vName5#"
							source     = "Statistics/WarehouseStatistics.cfm?warehouse=#URL.ID1#">				
					
		</tr>						
		</table>	
	</td>
	</tr>
	
	<tr class="hide"><td id="processunit"></td></tr>
		
	<tr><td height="1" colspan="2" class="line"></td></tr>						
	<tr>
	
		<td colspan="2" height="100%" valign="top">
			
		<table width="100%" height="100%">
						
				<cf_menucontainer item="1" class="regular">
				    <cfinclude template="RecordEdit.cfm">					
				</cf_menucontainer>
				<cf_menucontainer item="2" class="hide"/>
							
		</table>
		</td>
	</tr>	

</table>