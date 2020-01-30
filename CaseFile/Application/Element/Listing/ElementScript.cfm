
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