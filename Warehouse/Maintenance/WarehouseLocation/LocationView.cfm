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
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseLocation
	WHERE  Warehouse = '#URL.warehouse#'	
	AND    Location  = '#url.location#' 
</cfquery>

<cf_tl id = "Stock storage <b>#get.Description#</b>" var = "vTitle">
	 
<cf_screentop height="100%" 
	     layout="webapp" 
		 banner="red" 		 
		 user="yes" 
		 html="Yes" 
		 jQuery="Yes"
		 scroll="No" 
		 label="#vTitle#" 
		 title="#vTitle#">
		 
<cfoutput>
	
	<script language="JavaScript">
	
		function save(warehouse,location) {	
		    document.getElementById('action'+code).onsubmit() 
			if( _CF_error_messages.length == 0 ) {
		       ptoken.navigate('LocationEditSubmit.cfm?warehouse='+warehouse+'&location='+location,'box'+location,'','','POST','form'+location)
			 }   
		}
			 
		function checkItem() {	
			if (document.getElementById("itemno").value == ""){
				alert('Please, select a valid Item/UoM.');
				return false;
			}
			return true;
		} 
		
		function editLocationCapacity(wh,loc,id) {
				
			// try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
			ProsisUI.createWindow('mydialog', 'Detail', '',{x:100,y:100,height:400,width:600,modal:true,resizable:false,center:true})    							
			ptoken.navigate('DetailsView.cfm?warehouse='+wh+'&location='+loc+'&detailid='+id,'mydialog') 		
		
		}
		
		function editLocationRefresh(wh,loc) {
		    ptoken.navigate('DetailsListing.cfm?warehouse='+wh+'&location='+loc,'divWLCapacity');
		} 
		
		function printStatistics(wh,loc,divToGet) {
			ptoken.open('LocationStatistics/PrintableVersion.cfm?warehouse='+wh+'&location='+loc+'&divToGet='+divToGet+'&ts='+new Date().getTime(), 'LocationStatistics', 'left=100, top=100, width=1000, height=700, toolbar=no, status=no, scrollbars=no, resizable=no');
		}
		
	</script>	 

</cfoutput>
		 
	<cfif client.googleMAP eq "1">	 
	
		<cfajaximport tags="cfdiv,cfform,cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
		
	<cfelse>
	
		<cfajaximport tags="cfdiv,cfform">
	
	</cfif>	

	<cf_menuscript>
	<cf_dialogAsset>
	<cf_dialogmaterial>
	<cf_listingscript>
	<cf_filelibraryScript>	
	<cf_picturescript>
			
	<table width="100%" bgcolor="white" class="formspacing" height="100%">		
		<tr>
			<td height="100%" id="content" width="100%">			
			  <cfinclude template="LocationViewMenu.cfm">		
			</td>
		</tr>		
	</table>
		
