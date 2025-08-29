<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="get" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		<cfif url.id neq "">SystemFunctionId = '#url.id#'<cfelse>1 = 0</cfif>
</cfquery>


<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">
<cfif url.id neq "">
	<cfset vFunctionId = get.SystemFunctionId>
</cfif>

<cfset passName = get.functionName>
<cfset passName = replace(passName, "'", "%27", "ALL")>

<cfoutput>

	<script>
		function addportalline(id,name,cls,systemmodule,functionclass) {
			window.open("RecordEditTab.cfm?id="+id+"&class="+cls+"&name="+name+"&systemmodule="+systemmodule+"&functionclass="+functionclass+"&ts="+new Date().getTime(), "_blank", "left=75, top=40, height=800px, width=1100px, status=no, help=no, scrollbars=no, center=yes, resizable=yes, menubar=no, location=no, toolbars=no");
		}
		
		function purgeportalline(id,name,cls,systemmodule,functionclass) {
			ColdFusion.navigate("RecordPurgeLines.cfm?id="+id+"&name="+name+"&class="+cls+"&systemmodule="+systemmodule+"&functionclass="+functionclass,"div"+cls);
		}
		
		function ask(cls,systemmodule,functionclass) {
			var question = "Do you want to remove this record ?";
			var vPortal = 0;
			
			if (cls == "Main" || cls == "Mission") { 
				question = "Do you want to REMOVE this COMPLETE portal and all of its details ?"; 
				vPortal = 1;
			}
			
			if (confirm(question)) {
				ColdFusion.navigate('RecordPurgeLines.cfm?id=#vFunctionId#&name=#passName#&class=#url.class#&isPortal=' + vPortal+'&systemmodule='+systemmodule+'&functionclass='+functionclass,'processportalheader');
				try {			
				opener.document.getElementById('listing_refresh').click() } catch(e) {}	
			}
		}
		
		function exportPortalDefinition(name) {
			window.open("PortalExportForm.cfm?name="+name+"&type=#get.functionClass#", "_blank", "left=75, top=40, height=778px, width=804px, status=no, help=no, scrollbars=no, center=yes, resizable=no, menubar=no, location=no, toolbars=no");
		}
		
		function clonePortalDefinition(name) {
			window.open("PortalCloneForm.cfm?name="+name+"&type=#get.functionClass#", "_blank", "left=75, top=40, height=778px, width=804px, status=no, help=no, scrollbars=no, center=yes, resizable=no, menubar=no, location=no, toolbars=no");
		}
		
		function validateFileFields() {	
			var controlToValidate = document.getElementById('functionPath');	 
						
			controlToValidate.focus(); 
			controlToValidate.blur(); 
			
			if (controlToValidate.value != "") {
				if (document.getElementById('validatePath').value == 0)	{ 
					alert('[' + document.getElementById('functionDirectory').value + controlToValidate.value + '] not validated!');
					return false;
				} else {
					return true;
				}
			} else {
				return true;
			}		
		}
		
		function validateCellFileFields(directory) {	
			var controlToValidate = document.getElementById('SectionIcon');	 
						
			controlToValidate.focus(); 
			controlToValidate.blur(); 
			
			if (controlToValidate.value != "")
			{
				if (document.getElementById('validatePath').value == 0) 
				{ 
					alert('[' + directory + controlToValidate.value + '] not validated!');
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				return true;
			}		
		}
		
		function editSectionCell(id, section, code) {
			window.open("Section/FunctionSectionCellEdit.cfm?id="+id+"&section="+section+"&code="+code+"&ts="+new Date().getTime(), window, "left=75, top=40, height=675px, width=850px, status=no, help=no, scrollbars=no, center=yes, resizable=yes, menubar=no, location=no, toolbars=no");
		}
		
		function removeSectionCell(id, section, code) {
			ColdFusion.navigate('Section/FunctionSectionCellDelete.cfm?id='+id+'&section='+section+'&code='+code, 'divCellListing');
		}
		
		<!--- correction for non Explorer browsers on the display mechanism --->
		<cfif client.browser eq "Explorer">
			<cfset display="block">
		<cfelse>		
			<cfset display="">
		</cfif>
		
		function toggleTarget(){
			
			if (document.getElementById('FunctionTarget').value == "basic"){
				document.getElementById('trDatasource').style.display = 'none';
				document.getElementById('trDatasource').value = '';				
				document.getElementById('trConditionHeader').style.display = 'none';		
				document.getElementById('trCondition').style.display = 'none';
				document.getElementById('trMenuClass').style.display = 'none';
				document.getElementById('MenuClass').value = 'Main';
				if (document.getElementById('tblDetail') != null){ document.getElementById('tblDetail').style.display = 'none'; }
				toggleClass();
			}
			
			if (document.getElementById('FunctionTarget').value == "extended" || document.getElementById('FunctionTarget').value == "html5"){
				document.getElementById('trDatasource').style.display = '#display#';
				document.getElementById('trConditionHeader').style.display = '#display#';
				document.getElementById('trCondition').style.display = '#display#';
				document.getElementById('trMenuClass').style.display = '#display#';
				if (document.getElementById('tblDetail') != null){ document.getElementById('tblDetail').style.display = '#display#'; }
				toggleClass();
			}		
		}
		
		function toggleClass(){
			
			if (document.getElementById('MenuClass').value == "Main"){
				document.getElementById('trDatasource').style.display = 'none';
				document.getElementById('trDatasource').value = '';			
			}
			
			if (document.getElementById('MenuClass').value == "Mission"){
				document.getElementById('trDatasource').style.display = '#display#';
			}		
		}
		
		function toggleDivDetail(id) {
			if ($('##div'+id).is(':hidden')) {
				$('##div'+id).fadeIn(500, function(){ 
					$('##divInfo'+id).attr('title','click to hide the details');
					$('##twistieHeader').attr('src','#SESSION.root#/images/collapse.png'); 
					$('##twistieHeader').attr('title','click to hide all details');
				});
				$('.detailHeader').fadeIn(500);
			}else{
				$('##div'+id).fadeOut(500, function(){ 
					$('##divInfo'+id).attr('title','click to show the details');
					if ($('.clsDetail:hidden').length == $('.clsDetail').length) {  
						$('##twistieHeader').attr('src','#SESSION.root#/images/expand.png'); 
						$('##twistieHeader').attr('title','click to show all details');
						$('.detailHeader').fadeOut(200); 
					}
				});
			}
		}
		
		function toggleAllDetails() {
			if ($('.clsDetail:hidden').length == $('.clsDetail').length) {
				$('.clsDetail').fadeIn(500, function(){
					$('##twistieHeader').attr('src','#SESSION.root#/images/collapse.png'); 
					$('##twistieHeader').attr('title','click to hide all details');
					$('.clsInfo').attr('title','click to hide the details');
				});
				$('.labelheader').fadeIn(500);
			}else{
				$('.clsDetail').fadeOut(500, function(){
					$('##twistieHeader').attr('src','#SESSION.root#/images/expand.png'); 
					$('##twistieHeader').attr('title','click to show all details');
					$('.clsInfo').attr('title','click to show the details');
				}); 
				$('.labelheader').fadeOut(200);
			}
		}
		
		function showDivDetail(id) {
			if ($('##div'+id).is(':hidden')) {
				$('##div'+id).fadeIn(500, function() { 
					$('##twistie'+id).attr('src','#SESSION.root#/images/collapse.png'); 
					$('##divInfo'+id).attr('title','click to hide the detail');
				});
				$('.detailHeader').fadeIn(500);
			}
		}
		
		function doKendoMenu(id) {
			$('##'+id).kendoMenu();
		}
		
	</script>

</cfoutput>