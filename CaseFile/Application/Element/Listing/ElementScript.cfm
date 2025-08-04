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

<!--- ------------------------------------------- --->
<!--- container for the service lines to be shown --->
<!--- ------------------------------------------- --->

<cfoutput>
	
	<script language="JavaScript">
	
		function lineadd(wid,lid,cls) {   
		   		
				try {
					parent.ColdFusion.Window.destroy('mydialog')						
				} catch(e) {}				
				parent.ColdFusion.Window.create('mydialog', 'Element', '',{x:100,y:100,height:parent.document.body.clientHeight-50,width:parent.document.body.clientWidth-50,modal:false,center:true})    						
				parent.ptoken.navigate('#session.root#/CaseFile/Application/Element/Create/Element.cfm?mode=edit&claimid='+wid+'&elementclass='+cls,'mydialog') 	    				
			  		
		}
		
		function linepurge(row,cid,eid) {
			if (confirm("Do you want to deactivate this line ?"))	{
				ptoken.navigate('../Create/ElementPurge.cfm?row='+row+'&claimid='+cid+'&elementid='+eid,'elementdelete'+row)
			} 
			return false
		}
		
		function ShowCaseFileCandidate(personno){
				w = #CLIENT.width# - 60;
			    h = #CLIENT.height# - 120;
			  	ptoken.open("#SESSION.root#/Roster/Candidate/Details/PHPView.cfm?ID=" + personno + "&scope=casefile&mode=Manual", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
		}
	
	</script>

</cfoutput>