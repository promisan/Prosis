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
<cf_screentop jquery="Yes" html="No">

<cfparam name="url.id1" default="">
<cfparam name="url.id2" default=""> 	   	
<cfparam name="url.id3" default="">
<cfparam name="url.id4" default="">

<cfoutput>
	
	<!--- old code reading from tree, better to work with session variables 
	
	DELETEME
	
	<cfif url.id eq "org">
			
		<script>
		var vl = parent._SELECTED_ITEMS.length;
		for (var i = vl-1; i >= 0; i--) {
			console.log(parent._SELECTED_ITEMS[i].id);
			console.log(parent._SELECTED_ITEMS[i].value);
			console.log('----');
		}

		//var id_tree = "mandatetreecontent";
		//var tree = parent.ColdFusion.objectCache[id_tree+"collection"];
		//var element  = parent.ColdFusion.DOM.getElement(tree.prevspanid,id_tree);
		//element.style.backgroundColor=tree.prevspanbackground;
		// parent._cf_loadingtexthtml='';	
		// parent.ptoken.navigate('setTree.cfm?mission=#url.id2#&mandate=#url.id3#','mandatetree')	
			
		</script>		
				
	<cfelse>

		<script>
		//parent.document.getElementById('selectedfilter').value = '#url.id#'
		//parent.document.getElementById('selectedfiltervalue').value = '#url.id1#'
		var vl = parent._SELECTED_ITEMS.length;
		for (var i = vl-1; i >= 0; i--) {
			console.log(parent._SELECTED_ITEMS[i].id);
			console.log(parent._SELECTED_ITEMS[i].value);
			console.log('----');
		}
		</script>
		
	</cfif>	
	
	--->
			
	<cfparam name="session.mandateorg"         default="">
	<cfparam name="session.mandatefilter"      default="">
	<cfparam name="session.mandatefiltervalue" default="">
		
	<cfif url.id eq "org">
	    <cfset session.mandatefilter      = url.id>
		<cfset session.mandateorg         = url.id1>
		<cfset session.mandatefiltervalue = url.id1>
		
	<cfelseif url.id1 eq "">
	
		<cfset session.mandatefilter      = "">
		<cfset session.mandatefiltervalue = "">
	
	<cfelse>
	
		<cfset session.mandatefilter      = url.id>
		<cfset session.mandatefiltervalue = url.id1>
			
	</cfif>		
	
		
	<cfif URL.ID eq "Locate">
	
		<script language="JavaScript">		   		
		   ptoken.location('MandateViewView.cfm?ID=#URL.ID#&ID2=#URL.ID2#&ID3=#URL.ID3#')
		</script>
		
	<cfelse>
		
		<script language="JavaScript">	 
			// unitcode = parent._SELECTED_ITEMS[0].value;							
		   	ptoken.location('MandateViewGeneral.cfm?org=#session.mandateorg#&ID=#session.mandatefilter#&ID1=#session.mandatefiltervalue#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&selectiondate=' + parent.document.getElementById('selectiondate').value)
		</script>
	
	</cfif>
	
</cfoutput>
