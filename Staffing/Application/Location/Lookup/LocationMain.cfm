
<cfparam name="URL.Mode" default="Lookup">
<cfparam name="URL.mid"  default="">

<cfif URL.Mode eq "Lookup">
  <cfset link = "LocationTree.cfm?FormName=#URL.formname#&fldlocationcode=#URL.fldlocationcode#&fldlocationname=#URL.fldlocationname#&Mission=#URL.Mission#&Mode=#URL.Mode#&mid=#url.mid#">
<cfelse>
  <cfset link = "LocationTree.cfm?Mission=#URL.Mission#&Mode=#URL.Mode#&mid=#url.mid#">
</cfif>
	   
<cfoutput>
	
	<script>
	
	function selectloc(val,des) { 
				
		<cfif URL.Mode eq "Lookup">			     
					
		   		parent.document.getElementById('#URL.fldlocationcode#').value = val						
		   	    parent.document.getElementById('#URL.fldlocationname#').value = des			
				try { parent.processloc(val,'#URL.id#') } catch(e) {}     	
				parent.ProsisUI.closeWindow('mylocation',true)		   
				
		<cfelseif #URL.Mode# eq "Bucket">
					
		    //    parent.window.close()		
	        //    window.open("#SESSION.root#/roster/RosterSpecial/Bucket/BucketAdd.cfm?FunctionNo="+no+"&owner=#URL.Owner#", "_blank", "left=80, top=80, width= 400, height=260, toolbar=no, status=yes, scrollbars=no, resizable=no");
						
		</cfif>   
		
		}
	
	</script>

</cfoutput>

<cf_screentop height="100%" 
	  html="No" 
	  scroll="No"		 
	  layout="webapp"
	  jQuery="Yes"
	  close="parent.ColdFusion.Window.destroy('mylocation',true)"
	  banner="gray"		 
	  line="no"
	  label="Location">
		  
<cf_layoutScript>

<cf_layout type="border" id="personProfileLayout">
	
		<cf_layoutArea id="leftArea" position="left" collapsible="true" size="310" maxsize="310" minsize="18%">
		
		    <cfoutput>
			<iframe name="right" 
				 id="right" 
				 src="#link#" 
				 width="100%" 
				 height="99%" 
				 marginwidth="0" 
				 marginheight="0" 
				 scrolling="no" 
				 frameborder="0"></iframe>
			</cfoutput>	 
				
		</cf_layoutArea>
				
		<cf_layoutArea id="centerArea" position="center">
				
				<iframe src="" 
					 name="right" 
					 id="right" 
					 width="100%" 
					 height="99%" 
					 marginwidth="0" 
					 marginheight="0" 
					 scrolling="no" 
					 frameborder="0"></iframe>
								
		</cf_layoutArea>
	
</cf_layout>	



