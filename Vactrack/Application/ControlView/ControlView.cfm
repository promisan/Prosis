<!--
    Copyright © 2025 Promisan

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

<cf_tl id="Recruitment Track Manager" var="1">

<cf_screenTop height="100%" title="#lt_text#" jQuery="Yes" html="No" banner="gray" bannerforce="Yes" scroll="no" validateSession="Yes">

<cf_layoutscript>
	
	<cfajaximport tags="cfform">
	<cf_calendarscript>
	<cf_listingscript>
	
	<cfoutput>
	
	<script>
	
	    function tracklisting(sid,mde,con,fil,mis) {	    
		    ProsisUI.createWindow('tracklisting', 'Track listing', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    	   					
		    ptoken.navigate('#session.root#/Vactrack/Application/ControlView/ControlListingTrackContent.cfm?systemfunctionid=#url.systemfunctionid#&mission='+mis+'&mode='+mde+'&condition='+con+'&filter='+fil,'tracklisting') 			 
		}
		
		function candidatetracklisting(sid,mde,con,fil,mis) {	    
		    ProsisUI.createWindow('tracklisting', 'Track listing', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    	   					
		    ptoken.navigate('#session.root#/Vactrack/Application/ControlView/ControlListingCandidateContent.cfm?systemfunctionid=#url.systemfunctionid#&mission='+mis+'&mode='+mde+'&condition='+con+'&filter='+fil,'tracklisting') 			 
		}
			
		function details(id) {
		      ptoken.open("#SESSION.root#/Roster/RosterSpecial/CandidateView/FunctionViewLoop.cfm?IDFunction=" + id + "&status=1", id);
	    }
	
	</script>
	
	<cfset CLIENT.FileNo = round(rand()*20) >
		 	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

	<cf_layout attributeCollection="#attrib#">	
		
		<cf_layoutarea 
		          position="header"
				  size="55"
		          name="controltop">	
						  
				<cf_ViewTopMenu label="#lt_text#">
						 
		</cf_layoutarea>
	
		<cf_layoutarea  position="left" name="tree" maxsize="320" size="320" collapsible="true" splitter="true">
			<cf_divScroll>
				<cfinclude template="ControlTree.cfm">
			</cf_divScroll>
		</cf_layoutarea>
	
		<cf_layoutarea  position="center" name="box">
					
			<iframe src="../../../Tools/Treeview/TreeViewInit.cfm"
			        name="right"
			        id="right"
			        width="100%"
			        height="100%"
					scrolling="no"
			        frameborder="0"></iframe>
				
		</cf_layoutarea>			
			
	</cf_layout>	

</cfoutput>

<!--- this data was needed for some queries in the tree but I decided not to use this naymore --->


	  


