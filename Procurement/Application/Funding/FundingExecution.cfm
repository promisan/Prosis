
<cfoutput>
	
<cf_tl id="Budget Execution Overview" var="1">

<cf_screenTop height="100%" 
              title="#lt_text#" 
			  html="No" 	
			  validateSession="Yes"		  
			  border="0"
			  JQuery="yes">

<!--- disabled 
			  
<script>

function facttable1(controlid,format,filter,qry) {
					
	w = #CLIENT.widthfull# - 80;
    h = #CLIENT.height# - 110;			
	window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?fileno=1&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=1&format="+format, "_blank"); 
	}
	
</script>

--->

<cf_layoutScript>	

			  
<cfajaximport tags="cfdiv,cfchart">
 			 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
          position  = "header"
          name      = "reqtop"
		  splitter  = "true"		  
		  overflow  = "hidden"
		  collapsible="false">	
		
			<cfinclude template="FundingExecutionMenu.cfm">
			  
	</cf_layoutarea>
				  
	<cf_layoutarea 
	    position = "left" 
		name     = "treebox" 
		maxsize  = "260" 				
		size     = "210" 
		minsize  = "210"
		collapsible="true"		
		state	= "open" 
		splitter ="true">
				
			<cf_divscroll>
				<cfinclude template="FundingExecutionTree.cfm">
			</cf_divscroll>
	
	</cf_layoutarea>	
			
	<cf_layoutarea position="center" name="box" overflow="hidden">
			
			<iframe 
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="content" 
				id="content"
		        width="100%" 
				height="100%" 				
		        scrolling="no" 
				frameborder="0">				
			</iframe>
					
	</cf_layoutarea>		
	
	<cf_layoutarea 
	    position	="right" 
		name		="propertybox" 
		maxsize		="390" 		
		size		="390" 
		minsize		="390" 
		initcollapsed="true"
		collapsible	="true" 
		splitter	="true"
		state		= "closed">
	</cf_layoutarea>
			
</cf_layout>

</cfoutput>
