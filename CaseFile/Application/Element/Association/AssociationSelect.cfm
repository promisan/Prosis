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
<cf_screentop jQuery="Yes" html="no" scroll="no">

<cf_dialogstaffing>
<cf_listingscript>
<cf_FileLibraryScript>
<cf_layoutscript>

<cfoutput>
	
	<script>
	
	function associateedit(thisform,elementfrom,elementto,box,elementclass,mis,relid,mode,mde) {		
	      
		document.getElementById(thisform).onsubmit() 			
		if( _CF_error_messages.length == 0 ) {        
		
			source = document.getElementsByName("RelationElementId");		
			var sourceId = 0;
			for(var i = 0; i < source.length; i++) {
				if(source[i].checked) {
					sourceId = source[i].value
				}
			}
	
			if (sourceId == 0)
			{
				alert('Please select a source document');
				return;
			}else{
				ptoken.navigate('AssociationAddSubmit.cfm?mission='+mis+'&elementidfrom='+elementfrom+'&elementclass=#url.elementclass#&elementidto='+elementto+'&relationid='+relid+'&sourceId='+sourceId+'&mode='+mde,mode+'_'+box,'','','POST',thisform)
			}
			
		}   
		
	 }
	 
	 function updateSourceDocument(relationElementId){
	 	source = document.getElementsByName("RelationElementId");		
		for(var i = 0; i < source.length; i++) {
			if(source[i].value==relationElementId) {
				source[i].checked = true;
				break;
			}else{
				source[i].checked = false;
			}
		}
	 }
	
	</script>
	
</cfoutput>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
   
	<cf_layoutarea 
	          position  = "header"
	          name      = "reqtop"
	          minsize   = "50px"
	          maxsize   = "50px"  
			  size      = "50px" 
			  splitter="true" 
			  overflow="hidden">	
			  
			  
				<cf_tl id="Associate Element" var="1">
				<cfset label = lt_text>

				<cf_tl id="Locate and associate elements" var="1">
				<cf_ViewTopMenu label="#label#" option="#lt_text#" user="No">
			 
			  
	</cf_layoutarea>		
	
	<cf_tl id= "Select Source Document" var="1">
	  
	<cf_layoutarea 
	    position="left" 		
		name="associatebox" 
		collapsible="true"
		size="350px" 		
		splitter="true">
		
		<table width="100%" height="100%" align="center" bgcolor="FFFFFF">
		<tr><td>
		   <cf_divscroll>
		  				
			<cfinclude template="AssociationSelectDocument.cfm">	
			
		   </cf_divscroll>	
		  </td></tr>
		  </table> 
			
	</cf_layoutarea>
		
	<cf_layoutarea  position="center" name="box">
		    
		<table width="100%" height="100%" align="center" bgcolor="FFFFFF">
			<tr class="hide">
			<td id="processbox" align="center" colspan="3"></td></tr>
			<tr><td valign="top" width="100%">
				<cf_divScroll overflowx="yes">
				<cfinclude template="AssociationSelectContent.cfm">
				</cf_divScroll>	
				</td>
			</tr>
		</table>
							
	</cf_layoutarea>		

</cf_layout>
